package api

import (
	"net/mail"
	"regexp"
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
