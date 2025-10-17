using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;

namespace HospitalService.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DoctorsController : ControllerBase
{
    private readonly IDoctorRepository _doctorRepository;
    private readonly IReviewRepository _reviewRepository;

    public DoctorsController(IDoctorRepository doctorRepository, IReviewRepository reviewRepository)
    {
        _doctorRepository = doctorRepository;
        _reviewRepository = reviewRepository;
    }

    /// <summary>
    /// Get doctor by ID
    /// </summary>
    [HttpGet("{id}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<DoctorDto>>> GetById(Guid id)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var doctor = await _doctorRepository.GetByIdAsync(id);
        
        if (doctor == null)
            return NotFound(ApiResponse<DoctorDto>.ErrorResponse("Doctor not found", null, correlationId));

        var dto = MapDoctorToDto(doctor);
        return Ok(ApiResponse<DoctorDto>.SuccessResponse(dto, null, correlationId));
    }

    /// <summary>
    /// Get doctors by hospital
    /// </summary>
    [HttpGet("hospital/{hospitalId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<DoctorDto>>>> GetByHospital(Guid hospitalId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var doctors = await _doctorRepository.GetByHospitalIdAsync(hospitalId);
        var dtos = doctors.Select(MapDoctorToDto).ToList();
        
        return Ok(ApiResponse<List<DoctorDto>>.SuccessResponse(dtos, null, correlationId));
    }

    /// <summary>
    /// Get doctors by specialty
    /// </summary>
    [HttpGet("specialty/{specialty}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<DoctorDto>>>> GetBySpecialty(string specialty)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var doctors = await _doctorRepository.GetBySpecialtyAsync(specialty);
        var dtos = doctors.Select(MapDoctorToDto).ToList();
        
        return Ok(ApiResponse<List<DoctorDto>>.SuccessResponse(dtos, null, correlationId));
    }

    /// <summary>
    /// Get doctor reviews
    /// </summary>
    [HttpGet("{id}/reviews")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<ReviewDto>>>> GetReviews(
        Guid id, [FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var reviews = await _reviewRepository.GetByEntityAsync("doctor", id, pageNumber, pageSize);

        var result = new PagedResult<ReviewDto>
        {
            Items = reviews.Select(r => new ReviewDto(
                r.Id, "doctor", id, r.UserId, r.Rating, r.Comment, r.IsVerified, r.CreatedAt
            )).ToList(),
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = reviews.Count()
        };

        return Ok(ApiResponse<PagedResult<ReviewDto>>.SuccessResponse(result, null, correlationId));
    }

    /// <summary>
    /// Add doctor review
    /// </summary>
    [HttpPost("{id}/reviews")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<ReviewDto>>> AddReview(Guid id, [FromBody] CreateReviewRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var review = new Core.Entities.Review
        {
            Id = Guid.NewGuid(),
            DoctorId = id,
            UserId = userId,
            Rating = request.Rating,
            Comment = request.Comment,
            IsVerified = false
        };

        var created = await _reviewRepository.CreateAsync(review);
        var dto = new ReviewDto(created.Id, "doctor", id, userId, created.Rating, created.Comment, created.IsVerified, created.CreatedAt);

        return Ok(ApiResponse<ReviewDto>.SuccessResponse(dto, "Review added successfully", correlationId));
    }

    private static DoctorDto MapDoctorToDto(Core.Entities.Doctor d) => new(
        d.Id, d.HospitalId, d.Hospital?.Name ?? "", d.FirstName, d.LastName,
        d.Email, d.Phone, d.Qualification, d.YearsOfExperience, d.Biography,
        d.ProfileImageUrl, d.ConsultationFee, d.AverageRating, d.TotalReviews,
        d.Specialties.Select(s => s.Specialty.Name).ToList(),
        d.Languages.Select(l => l.Language.Name).ToList(),
        d.Credentials.Select(c => new CredentialDto(
            c.Type, c.Name, c.IssuingOrganization, c.IssueDate, c.ExpiryDate, c.IsVerified
        )).ToList()
    );
}
