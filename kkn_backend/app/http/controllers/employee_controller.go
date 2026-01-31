package controllers

import (
	"github.com/goravel/framework/contracts/http"
)

type EmployeeController struct {
}

func NewEmployeeController() *EmployeeController {
	return &EmployeeController{}
}

func (c *EmployeeController) Index(ctx http.Context) http.Response {
	return ctx.Response().Success().Json(http.Json{
		"Hello": "Goravel",
	})
}
