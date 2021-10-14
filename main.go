package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/notnil/chess"
)

var client = &http.Client{Transport: &myTransport{}}
var token = os.Getenv("LICHESS_TOKEN")

type myTransport struct{}

func (t *myTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	req.Header.Add("Authorization", "Bearer "+token)
	return http.DefaultTransport.RoundTrip(req)
}

func main() {
	for {
		log.Println("Looking for games")
		if id := lookForGameStart(); id != "" {
			log.Printf("JOIN GAME %s", id)
			runGame(id)
		}
	}

}

func runGame(id string) {
	req, err := http.NewRequest("GET", "https://lichess.org/api/board/game/stream/"+id, nil)
	if err != nil {
		log.Fatal(err)
	}
	res, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	log.Println(res.Status)
	dec := json.NewDecoder(res.Body)
	for {
		o := gameEvent{}
		err = dec.Decode(&o)
		if err != nil {
			log.Fatal(err)
		}
		log.Println("!!!!", o)
		var state *State
		if o.Type == "gameFull" {
			state = o.InnerState
		} else {
			state = &o.State
		}
		log.Println(state)
		if state.Status != "started" {
			return
		}
		game := chess.NewGame()
		uci := chess.UCINotation{}
		log.Printf("!%s!", state.Moves)
		for _, m := range strings.Split(strings.TrimSpace(state.Moves), " ") {
			if m == "" {
				break
			}
			move, err := uci.Decode(game.Position(), m)
			log.Println(move, err)
			log.Println(game.Move(move))
		}
		fmt.Println(game.Position().Board().Draw())
	}

}

type gameEvent struct {
	Type    string `json:"type"`
	ID      string `json:"id"`
	Rated   bool   `json:"rated"`
	Variant struct {
		Key   string `json:"key"`
		Name  string `json:"name"`
		Short string `json:"short"`
	} `json:"variant"`
	Clock struct {
		Initial   int `json:"initial"`
		Increment int `json:"increment"`
	} `json:"clock"`
	Speed string `json:"speed"`
	Perf  struct {
		Name string `json:"name"`
	} `json:"perf"`
	CreatedAt int64 `json:"createdAt"`
	White     struct {
		ID          string `json:"id"`
		Name        string `json:"name"`
		Provisional bool   `json:"provisional"`
		Rating      int    `json:"rating"`
		Title       string `json:"title"`
	} `json:"white"`
	Black struct {
		ID     string      `json:"id"`
		Name   string      `json:"name"`
		Rating int         `json:"rating"`
		Title  interface{} `json:"title"`
	} `json:"black"`
	InitialFen string `json:"initialFen"`
	InnerState *State `json:"state"`
	State
}

type State struct {
	Type   string `json:"type"`
	Moves  string `json:"moves"`
	Wtime  int    `json:"wtime"`
	Btime  int    `json:"btime"`
	Winc   int    `json:"winc"`
	Binc   int    `json:"binc"`
	Status string `json:"status"`
}

type serverEvent struct {
	Type string `json:"type"`
	Game *struct {
		Id     string `json:"id"`
		Compat struct {
			Bot   bool `json:"bot"`
			Board bool `json:"board"`
		} `json:"compat"`
	} `json:"game"`
}

func lookForGameStart() string {
	req, err := http.NewRequest("GET", "https://lichess.org/api/stream/event", nil)
	if err != nil {
		log.Fatal(err)
	}
	res, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	log.Println(res.Status)
	dec := json.NewDecoder(res.Body)
	for {
		o := serverEvent{}
		err = dec.Decode(&o)
		if err != nil {
			log.Fatal(err)
		}
		if o.Type == "gameStart" {
			if o.Game.Compat.Board {
				return o.Game.Id
			}
			log.Println("Not compatible with board API")
		}
	}
}
