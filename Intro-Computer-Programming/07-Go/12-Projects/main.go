package main

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)


func main(){
	fmt.Println("Hello World")
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	PortString := os.Getenv("PORT")
	if PortString == "" {
		log.Fatal("Port is not defined")
	}
	fmt.Println("Port: ", PortString)
}