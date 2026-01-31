package seeders

type DatabaseSeeder struct {
}

// Signature The name and signature of the seeder.
func (s *DatabaseSeeder) Signature() string {
	return "DatabaseSeeder"
}

// Run executes the seeder logic.
func (s *DatabaseSeeder) Run() error {
	err := SeedUsers()
	if err != nil {
		return err
	}
	err = SeedBusinesses()
	if err != nil {
		return err
	}
	err = SeedProducts()
	if err != nil {
		return err
	}
	return nil
}
