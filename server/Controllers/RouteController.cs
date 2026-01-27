using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;  // Add this namespace
using Microsoft.AspNetCore.Http.Metadata;
using System.Linq;
namespace server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RouteController : ControllerBase
    {
        private readonly EndpointDataSource _endpointDataSource;

        // Constructor to inject IEndpointDataSource
        public RouteController(EndpointDataSource endpointDataSource)
        {
            _endpointDataSource = endpointDataSource;
        }

        [HttpGet("routes")]
        public IActionResult GetRoutes()
        {
            // Collect all registered routes and their HTTP methods
            var routes = _endpointDataSource.Endpoints
                .Select(endpoint => new
                {
                    Route = endpoint.DisplayName,
                    Methods = string.Join(", ", endpoint.Metadata
                        .OfType<HttpMethodMetadata>()
                        .SelectMany(httpMethodMetadata => httpMethodMetadata.HttpMethods)
                        .ToArray())
                })
                .ToList();

            return Ok(routes);
        }
    }
}
