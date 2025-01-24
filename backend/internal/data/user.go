package data

import "golang.org/x/crypto/bcrypt"

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