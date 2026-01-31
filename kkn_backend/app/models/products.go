package models

import (
	"github.com/goravel/framework/database/orm"
	"github.com/goravel/framework/facades"
)

type Product struct {
	orm.Model

	Name        string
	Description string
	Stock       uint
	Price       float64
	BusinessId  uint

	Business     Business
	Images       []Image `gorm:"polymorphic:Imageable;"`
	Transactions []ProductTransaction
}

func (product *Product) CreateProduct(name, description string, stock uint, price float64, business Business) error {
	product.Name = name
	product.Description = description
	product.Stock = stock
	product.Price = price
	product.Business = business
	product.BusinessId = business.ID

	return facades.Orm().Query().Create(product)
}
