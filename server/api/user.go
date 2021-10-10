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

type SearchResponse struct {
	Users []UserResponse `json:"users"`
	Error string         `json:"error"`
}

func onboardingHandler(res http.ResponseWriter, req *http.Request) {
	if req.Method != http.MethodPost {
		res.WriteHeader(http.StatusMethodNotAllowed)
		return
	}
	var data OnboardingRequest
	var response OnboardingResponse
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
	json.NewEncoder(res).Encode(response)
}

func userHandler(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	var response UserResponse

	id, err := strconv.Atoi(req.Header["Id"][0])
	if err != nil {
		res.WriteHeader(http.StatusBadRequest)
		response.Error = "Bad token"
		json.NewEncoder(res).Encode(response)
		return
	}

	if req.Method == http.MethodGet {
		res.Header().Set("Content-Type", "application/json")

		var user models.User
		db := db.GetDB()

		start := nthIndex(req.URL.Path, "/", 2)
		end := nthIndex(req.URL.Path, "/", 3)
		if start != -1 && end != -1 {
			id, err = strconv.Atoi(req.URL.Path[start+1 : end])
			if err != nil {
				res.WriteHeader(http.StatusBadRequest)
				response.Error = "Bad url"
				json.NewEncoder(res).Encode(response)
				return
			}
		}

		db.First(&user, "id = ?", id)
		if user.Email == "" {
			res.WriteHeader(http.StatusNotFound)
			response.Error = "User not found"
			json.NewEncoder(res).Encode(response)
			return
		}
		response.Bio = user.Bio
		response.Email = user.Email
		response.Name = user.Name
		response.Username = user.Username
		response.ID = int(user.ID)
		json.NewEncoder(res).Encode(response)

	} else if req.Method == http.MethodPost {
		res.Header().Set("Content-Type", "application/json")

		var data UserRequest
		decoder := json.NewDecoder(req.Body)
		err = decoder.Decode(&data)
		if err != nil {
			res.WriteHeader(http.StatusBadRequest)
			response.Error = "Could not parse body"
			json.NewEncoder(res).Encode(response)
			return
		}

		data.Email = strings.TrimSpace(data.Email)
		data.Name = strings.TrimSpace(data.Name)
		data.Username = strings.TrimSpace(data.Username)
		data.Bio = strings.TrimSpace(data.Bio)
		if !validateEmail(data.Email, true) {
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
		if !validateUsername(data.Username, true) {
			res.WriteHeader(http.StatusBadRequest)
			response.Error = "Invalid username"
			json.NewEncoder(res).Encode(response)
			return
		}

		var user models.User
		db := db.GetDB()
		db.First(&user, "id = ?", id)
		if user.Email == "" {
			res.WriteHeader(http.StatusNotFound)
			response.Error = "User not found"
			json.NewEncoder(res).Encode(response)
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

		response.Bio = user.Bio
		response.Email = user.Email
		response.Name = user.Name
		response.Username = user.Username
		response.ID = int(user.ID)
		json.NewEncoder(res).Encode(response)

	} else {

		res.WriteHeader(http.StatusMethodNotAllowed)
		return

	}
}

func searchHandler(res http.ResponseWriter, req *http.Request) {

	var response SearchResponse

	if req.Method != http.MethodGet {
		res.WriteHeader(http.StatusMethodNotAllowed)
		return
	}

	query := strings.ToLower(req.URL.Query().Get("q"))
	offset, err := strconv.Atoi(req.URL.Query().Get("offset"))
	if err != nil {
		offset = 0
	}
	limit, err := strconv.Atoi(req.URL.Query().Get("limit"))
	if err != nil {
		limit = 10
	} else if limit > 50 {
		limit = 50
	}

	var users []models.User

	db := db.GetDB()
	db.Where("LOWER(name) LIKE ?", fmt.Sprintf("%%%s%%", query)).Offset(offset).Limit(limit).Find(&users)

	for i := 0; i < len(users); i++ {
		response.Users = append(response.Users, UserResponse{
			ID:       int(users[i].ID),
			Bio:      users[i].Bio,
			Email:    users[i].Email,
			Name:     users[i].Name,
			Username: users[i].Username,
		})
	}

	json.NewEncoder(res).Encode(response)
}
