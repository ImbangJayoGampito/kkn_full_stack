package models

import "github.com/goravel/framework/database/orm"

type WaliNagari struct {
	orm.Model

	// Fields from your migration
	Name  string `orm:"column:name"`
	Email string `orm:"column:email"`
	Phone string `orm:"column:phone"`

	// Foreign key to User model
	UserId uint64 `orm:"column:user_id"`
	User   *User  `orm:"belongsTo:user"` // Relationship with User model

	// Timestamps are handled automatically by `orm.Model`
}
