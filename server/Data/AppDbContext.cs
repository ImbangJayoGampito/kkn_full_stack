using Microsoft.EntityFrameworkCore;
using server.Models;

namespace server.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        // DbSets
        public DbSet<User> Users { get; set; } = null!;
        public DbSet<WaliKorong> WaliKorongs { get; set; } = null!;
        public DbSet<Business> Businesses { get; set; } = null!;
        public DbSet<Employee> Employees { get; set; } = null!;
        public DbSet<EmployeeRole> EmployeeRoles { get; set; } = null!;
        public DbSet<Product> Products { get; set; } = null!;
        public DbSet<ProductImage> ProductImages { get; set; } = null!;
        public DbSet<ProductTransaction> ProductTransactions { get; set; } = null!;
        public DbSet<Korong> Korongs { get; set; } = null!;
        public DbSet<KorongCoordinate> KorongCoordinates { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // ======= ONE-TO-ONE =======
            modelBuilder.Entity<User>()
                .HasOne(u => u.WaliKorong)
                .WithOne(w => w.User)
                .HasForeignKey<WaliKorong>(w => w.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // ======= ONE-TO-MANY =======
            modelBuilder.Entity<User>()
                .HasMany(u => u.Businesses)
                .WithOne(b => b.User)
                .HasForeignKey(b => b.UserId);

            modelBuilder.Entity<User>()
                .HasMany(u => u.EmployeedAt)
                .WithOne(e => e.User)
                .HasForeignKey(e => e.UserId);

            modelBuilder.Entity<User>()
                .HasMany(u => u.ProductTransactions)
                .WithOne(pt => pt.User)
                .HasForeignKey(pt => pt.UserId);

            modelBuilder.Entity<Business>()
                .HasMany(b => b.Products)
                .WithOne(p => p.Business)
                .HasForeignKey(p => p.BusinessId);

            modelBuilder.Entity<Business>()
                .HasMany(b => b.EmployeeRoles)
                .WithOne(er => er.Business)
                .HasForeignKey(er => er.BusinessId);

            modelBuilder.Entity<EmployeeRole>()
                .HasMany(er => er.Employees)
                .WithOne(e => e.Role)
                .HasForeignKey(e => e.RoleId);

            modelBuilder.Entity<Product>()
                .HasMany(p => p.Images)
                .WithOne(pi => pi.Product)
                .HasForeignKey(pi => pi.ProductId);

            modelBuilder.Entity<Product>()
                .HasMany(p => p.Transactions)
                .WithOne(pt => pt.Product)
                .HasForeignKey(pt => pt.ProductId);

            modelBuilder.Entity<Korong>()
                .HasMany(k => k.Coordinates)
                .WithOne(c => c.Korong)
                .HasForeignKey(c => c.KorongId);

            // Korong -> WaliKorong (many-to-one)
            modelBuilder.Entity<Korong>()
                .HasOne(k => k.WaliKorong)
                .WithMany()
                .HasForeignKey(k => k.WaliKorongId);
        }
    }
}
