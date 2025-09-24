package utils

import "unicode"

func ToSnakeCase(s string) string {
	var result []rune
	for i, r := range s {
		// 处理以下情况：
		// 1. 当前字符是大写且前一个字符是小写时，添加下划线
		// 2. 当前字符是大写，前一个字符也是大写，但后一个字符是小写时，添加下划线
		if i > 0 && r >= 'A' && r <= 'Z' && (
			// 前一个字符是小写
			(s[i-1] < 'A' || s[i-1] > 'Z') ||
			// 前一个字符是大写，当前字符是大写，后一个字符是小写
			(i < len(s)-1 && s[i-1] >= 'A' && s[i-1] <= 'Z' && s[i+1] >= 'a' && s[i+1] <= 'z')) {
			result = append(result, '_')
		}
		result = append(result, unicode.ToLower(r))
	}
	return string(result)
}
