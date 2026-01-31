package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129161336CreateProductTransactionsTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129161336CreateProductTransactionsTable) Signature() string {
	return "20260129161336_create_product_transactions_table"
}

// Up Run the migrations.
func (r *M20260129161336CreateProductTransactionsTable) Up() error {
	if !facades.Schema().HasTable("product_transactions") {
		return facades.Schema().Create("product_transactions", func(table schema.Blueprint) {
			// Create ID column
			table.ID()

			// Foreign key to User table (nullable because not every transaction needs a user)
			table.UnsignedBigInteger("user_id").Nullable()
			table.Foreign("user_id").References("id").On("users")

			// Quantity of product in the transaction
			table.Integer("quantity")

			// Foreign key to Product table (nullable because not every transaction needs a product)
			table.UnsignedBigInteger("product_id").Nullable()
			table.Foreign("product_id").References("id").On("products")

			// Optional product name (in case the product was deleted or changed)
			table.String("product_name", 255).Nullable()

			// Add timestamps
			table.TimestampsTz() // timezone-aware timestamps
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129161336CreateProductTransactionsTable) Down() error {
	return facades.Schema().DropIfExists("product_transactions")
}
