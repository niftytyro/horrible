package api

import (
	"bytes"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

type Client struct {
	connection *websocket.Conn
	room       *Room
	send       chan []byte
}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

func (c Client) readPump() {
	defer func() {
		c.connection.Close()
	}()
	for {
		_, msg, err := c.connection.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseAbnormalClosure, websocket.CloseGoingAway) {
				log.Println("websocket closed err: ", err)
				return
			}
		}
		msg = bytes.TrimSpace(msg)
		c.room.broadcast <- msg
	}
}

func (c Client) writePump() {
	defer func() {
		c.connection.WriteMessage(websocket.CloseMessage, []byte{})
		c.connection.Close()
	}()
	for message := range c.send {
		w, err := c.connection.NextWriter(websocket.TextMessage)
		if err != nil {
			return
		}

		w.Write(message)
		for i := 0; i < len(c.send); i++ {
			w.Write([]byte{'\n'})
			w.Write(<-c.send)
		}

		if err := w.Close(); err != nil {
			return
		}
	}
}

func ServeWs(room *Room, w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	client := Client{connection: conn, send: make(chan []byte), room: room}
	room.register <- &client
	go client.readPump()
	go client.writePump()
}
