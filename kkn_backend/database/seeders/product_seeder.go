package seeders

import (
	"fmt"
	"kkn_backend/app/models"
	"math/rand"

	"github.com/goravel/framework/facades"
)

func SeedProducts() error {
	var businesses []models.Business
	err := facades.Orm().Query().Find(&businesses)
	if err != nil {
		return err
	}
	products_per_business := 5

	for i := 0; i < len(businesses); i++ {
		for j := 0; j < products_per_business; j++ {
			product := &models.Product{
				Name:        fmt.Sprintf("Product %d-%d", i, j),
				Price:       float64(j + 1),
				Business:    businesses[i],
				Description: fmt.Sprintf("Description for product %d via business %d\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", i, j),
			}
			rand_price := float64(rand.Intn(10000))
			err := product.CreateProduct(product.Name, product.Description, 0, rand_price, businesses[i])
			if err != nil {
				return err
			}
		}
	}
	return nil
}
