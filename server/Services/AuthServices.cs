using server.Models;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.Text;
using server.Data;
namespace server.Services
{
    class AuthService
    {
        public static ClaimsPrincipal? ValidateToken(string token, byte[] key)
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
        static public (User? user, string message) GetUserFromToken(HttpRequest? request, IConfiguration _config, AppDbContext _db)
        {
            // Implement logic to retrieve user from token
            if (request == null)
            {
                return (null, "Token is missing");
            }
            var Authorization = request.Headers["Authorization"].ToString();
            Console.WriteLine($"Authorization Header: {Authorization}");

            foreach (var header in request.Headers)
            {
                Console.WriteLine($"{header.Key}: {header.Value}");
            }
            if (string.IsNullOrEmpty(Authorization) || !Authorization.StartsWith("Bearer "))
            {
                return (null, "Authorization header is missing or invalid.");
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
                    return (null, "JWT Key is missing in the configuration.");
                }

                var principal = ValidateToken(token, key);
                if (principal == null)
                {
                    Console.WriteLine("Token validation failed.");
                    return (null, "Invalid token.");
                }

                // Log user ID from token
                var userIdClaim = principal.FindFirstValue(ClaimTypes.NameIdentifier);
                if (string.IsNullOrEmpty(userIdClaim))
                {
                    Console.WriteLine("Token does not contain a valid user identifier.");
                    return (null, "Token does not contain a valid user identifier.");
                }

                if (!int.TryParse(userIdClaim, out var userId))
                {
                    Console.WriteLine("Invalid user ID in the token.");
                    return (null, "Invalid user ID in the token.");
                }

                var user = _db.Users.FirstOrDefault(u => u.Id == userId);
                if (user == null)
                {
                    Console.WriteLine("User not found in the database.");
                    return (null, "User not found.");
                }

                Console.WriteLine("User restored successfully.");
                return (user, "Session restored successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
                return (null, "An error occurred during token validation.");
            }
        }
    }
};
