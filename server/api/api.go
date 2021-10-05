package api

import (
	"log"
	"net/http"

	"github.com/udasitharani/horrible/config"
	"github.com/udasitharani/horrible/db"
)

func Init() {
	config.Init()
	db.Init()
	router := http.NewServeMux()
	router.HandleFunc("/auth", loginHandler)
	router.HandleFunc("/", isAuthorized(updateHandler))
	log.Fatal(http.ListenAndServe(":8080", router))
}
