using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using server.Models;

namespace server.Models
{
    public class WaliKorong
    {
        [Key]
        public long Id { get; set; }

        [Required, MaxLength(255)]
        public string Name { get; set; } = null!;

        [Required, MaxLength(255)]
        public string Email { get; set; } = null!;

        [Required, MaxLength(50)]
        public string Phone { get; set; } = null!;

        // Foreign key
        [Required]
        public long UserId { get; set; }

        [ForeignKey("UserId")]
        public User User { get; set; } = null!;

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
