package data

import (
	"database/sql"
	"errors"
)

var (
	ErrDuplicateEmail = errors.New("duplicate email")
)

type UserModel struct {
	DB *sql.DB
}
