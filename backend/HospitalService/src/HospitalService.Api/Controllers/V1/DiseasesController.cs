using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/diseases")]
[AllowAnonymous]
[ApiVersion("1.0")]
public class DiseasesController : ControllerBase
{
    /// <summary>
    /// Get all diseases (with optional filtering)
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<ApiResponse<PagedResult<object>>>> GetDiseases(
        [FromQuery] string? category = null,
        [FromQuery] string? specialty = null,
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var diseases = new List<object>
        {
            new {
                id = Guid.NewGuid(),
                name = "Coronary Artery Disease",
                category = "Cardiovascular",
                description = "Narrowing of coronary arteries",
                symptoms = new[] { "Chest pain", "Shortness of breath", "Fatigue" },
                specialties = new[] { "Cardiology" },
                avgTreatmentCost = 500000m,
                currency = "INR"
            },
            new {
                id = Guid.NewGuid(),
                name = "Type 2 Diabetes",
                category = "Endocrine",
                description = "Chronic condition affecting blood sugar",
                symptoms = new[] { "Increased thirst", "Frequent urination", "Fatigue" },
                specialties = new[] { "Endocrinology" },
                avgTreatmentCost = 50000m,
                currency = "INR"
            },
            new {
                id = Guid.NewGuid(),
                name = "Osteoarthritis",
                category = "Musculoskeletal",
                description = "Degenerative joint disease",
                symptoms = new[] { "Joint pain", "Stiffness", "Reduced mobility" },
                specialties = new[] { "Orthopedics", "Rheumatology" },
                avgTreatmentCost = 300000m,
                currency = "INR"
            }
        };

        if (!string.IsNullOrEmpty(category))
            diseases = diseases.Where(d => ((dynamic)d).category == category).ToList();

        var result = new PagedResult<object>
        {
            Items = diseases.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToList(),
            TotalCount = diseases.Count,
            PageNumber = pageNumber,
            PageSize = pageSize
        };

        return Ok(ApiResponse<PagedResult<object>>.SuccessResponse(result, null, correlationId));
    }
}
