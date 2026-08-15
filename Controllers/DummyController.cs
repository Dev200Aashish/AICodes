using Microsoft.AspNetCore.Mvc;

namespace AICodeAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DummyController : ControllerBase
    {
        [HttpGet("get-dummy")]
        public IActionResult GetDummy()
        {
            var dummyResponse = new
            {
                id = 1,
                message = "This is a dummy response",
                status = "success",
                data = new
                {
                    name = "John Doe",
                    email = "john@example.com",
                    timestamp = DateTime.UtcNow
                }
            };

            return Ok(dummyResponse);
        }
    }
}
