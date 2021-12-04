-- +goose Up
-- +goose StatementBegin
CREATE TABLE users (
   id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
   username VARCHAR(128) NOT NULL UNIQUE,
   password VARCHAR(128) NOT NULL,
   created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
   updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS users;
-- +goose StatementEnd
