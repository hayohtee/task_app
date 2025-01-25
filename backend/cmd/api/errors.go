package main

import (
	"fmt"
	"net/http"
)

// logError is a generic helper for logging an error message
// along with the current request method and URL
// as attributes in the log entry.
func (app *application) logError(r *http.Request, err error) {
	var (
		method = r.Method
		uri    = r.URL.RequestURI()
	)

	app.logger.Error(err.Error(), "method", method, "uri", uri)
}

// errorResponse is a generic method for sending JSON-formatted
// error messages to the client with the given status code.
func (app *application) errorResponse(w http.ResponseWriter, r *http.Request, status int, message any) {
	env := envelope{"error": message}

	if err := app.writeJSON(w, status, env, nil); err != nil {
		app.logError(r, err)
		w.WriteHeader(http.StatusInternalServerError)
	}
}

// serverErrorResponse is a helper method for sending JSON-formatted error response
// when the server encountered an unexpected problem at runtime.
//
// It logs the detailed error message, and sends a 500 Internal Server Error
// status code and JSON response containing generic error message to the client.
func (app *application) serverErrorResponse(w http.ResponseWriter, r *http.Request, err error) {
	app.logError(r, err)

	message := "the server encountered a problem and could not process your request"
	app.errorResponse(w, r, http.StatusInternalServerError, message)
}

// notFoundResponse is a helper method for sending a 404 Not Found status code
// and JSON response to the client.
func (app *application) notFoundResponse(w http.ResponseWriter, r *http.Request) {
	message := "the requested resource could not be found"
	app.errorResponse(w, r, http.StatusNotFound, message)
}

// methodNotAllowedResponse is a helper method for sending a 405 Method Not Allowed
// status code and JSON response to the client.
func (app *application) methodNotAllowedResponse(w http.ResponseWriter, r *http.Request) {
	message := fmt.Sprintf("the %s method is not supported for this resource", r.Method)
	app.errorResponse(w, r, http.StatusMethodNotAllowed, message)
}

// badRequestResponse is a helper method for sending 400 Bad Request status code
// and the error message as JSON response to the client.
func (app *application) badRequestResponse(w http.ResponseWriter, r *http.Request, err error) {
	app.errorResponse(w, r, http.StatusBadRequest, err.Error())
}

// failedValidationResponse is a helper method for sending a 422 Unprocessable Entity
// status code and JSON response containing the errors.
func (app *application) failedValidationResponse(w http.ResponseWriter, r *http.Request, errs map[string]string) {
	app.errorResponse(w, r, http.StatusUnprocessableEntity, errs)
}

// editConflictResponse is a helper method for sending 409 Conflict status code
// and JSON response to the client
func (app *application) editConflictResponse(w http.ResponseWriter, r *http.Request) {
	message := "unable to update the record due to an edit conflict, please try again"
	app.errorResponse(w, r, http.StatusConflict, message)
}

func (app *application) invalidCredentialsResponse(w http.ResponseWriter, r *http.Request) {
	message := "the email and password combination does not match any account."
	app.errorResponse(w, r, http.StatusUnauthorized, message)
}

func (app *application) emailAddressNotFoundResponse(w http.ResponseWriter, r *http.Request) {
	message := "no account exist for the provided email address"
	app.errorResponse(w, r, http.StatusNotFound, message)
}

func (app *application) invalidAuthenticationTokenResponse(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("WWW-Authenticate", "Bearer")

	message := "invalid or missing authentication token"
	app.errorResponse(w, r, http.StatusUnauthorized, message)
}

// invalidRefreshTokenResponse is a helper method for sending a JSON response when
// the provided refresh token is either invalid or has expired. It sends an appropriate
// error message to the client.
func (app *application) invalidRefreshTokenResponse(w http.ResponseWriter, r *http.Request) {
	message := "the refresh token provided is invalid or expired"
	app.errorResponse(w, r, http.StatusUnauthorized, message)
}