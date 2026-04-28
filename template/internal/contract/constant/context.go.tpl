package constant

// TxKey is the key for the database transaction in the context.
type TxKeyType struct{}

var TxKey = TxKeyType{}

// UserIDKey is the key for the user ID in the context.
type UserIDKeyType struct{}

var UserIDKey = UserIDKeyType{}

const (
    // CtxKeyRequestID is the key for the request ID in the context.
    CtxKeyRequestID = "request_id"
    // CtxKeyURI is the key for the URI in the context.
    CtxKeyURI = "uri"
)
