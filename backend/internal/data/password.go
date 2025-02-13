package data

import (
	"errors"

	"github.com/hayohtee/task_app/internal/validator"
	"golang.org/x/crypto/bcrypt"
)

// password is a struct containing the plaintext and hashed
// versions of the password for a user.
//
// The plaintext is a pointer to a string to help distinguish
// between a plaintext password not being present in the struct
// versus a plaintext password which is empty string.
type password struct {
	plaintext *string
	hash      []byte
}

// Set calculates the bycrypt hash of plaintextPassword and stores
// both the hash and the plaintext versions in the struct.
func (p *password) Set(plaintextPassword string) error {
	hash, err := bcrypt.GenerateFromPassword([]byte(plaintextPassword), 12)
	if err != nil {
		return err
	}

	p.plaintext = &plaintextPassword
	p.hash = hash

	return nil
}

// Matches checks whether the provided plaintext password matches the
// hashed password stored in the struct, returning true if it matches
// and false otherwise.
func (p *password) Matches(plaintextPassword string) (bool, error) {
	err := bcrypt.CompareHashAndPassword(p.hash, []byte(plaintextPassword))
	if err != nil {
		switch {
		case errors.Is(err, bcrypt.ErrMismatchedHashAndPassword):
			return false, nil
		default:
			return false, err
		}
	}
	return true, nil
}

func ValidatePassword(v *validator.Validator, password string) {
	v.Check(password != "", "password", "must be provided")
	v.Check(len(password) >= 8, "password", "must be at least 8 bytes")
	v.Check(len(password) <= 72, "password", "must not be more than 72 bytes long")
}