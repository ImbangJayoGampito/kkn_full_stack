package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20260129154411CreateCoordinatesTable struct{}

// Signature The unique signature for the migration.
func (r *M20260129154411CreateCoordinatesTable) Signature() string {
	return "20260129154411_create_coordinates_table"
}

// Up Run the migrations.
func (r *M20260129154411CreateCoordinatesTable) Up() error {
	if !facades.Schema().HasTable("coordinates") {
		return facades.Schema().Create("coordinates", func(table schema.Blueprint) {
			table.ID()

			table.String("latitude", 50)
			table.String("longitude", 50)

			// Polymorphic
			table.String("coordinateable_type", 100)
			table.UnsignedBigInteger("coordinateable_id")
			table.TimestampsTz()
		})
	}

	return nil
}

// Down Reverse the migrations.
func (r *M20260129154411CreateCoordinatesTable) Down() error {
	return facades.Schema().DropIfExists("coordinates")
}
