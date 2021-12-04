package cmd

import (
	"fmt"

	"github.com/ITK13201/gin-ent-sample/config"
	"github.com/ITK13201/gin-ent-sample/infrastructure"
)

func Run() {
	cfg := *config.Cfg

	router := infrastructure.InitRouter()

	router.Run(fmt.Sprintf(":%d", cfg.Port))
}
