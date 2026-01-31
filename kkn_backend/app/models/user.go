package models

import (
	"github.com/goravel/framework/database/orm"
)

type User struct {
	orm.Model

	Username string
	Email    string
	Password string

	Businesses          []Business
	EmployeedAt         []Employee
	ProductTransactions []ProductTransaction
	WaliKorong          *WaliKorong
	WaliNagari          *WaliNagari
}
