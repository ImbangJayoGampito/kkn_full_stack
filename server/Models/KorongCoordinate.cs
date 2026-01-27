using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;
namespace server.Models
{
    public class KorongCoordinate
    {
        [Key]
        public long Id { get; set; }

        [Required, MaxLength(50)]
        public string Latitude { get; set; } = null!;

        [Required, MaxLength(50)]
        public string Longitude { get; set; } = null!;

        // FK
        public long KorongId { get; set; }
        public Korong Korong { get; set; } = null!;

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
