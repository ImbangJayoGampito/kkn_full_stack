using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;
namespace server.Models
{
    public enum BusinessType
    {
        Retail,
        Service,
        Manufacturing,
        Tourism,
        Other
    }

    public class Business
    {
        [Key]
        public long Id { get; set; }

        [Range(-180, 180)]
        public decimal Longitude { get; set; }

        [Range(-90, 90)]
        public decimal Latitude { get; set; }

        [Required, MaxLength(255)]
        public string Name { get; set; } = null!;

        [Required, MaxLength(255)]
        public string Address { get; set; } = null!;

        [Required, MaxLength(50)]
        public string Phone { get; set; } = null!;

        [Required]
        public BusinessType Type { get; set; }

        // FK
        public long UserId { get; set; }
        public User User { get; set; } = null!;

        // Navigation
        public ICollection<Product> Products { get; set; } = new List<Product>();
        public ICollection<EmployeeRole> EmployeeRoles { get; set; } = new List<EmployeeRole>();

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }

}
