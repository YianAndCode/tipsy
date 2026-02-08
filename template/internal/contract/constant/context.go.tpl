package constant

// TxKey is the key for the database transaction in the context.
type TxKeyType struct{}

var TxKey = TxKeyType{}

// UserIDKey is the key for the user ID in the context.
type UserIDKeyType struct{}

var UserIDKey = UserIDKeyType{}
