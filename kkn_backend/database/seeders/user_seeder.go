package seeders

import (
	"fmt"
	"kkn_backend/app/services"
)

func SeedUsers() error {
	amount_to_generate := 30
	for i := 0; i < amount_to_generate; i++ {
		_, err := services.RegisterUser(fmt.Sprintf("User %d", i), fmt.Sprintf("user%d@example.com", i), "password")
		if err != nil {
			return err
		}
	}
	return nil
}
