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
	router.HandleFunc("/", isAuthorized(updateHandler))
	router.HandleFunc("/user", loginHandler)
	log.Fatal(http.ListenAndServe(":8080", router))
}
