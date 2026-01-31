package services

import (
	"kkn_backend/app/models"

	"github.com/goravel/framework/contracts/database/orm"
)

func CreateRole(
	tx orm.Query,
	Name string,
	Description string,
	Permission string,
	HasAdmin bool,
	BusinessId uint64,
) (*models.EmployeeRole, error) {

	role := &models.EmployeeRole{
		Name:        Name,
		Description: Description,
		Permissions: Permission,
		HasAdmin:    HasAdmin,
		BusinessId:  BusinessId,
	}

	if err := tx.Create(role); err != nil {
		return nil, err
	}

	return role, nil
}
