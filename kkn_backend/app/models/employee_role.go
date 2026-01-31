package models

import (
	"github.com/goravel/framework/database/orm"

)

type EmployeeRole struct {
	orm.Model
	ID          uint64
	Name        string
	Description string
	Permissions string
	HasAdmin    bool
	BusinessId  uint64

	Business  Business
	Employees []Employee `gorm:"many2many:employee_roles_employees;"`
}


