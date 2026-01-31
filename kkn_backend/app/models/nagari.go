package models

import (
	"github.com/goravel/framework/database/orm"
	"github.com/goravel/framework/facades"
)

type Nagari struct {
	orm.Model

	// Fields from your migration
	Name        string
	Address     string
	Phone       string
	Email       string
	Description string

	// Foreign key to User model
	UserId     uint64
	WaliNagari *WaliNagari

	// Timestamps are handled automatically by `orm.Model`
}

func (nagari *Nagari) Create() error {
	return facades.Orm().Query().Create(nagari)
}
