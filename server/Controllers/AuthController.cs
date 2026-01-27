using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using server.Data;
using server.DTO;
using server.Models;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.Text;
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly AppDbContext _db;
    private readonly IConfiguration _config;

    public AuthController(AppDbContext db, IConfiguration config)
    {
        _db = db;
        _config = config;
    }
    public ClaimsPrincipal ValidateToken(string token, byte[] key)
    {
        var tokenHandler = new JwtSecurityTokenHandler();

        try
        {
            var validationParameters = new TokenValidationParameters
            {
                ValidateIssuer = false,
                ValidateAudience = false,
                ValidateLifetime = true,
                IssuerSigningKey = new SymmetricSecurityKey(key)
            };

            var principal = tokenHandler.ValidateToken(token, validationParameters, out var validatedToken);
            return principal;
        }
        catch (SecurityTokenException)
        {
            return null;
        }
    }

    [HttpPost("restore")]
    public IActionResult Restore()
    {
        var request = HttpContext.Request;
        var Authorization = request.Headers["Authorization"].ToString();
        Console.WriteLine($"Authorization Header: {Authorization}");

        foreach (var header in request.Headers)
        {
            Console.WriteLine($"{header.Key}: {header.Value}");
        }
        if (string.IsNullOrEmpty(Authorization) || !Authorization.StartsWith("Bearer "))
        {
            return BadRequest(new { message = "Authorization header is missing or invalid." });
        }
        var token = Authorization.Substring("Bearer ".Length).Trim();

        // Decode the JWT token sent by the client
        try
        {
            // Log token
            var key = Encoding.ASCII.GetBytes(_config["Jwt:Key"]);
            if (key == null)
            {
                Console.WriteLine("JWT Key is missing in the configuration.");
                return Unauthorized(new { message = "JWT Key is missing in the configuration." });
            }

            var principal = ValidateToken(token, key);
            if (principal == null)
            {
                Console.WriteLine("Token validation failed.");
                return Unauthorized(new { message = "Invalid token." });
            }

            // Log user ID from token
            var userIdClaim = principal.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userIdClaim))
            {
                Console.WriteLine("Token does not contain a valid user identifier.");
                return Unauthorized(new { message = "Token does not contain a valid user identifier." });
            }

            if (!int.TryParse(userIdClaim, out var userId))
            {
                Console.WriteLine("Invalid user ID in the token.");
                return Unauthorized(new { message = "Invalid user ID in the token." });
            }

            var user = _db.Users.FirstOrDefault(u => u.Id == userId);
            if (user == null)
            {
                Console.WriteLine("User not found in the database.");
                return Unauthorized(new { message = "User not found." });
            }

            Console.WriteLine("User restored successfully.");
            return Ok(new
            {
                user = new { user.Id, user.Username, user.Email },
                message = "Session restored successfully."
            });
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
            return Unauthorized(new { message = "An error occurred during token validation.", error = ex.Message });
        }

    }


    // Register
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterDto dto)
    {
        if (await _db.Users.AnyAsync(u => u.Username == dto.Username))
            return BadRequest(new { message = "Username already exists" });

        if (await _db.Users.AnyAsync(u => u.Email == dto.Email))
            return BadRequest(new { message = "Email already exists" });

        var user = new User
        {
            Username = dto.Username,
            Email = dto.Email,
            Password = BCrypt.Net.BCrypt.HashPassword(dto.Password)
        };

        _db.Users.Add(user);
        await _db.SaveChangesAsync();

        var token = GenerateJwtToken(user);

        return Ok(new
        {
            user = new { user.Id, user.Username, user.Email },
            token
        });
    }

    // Login
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginDto dto)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Username == dto.Username);

        if (user == null || !BCrypt.Net.BCrypt.Verify(dto.Password, user.Password))
            return Unauthorized(new { message = "Invalid credentials" });

        var token = GenerateJwtToken(user);

        return Ok(new
        {
            user = new { user.Id, user.Username, user.Email },
            token
        });
    }

    // Logout (no server-side action with JWT; token expires or remove from client)
    [HttpPost("logout")]
    public IActionResult Logout()
    {
        return Ok(new { message = "Logged out (client should delete token)" });
    }

    private string GenerateJwtToken(User user)
    {
        var jwtSettings = _config.GetSection("Jwt");
        var key = Encoding.ASCII.GetBytes(jwtSettings["Key"]);
        if (key == null)
            throw new InvalidOperationException("JWT key is not configured");

        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.UniqueName, user.Username),
            new Claim(JwtRegisteredClaimNames.Email, user.Email),
        };

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = DateTime.UtcNow.AddDays(int.Parse(jwtSettings["DurationInMinutes"])),
            Issuer = jwtSettings["Issuer"],
            Audience = jwtSettings["Audience"],
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);

        return tokenHandler.WriteToken(token);
    }
}
