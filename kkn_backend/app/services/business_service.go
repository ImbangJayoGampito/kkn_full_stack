package services

import (
	"fmt"
	"kkn_backend/app/models"

	"github.com/goravel/framework/contracts/database/orm"
	"github.com/goravel/framework/facades"
)

func CreateBusiness(Longitude float64, Latitude float64, Name string, Address string, Phone string, Type models.BusinessType, user models.User) (*models.Business, error) {
	business := &models.Business{
		Longitude: Longitude,
		Latitude:  Latitude,
		Name:      Name,
		Address:   Address,
		Phone:     Phone,
		Type:      Type,
		UserId:    uint64(user.ID),
	}

	err := facades.Orm().Transaction(func(tx orm.Query) error {
		error := tx.Create(business)
		if error != nil {
			return error
		}
		businessId := business.ID
		// Create the owner then
		role, err := CreateRole(tx, "Pemilik", "Pemilik UMKM", "Mengurus bisnis", true, uint64(businessId))
		if err != nil {
			return err
		}
		// User owner as own employee (obviously duh)
		employee := &models.Employee{
			UserId: uint64(user.ID),
			RoleId: role.ID,
		}
		_, err = CreateEmployeeFromAdmin(&user, role, employee, tx)
		if err != nil {
			return err
		}
		// Create an employee for the CreateBusiness
		employeeUser, err := RegisterUser(tx, fmt.Sprintf("employee%d", businessId), fmt.Sprintf("employee%d@example.com", businessId), "password")
		if err != nil {
			return err
		}

		role2, err := CreateRole(tx, "Pegawai", "Pegawai UMKM", "Mengurus bisnis", false, uint64(business.ID))
		if err != nil {
			return err
		}
		employee2 := &models.Employee{
			UserId: uint64(employeeUser.ID),
			RoleId: uint64(role.ID),
		}
		_, err = CreateEmployeeFromAdmin(employeeUser, role2, employee2, tx)
		if err != nil {
			return err
		}
		if err := tx.Commit(); err != nil {
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}

	return business, nil
}
