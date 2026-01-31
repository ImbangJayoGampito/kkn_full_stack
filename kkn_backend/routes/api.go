package routes

import (
	"github.com/goravel/framework/contracts/http"
	"github.com/goravel/framework/contracts/route"
	"github.com/goravel/framework/facades"
	"github.com/goravel/framework/http/middleware"

	"kkn_backend/app/http/controllers"
)

func Api() {
	userController := controllers.NewUserController()
	productController := controllers.NewProductController()
	facades.Route().Middleware(middleware.Throttle("api")).Group(func(router route.Router) {
		router.Get("/api/users/{id}", userController.Show)
		router.Get("/api/produk", productController.Index)
	})

	facades.Route().Middleware(middleware.Throttle("api")).Get("/meow", func(ctx http.Context) http.Response {
		return ctx.Response().Json(200, http.Json{
			"Hello": "Goravel",
		})
	})

}
