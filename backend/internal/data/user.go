package data

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
