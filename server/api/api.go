package api

import (
	"flag"
	"log"
	"net/http"

	"github.com/udasitharani/horrible/config"
	"github.com/udasitharani/horrible/db"
)

var chatRooms map[string]*Room = make(map[string]*Room)
var addr = flag.String("addr", ":8080", "http server address")

func Init() {
	config.Init()
	db.Init()
	router := http.NewServeMux()
	router.HandleFunc("/onboard", onboardingHandler)
	router.HandleFunc("/search", isAuthorized(searchHandler))
	router.HandleFunc("/user", isAuthorized(userHandler))
	router.HandleFunc("/user/", isAuthorized(userHandler))
	router.HandleFunc("/chat/", chatHandler)
	log.Fatal(http.ListenAndServe(*addr, router))
}
