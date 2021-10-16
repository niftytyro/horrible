package api

type Room struct {
	clients    []*Client
	register   chan *Client
	unregister chan *Client
	broadcast  chan []byte
}

func joinRoom(roomId string) *Room {
	if room, ok := chatRooms[roomId]; ok {
		return room
	}

	room := &Room{
		clients:    []*Client{},
		register:   make(chan *Client),
		unregister: make(chan *Client),
		broadcast:  make(chan []byte),
	}
	chatRooms[roomId] = room
	return room
}

func (r *Room) unregisterClient(client *Client) {
	for i := range r.clients {
		if r.clients[i] == client {
			r.clients = append(r.clients[:i], r.clients[i+1:]...)
		}
	}
}

func (r *Room) run() {
	for {
		select {
		case client := <-r.register:
			r.clients = append(r.clients, client)
		case client := <-r.unregister:
			r.unregisterClient(client)
		case message := <-r.broadcast:
			for i := range r.clients {
				select {
				case r.clients[i].send <- message:
				default:
					close(r.clients[i].send)
					r.unregisterClient(r.clients[i])
				}
			}
		}
	}
}
