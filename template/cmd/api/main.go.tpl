package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	app, cleanup, err := initAPIServer()
	if err != nil {
		panic(fmt.Sprintf("failed to init app: %v", err))
	}
	defer cleanup()
	defer app.Logger.Close()

	srv := http.Server{
		Addr:         fmt.Sprintf("%s:%d", app.Config.App.Host, app.Config.App.Port),
		Handler:      app.Server.Handler,
		ReadTimeout:  time.Second * 5,
		WriteTimeout: time.Second * 5,
	}

	go func() {
		app.Logger.Infof("server listening on %s", srv.Addr)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			app.Logger.Errorf("listen: %s", err)
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
	{{ "<" | Safe }}-quit
	app.Logger.Info("Shutdown Server ...")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		app.Logger.Errorf("Server Shutdown: %s", err)
	}

	select {
	case {{ "<" | Safe }}-ctx.Done():
		app.Logger.Info("timeout of 5 seconds.")
	}
	app.Logger.Info("Server exiting")
}
