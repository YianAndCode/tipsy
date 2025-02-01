package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"{{ .ProjectName }}/cmd/api/bootstrap"
	"{{ .ProjectName }}/internal/config"
	"{{ .ProjectName }}/internal/log"
	"syscall"
	"time"
)

func main() {
	flag := bootstrap.ParseFlag()

	err := bootstrap.Boot(flag.Config)
	if err != nil {
		panic(err)
	}

	cnf := config.Get()

	logger := log.NewLogger(cnf.App.LogFile, cnf.App.LogLevel)
	defer logger.Close()

	apiServer := initAPIServer(logger, cnf)

	srv := http.Server{
		Addr:         fmt.Sprintf("%s:%d", cnf.App.Host, cnf.App.Port),
		Handler:      apiServer.Handler,
		ReadTimeout:  time.Second * 5,
		WriteTimeout: time.Second * 5,
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Errorf("listen: %s", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	// kill (no param) default send syscall.SIGTERM
	// kill -2 is syscall.SIGINT
	// kill -9 is syscall. SIGKILL but can"t be catch, so don't need add it
	signal.Notify(
		quit,
		syscall.SIGINT, syscall.SIGTERM, syscall.SIGUSR1, syscall.SIGUSR2,
	)
	<-quit
	logger.Info("Shutdown Server ...")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		logger.Errorf("Server Shutdown: %s", err)
	}

	select {
	case {{ "<" | Safe }}-ctx.Done():
		logger.Info("timeout of 5 seconds.")
	}
	logger.Info("Server exiting")
}
