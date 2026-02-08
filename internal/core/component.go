package core

import (
	"fmt"
	"path/filepath"
)

type ComponentType string

const (
	Unknown    ComponentType = ""
	App        ComponentType = "application"
	Entity     ComponentType = "entity"
	Repo       ComponentType = "repo"
	Controller ComponentType = "controller"
	Middleware ComponentType = "middleware"
	Service    ComponentType = "service"
)

func (ct ComponentType) String() string {
	return string(ct)
}

// 是否是合法的组件
func IsValidComponent(componentTypeStr string) bool {
	validTypes := map[string]bool{
		"app":         true, // alias for application
		"application": true,
		"entity":      true,
		"repo":        true,
		"controller":  true,
		"middleware":  true,
		"service":     true,
	}
	return validTypes[componentTypeStr]
}

// 获取组件类型
func GetComponentType(componentTypeStr string) ComponentType {
	switch componentTypeStr {
	case "app", "application":
		return App
	case "entity":
		return Entity
	case "repo":
		return Repo
	case "controller":
		return Controller
	case "middleware":
		return Middleware
	case "service":
		return Service
	default:
		return Unknown
	}
}

// 获取组件路径
func GetComponentDir(cwd string, componentType ComponentType) string {
	var componentDir string
	switch componentType {
	case App:
		componentDir = filepath.Join(cwd, "internal", "application")
	case Entity:
		componentDir = filepath.Join(cwd, "internal", "entity")
	case Repo:
		componentDir = filepath.Join(cwd, "internal", "repo")
	case Controller:
		componentDir = filepath.Join(cwd, "internal", "controller")
	case Middleware:
		componentDir = filepath.Join(cwd, "internal", "middleware")
	case Service:
		componentDir = filepath.Join(cwd, "internal", "service")
	}
	return componentDir
}

// 获取 Provider 构造函数名
func GetProviderConstructorName(componentName string, componentType ComponentType) string {
	switch componentType {
	case App:
		return fmt.Sprintf("New%sApp", componentName)
	case Repo:
		return fmt.Sprintf("New%sRepo", componentName)
	case Controller:
		return fmt.Sprintf("New%sController", componentName)
	case Middleware:
		return fmt.Sprintf("New%sMiddleware", componentName)
	case Service:
		return fmt.Sprintf("New%sService", componentName)
	default:
		return ""
	}
}
