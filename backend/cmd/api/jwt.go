package main

import (
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

type claims struct {
	UserID uuid.UUID `json:"user_id"`
	jwt.RegisteredClaims
}
