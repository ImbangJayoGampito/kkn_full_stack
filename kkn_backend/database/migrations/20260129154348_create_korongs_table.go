package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129154348CreateKorongsTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129154348CreateKorongsTable) Signature() string {
	return "20260129154348_create_korongs_table"
}

// Up Run the migrations.
func (r *M20260129154348CreateKorongsTable) Up() error {
	if !facades.Schema().HasTable("korongs") {
		return facades.Schema().Create("korongs", func(table schema.Blueprint) {
			table.ID()
			table.String("name", 255)
			table.String("address", 255)
			table.String("phone", 50)
			table.String("email", 255)
			table.Text("description")

			table.UnsignedBigInteger("wali_korong_id")
			table.Foreign("wali_korong_id").References("id").On("wali_korongs").NullOnDelete()

			table.UnsignedBigInteger("nagari_id")
			table.Foreign("nagari_id").References("id").On("nagaris").CascadeOnDelete()
			table.TimestampsTz()
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129154348CreateKorongsTable) Down() error {
	return facades.Schema().DropIfExists("korongs")
}
