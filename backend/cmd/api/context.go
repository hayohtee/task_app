package main

import (
	"context"
	"net/http"

	"github.com/hayohtee/task_app/internal/data"
)

// contextKey is a custom type used to define keys for storing and retrieving values in context.
// Using a distinct type helps to avoid key collisions and ensures type safety.
type contextKey string

const (
	userContextKey = contextKey("user")
)

// contextSetUserID adds the user ID from the provided token to the request context.
// This allows the user ID to be accessed throughout the request lifecycle.
//
// Parameters:
//   r - The original HTTP request.
//   token - The token containing the user ID to be added to the context.
//
// Returns:
//   A new HTTP request with the user ID added to the context.
func (app *application) contextSetUserID(r *http.Request, token data.Token) *http.Request {
	ctx := context.WithValue(r.Context(), userContextKey, token.UserID)
	return r.WithContext(ctx)
}