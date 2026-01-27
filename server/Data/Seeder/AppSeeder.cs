using server.Models;
namespace server.Data.Seeder
{
    using server.Models;
    using Microsoft.EntityFrameworkCore;

    public static class AppSeeder
    {
        public static async Task SeedAsync(AppDbContext db)
        {
            // Check if users exist
            if (!await db.Users.AnyAsync())
            {
                var user = new User
                {
                    Username = "admin",
                    Email = "admin@example.com",
                    Password = BCrypt.Net.BCrypt.HashPassword("password"),
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                db.Users.Add(user);
                await db.SaveChangesAsync();

                // Add WaliKorong for user
                var waliKorong = new WaliKorong
                {
                    Name = "Wali Korong 1",
                    Email = "wali1@example.com",
                    Phone = "1234567890",
                    UserId = user.Id,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                db.WaliKorongs.Add(waliKorong);
                await db.SaveChangesAsync();

                // Add Business
                var business = new Business
                {
                    Name = "My First Business",
                    Address = "123 Main Street",
                    Phone = "0987654321",
                    Type = BusinessType.Retail,
                    UserId = user.Id,
                    Longitude = 0,
                    Latitude = 0,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                db.Businesses.Add(business);
                await db.SaveChangesAsync();

                // Add EmployeeRole
                var role = new EmployeeRole
                {
                    Name = "Manager",
                    Description = "Manages the business",
                    BusinessId = business.Id,
                    Permissions = "create,read,update,delete",
                    HasAdmin = true,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                db.EmployeeRoles.Add(role);
                await db.SaveChangesAsync();

                // Add Products
                var product1 = new Product
                {
                    Name = "Product 1",
                    Description = "This is product 1",
                    Stock = 10,
                    Price = 9.99m,
                    BusinessId = business.Id,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                var product2 = new Product
                {
                    Name = "Product 2",
                    Description = "This is product 2",
                    Stock = 20,
                    Price = 19.99m,
                    BusinessId = business.Id,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                db.Products.AddRange(product1, product2);
                await db.SaveChangesAsync();
            }
        }
    }
}
