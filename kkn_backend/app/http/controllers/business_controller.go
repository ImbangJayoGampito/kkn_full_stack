package controllers

import (
	"github.com/goravel/framework/contracts/http"
)

type BusinessController struct {
}

func NewBusinessController() *BusinessController {
	return &BusinessController{}
}

func (b *BusinessController) Index(ctx http.Context) http.Response {
	return ctx.Response().Success().Json(http.Json{
		"Hello": "Goravel",
	})
}
