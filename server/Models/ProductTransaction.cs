using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;
namespace server.Models
{
    public class ProductTransaction
    {
        [Key]
        public long Id { get; set; }

        public long? UserId { get; set; }
        public User? User { get; set; }

        [Required]
        public int Quantity { get; set; }

        public long? ProductId { get; set; }
        public Product? Product { get; set; }

        public string? ProductName { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
