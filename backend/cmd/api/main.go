package main

import (
	"context"
	"database/sql"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"time"

	"github.com/hayohtee/task_app/internal/data"
	_ "github.com/jackc/pgx/v5/stdlib"
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

	flag.StringVar(&cfg.redis.addr, "redis-addr", os.Getenv("REDIS_ADDRESS"), "Redis server address")
	flag.StringVar(&cfg.redis.password, "redis-password", os.Getenv("REDIS_PASSWORD"), "Redis server password")
	flag.IntVar(&cfg.redis.db, "redis-db", 0, "Redis server database")
	flag.Parse()

	db, err := openDB(cfg)
	if err != nil {
		logger.Error(fmt.Sprintf("database: %s", err.Error()))
		os.Exit(1)
	}
	defer db.Close()
	logger.Info("database connection established")

	app := application{
		config: cfg,
		logger: logger,
		model:  data.NewModel(db),
	}

	if err := app.serve(); err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}
}

func openDB(cfg config) (*sql.DB, error) {
	db, err := sql.Open("pgx", cfg.db.dsn)
	if err != nil {
		return nil, err
	}

	db.SetMaxIdleConns(cfg.db.maxIdleConn)
	db.SetMaxOpenConns(cfg.db.maxOpenConn)
	db.SetConnMaxIdleTime(cfg.db.maxIdleTime)

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := db.PingContext(ctx); err != nil {
		db.Close()
		return nil, err
	}

	return db, nil
}
