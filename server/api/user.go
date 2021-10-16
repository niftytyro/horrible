package api

import (
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"net/http"

	"github.com/golang-jwt/jwt"
	"github.com/udasitharani/horrible/db"
	"github.com/udasitharani/horrible/models"
)

type AuthTokenClaims struct {
	ID uint `json:"id"`
	jwt.StandardClaims
}

type OnboardingRequest struct {
	Email string `json:"email"`
	Name  string `json:"name"`
}

type OnboardingResponse struct {
	Bio      string `json:"bio"`
	Name     string `json:"name"`
	Token    string `json:"token"`
	Username string `json:"username"`
	Error    string `json:"error"`
}

type UserRequest struct {
	Bio      string `json:"bio,omitempty"`
	Email    string `json:"email,omitempty"`
	Name     string `json:"name,omitempty"`
	Username string `json:"username,omitempty"`
}

type UserResponse struct {
	ID       int    `json:"id"`
	Bio      string `json:"bio"`
	Email    string `json:"email"`
	Name     string `json:"name"`
	Username string `json:"username"`
	Error    string `json:"error"`
}

func onboardingHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	var data OnboardingRequest
	var response OnboardingResponse
	responseEncoder := json.NewEncoder(w)

	decoder := json.NewDecoder(r.Body)
	err := decoder.Decode(&data)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		response.Error = "Could not parse body"
		responseEncoder.Encode(response)
		return
	}

	data.Email = strings.TrimSpace(data.Email)
	data.Name = strings.TrimSpace(data.Name)
	if !validateEmail(data.Email, false) {
		w.WriteHeader(http.StatusBadRequest)
		response.Error = "Invalid email"
		responseEncoder.Encode(response)
		return
	}
	if !validateName(data.Name, true) {
		w.WriteHeader(http.StatusBadRequest)
		response.Error = "Invalid name"
		responseEncoder.Encode(response)
		return
	}

	var user models.User

	db := db.GetDB()
	db.First(&user, "email = ?", data.Email)

	if user.Email == "" {
		db.Create(&models.User{Email: data.Email, Name: data.Name, Username: generateUsername(data.Name, db), Bio: ""})
		db.First(&user, "email = ?", data.Email)
	}

	authToken := jwt.NewWithClaims(jwt.SigningMethodHS256, AuthTokenClaims{
		user.ID,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * 24 * 365 * 10).Unix(),
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
	responseEncoder.Encode(response)
}

func userHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var response UserResponse
	responseEncoder := json.NewEncoder(w)

	id, err := strconv.Atoi(r.Header["Id"][0])
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		response.Error = "Bad token"
		responseEncoder.Encode(response)
		return
	}

	if r.Method == http.MethodGet {
		w.Header().Set("Content-Type", "application/json")

		var user models.User
		db := db.GetDB()

		start := nthIndex(r.URL.Path, "/", 2)
		end := nthIndex(r.URL.Path, "/", 3)
		if start != -1 && end != -1 {
			id, err = strconv.Atoi(r.URL.Path[start+1 : end])
			if err != nil {
				w.WriteHeader(http.StatusBadRequest)
				response.Error = "Bad url"
				responseEncoder.Encode(response)
				return
			}
		}

		db.First(&user, "id = ?", id)
		if user.Email == "" {
			w.WriteHeader(http.StatusNotFound)
			response.Error = "User not found"
			responseEncoder.Encode(response)
			return
		}
		response.Bio = user.Bio
		response.Email = user.Email
		response.Name = user.Name
		response.Username = user.Username
		response.ID = int(user.ID)
		responseEncoder.Encode(response)

	} else if r.Method == http.MethodPost {
		w.Header().Set("Content-Type", "application/json")

		var data UserRequest
		decoder := json.NewDecoder(r.Body)
		err = decoder.Decode(&data)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			response.Error = "Could not parse body"
			responseEncoder.Encode(response)
			return
		}

		data.Email = strings.TrimSpace(data.Email)
		data.Name = strings.TrimSpace(data.Name)
		data.Username = strings.TrimSpace(data.Username)
		data.Bio = strings.TrimSpace(data.Bio)
		if !validateEmail(data.Email, true) {
			w.WriteHeader(http.StatusBadRequest)
			response.Error = "Invalid email"
			responseEncoder.Encode(response)
			return
		}
		if !validateName(data.Name, true) {
			w.WriteHeader(http.StatusBadRequest)
			response.Error = "Invalid name"
			responseEncoder.Encode(response)
			return
		}
		if !validateUsername(data.Username, true) {
			w.WriteHeader(http.StatusBadRequest)
			response.Error = "Invalid username"
			responseEncoder.Encode(response)
			return
		}

		var user models.User
		db := db.GetDB()
		db.First(&user, "id = ?", id)
		if user.Email == "" {
			w.WriteHeader(http.StatusNotFound)
			response.Error = "User not found"
			responseEncoder.Encode(response)
			return
		}

		if data.Username != "" && data.Username != user.Username {
			var userWithNewUsername models.User
			db.First(&userWithNewUsername, "username = ?", data.Username)
			if userWithNewUsername.Email == "" {
				db.Model(&user).Update("username", data.Username)
			} else {
				w.WriteHeader(http.StatusBadRequest)
				response.Error = "username already in use"
				responseEncoder.Encode(response)
				return
			}
		}
		if data.Email != "" && data.Email != user.Email {
			var userWithNewEmail models.User
			db.First(&userWithNewEmail, "email = ?", data.Email)
			if userWithNewEmail.Email == "" {
				db.Model(&user).Update("email", data.Email)
			} else {
				w.WriteHeader(http.StatusBadRequest)
				response.Error = "email already in use"
				responseEncoder.Encode(response)
				return
			}
		}
		if data.Bio != "" {
			db.Model(&user).Update("bio", data.Bio)
		}
		if data.Name != "" {
			db.Model(&user).Update("name", data.Name)
		}

		response.Bio = user.Bio
		response.Email = user.Email
		response.Name = user.Name
		response.Username = user.Username
		response.ID = int(user.ID)
		responseEncoder.Encode(response)

	} else {

		w.WriteHeader(http.StatusMethodNotAllowed)
		return

	}
}

func searchHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	id, err := strconv.Atoi(r.Header["Id"][0])
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode([]models.User{})
		return
	}

	query := strings.Trim(strings.ToLower(r.URL.Query().Get("q")), " ")
	offset, err := strconv.Atoi(r.URL.Query().Get("offset"))
	if err != nil {
		offset = 0
	}
	limit, err := strconv.Atoi(r.URL.Query().Get("limit"))
	if err != nil {
		limit = 10
	} else if limit > 50 {
		limit = 50
	}

	var users []models.User

	db := db.GetDB()
	db.Not("id = ?", id).
		Where("LOWER(name) LIKE ?", fmt.Sprintf("%%%s%%", query)).
		Or("LOWER(username) LIKE ?", fmt.Sprintf("%%%s%%", query)).
		Offset(offset).
		Limit(limit).
		Find(&users)

	json.NewEncoder(w).Encode(users)
}
