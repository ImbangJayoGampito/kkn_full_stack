using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;
namespace server.Models
{
    public class Employee
    {
        [Key]
        public long Id { get; set; }

        // FK
        public long UserId { get; set; }
        public User User { get; set; } = null!;

        public long RoleId { get; set; }
        public EmployeeRole Role { get; set; } = null!;

        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        [Column(TypeName = "decimal(15,2)")]
        public decimal Salary { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
