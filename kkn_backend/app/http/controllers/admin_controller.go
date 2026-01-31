package controllers

import (
	"github.com/goravel/framework/contracts/http"
)

type AdminController struct {
}

func NewAdminController() *AdminController {
	return &AdminController{}
}

func (a *AdminController) Index(ctx http.Context) http.Response {
	return ctx.Response().Success().Json(http.Json{
		"Hello": "Goravel",
	})
}
