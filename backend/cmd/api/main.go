package main

import (
	"flag"
	"log/slog"
	"os"
	"time"

	"github.com/joho/godotenv"
)

func main() {
	// Initialize a structured logger that logs to an output stream
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	if err := godotenv.Load(); err != nil {
		logger.Error("error loading .env file")
		os.Exit(1)
	}

	// Read the value of the config fields from the command-line flags
	var cfg config
	flag.IntVar(&cfg.port, "port", 4000, "API server port")
	flag.StringVar(&cfg.env, "env", "development", "Environment (development|staging|production")

	flag.StringVar(&cfg.db.dsn, "db-dsn", os.Getenv("DATABASE_DSN"), "PostgreSQL DSN")
	flag.IntVar(&cfg.db.maxOpenConn, "db-max-open-conn", 25, "PostgreSQL max open connections")
	flag.IntVar(&cfg.db.maxIdleConn, "db-max-idle-conn", 25, "PostgreSQL max idle connections")
	flag.DurationVar(&cfg.db.maxIdleTime, "db-max-idle-time", 15*time.Minute, "PostgreSQL max idle time")
	flag.Parse()
}
