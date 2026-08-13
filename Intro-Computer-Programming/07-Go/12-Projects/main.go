package main

import (
	"fmt"
	"log"
	"os"
)


func main(){
	fmt.Println("Hello World")

	PortString := os.Getenv("PORT")
	if PortString == "" {
		log.Fatal("Port is not defined")
	}
	fmt.Println("Port: ", PortString)
}