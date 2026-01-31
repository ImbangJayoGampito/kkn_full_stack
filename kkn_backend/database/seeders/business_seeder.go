package seeders

import (
	"fmt"
	"kkn_backend/app/models"
	"kkn_backend/app/services"
	"math/rand"
	"time"
)

func randomLatLon() (float64, float64) {
	// Seed the generator so results differ each run
	rand.Seed(time.Now().UnixNano())

	// Latitude range: -90 to 90
	lat := rand.Float64()*180 - 90

	// Longitude range: -180 to 180
	lon := rand.Float64()*360 - 180

	return lat, lon
}
func SeedBusinesses() error {
	business_owner_amount := 20
	for i := 0; i < business_owner_amount; i++ {
		tx := facades.Orm().Begin()
		user, err := services.RegisterUser(tx, fmt.Sprintf("owner%d", i), fmt.Sprintf("business_owner%d@example.com", i), "password")
		if err != nil {
			return err
		}

		business_per_user := 2
		for j := 0; j < business_per_user; j++ {
			business := &models.Business{
				Name:   fmt.Sprintf("Business %d-%d", i, j),
				UserId: uint64(user.ID),

				Phone:   fmt.Sprintf("123456789%d", j),
				Address: fmt.Sprintf("Address %d-%d", i, j),
			}
			latitude, longitude := randomLatLon()
			_, err := services.CreateBusiness(longitude, latitude, business.Name, business.Address, business.Phone, models.BusinessTypeKantor, *user)
			if err != nil {
				return err
			}

		}
	}
	return nil
}
