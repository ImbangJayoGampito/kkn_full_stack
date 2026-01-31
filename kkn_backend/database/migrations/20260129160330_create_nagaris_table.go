package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129160330CreateNagarisTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129160330CreateNagarisTable) Signature() string {
	return "20260129160330_create_nagaris_table"
}

// Up Run the migrations.
func (r *M20260129160330CreateNagarisTable) Up() error {
	if !facades.Schema().HasTable("nagaris") {
		return facades.Schema().Create("nagaris", func(table schema.Blueprint) {
			table.ID()
			table.String("name", 255)
			table.String("address", 255)
			table.String("phone", 50)
			table.String("email", 255)
			table.Text("description")
			table.UnsignedBigInteger("wali_nagari_id")
			table.Foreign("wali_nagari_id").References("id").On("wali_nagari").CascadeOnDelete()
			table.TimestampsTz()
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129160330CreateNagarisTable) Down() error {
	return facades.Schema().DropIfExists("nagaris")
}
