using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure; // for ServerVersion if needed

namespace server.Data
{
    public class AppDbContextFactory : IDesignTimeDbContextFactory<AppDbContext>
    {
        public AppDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<AppDbContext>();

            // Use your Laragon MySQL connection string
            // Best for local: localhost instead of 127.0.0.1; empty password is fine for Laragon root
            var connectionString = "Server=localhost;Database=KKNDb;User=root;Password=;Charset=utf8mb4;";

            optionsBuilder.UseMySql(
                connectionString,
                ServerVersion.AutoDetect(connectionString) // auto-detects MySQL/MariaDB version
                                                           // Optional: add retry logic for local dev
                                                           // , x => x.EnableRetryOnFailure(maxRetryCount: 5, maxRetryDelay: TimeSpan.FromSeconds(10), errorNumbersToAdd: null)
            );

            return new AppDbContext(optionsBuilder.Options);
        }
    }
}
