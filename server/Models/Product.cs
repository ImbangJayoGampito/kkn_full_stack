using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;
namespace server.Models
{
    public class Product
    {
        [Key]
        public long Id { get; set; }

        [Required, MaxLength(255)]
        public string Name { get; set; } = null!;

        [Required]
        public string Description { get; set; } = null!;

        public uint Stock { get; set; } = 0;

        [Range(0, double.MaxValue)]
        [Column(TypeName = "decimal(8,2)")]
        public decimal Price { get; set; }



        // FK
        public long BusinessId { get; set; }
        public Business Business { get; set; } = null!;

        public ICollection<ProductImage> Images { get; set; } = new List<ProductImage>();
        public ICollection<ProductTransaction> Transactions { get; set; } = new List<ProductTransaction>();

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
