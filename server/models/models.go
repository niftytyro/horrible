package models

import "gorm.io/gorm"

type User struct {
	gorm.Model
	Bio      string
	Email    string `gorm:"unique"`
	Name     string
	Username string `gorm:"unique"`
}
