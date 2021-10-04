package models

import "gorm.io/gorm"

type User struct {
	gorm.Model
	Bio      string
	Email    string
	Name     string
	Username string
}
