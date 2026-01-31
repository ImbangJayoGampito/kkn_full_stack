package models

import (
	"github.com/goravel/framework/database/orm"
)

type Employee struct {
	orm.Model

	UserId uint64
	User   User

	RoleId uint64
	Role   EmployeeRole

	StartDate string
	EndDate   *string
	Salary    float64
}
