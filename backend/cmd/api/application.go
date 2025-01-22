package main

import (
	"log/slog"
	"sync"
	"time"
)

// config struct holds the configuration settings
// for the application.
type config struct {
	port int
	env  string
	db   struct {
		dsn         string
		maxOpenConn int
		maxIdleConn int
		maxIdleTime time.Duration
	}
}

// application holds the dependencies for the HTTP handlers
// helpers and middlewares.
type application struct {
	config config
	logger *slog.Logger
	wg     sync.WaitGroup
}
