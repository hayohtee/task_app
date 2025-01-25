package main

import (
	"log/slog"
	"sync"
	"time"

	"github.com/hayohtee/task_app/internal/data"
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
	redis struct {
		addr     string
		password string
		db       int
	}
}

// application holds the dependencies for the HTTP handlers
// helpers and middlewares.
type application struct {
	config config
	logger *slog.Logger
	model  data.Model
	wg     sync.WaitGroup
}
