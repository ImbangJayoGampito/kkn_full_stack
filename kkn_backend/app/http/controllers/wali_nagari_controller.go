package controllers

import (
	"github.com/goravel/framework/contracts/http"
)

type WaliNagariController struct {
}

func NewWaliNagariController() *WaliNagariController {
	return &WaliNagariController{}
}

func (w *WaliNagariController) Index(ctx http.Context) http.Response {
	return ctx.Response().Success().Json(http.Json{
		"Hello": "Goravel",
	})
}
