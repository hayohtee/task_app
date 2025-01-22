package main

import "time"

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
