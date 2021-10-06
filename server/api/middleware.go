package api

import (
	"fmt"
	"net/http"
	"os"

	"github.com/golang-jwt/jwt"
)

func isAuthorized(next http.HandlerFunc) http.HandlerFunc {
	return http.HandlerFunc(
		func(res http.ResponseWriter, req *http.Request) {
			if req.Header["Authorization"] == nil {
				res.WriteHeader(http.StatusUnauthorized)
				res.Write([]byte("jwt not found"))
				return
			}
			token, err := jwt.Parse(req.Header["Authorization"][0], func(t *jwt.Token) (interface{}, error) {
				if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
					return nil, fmt.Errorf("error while parsing")
				}
				return []byte(os.Getenv("JWT_SECRET")), nil
			})

			if err != nil {
				res.WriteHeader(http.StatusUnauthorized)
				res.Write([]byte(err.Error()))
				return
			}

			if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
				id := fmt.Sprint(claims["id"])
				req.Header.Set("Id", id)
				next.ServeHTTP(res, req)
			}
		},
	)
}
