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
	router.HandleFunc("/search", isAuthorized(searchHandler))
	router.HandleFunc("/onboard", onboardingHandler)
	router.HandleFunc("/user", isAuthorized(userHandler))
	router.HandleFunc("/user/", isAuthorized(userHandler))
	log.Fatal(http.ListenAndServe(":8080", router))
}
