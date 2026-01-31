package models

import "github.com/goravel/framework/database/orm"

type Coordinate struct {
	orm.Model

	Latitude  string
	Longitude string

	CoordinateableType string
	CoordinateableID   uint64
}
