package api

import (
	"encoding/json"
	"os"
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

type UpdateBody struct {
	Bio      string `json:"bio,omitempty"`
	Email    string `json:"email,omitempty"`
	Name     string `json:"name,omitempty"`
	Username string `json:"username,omitempty"`
	Id       string
}

func loginHandler(res http.ResponseWriter, req *http.Request) {
	if req.Method != http.MethodPost {
		res.WriteHeader(http.StatusMethodNotAllowed)
		return
	}
	var data AuthBody

	decoder := json.NewDecoder(req.Body)
	err := decoder.Decode(&data)
	if err != nil {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte("could not parse body"))
		return
	}

	data.Email = strings.TrimSpace(data.Email)
	data.Name = strings.TrimSpace(data.Name)
	if !validateEmail(data.Email, false) {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte("invalid email"))
		return
	}
	if !validateName(data.Name, true) {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte("invalid name"))
		return
	}

	var user models.User

	db := db.GetDB()
	db.First(&user, "email = ?", data.Email)

	if user.Email == "" {
		db.Create(&models.User{Email: data.Email, Name: data.Name})
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

	res.Header().Set("Content-Type", "application/json")
	json.NewEncoder(res).Encode(tokenString)
}

func updateHandler(res http.ResponseWriter, req *http.Request) {
	var data UpdateBody

	decoder := json.NewDecoder(req.Body)
	err := decoder.Decode(&data)

	if err != nil {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte("could not parse body"))
	}

	data.Email = strings.TrimSpace(data.Email)
	data.Name = strings.TrimSpace(data.Name)
	data.Username = strings.TrimSpace(data.Username)
	data.Bio = strings.TrimSpace(data.Bio)
	if !validateEmail(data.Email, true) {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte("invalid email"))
		return
	}
	if !validateName(data.Name, true) {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte("invalid name"))
		return
	}
	if !validateUsername(data.Username, true) {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte("invalid username"))
		return
	}
	if data.Id == "" {
		panic("user id not available")
	}

	var user models.User
	db := db.GetDB()
	db.First(user, "id = ?", data.Id)

	if user.Email == "" {
		res.WriteHeader(http.StatusNotFound)
		res.Write([]byte("user not found"))
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
}
