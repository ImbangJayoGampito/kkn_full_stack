package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129154314CreateEmployeesTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129154314CreateEmployeesTable) Signature() string {
	return "20260129154314_create_employees_table"
}

// Up Run the migrations.
func (r *M20260129154314CreateEmployeesTable) Up() error {
	if !facades.Schema().HasTable("employees") {
		return facades.Schema().Create("employees", func(table schema.Blueprint) {
			table.ID()
			table.UnsignedBigInteger("user_id")
			table.UnsignedBigInteger("role_id")

			table.Date("start_date")
			table.Date("end_date").Nullable()
			table.Decimal("salary")
			table.TimestampsTz()
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129154314CreateEmployeesTable) Down() error {
	return facades.Schema().DropIfExists("employees")
}
