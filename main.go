package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)

var client = &http.Client{Transport: &myTransport{}}
var token = os.Getenv("LICHESS_TOKEN")

type myTransport struct{}

func (t *myTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	req.Header.Add("Authorization", "Bearer "+token)
	return http.DefaultTransport.RoundTrip(req)
}

func main() {
	req, err := http.NewRequest("GET", "https://lichess.org/api/stream/event", nil)
	if err != nil {
		log.Fatal(err)
	}
	res, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	dec := json.NewDecoder(res.Body)
	for {
		o := map[string]interface{}{}
		err = dec.Decode(&o)
		if err != nil {
			log.Fatal(err)
		}
		log.Println(o)
	}
}
