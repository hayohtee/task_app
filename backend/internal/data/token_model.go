package data

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/redis/go-redis/v9"
)

// TokenModel represents a model for handling tokens using a Redis client.
// It provides methods to interact with the Redis database for token-related operations.
type TokenModel struct {
	client *redis.Client
}

// New generates a new token for the specified user ID, time-to-live (ttl) duration, and token scope.
// It returns the generated token and any error encountered during the process.
// The function first generates the token using the generateToken function.
// If token generation is successful, it attempts to insert the token into the database.
// If the insertion fails, it returns the token and the encountered error.
func (t TokenModel) New(userID uuid.UUID, ttl time.Duration, scope tokenScope) (Token, error) {
	token, err := generateToken(userID, ttl, scope)
	if err != nil {
		return token, err
	}

	if err := t.insert(token); err != nil {
		return token, err
	}

	return token, nil
}

// insert stores a token in the Redis database and sets its expiry time.
// It takes a Token object as input and returns an error if the operation fails.
// The function uses a context with a timeout of 5 seconds for the Redis operations.
//
// Parameters:
//   - token: The Token object to be stored in the Redis database.
//
// Returns:
//   - error: An error object if the insertion or expiry setting fails, otherwise nil.
func (t TokenModel) insert(token Token) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	err := t.client.HSet(ctx, fmt.Sprintf("%s:%s", token.Scope, token.UserID), token).Err()
	if err != nil {
		return fmt.Errorf("failed to insert the token into redis: %w", err)
	}

	err = t.client.ExpireAt(ctx, token.PlainText, token.Expiry).Err()
	if err != nil {
		return fmt.Errorf("failed to set expiry for token in redis: %w", err)
	}

	return nil
}

// Get retrieves a token for a given user ID and scope from the Redis store.
// It returns the token if found, or an error if the token is not found or if there is an issue with the Redis operation.
//
// Parameters:
//   - userID: The UUID of the user for whom the token is being retrieved.
//   - scope: The scope of the token to be retrieved.
//
// Returns:
//   - Token: The retrieved token.
//   - error: An error if the token is not found or if there is an issue with the Redis operation.
func (t TokenModel) Get(userID uuid.UUID, scope tokenScope) (Token, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	var token Token

	value := t.client.HGetAll(ctx, fmt.Sprintf("%s:%s", scope, userID))
	if err := value.Err(); err != nil {
		return token, err
	}

	results, err := value.Result()
	if err != nil {
		return token, err
	}

	if len(results) == 0 {
		return token, ErrRecordNotFound
	}

	if err := value.Scan(&token); err != nil {
		return token, err
	}

	return token, nil
}
