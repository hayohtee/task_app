package data

import (
	"time"

	"github.com/hayohtee/task_app/internal/validator"
	uuid "github.com/jackc/pgx/pgtype/ext/gofrs-uuid"
)

type User struct {
	ID        uuid.UUID `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Password  password  `json:"-"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	Version   int       `json:"-"`
}

func ValidateEmail(v *validator.Validator, email string) {
	v.Check(email != "", "email", "must be provided")
	v.Check(validator.Matches(email, validator.EmailRX), "email", "must be a valid email address")
}

func ValidateUser(v *validator.Validator, user User) {
	ValidateEmail(v, user.Email)
	ValidatePassword(v, *user.Password.plaintext)

	v.Check(user.Name != "", "name", "must be provided")
	v.Check(len(user.Name) < 500, "name", "must not be more than 500 bytes long")
}