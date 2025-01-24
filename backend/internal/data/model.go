package data

import (
	"database/sql"
	"errors"
)

var (
	// ErrRecordNotFound is a custom error that is returned when
	// looking for a record in the database that doesn't exist.
	ErrRecordNotFound = errors.New("record not found")

	// ErrEditConflict is a custom error that is returned when
	// there is an edit conflict in the database operation.
	ErrEditConflict = errors.New("edit conflict")
)

// Model represents the main data structure that holds various models used in the application.
// It currently contains a single field, Users, which is of type UserModel.
type Model struct {
	Users UserModel
}

// NewModel initializes a new Model instance with the provided database connection.
//
// Parameters:
//   - db: A pointer to an sql.DB instance representing the database connection.
//
// Returns:
//
//	A Model instance with the Users field initialized.
func NewModel(db *sql.DB) Model {
	return Model{
		Users: UserModel{DB: db},
	}
}
