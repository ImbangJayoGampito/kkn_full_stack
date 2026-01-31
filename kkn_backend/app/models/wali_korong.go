package models

import "github.com/goravel/framework/database/orm"

type WaliKorong struct {
	orm.Model

	// Fields from your migration
	Name  string 
	Email string 
	Phone string 

	// Foreign key to User model
	UserId uint64 
	User   *User  // Relationship with User model

	// Timestamps are handled automatically by `orm.Model`
}
