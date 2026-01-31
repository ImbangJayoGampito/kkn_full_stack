package controllers

import (
	"github.com/goravel/framework/contracts/http"
)

type WaliKorongController struct {
}

func NewWaliKorongController() *WaliKorongController {
	return &WaliKorongController{}
}

func (w *WaliKorongController) Index(ctx http.Context) http.Response {
	return ctx.Response().Success().Json(http.Json{
		"Hello": "Goravel",
	})
}
