package main

import (
	"errors"
	"net/http"
	"strconv"
)

// envelope is a custom type for enveloping JSON response.
type envelope map[string]any

func (app *application) readIDParam(r *http.Request) (int64, error) {
	id, err := strconv.ParseInt(r.PathValue("id"), 10, 64)
	if err != nil {
		return 0, errors.New("invalid id parameter")
	}
	return id, nil
}
