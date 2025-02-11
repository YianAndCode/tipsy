package template

import (
	"bytes"
	"embed"
	"fmt"
	"html/template"
	"path/filepath"
	"strings"

	"github.com/YianAndCode/tipsy/internal/utils"
)

// 辅助函数映射
var funcMap = template.FuncMap{
	"ToSnakeCase": utils.ToSnakeCase,
	"ToLowerCase": strings.ToLower,
	"ToUpperCase": strings.ToUpper,
	"Title":       strings.Title,
	"TrimSpace":   strings.TrimSpace,
	"Safe": func(s string) template.HTML {
		return template.HTML(s)
	},
}

// Engine 是模板引擎的核心结构
type Engine struct {
	templateFS embed.FS
	templates  map[string]*template.Template
}

// New 创建一个新的模板引擎实例
func New(fs embed.FS) *Engine {
	return &Engine{
		templateFS: fs,
		templates:  make(map[string]*template.Template),
	}
}

// LoadTemplates 从嵌入的文件系统中加载所有模板文件
func (e *Engine) LoadTemplates() error {
	return e.loadTemplatesFromDir(".")
}

// loadTemplatesFromDir 递归加载指定目录下的所有模板文件
func (e *Engine) loadTemplatesFromDir(dir string) error {
	entries, err := e.templateFS.ReadDir(dir)
	if err != nil {
		return err
	}

	for _, entry := range entries {
		path := filepath.Join(dir, entry.Name())
		if entry.IsDir() {
			if err := e.loadTemplatesFromDir(path); err != nil {
				return err
			}
		} else if strings.HasSuffix(entry.Name(), ".tpl") {
			content, err := e.templateFS.ReadFile(path)
			if err != nil {
				return err
			}
			tmpl, err := template.New(entry.Name()).Funcs(funcMap).Parse(string(content))
			if err != nil {
				return err
			}
			e.templates[path] = tmpl
		}
	}

	return nil
}

// Execute 执行模板渲染
func (e *Engine) Execute(templateName string, data interface{}) (string, error) {
	tmpl, ok := e.templates[templateName]
	if !ok {
		return "", fmt.Errorf("template %s not found", templateName)
	}

	var buf bytes.Buffer
	if err := tmpl.Execute(&buf, data); err != nil {
		return "", err
	}

	return buf.String(), nil
}

// GetTemplates 返回所有已加载的模板
func (e *Engine) GetTemplates() map[string]*template.Template {
	return e.templates
}
