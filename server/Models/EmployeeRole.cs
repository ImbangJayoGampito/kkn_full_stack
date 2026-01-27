using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;
namespace server.Models
{
    public class EmployeeRole
    {
        [Key]
        public long Id { get; set; }

        [Required, MaxLength(255)]
        public string Name { get; set; } = null!;

        public string Description { get; set; } = null!;

        // Permissions stored as JSON string or comma-separated
        public string Permissions { get; set; } = null!;

        public bool HasAdmin { get; set; } = false;

        // FK
        public long BusinessId { get; set; }
        public Business Business { get; set; } = null!;

        public ICollection<Employee> Employees { get; set; } = new List<Employee>();

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
