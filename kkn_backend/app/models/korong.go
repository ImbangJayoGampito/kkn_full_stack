package models

import (
	"github.com/goravel/framework/database/orm"
	"github.com/goravel/framework/facades"
)

type Korong struct {
	orm.Model

	Name         string
	Address      string
	Phone        string
	Email        string
	Description  string
	WaliKorongId uint64

	WaliKorong *WaliKorong

	Coordinates []Coordinate `orm:"morphMany:Coordinateable"`
	Images      []Image      `orm:"morphMany:Imageable"`
}

func (korong *Korong) Create() error {
	return facades.Orm().Query().Create(korong)
}
