package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi"
	"github.com/go-chi/cors"
	"github.com/joho/godotenv"
	"github.com/unawarexi/12-projects/internal/database"

	_ "github.com/lib/pq"
)

type apiConfig struct {
	DB *database.Queries
}

func main() {
	fmt.Println("Hello World")

	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	portString := os.Getenv("PORT")
	if portString == "" {
		log.Fatal("Port is not defined")
	}

	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		log.Fatal("DATABASE_URL environment variable is not set")
	}

	db, err := sql.Open("postgres", dbURL)
	if err != nil {
		log.Fatal(err)
	}
	dbQueries := database.New(db)

	apiCfg := apiConfig{
		DB: dbQueries,
	}


	router := chi.NewRouter()

	router.Use(cors.Handler(cors.Options{
		AllowedOrigins: []string{"https://*", "http://*"},
		AllowedHeaders: []string{"*"},
		AllowedMethods: []string{"PUT", "GET", "PATCH", "POST", "DELETE", "OPTIONS", "QUERY"},
		ExposedHeaders: []string{"Link"},
		AllowCredentials: false,
		MaxAge: 300,

	}))

	v1Router := chi.NewRouter()
	v1Router.Post("/users", apiCfg.handlerUsersCreate)
	v1Router.Get("/users", apiCfg.handlerUsersGet)
	v1Router.Get("/health", handlerReadiness)
	router.Mount("/v1", v1Router)
	v1Router.Get("/err", handlerError)

 
	srv := &http.Server{
		Handler: router,
		Addr:    ":" + portString,
	}

	log.Printf("Server starting on port %s", portString)

	err = srv.ListenAndServe()
	if err != nil {
		log.Fatal("Error starting server: ", err)
	}
}