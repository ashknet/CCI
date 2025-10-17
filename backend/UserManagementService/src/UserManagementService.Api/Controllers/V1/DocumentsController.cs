using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UserManagementService.Core.Interfaces;
using UserManagementService.Core.Entities;

namespace UserManagementService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/users/{userId}/documents")]
[Authorize]
[ApiVersion("1.0")]
public class DocumentsController : ControllerBase
{
    private readonly ILogger<DocumentsController> _logger;

    public DocumentsController(ILogger<DocumentsController> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Get user documents
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetDocuments(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId && !User.IsInRole("support"))
            return Forbid();

        var documents = new List<object>
        {
            new {
                id = Guid.NewGuid(),
                documentType = "passport",
                documentName = "Passport.pdf",
                isVerified = true,
                uploadedAt = DateTime.UtcNow.AddDays(-30)
            },
            new {
                id = Guid.NewGuid(),
                documentType = "medical_records",
                documentName = "MedicalHistory.pdf",
                isVerified = false,
                uploadedAt = DateTime.UtcNow.AddDays(-10)
            }
        };

        return Ok(ApiResponse<List<object>>.SuccessResponse(documents, null, correlationId));
    }

    /// <summary>
    /// Upload document
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<ApiResponse<object>>> UploadDocument(
        Guid userId,
        [FromForm] string documentType,
        [FromForm] IFormFile file)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId)
            return Forbid();

        if (file == null || file.Length == 0)
            return BadRequest(ApiResponse<object>.ErrorResponse("No file uploaded", null, correlationId));

        // Simulate file upload
        var document = new
        {
            id = Guid.NewGuid(),
            documentType,
            documentName = file.FileName,
            documentUrl = $"/uploads/{userId}/{file.FileName}",
            fileSize = file.Length,
            uploadedAt = DateTime.UtcNow
        };

        _logger.LogInformation("Document uploaded for user {UserId}: {FileName}", userId, file.FileName);

        return Ok(ApiResponse<object>.SuccessResponse(document, "Document uploaded successfully", correlationId));
    }

    /// <summary>
    /// Delete document
    /// </summary>
    [HttpDelete("{documentId}")]
    public async Task<ActionResult<ApiResponse<object>>> DeleteDocument(Guid userId, Guid documentId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId)
            return Forbid();

        _logger.LogInformation("Document {DocumentId} deleted for user {UserId}", documentId, userId);

        return Ok(ApiResponse<object>.SuccessResponse(null, "Document deleted successfully", correlationId));
    }
}
