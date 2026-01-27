using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;
namespace server.Models
{
    public class ProductImage
    {
        [Key]
        public long Id { get; set; }

        [Required, MaxLength(255)]
        public string ImageUrl { get; set; } = null!;

        [Required, MaxLength(255)]
        public string ImageAlt { get; set; } = null!;

        [Required, MaxLength(255)]
        public string ImageTitle { get; set; } = null!;

        // FK
        public long ProductId { get; set; }
        public Product Product { get; set; } = null!;

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
