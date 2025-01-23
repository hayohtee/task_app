package main

import (
	"encoding/json"
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

// writeJSON is a helper method for sending JSON responses.
//
// It takes the destination http.ResponseWriter, the HTTP status
// code to send, the data to encode to JSON, and a header map
// containing additional HTTP headers to include in the response.
func (app *application) writeJSON(w http.ResponseWriter, status int, data envelope, headers http.Header) error {
	// Encode the data into JSON
	js, err := json.Marshal(data)
	if err != nil {
		return err
	}

	// Append a newline to make it easier to view in terminal applications.
	js = append(js, '\n')

	// Include the header values in the response.
	for key, value := range headers {
		w.Header()[key] = value
	}

	// Add the "Content-Type: application/json" header,
	// then write the status code and JSON response.
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	w.Write(js)

	return nil
}