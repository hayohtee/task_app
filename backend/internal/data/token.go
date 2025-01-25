package data

import (
	"time"

	"github.com/google/uuid"
)

// tokenScope represents the scope of a token as a string type.
type tokenScope string

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
