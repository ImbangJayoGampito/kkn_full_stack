package database

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/contracts/database/seeder"

	"kkn_backend/database/migrations"
	"kkn_backend/database/seeders"
)

type Kernel struct {
}

func (kernel Kernel) Migrations() []schema.Migration {
	return []schema.Migration{
		&migrations.M20210101000001CreateUsersTable{},
		&migrations.M20210101000002CreateJobsTable{},
		&migrations.M20260129154129CreateImagesTable{},
		&migrations.M20260129155946CreateBusinessesTable{},
		&migrations.M20260129154147CreateProductsTable{},

		&migrations.M20260129154314CreateEmployeesTable{},
		&migrations.M20260129154332CreateEmployeeRolesTable{},
		&migrations.M20260129160434CreateWaliNagariTable{},
		&migrations.M20260129160330CreateNagarisTable{},
		&migrations.M20260129160425CreateWaliKorongsTable{},
		&migrations.M20260129154348CreateKorongsTable{},

		&migrations.M20260129154411CreateCoordinatesTable{},

		&migrations.M20260129161336CreateProductTransactionsTable{},
	}
}

func (kernel Kernel) Seeders() []seeder.Seeder {
	return []seeder.Seeder{
		&seeders.DatabaseSeeder{},
	}
}
