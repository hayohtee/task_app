package main

import (
	"errors"
	"fmt"
	"net/http"
	"strings"

	"github.com/hayohtee/task_app/internal/data"
	"github.com/hayohtee/task_app/internal/validator"
)

// recoverPanic is a middleware that recovers from any panics and writes a 500 Internal Server Error
// response. It ensures that the server does not crash due to unexpected errors. If a panic occurs,
// it sets the "Connection: close" header to indicate that the connection should be closed after
// the response is sent, and calls the app.serverErrorResponse method to handle the error.
func (app *application) recoverPanic(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Create a deferred function which always run in the event
		// of panic as Go unwinds the stack.
		defer func() {
			// Use the built-in recover function to check if
			// there has been a panic or not.
			if err := recover(); err != nil {
				// If there was a panic, set "Connection: close" header
				// on the response. This acts as a trigger to make
				// Go's HTTP server automatically close the current connection
				// after a response has been sent
				w.Header().Set("Connection", "close")

				// The value returned by recover is a type of any, so we use
				// fmt.Errorf to normalize it into an error and call
				// app.serverErrorResponse method.
				app.serverErrorResponse(w, r, fmt.Errorf("%s", err))
			}
		}()

		next.ServeHTTP(w, r)
	})
}

// requireAuthentication is a middleware function that ensures the incoming request
// contains a valid authentication token in the Authorization header. If the token
// is missing, invalid, or expired, it sends a 401 Unauthorized response. Otherwise,
// it retrieves the token from Redis, validates its scope, and sets the user ID in
// the request context before passing control to the next handler in the chain.
//
// The token must be in the format "Bearer <token>". The middleware checks the token
// format, validates it, and retrieves the corresponding token from Redis. If the
// token is valid and has the correct scope, the user ID is set in the request context.
//
// Parameters:
// - next: The next http.HandlerFunc in the middleware chain.
//
// Returns:
// - An http.HandlerFunc that wraps the next handler with authentication checks.
func (app *application) requireAuthentication(next http.HandlerFunc) http.HandlerFunc {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Get the value of the Authorization header from the request. If there isn't any
		// value present, call the app.invalidAuthenticationTokenResponse() helper to send
		// a 401 Unauthorized response, and return from the middleware chain.
		w.Header().Add("Vary", "Authorization")
		authorizationHeader := r.Header.Get("Authorization")
		if authorizationHeader == "" {
			app.invalidAuthenticationTokenResponse(w, r)
			return
		}

		// Otherwise, extract the authentication token from the header.
		headerParts := strings.Split(authorizationHeader, " ")
		if len(headerParts) != 2 || headerParts[0] != "Bearer" {
			app.invalidAuthenticationTokenResponse(w, r)
			return
		}

		// The value of the token will be in the second position in the headerParts slice.
		// We extract this and assign it to the token variable.
		tokenPlainText := headerParts[1]

		// Validate the token to make sure it is in a sensible format. If it's not, then
		// call the app.invalidAuthenticationTokenResponse() helper to send a 401 Unauthorized
		// response, and return from the middleware chain.
		v := validator.New()
		if data.ValidateTokenPlainText(v, "access_token", tokenPlainText); !v.Valid() {
			app.invalidAuthenticationTokenResponse(w, r)
			return
		}

		// Attempt to retrieve a token from Redis using the plain text token as the key
		token, err := app.model.Tokens.Get(data.ScopeAccess, tokenPlainText)
		if err != nil {
			switch {
			case errors.Is(err, data.ErrRecordNotFound):
				app.invalidAuthenticationTokenResponse(w, r)
			default:
				app.serverErrorResponse(w, r, err)
			}
			return
		}

		if token.Scope != data.ScopeAccess {
			app.errorResponse(w, r, http.StatusUnauthorized, "require an access token")
			return
		}

		r = app.contextSetUserID(r, userContextKey, token)
		next.ServeHTTP(w, r)
	})
}
