package log

import (
	"fmt"
	"log"
	"os"
	"sync"
	"time"
)

type FileManager struct {
	mu             sync.Mutex
	currentFile    *os.File
	logPath        string
	nextSwitchTime time.Time
}

func NewFileManager(logPath string) *FileManager {
	loger := &FileManager{
		logPath: logPath,
	}
	loger.rotate()
	return loger
}

func (l *FileManager) Write(p []byte) (n int, err error) {
	l.mu.Lock()
	defer l.mu.Unlock()

	if time.Now().After(l.nextSwitchTime) {
		l.rotate()
	}

	return l.currentFile.Write(p)
}

func (l *FileManager) Close() error {
	l.mu.Lock()
	defer l.mu.Unlock()

	if l.currentFile == nil {
		return l.currentFile.Close()
	}
	return nil
}

func (l *FileManager) rotate() {
	if l.currentFile != nil {
		l.currentFile.Close()
	}

	now := time.Now()
	l.nextSwitchTime = time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location()).Add(24 * time.Hour)

	logPath := fmt.Sprintf("%s.%s", l.logPath, now.Format("2006-01-02"))
	f, err := os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	if err != nil {
		log.Fatalf("failed to open log file: %v", err)
	}

	l.currentFile = f
}
