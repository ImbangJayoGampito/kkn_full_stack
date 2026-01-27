using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;
namespace server.Models
{
    public class Korong
    {
        [Key]
        public long Id { get; set; }

        [Required, MaxLength(255)]
        public string Name { get; set; } = null!;

        [Required, MaxLength(255)]
        public string Address { get; set; } = null!;

        [Required, MaxLength(50)]
        public string Phone { get; set; } = null!;

        [Required, MaxLength(255)]
        public string Email { get; set; } = null!;

        public string Description { get; set; } = null!;

        // FK
        public long WaliKorongId { get; set; }
        public WaliKorong WaliKorong { get; set; } = null!;

        public ICollection<KorongCoordinate> Coordinates { get; set; } = new List<KorongCoordinate>();

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
