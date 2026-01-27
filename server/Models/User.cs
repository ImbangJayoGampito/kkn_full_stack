using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;
namespace server.Models
{
    public class User
    {
        [Key]
        public long Id { get; set; }

        [Required]
        [MaxLength(255)]
        public string Username { get; set; } = null!;

        [Required]
        [MaxLength(255)]
        public string Email { get; set; } = null!;

        public DateTime? EmailVerifiedAt { get; set; }

        [Required]
        public string Password { get; set; } = null!;

        public string? RememberToken { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        // Navigation properties
        public ICollection<Business> Businesses { get; set; } = new List<Business>();
        public ICollection<Employee> EmployeedAt { get; set; } = new List<Employee>();
        public ICollection<ProductTransaction> ProductTransactions { get; set; } = new List<ProductTransaction>();
        public WaliKorong WaliKorong { get; set; } = null!;
    }
}
