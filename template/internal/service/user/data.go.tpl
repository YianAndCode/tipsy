package user

type RegisterInput struct {
	LoginName string
	Password  string
	Nickname  string
}

type LoginInput struct {
	LoginName string
	Password  string
}
