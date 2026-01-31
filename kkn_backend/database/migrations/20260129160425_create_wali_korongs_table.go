package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129160425CreateWaliKorongsTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129160425CreateWaliKorongsTable) Signature() string {
	return "20260129160425_create_wali_korong_table"
}

// Up Run the migrations.
func (r *M20260129160425CreateWaliKorongsTable) Up() error {
	if !facades.Schema().HasTable("wali_korongs") {
		return facades.Schema().Create("wali_korongs", func(table schema.Blueprint) {
			table.ID()

			// Fields from your model
			table.String("name", 255)
			table.String("email", 255)
			table.String("phone", 50)

			// Foreign key to user
			table.UnsignedBigInteger("user_id")
			table.Foreign("user_id").References("id").On("users").CascadeOnDelete()

			table.TimestampsTz()
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129160425CreateWaliKorongsTable) Down() error {
	return facades.Schema().DropIfExists("wali_korongs")
}
