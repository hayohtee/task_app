package data

import "github.com/redis/go-redis/v9"

type TokenModel struct {
	client *redis.Client
}