using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace UserManagementService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/procedures")]
[Authorize]
[ApiVersion("1.0")]
public class ProceduresController : ControllerBase
{
    /// <summary>
    /// Get all procedures (filtered by disease/condition)
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<ApiResponse<PagedResult<object>>>> GetProcedures(
        [FromQuery] string? disease = null,
        [FromQuery] string? condition = null,
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var procedures = new List<object>
        {
            new {
                code = "CABG001",
                name = "Coronary Artery Bypass Grafting",
                disease = "Coronary Artery Disease",
                category = "Cardiovascular Surgery",
                avgCost = 500000m,
                duration = "4-6 hours",
                hospitalStay = "7-10 days",
                recoveryTime = "6-8 weeks"
            },
            new {
                code = "HIP001",
                name = "Hip Replacement Surgery",
                disease = "Osteoarthritis",
                category = "Orthopedic Surgery",
                avgCost = 350000m,
                duration = "2-3 hours",
                hospitalStay = "5-7 days",
                recoveryTime = "8-12 weeks"
            }
        };

        if (!string.IsNullOrEmpty(disease))
            procedures = procedures.Where(p => ((dynamic)p).disease.Contains(disease, StringComparison.OrdinalIgnoreCase)).ToList();

        var result = new PagedResult<object>
        {
            Items = procedures.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToList(),
            TotalCount = procedures.Count,
            PageNumber = pageNumber,
            PageSize = pageSize
        };

        return Ok(ApiResponse<PagedResult<object>>.SuccessResponse(result, null, correlationId));
    }

    /// <summary>
    /// Get procedure requirements (pre-op, post-op, documents, etc.)
    /// </summary>
    [HttpGet("{code}/requirements")]
    public async Task<ActionResult<ApiResponse<object>>> GetProcedureRequirements(string code)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var requirements = new
        {
            procedureCode = code,
            procedureName = "Coronary Artery Bypass Grafting",
            preOperative = new
            {
                medicalTests = new[] {
                    "Complete Blood Count",
                    "Chest X-Ray",
                    "ECG",
                    "Echocardiogram",
                    "Coronary Angiography"
                },
                medications = new[] {
                    "Stop blood thinners 7 days before",
                    "Continue heart medications as prescribed"
                },
                fasting = "No food or water 8 hours before surgery",
                arrivalTime = "1 day before surgery for pre-op preparation"
            },
            postOperative = new
            {
                hospitalStay = "7-10 days",
                icu = "2-3 days in ICU",
                followUpSchedule = new[] {
                    "1 week post-discharge",
                    "1 month post-surgery",
                    "3 months post-surgery",
                    "6 months post-surgery"
                },
                restrictions = new[] {
                    "No heavy lifting for 6 weeks",
                    "No driving for 4 weeks",
                    "Cardiac rehabilitation recommended"
                },
                medications = new[] {
                    "Blood thinners",
                    "Beta blockers",
                    "Statins",
                    "Aspirin"
                }
            },
            documentsRequired = new[] {
                "Medical history",
                "Previous cardiac reports",
                "Current medications list",
                "Insurance documents",
                "Passport/ID proof"
            },
            estimatedTotalCost = new {
                surgery = 450000m,
                hospitalStay = 80000m,
                medications = 15000m,
                followUp = 10000m,
                total = 555000m,
                currency = "INR"
            },
            whatToCarry = new[] {
                "Comfortable clothing",
                "Personal hygiene items",
                "Medical records folder",
                "Emergency contact information",
                "Insurance cards"
            }
        };

        return Ok(ApiResponse<object>.SuccessResponse(requirements, null, correlationId));
    }
}
