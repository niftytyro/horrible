package api

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/udasitharani/gab/config"
	"github.com/udasitharani/gab/db"
)

type auth_body struct {
	Email string
	Name  string
}

func loginHandler(res http.ResponseWriter, req *http.Request) {
	decoder := json.NewDecoder(req.Body)

	var body auth_body
	err := decoder.Decode(&body)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(body)
}

func Init() {
	config.Init()
	db.Init()
	router := http.NewServeMux()
	router.HandleFunc("/auth", loginHandler)
	log.Fatal(http.ListenAndServe(":8080", router))
}
