package middleware

import (
    "runtime/debug"

    contractshttp "github.com/goravel/framework/contracts/http"
    "github.com/goravel/framework/facades"
)

func Recover() contractshttp.Middleware {
    return func(ctx contractshttp.Context) {
        defer func() {
            if r := recover(); r != nil {
                facades.Log().Error("Panic recovered in request",
                    "error", r,
                    "stack", string(debug.Stack()),
                    "path", ctx.Request().Path(),
                    "method", ctx.Request().Method(),
                )
                ctx.Response().Json(500, map[string]any{
                    "message": "Internal Server Error - panic occurred",
                })
                // ctx.Request().Abort()  // optional
            }
        }()
        ctx.Request().Next()
    }
}