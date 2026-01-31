package controllers

import (
	"kkn_backend/app/models"

	"github.com/goravel/framework/contracts/http"
	"github.com/goravel/framework/facades"
)

type ProductController struct {
}

func NewProductController() *ProductController {
	return &ProductController{}
}

func (p *ProductController) Index(ctx http.Context) http.Response {
	var products []models.Product
	if err := facades.Orm().Query().Find(&products); err != nil {
		return ctx.Response().
			Status(http.StatusInternalServerError). // Set status code
			Json(http.Json{
				"error": err.Error(),
			})
	}
	return ctx.Response().Success().Json(http.Json{
		"data": products,
	})
}
