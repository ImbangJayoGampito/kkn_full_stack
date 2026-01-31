package models

import "github.com/goravel/framework/database/orm"

type Image struct {
	orm.Model

	ImageUrl      string
	ImageAlt      string
	ImageTitle    string
	ImageableType string 
	ImageableID   uint64 
}
