package utils

import "testing"

func TestToSnakeCase(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{"Normal CamelCase", "HelloWorld", "hello_world"},
		{"All Uppercase Abbreviation", "ID", "id"},
		{"CamelCase With Uppercase Abbreviation", "UserID", "user_id"},
		{"Consecutive Uppercase Letters Followed By Lowercase", "APIKey", "api_key"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := ToSnakeCase(tt.input)
			if got != tt.expected {
				t.Errorf("ToSnakeCase() = %v, want %v", got, tt.expected)
			}
		})
	}
}