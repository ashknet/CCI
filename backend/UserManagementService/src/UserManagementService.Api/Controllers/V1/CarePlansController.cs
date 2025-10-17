using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace UserManagementService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/users/{userId}/care-plans")]
[Authorize]
[ApiVersion("1.0")]
public class CarePlansController : ControllerBase
{
    /// <summary>
    /// Get user's care plans
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetCarePlans(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId && !User.IsInRole("support") && !User.IsInRole("doctor"))
            return Forbid();

        var carePlans = new List<object>
        {
            new {
                id = Guid.NewGuid(),
                procedureCode = "CABG001",
                procedureName = "Coronary Artery Bypass Grafting",
                status = "active",
                createdDate = DateTime.UtcNow.AddDays(-30),
                scheduledDate = DateTime.UtcNow.AddDays(10),
                doctorId = Guid.NewGuid(),
                doctorName = "Dr. Rajesh Kumar",
                hospital = "Apollo Hospitals Hyderabad",
                preOpChecklist = new[] {
                    new { item = "Complete blood tests", completed = true, dueDate = DateTime.UtcNow.AddDays(-5) },
                    new { item = "ECG and Echocardiogram", completed = true, dueDate = DateTime.UtcNow.AddDays(-3) },
                    new { item = "Stop blood thinners", completed = false, dueDate = DateTime.UtcNow.AddDays(3) },
                    new { item = "Pre-operative consultation", completed = false, dueDate = DateTime.UtcNow.AddDays(9) }
                },
                postOpPlan = new {
                    icuDays = 3,
                    wardDays = 7,
                    totalHospitalStay = 10,
                    followUpSchedule = new[] {
                        new { type = "In-person", date = DateTime.UtcNow.AddDays(17) },
                        new { type = "Telemedicine", date = DateTime.UtcNow.AddDays(40) }
                    },
                    medications = new[] {
                        new { name = "Aspirin", dosage = "75mg daily", duration = "Lifelong" },
                        new { name = "Atorvastatin", dosage = "40mg daily", duration = "Lifelong" }
                    },
                    restrictions = new[] {
                        "No heavy lifting for 6 weeks",
                        "No driving for 4 weeks",
                        "Cardiac rehabilitation program"
                    }
                },
                estimatedCosts = new {
                    surgery = 450000,
                    hospitalStay = 80000,
                    medications = 15000,
                    followUp = 10000,
                    total = 555000,
                    currency = "INR"
                }
            }
        };

        return Ok(ApiResponse<List<object>>.SuccessResponse(carePlans, null, correlationId));
    }
}
