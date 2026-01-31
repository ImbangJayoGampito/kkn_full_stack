package services

import (
	"errors"
	"kkn_backend/app/models"

	"github.com/goravel/framework/contracts/database/orm"
	"github.com/goravel/framework/facades"
)

func LoginUser(usernameOrEmail string, passwordRaw string) (*models.User, error) {
	if usernameOrEmail == "" || passwordRaw == "" {
		return nil, errors.New("username or email and password are required")
	}
	pass, err := facades.Hash().Make(passwordRaw)
	if err != nil {
		return nil, err
	}
	u := &models.User{
		Username: usernameOrEmail,
		Email:    usernameOrEmail,
		Password: pass,
	}
	error := facades.Orm().Query().Create(u)
	if error != nil {
		return nil, error
	}
	return u, nil
}

func RegisterUser(tx orm.Query, username, email, passwordRaw string) (*models.User, error) {
	pass, err := facades.Hash().Make(passwordRaw)
	if err != nil {
		return nil, err
	}
	u := &models.User{
		Username: username,
		Email:    email,
		Password: pass,
	}
	error := tx.Create(u)
	if error != nil {
		return nil, error
	}
	return u, nil
}
