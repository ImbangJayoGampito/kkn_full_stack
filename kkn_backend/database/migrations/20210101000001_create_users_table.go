package migrations

import (
	"github.com/goravel/framework/contracts/database/schema"
	"github.com/goravel/framework/facades"
)

type M20210101000001CreateUsersTable struct{}

// Signature The unique signature for the migration.
func (r *M20210101000001CreateUsersTable) Signature() string {
	return "20210101000001_create_users_table"
}

// Up Run the migrations.
func (r *M20210101000001CreateUsersTable) Up() error {
	return facades.Schema().Create("users", func(table schema.Blueprint) {
		table.ID()
		table.String("username", 255)
		table.String("email", 255)

		table.Timestamp("email_verified_at").Nullable()
		table.String("password", 255)
		table.String("remember_token", 100).Nullable()

		table.TimestampsTz()
		table.Unique("email")
		table.Unique("username")
	})
}

// Down Reverse the migrations.
func (r *M20210101000001CreateUsersTable) Down() error {
	return facades.Schema().DropIfExists("users")
}
