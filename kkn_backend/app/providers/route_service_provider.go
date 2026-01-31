package providers

import (
	"kkn_backend/routes"

	"github.com/goravel/framework/contracts/foundation"
	contractshttp "github.com/goravel/framework/contracts/http"
	"github.com/goravel/framework/facades"
	"github.com/goravel/framework/http/limit"
)

type RouteServiceProvider struct {
}

func (receiver *RouteServiceProvider) Register(app foundation.Application) {
}

func (receiver *RouteServiceProvider) Boot(app foundation.Application) {
	// Add HTTP middleware
	facades.Route().GlobalMiddleware()

	receiver.configureRateLimiting()

	// Add routes
	routes.Web()
	routes.Api()
}

func (receiver *RouteServiceProvider) configureRateLimiting() {
	facades.RateLimiter().For("global", func(ctx contractshttp.Context) contractshttp.Limit {
		return limit.PerMinute(1000)
	})
	facades.RateLimiter().For("api", func(ctx contractshttp.Context) contractshttp.Limit {
		// Simple per-IP limit (10 requests per minute)
		facades.Log().Info("RateLimiter called for IP: " + ctx.Request().Ip())
		return limit.PerMinute(10).By(ctx.Request().Ip())
	})
}
