package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129154147CreateProductsTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129154147CreateProductsTable) Signature() string {
	return "20260129154147_create_products_table"
}

// Up Run the migrations.
func (r *M20260129154147CreateProductsTable) Up() error {
	if !facades.Schema().HasTable("products") {
		return facades.Schema().Create("products", func(table schema.Blueprint) {
			table.ID()
			table.String("name", 255)
			table.Text("description")
			table.UnsignedInteger("stock").Default(0)
			table.Decimal("price")

			table.UnsignedBigInteger("business_id")
			table.Foreign("business_id").References("id").On("businesses").CascadeOnDelete()

			table.TimestampsTz()
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129154147CreateProductsTable) Down() error {
	return facades.Schema().DropIfExists("products")
}
