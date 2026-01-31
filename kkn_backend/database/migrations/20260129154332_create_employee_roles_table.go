package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129154332CreateEmployeeRolesTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129154332CreateEmployeeRolesTable) Signature() string {
	return "20260129154332_create_employee_roles_table"
}

// Up Run the migrations.
func (r *M20260129154332CreateEmployeeRolesTable) Up() error {
	if !facades.Schema().HasTable("employee_roles") {
		return facades.Schema().Create("employee_roles", func(table schema.Blueprint) {
			table.ID()
			table.String("name", 255)
			table.Text("description")
			table.Text("permissions")
			table.Boolean("has_admin").Default(false)

			table.UnsignedBigInteger("business_id")
			table.Foreign("business_id").References("id").On("businesses").CascadeOnDelete()
			table.TimestampsTz()
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129154332CreateEmployeeRolesTable) Down() error {
	return facades.Schema().DropIfExists("employee_roles")
}
