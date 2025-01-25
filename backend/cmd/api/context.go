package main

import (
	"context"
	"net/http"

	"github.com/google/uuid"
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
//
//	r - The original HTTP request.
//	token - The token containing the user ID to be added to the context.
//
// Returns:
//
//	A new HTTP request with the user ID added to the context.
func (app *application) contextSetUserID(r *http.Request, key contextKey, token data.Token) *http.Request {
	ctx := context.WithValue(r.Context(), key, token.UserID)
	return r.WithContext(ctx)
}

// contextGetUserID retrieves the user ID from the request context using the provided context key.
// It expects the user ID to be stored as a uuid.UUID in the context.
// If the user ID is not found or is of an incorrect type, the function will panic.
//
// Parameters:
//   - r: The HTTP request containing the context.
//   - key: The context key used to retrieve the user ID.
//
// Returns:
//   - uuid.UUID: The user ID extracted from the context.
func (app *application) contextGetUserID(r *http.Request, key contextKey) uuid.UUID {
	id, ok := r.Context().Value(key).(uuid.UUID)
	if !ok {
		panic("missing user id in the request context")
	}
	return id
}
