using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;

namespace HospitalService.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class HospitalsController : ControllerBase
{
    private readonly IHospitalRepository _hospitalRepository;
    private readonly IReviewRepository _reviewRepository;

    public HospitalsController(IHospitalRepository hospitalRepository, IReviewRepository reviewRepository)
    {
        _hospitalRepository = hospitalRepository;
        _reviewRepository = reviewRepository;
    }

    /// <summary>
    /// Get hospital by ID
    /// </summary>
    [HttpGet("{id}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<HospitalDto>>> GetById(Guid id)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var hospital = await _hospitalRepository.GetByIdAsync(id);
        
        if (hospital == null)
            return NotFound(ApiResponse<HospitalDto>.ErrorResponse("Hospital not found", null, correlationId));

        var dto = new HospitalDto(
            hospital.Id, hospital.Name, hospital.Description, hospital.Address,
            hospital.City, hospital.State, hospital.Country, hospital.Latitude,
            hospital.Longitude, hospital.Phone, hospital.Email, hospital.Website,
            hospital.BedCapacity, hospital.AverageRating, hospital.TotalReviews,
            new List<string>(), new List<string>()
        );

        return Ok(ApiResponse<HospitalDto>.SuccessResponse(dto, null, correlationId));
    }

    /// <summary>
    /// Get hospital reviews
    /// </summary>
    [HttpGet("{id}/reviews")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<ReviewDto>>>> GetReviews(
        Guid id, [FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var reviews = await _reviewRepository.GetByEntityAsync("hospital", id, pageNumber, pageSize);

        var result = new PagedResult<ReviewDto>
        {
            Items = reviews.Select(r => new ReviewDto(
                r.Id, "hospital", id, r.UserId, r.Rating, r.Comment, r.IsVerified, r.CreatedAt
            )).ToList(),
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = reviews.Count()
        };

        return Ok(ApiResponse<PagedResult<ReviewDto>>.SuccessResponse(result, null, correlationId));
    }

    /// <summary>
    /// Add hospital review
    /// </summary>
    [HttpPost("{id}/reviews")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<ReviewDto>>> AddReview(Guid id, [FromBody] CreateReviewRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var review = new Core.Entities.Review
        {
            Id = Guid.NewGuid(),
            HospitalId = id,
            UserId = userId,
            Rating = request.Rating,
            Comment = request.Comment,
            IsVerified = false
        };

        var created = await _reviewRepository.CreateAsync(review);
        var dto = new ReviewDto(created.Id, "hospital", id, userId, created.Rating, created.Comment, created.IsVerified, created.CreatedAt);

        return Ok(ApiResponse<ReviewDto>.SuccessResponse(dto, "Review added successfully", correlationId));
    }

    /// <summary>
    /// Get hospital departments
    /// </summary>
    [HttpGet("{id}/departments")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetDepartments(Guid id)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var hospital = await _hospitalRepository.GetByIdAsync(id);
        
        if (hospital == null)
            return NotFound(ApiResponse<List<object>>.ErrorResponse("Hospital not found", null, correlationId));

        var departments = hospital.Departments.Select(d => new
        {
            d.Id,
            d.Name,
            d.Description,
            d.HeadOfDepartment,
            d.IsActive
        }).ToList<object>();

        return Ok(ApiResponse<List<object>>.SuccessResponse(departments, null, correlationId));
    }

    /// <summary>
    /// Get hospital accreditations
    /// </summary>
    [HttpGet("{id}/accreditations")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetAccreditations(Guid id)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var hospital = await _hospitalRepository.GetByIdAsync(id);
        
        if (hospital == null)
            return NotFound(ApiResponse<List<object>>.ErrorResponse("Hospital not found", null, correlationId));

        var accreditations = hospital.Accreditations.Select(a => new
        {
            a.Id,
            a.Name,
            a.IssuingBody,
            a.IssueDate,
            a.ExpiryDate,
            a.CertificateUrl
        }).ToList<object>();

        return Ok(ApiResponse<List<object>>.SuccessResponse(accreditations, null, correlationId));
    }
}
