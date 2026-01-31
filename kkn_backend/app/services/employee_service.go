package services

import (
	"fmt"
	"kkn_backend/app/models"

	"github.com/goravel/framework/contracts/database/orm"
)

func createEmployee(user *models.User, role *models.EmployeeRole, employee *models.Employee, tx orm.Query) (*models.Employee, error) {
	if err := tx.Create(&employee); err != nil {
		tx.Rollback()
		return nil, err
	}
	if err := tx.Model(employee).Association("User").Append(user); err != nil {
		tx.Rollback()
		return nil, err
	}
	if err := tx.Model(employee).Association("Role").Append(role); err != nil {
		tx.Rollback()
		return nil, err
	}

	return employee, nil
}

func CreateEmployeeBusinessOwner(user *models.User, role *models.EmployeeRole, employee *models.Employee, tx orm.Query) (*models.Employee, error) {
	if role.HasAdmin {
		return nil, fmt.Errorf("You do not have permission ")
	}
	employee, err := createEmployee(user, role, employee, tx)
	if err != nil {
		return nil, err
	}
	return employee, nil
}
func CreateEmployeeFromAdmin(user *models.User, role *models.EmployeeRole, employee *models.Employee, tx orm.Query) (*models.Employee, error) {
	employee, err := createEmployee(user, role, employee, tx)
	if err != nil {
		return nil, err
	}
	return employee, nil
}
