package tests

import (
	"github.com/goravel/framework/testing"

	"kkn_backend/bootstrap"
)

func init() {
	bootstrap.Boot()
}

type TestCase struct {
	testing.TestCase
}
