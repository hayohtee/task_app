package main

import "net/http"

func (app *application) routes() http.Handler {
	mux := http.NewServeMux()

	mux.HandleFunc("POST /v1/auth/register", app.registerUserHandler)
	mux.HandleFunc("POST /v1/auth/login", app.loginUserHandler)

	return app.recoverPanic(mux)
}
