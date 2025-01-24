package data

import (
	"context"
	"database/sql"
	"errors"
	"strings"
	"time"
)

var (
	ErrDuplicateEmail = errors.New("duplicate email")
)

// UserModel represents a model for interacting with the users table in the database.
// It holds a reference to the database connection pool.
type UserModel struct {
	DB *sql.DB
}

// Insert inserts a new user into the database and updates the user object with the generated ID, 
// created_at, updated_at, and version fields. It returns an error if the insertion fails, 
// including a specific error for duplicate email addresses.
//
// Parameters:
//   user - A pointer to the User struct containing the user details to be inserted.
//
// Returns:
//   error - An error object if the insertion fails, or nil if the insertion is successful.
func (u UserModel) Insert(user *User) error {
	dbQuery := `
			INSERT INTO users (name, email, password_hash)
			VALUES ($1, $2, $3)
			RETURNING id, created_at, updated_at, version`

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	err := u.DB.QueryRowContext(ctx, dbQuery, user.Name, user.Email, user.Password.hash).Scan(
		&user.ID,
		&user.CreatedAt,
		&user.UpdatedAt,
		&user.Version,
	)

	if err != nil {
		switch {
		case strings.Contains(err.Error(), "users_email_key"):
			return ErrDuplicateEmail
		default:
			return err
		}
	}

	return nil
}
