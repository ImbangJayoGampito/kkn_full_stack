using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using server.Models;
using server.Data;
using server.DTO;
[ApiController]
[Route("api/[controller]")]
public class ProductController : ControllerBase
{
    private readonly AppDbContext _db;

    public ProductController(AppDbContext db)
    {
        _db = db;
    }

    // GET /api/products

    [HttpGet]
    public async Task<IActionResult> Index([FromQuery] PageQueryDto query)
    {
        var productsQuery = _db.Products
            .Include(p => p.Images)
            .AsQueryable();

        if (query.BusinessId.HasValue)
        {
            productsQuery = productsQuery.Where(p => p.BusinessId == query.BusinessId.Value);
        }

        if (!string.IsNullOrEmpty(query.Search))
        {
            productsQuery = productsQuery.Where(p =>
                p.Name.Contains(query.Search) || p.Description.Contains(query.Search));
        }

        // Pagination
        var totalItems = await productsQuery.CountAsync();
        var totalPages = (int)Math.Ceiling(totalItems / (double)query.PageSize);

        var products = await productsQuery
            .Skip((query.Page - 1) * query.PageSize)
            .Take(query.PageSize)
            .ToListAsync();

        return Ok(new
        {
            currentPage = query.Page,
            pageSize = query.PageSize,
            totalItems,
            totalPages,
            data = products.Select(p => new
            {
                p.Id,
                p.Name,
                p.Description,
                p.Stock,
                p.Price,
                Images = p.Images.Select(i => new { i.Id, i.ProductId }) // map images
            })
        });
    }

    // GET /api/products/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> Show(long id)
    {
        var product = await _db.Products
            .Include(p => p.Images)
            .FirstOrDefaultAsync(p => p.Id == id);

        if (product == null) return NotFound();

        return Ok(product);
    }
}
