using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;
using server.Data;
using server.Data.Seeder;
using System.Text;
using Microsoft.Extensions.FileProviders;

var builder = WebApplication.CreateBuilder(args);

// ────────────────────────────────────────────────
// ALL SERVICE REGISTRATIONS MUST GO HERE
// ────────────────────────────────────────────────

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("DefaultConnection"))
    // Optional: good for flaky local connections
    // , x => x.EnableRetryOnFailure(maxRetryCount: 5, maxRetryDelay: TimeSpan.FromSeconds(10))
    ));

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
        // .AllowCredentials(); // only if you actually need cookies/auth with credentials
    });
});

// JWT Authentication – moved here (before Build!)
var jwtSettings = builder.Configuration.GetSection("Jwt");
var keyString = jwtSettings["Key"];

if (string.IsNullOrWhiteSpace(keyString))
{
    throw new InvalidOperationException("JWT Key is missing or empty in configuration.");
}

var key = Encoding.ASCII.GetBytes(keyString);
builder.Services.AddControllers();
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["Issuer"],
        ValidAudience = jwtSettings["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ClockSkew = TimeSpan.Zero
    };
});

// ────────────────────────────────────────────────
// BUILD THE APPLICATION
// ────────────────────────────────────────────────
var app = builder.Build();

// ────────────────────────────────────────────────
// MIDDLEWARE PIPELINE – AFTER BUILD
// ────────────────────────────────────────────────

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();

// Serve Flutter static files from wwwroot/web under /web
app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "web")),  // Path to your Flutter build in wwwroot/web
    RequestPath = "/web"  // Serves under /web (e.g., /web/index.html)
});

app.UseRouting();

app.UseCors("AllowFrontend"); // Apply CORS policy

app.UseAuthentication();      // Important for JWT
app.UseAuthorization();

// Database seeding & migration (safe here – uses app.Services)
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<AppDbContext>();
        await context.Database.MigrateAsync();
        await AppSeeder.SeedAsync(context);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"An error occurred while seeding the database: {ex.Message}");
        // Optional: log full exception
        // Console.WriteLine(ex);
    }
}

app.MapControllers();  // Maps API routes (e.g., /api/*) – these take precedence
app.MapFallbackToFile("/web/index.html");  // Redirects all unmatched routes (except API) to /web/index.html for SPA routing

app.Run();