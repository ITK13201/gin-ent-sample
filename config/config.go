package config

import (
	"log"
	"time"

	"github.com/kelseyhightower/envconfig"
)

type Config struct {
	Debug       bool   `json:debug envconfig:"DEBUG"`
	DatabaseDsn string `json:"database-dsn" envconfig:"DATABASE_DSN" required:"true"`
	Port        int    `json:"port" envconfig:"PORT" required:"true"`
}

var Cfg *Config
var JST *time.Location
var UTC *time.Location

func LoadConfig() (*Config, error) {
	var cfg Config
	err := envconfig.Process("", &cfg)

	return &cfg, err
}

func init() {
	var err error

	Cfg, err = LoadConfig()
	if err != nil {
		log.Fatal(err)
	}

	JST, err = time.LoadLocation("Asia/Tokyo")
	if err != nil {
		log.Fatal(err)
	}

	UTC, err = time.LoadLocation("UTC")
	if err != nil {
		log.Fatal(err)
	}
}
