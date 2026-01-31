package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129155946CreateBusinessesTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129155946CreateBusinessesTable) Signature() string {
	return "20260129155946_create_businesses_table"
}

// Up Run the migrations.
func (r *M20260129155946CreateBusinessesTable) Up() error {
	if !facades.Schema().HasTable("businesses") {
		return facades.Schema().Create("businesses", func(table schema.Blueprint) {
			table.ID()
			table.Decimal("longitude")
			table.Decimal("latitude")
			table.String("name", 255)
			table.String("address", 255)
			table.String("phone", 50)
			table.Enum("type", []any{"restoran", "toko", "kantor", "gudang", "pariwisata", "lain-lain"}).Default("lain-lain")

			table.UnsignedBigInteger("user_id")
			table.Foreign("user_id").References("id").On("users").NullOnDelete()
			table.TimestampsTz()
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129155946CreateBusinessesTable) Down() error {
	return facades.Schema().DropIfExists("businesses")
}
