package api

import (
	"net/mail"
	"regexp"
	"strings"

	"github.com/udasitharani/horrible/models"
	"gorm.io/gorm"
)

func validateEmail(email string, allowEmpty bool) bool {
	if allowEmpty && email == "" {
		return true
	}
	_, err := mail.ParseAddress(email)
	return err == nil
}

func validateName(name string, allowEmpty bool) bool {
	if allowEmpty && name == "" {
		return true
	}
	match, _ := regexp.MatchString("(^[a-zA-Z][a-zA-Z ]+[a-zA-Z]$)", name)
	return match
}

func validateUsername(username string, allowEmpty bool) bool {
	if allowEmpty && username == "" {
		return true
	}
	match, _ := regexp.MatchString("(^[a-zA-Z][a-zA-Z._]+[a-zA-Z]$)", username)
	return match
}

func generateUsername(name string, db *gorm.DB) string {
	firstName := strings.ToLower(name)[0:strings.Index(name, " ")]
	lastName := strings.TrimSpace(strings.ToLower(name)[strings.Index(name, " "):])
	var user models.User
	idx := 0
	db.First(&user, "username = ?", firstName+strings.Repeat("_", idx)+lastName)
	idx++
	for ; user.Email != "" && idx <= 10; idx++ {
		user = models.User{}
		db.First(&user, "username = ?", firstName+strings.Repeat("_", idx)+lastName)
	}
	return firstName + strings.Repeat("_", idx-1) + lastName
}

func nthIndex(text string, subtext string, n int) int {
	index := -1
	for count := 0; count < n; count++ {
		newIndex := strings.Index(text[index+1:], subtext)
		if newIndex == -1 {
			return -1
		}
		index = newIndex + index + 1
	}
	return index
}
