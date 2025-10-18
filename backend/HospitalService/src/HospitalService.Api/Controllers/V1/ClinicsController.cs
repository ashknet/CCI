using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/clinics")]
[ApiVersion("1.0")]
public class ClinicsController : ControllerBase
{
    /// <summary>
    /// Get all clinics (paginated and filtered)
    /// </summary>
    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<MedTravel.Shared.Models.PagedResult<object>>>> GetClinics(
        [FromQuery] string? city = null,
        [FromQuery] string? specialty = null,
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var clinics = new List<object>
        {
            new {
                id = Guid.NewGuid(),
                name = "Max Heart Clinic",
                type = "specialty_clinic",
                specialty = "Cardiology",
                city = "Hyderabad",
                address = "Jubilee Hills",
                phone = "+91-40-12345678",
                rating = 4.5,
                totalDoctors = 15,
                avgConsultationFee = 1500
            }
        };

        var result = new MedTravel.Shared.Models.PagedResult<object>
        {
            Items = clinics,
            TotalCount = clinics.Count,
            PageNumber = pageNumber,
            PageSize = pageSize
        };

        return Ok(ApiResponse<MedTravel.Shared.Models.PagedResult<object>>.SuccessResponse(result, null, correlationId));
    }

    /// <summary>
    /// Register new clinic (admin only)
    /// </summary>
    [HttpPost]
    [Authorize(Roles = "hospital_admin,support")]
    public async Task<ActionResult<ApiResponse<object>>> RegisterClinic([FromBody] object clinicData)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var clinic = new
        {
            id = Guid.NewGuid(),
            message = "Clinic registered successfully. Pending verification."
        };

        return Ok(ApiResponse<object>.SuccessResponse(clinic, "Clinic registered", correlationId));
    }

    /// <summary>
    /// Get clinic details
    /// </summary>
    [HttpGet("{clinicId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<object>>> GetClinic(Guid clinicId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var clinic = new
        {
            id = clinicId,
            name = "Max Heart Clinic",
            type = "specialty_clinic",
            specialty = "Cardiology",
            description = "Leading cardiac care clinic",
            city = "Hyderabad",
            address = "Jubilee Hills, Road No. 36",
            latitude = 17.4239,
            longitude = 78.4501,
            phone = "+91-40-12345678",
            email = "info@maxheartclinic.com",
            rating = 4.5,
            totalReviews = 320,
            timings = new {
                monday = "09:00 AM - 06:00 PM",
                tuesday = "09:00 AM - 06:00 PM",
                wednesday = "09:00 AM - 06:00 PM",
                thursday = "09:00 AM - 06:00 PM",
                friday = "09:00 AM - 06:00 PM",
                saturday = "09:00 AM - 02:00 PM",
                sunday = "Closed"
            },
            doctors = new[] {
                new { id = Guid.NewGuid(), name = "Dr. Anil Sharma", specialty = "Interventional Cardiology" },
                new { id = Guid.NewGuid(), name = "Dr. Priya Reddy", specialty = "Cardiac Electrophysiology" }
            }
        };

        return Ok(ApiResponse<object>.SuccessResponse(clinic, null, correlationId));
    }

    /// <summary>
    /// Update clinic information
    /// </summary>
    [HttpPut("{clinicId}")]
    [Authorize(Roles = "hospital_admin,support")]
    public async Task<ActionResult<ApiResponse<object>>> UpdateClinic(Guid clinicId, [FromBody] object updateData)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        return Ok(ApiResponse<object>.SuccessResponse(null, "Clinic updated successfully", correlationId));
    }
}
