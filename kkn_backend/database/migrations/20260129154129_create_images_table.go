package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129154129CreateImagesTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129154129CreateImagesTable) Signature() string {
	return "20260129154129_create_images_table"
}

// Up Run the migrations.
func (r *M20260129154129CreateImagesTable) Up() error {
	if !facades.Schema().HasTable("images") {
		return facades.Schema().Create("images", func(table schema.Blueprint) {
			table.ID()
			table.String("image_url", 255)
			table.String("image_alt", 255)
			table.String("image_title", 255)

			// Polymorphic
			table.String("imageable_type", 100)
			table.UnsignedBigInteger("imageable_id")

			table.TimestampsTz()
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129154129CreateImagesTable) Down() error {
	return facades.Schema().DropIfExists("images")
}
