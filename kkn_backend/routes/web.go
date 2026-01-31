package routes

import (
	"github.com/goravel/framework/contracts/http"
	"github.com/goravel/framework/facades"
	"github.com/goravel/framework/http/middleware"
	"github.com/goravel/framework/support"
)

func Web() {
	facades.Route().Middleware(middleware.Throttle("global")).Get("/arf", func(ctx http.Context) http.Response {
		return ctx.Response().Json(200, http.Json{
			"Hello": "Goravel",
		})
	})
	facades.Route().Get("/", func(ctx http.Context) http.Response {
		return ctx.Response().View().Make("welcome.tmpl", map[string]any{
			"version": support.Version,
		})
	})
}
