package api

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/udasitharani/horrible/db"
	"github.com/udasitharani/horrible/models"
)

func chatHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var response UserResponse
	responseEncoder := json.NewEncoder(w)

	var friendId, userId int
	var err error

	// fetching friend id
	start := nthIndex(r.URL.Path, "/", 2)
	end := nthIndex(r.URL.Path, "/", 3)
	if start != -1 && end != -1 {
		friendId, err = strconv.Atoi(r.URL.Path[start+1 : end])
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			response.Error = "Bad url"
			responseEncoder.Encode(response)
			return
		}
	}

	// fetching user id
	// userId, err = strconv.Atoi(r.Header["Id"][0])
	// if err != nil {
	// 	w.WriteHeader(http.StatusBadRequest)
	// 	response.Error = "Bad token"
	// 	responseEncoder.Encode(response)
	// 	return
	// }
	userId = 1

	var user, friend models.User
	// making sure both user & friend exist
	db := db.GetDB()
	db.First(&user, "id = ?", userId)
	db.First(&friend, "id = ?", friendId)

	if user.Email == "" || friend.Email == "" || userId == friendId {
		w.WriteHeader(http.StatusBadRequest)
		response.Error = "user not found"
		responseEncoder.Encode(response)
		return
	}

	room := joinRoom(generateRoomId(userId, friendId))
	go room.run()
	ServeWs(room, w, r)
}
