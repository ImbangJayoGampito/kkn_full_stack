package models

import (
	"github.com/goravel/framework/database/orm"
	"github.com/goravel/framework/facades"
)

type ProductTransaction struct {
	orm.Model

	// Foreign keys
	UserId *uint64
	User   *User // Relationship with the User model

	ProductId *uint64
	Product   *Product // Relationship with the Product model

	// Transaction details
	Quantity    int
	ProductName *string // Optional product name for denormalization

	// Optional fields
}

func CreateProductTransaction(userId uint64, productId uint64, quantity int) (*ProductTransaction, error) {
	transaction := &ProductTransaction{
		UserId:    &userId,
		ProductId: &productId,
		Quantity:  quantity,
	}

	err := facades.Orm().Query().Create(transaction)
	if err != nil {
		return nil, err
	}
	return transaction, nil
}

func (transaction *ProductTransaction) Update() error {
	_, err := facades.Orm().Query().Update(transaction)
	if err != nil {
		return err
	}
	return nil
}

func (transaction *ProductTransaction) Delete() error {
	_, err := facades.Orm().Query().Delete(transaction)
	if err != nil {
		return err
	}
	return nil
}
