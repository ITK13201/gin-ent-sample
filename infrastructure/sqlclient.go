package infrastructure

import (
	"log"

	"github.com/ITK13201/gin-ent-sample/config"
	"github.com/ITK13201/gin-ent-sample/ent"
	_ "github.com/go-sql-driver/mysql"
)

func NewSqlClient() *ent.Client {
	cfg := *config.Cfg

	entOptions := []ent.Option{}
	if cfg.Debug {
		entOptions = append(entOptions, ent.Debug())
	}

	client, err := ent.Open("mysql", cfg.DatabaseDsn, entOptions...)
	if err != nil {
		log.Fatal(err)
	}

	return client
}
