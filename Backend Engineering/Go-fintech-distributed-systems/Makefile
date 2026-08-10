.PHONY: all build run test clean db-up db-down migrate-up migrate-down sqlc

APP_NAME = fintech-backend
SERVER_BIN = bin/server
WORKER_BIN = bin/worker
MIGRATOR_BIN = bin/migrator
SCHEDULER_BIN = bin/scheduler

DB_URL ?= postgres://postgres:postgres@localhost:5432/fintech_db?sslmode=disable
MIGRATIONS_DIR = migrations/postgres

all: build

build:
	@echo "Building binaries..."
	go build -o $(SERVER_BIN) cmd/server/main.go
	go build -o $(WORKER_BIN) cmd/worker/main.go
	go build -o $(MIGRATOR_BIN) cmd/migrator/main.go
	go build -o $(SCHEDULER_BIN) cmd/scheduler/main.go

run-server:
	go run cmd/server/main.go

run-worker:
	go run cmd/worker/main.go

test:
	go test -v -race ./...

lint:
	golangci-lint run

clean:
	rm -rf bin/

# Database commands
db-up:
	docker-compose -f deployments/docker/docker-compose.yml up -d postgres mongo redis kafka zookeeper

db-down:
	docker-compose -f deployments/docker/docker-compose.yml down

migrate-create:
	@if [ -z "$(name)" ]; then echo "Usage: make migrate-create name=name_of_migration"; exit 1; fi
	migrate create -ext sql -dir $(MIGRATIONS_DIR) -seq $(name)

migrate-up:
	migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" up

migrate-down:
	migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" down 1

migrate-force:
	@if [ -z "$(version)" ]; then echo "Usage: make migrate-force version=1"; exit 1; fi
	migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" force $(version)

# Code Generation
sqlc:
	sqlc generate
