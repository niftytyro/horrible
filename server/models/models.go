package models

import (
	"time"
)

type User struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	Bio       string    `json:"bio"`
	Email     string    `gorm:"unique" json:"email"`
	Name      string    `json:"name"`
	Username  string    `gorm:"unique" json:"username"`
	CreatedAt time.Time `json:"-"`
	UpdatedAt time.Time `json:"-"`
}
