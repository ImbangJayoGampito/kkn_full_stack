package models

import (
	"github.com/goravel/framework/database/orm"
)

type BusinessType string

const (
	BusinessTypeRestoran   BusinessType = "restoran"
	BusinessTypeToko       BusinessType = "toko"
	BusinessTypeKantor     BusinessType = "kantor"
	BusinessTypeGudang     BusinessType = "gudang"
	BusinessTypePariwisata BusinessType = "pariwisata"
	BusinessTypeLainLain   BusinessType = "lain-lain"
)

type Business struct {
	orm.Model

	Longitude float64
	Latitude  float64
	Name      string
	Address   string
	Phone     string
	Type      BusinessType
	UserId    uint64

	User          User
	Products      []Product
	EmployeeRoles []EmployeeRole

	Images      []Image      `gorm:"polymorphic:Imageable;"`
}
