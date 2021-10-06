package api

import (
	"encoding/json"
	"os"
	"strconv"
	"strings"
	"time"

	"net/http"

	"github.com/golang-jwt/jwt"
	"github.com/udasitharani/horrible/db"
	"github.com/udasitharani/horrible/models"
)

type AuthBody struct {
	Email string `json:"email"`
	Name  string `json:"name"`
}

type AuthTokenClaims struct {
	ID uint `json:"id"`
	jwt.StandardClaims
}

type UpdateResponse struct {
	Bio      string `json:"bio,omitempty"`
	Email    string `json:"email,omitempty"`
	Name     string `json:"name,omitempty"`
	Username string `json:"username,omitempty"`
	Error    string `json:"error,omitempty"`
}

type LoginResponse struct {
	Bio      string `json:"bio"`
	Name     string `json:"name"`
	Token    string `json:"token"`
	Username string `json:"username"`
	Error    string `json:"error"`
}

func loginHandler(res http.ResponseWriter, req *http.Request) {
	if req.Method != http.MethodPost {
		res.WriteHeader(http.StatusMethodNotAllowed)
		return
	}
	var data AuthBody
	var response LoginResponse
	res.Header().Set("Content-Type", "application/json")

	decoder := json.NewDecoder(req.Body)
	err := decoder.Decode(&data)
	if err != nil {
		res.WriteHeader(http.StatusBadRequest)
		response.Error = "Could not parse body"
		json.NewEncoder(res).Encode(response)
		return
	}

	data.Email = strings.TrimSpace(data.Email)
	data.Name = strings.TrimSpace(data.Name)
	if !validateEmail(data.Email, false) {
		res.WriteHeader(http.StatusBadRequest)
		response.Error = "Invalid email"
		json.NewEncoder(res).Encode(response)
		return
	}
	if !validateName(data.Name, true) {
		res.WriteHeader(http.StatusBadRequest)
		response.Error = "Invalid name"
		json.NewEncoder(res).Encode(response)
		return
	}

	var user models.User

	db := db.GetDB()
	db.First(&user, "email = ?", data.Email)

	if user.Email == "" {
		db.Create(&models.User{Email: data.Email, Name: data.Name, Username: generateUsername(data.Name, db)})
		db.First(&user, "email = ?", data.Email)
	}

	authToken := jwt.NewWithClaims(jwt.SigningMethodHS256, AuthTokenClaims{
		user.ID,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * 24).Unix(),
		},
	})

	tokenString, err := authToken.SignedString([]byte(os.Getenv("JWT_SECRET")))

	if err != nil {
		panic(err)
	}

	response.Bio = user.Bio
	response.Name = user.Name
	response.Token = tokenString
	response.Username = user.Username
	json.NewEncoder(res).Encode(response)
}

func userHandler(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	var response UpdateResponse

	id, err := strconv.Atoi(req.Header["Id"][0])
	if err != nil {
		res.WriteHeader(http.StatusBadRequest)
		response.Error = "Bad token"
		return
	}

	if req.Method == http.MethodGet {

		var user models.User
		db := db.GetDB()
		db.First(&user, "id = ?", id)
		if user.Email == "" {
			res.WriteHeader(http.StatusNotFound)
			response.Error = "User not found"
			return
		}
		res.Header().Set("Content-Type", "application/json")
		response.Bio = user.Bio
		response.Email = user.Email
		response.Name = user.Name
		response.Username = user.Username
		json.NewEncoder(res).Encode(response)

	} else if req.Method == http.MethodPost {

		var data UpdateResponse
		decoder := json.NewDecoder(req.Body)
		err = decoder.Decode(&data)
		if err != nil {
			res.WriteHeader(http.StatusBadRequest)
			response.Error = "Could not parse body"
			return
		}

		data.Email = strings.TrimSpace(data.Email)
		data.Name = strings.TrimSpace(data.Name)
		data.Username = strings.TrimSpace(data.Username)
		data.Bio = strings.TrimSpace(data.Bio)
		if !validateEmail(data.Email, true) {
			res.WriteHeader(http.StatusBadRequest)
			response.Error = "Invalid email"
			return
		}
		if !validateName(data.Name, true) {
			res.WriteHeader(http.StatusBadRequest)
			response.Error = "Invalid name"
			return
		}
		if !validateUsername(data.Username, true) {
			res.WriteHeader(http.StatusBadRequest)
			response.Error = "Invalid username"
			return
		}

		var user models.User
		db := db.GetDB()
		db.First(&user, "id = ?", id)
		if user.Email == "" {
			res.WriteHeader(http.StatusNotFound)
			response.Error = "User not found"
			return
		}

		if data.Bio != "" {
			db.Model(&user).Update("bio", data.Bio)
		}
		if data.Email != "" {
			db.Model(&user).Update("email", data.Email)
		}
		if data.Name != "" {
			db.Model(&user).Update("name", data.Name)
		}
		if data.Username != "" {
			db.Model(&user).Update("username", data.Username)
		}

		json.NewEncoder(res).Encode(response)

	} else {

		res.WriteHeader(http.StatusMethodNotAllowed)
		return

	}
}
