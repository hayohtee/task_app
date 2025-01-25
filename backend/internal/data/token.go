package data

import (
	"crypto/rand"
	"encoding/base32"
	"time"

	"github.com/google/uuid"
	"github.com/hayohtee/task_app/internal/validator"
)

// tokenScope represents the scope of a token as a string type.
type tokenScope string

// MarshalBinary implements the encoding.BinaryMarshaler interface for tokenScope.
// It converts the tokenScope to a byte slice for binary serialization.
//
// Returns:
//   - []byte: The byte slice representation of the tokenScope.
//   - error: Always returns nil as this operation cannot fail.
func (t tokenScope) MarshalBinary() ([]byte, error) {
	return []byte(t), nil
}

const (
	ScopeAccess  = tokenScope("access")
	ScopeRefresh = tokenScope("refresh")
)


// Token represents a structure for storing token information.
// It includes the plain text token, associated user ID, expiry time, and scope of the token.
type Token struct {
	PlainText string     `redis:"token"`
	UserID    uuid.UUID  `redis:"user_id"`
	Expiry    time.Time  `redis:"expiry"`
	Scope     tokenScope `redis:"scope"`
}

// generateToken generates a new token for a given user ID with a specified time-to-live (TTL) and scope.
// It returns the generated Token and an error, if any.
//
// Parameters:
//   - userID: The UUID of the user for whom the token is being generated.
//   - ttl: The duration for which the token is valid.
//   - scope: The scope of the token.
//
// Returns:
//   - Token: The generated token containing the user ID, expiry time, scope, and plain text representation.
//   - error: An error if the token generation fails.
func generateToken(userID uuid.UUID, ttl time.Duration, scope tokenScope) (Token, error) {
	token := Token{
		UserID: userID,
		Expiry:     time.Now().Add(ttl),
		Scope:      scope,
	}

	// Generate a random 16 byte array
	randomBytes := make([]byte, 16)
	_, err := rand.Read(randomBytes)
	if err != nil {
		return token, err
	}

	// Encode the random bytes to a base32 string
	token.PlainText = base32.StdEncoding.WithPadding(base32.NoPadding).EncodeToString(randomBytes)

	return token, nil
}

// ValidateTokenPlainText checks if the provided tokenPlainText meets the required criteria.
// It validates that the tokenPlainText is not empty and has a length of exactly 26 bytes.
// Parameters:
//   - v: A pointer to a validator.Validator instance used for validation.
//   - tokenPlainText: The token string to be validated.
func ValidateTokenPlainText(v *validator.Validator, key, tokenPlainText string) {
	v.Check(tokenPlainText != "", key, "must be provided")
	v.Check(len(tokenPlainText) == 26, key, "must be 26 bytes long")
}