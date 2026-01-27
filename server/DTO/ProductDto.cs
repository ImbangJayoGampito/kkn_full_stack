namespace server.DTO
{
    public class PageQueryDto
    {
        public long? BusinessId { get; set; }
        public string? Search { get; set; }
        public int Page { get; set; } = 1; // default page
        public int PageSize { get; set; } = 10; // default page size
    }
}
