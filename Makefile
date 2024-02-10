BINARY=gobank
.DEFAULT_GOAL := run

build:
	@go build -o bin/${BINARY}

run:build
	@./bin/${BINARY}

clean:
	rm -rf bin

dbup:
	@docker compose up -d --remove-orphans

dbdown:
	@docker compose down

createdb:
	@docker exec -it gobank_db createdb --username=postgres --owner=postgres gobank

dropdb:
	@docker exec -it gobank_db dropdb --username=postgres gobank

migrate_up:
	@migrate -path db/migration -database "postgresql://postgres:postgres@localhost:5432/gobank?sslmode=disable" up

migrate_down:
	@migrate -path db/migration -database "postgresql://postgres:postgres@localhost:5432/gobank?sslmode=disable" down

sqlc:
	@sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

.PHONY: dbup dbdown createdb dropdb migrate_up migrate_down test server