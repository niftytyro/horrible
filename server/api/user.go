package api

import (
	"encoding/json"
	"os"
	"time"

	"net/http"

	"github.com/golang-jwt/jwt"
	"github.com/udasitharani/gab/db"
	"github.com/udasitharani/gab/models"
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
	var data AuthBody

	decoder := json.NewDecoder(req.Body)
	err := decoder.Decode(&data)
	if err != nil {
		panic(err)
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
		panic(err)
	}

	var user models.User
	db := db.GetDB()
	db.First(user, "id = ?", data.Id)

	if user.Email == "" {
		res.WriteHeader(http.StatusNotFound)
		res.Write([]byte("user not found"))
		return
	}

	db.Model(&user).Update("bio", data.Bio)
	db.Model(&user).Update("email", data.Email)
	db.Model(&user).Update("name", data.Name)
	db.Model(&user).Update("username", data.Username)
}
