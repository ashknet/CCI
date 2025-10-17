using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UserManagementService.Core.DTOs;
using UserManagementService.Core.Interfaces;
using UserManagementService.Core.Entities;

namespace UserManagementService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/users/{userId}/insurance")]
[Authorize]
[ApiVersion("1.0")]
public class InsuranceController : ControllerBase
{
    private readonly IInsurancePolicyRepository _insuranceRepository;

    public InsuranceController(IInsurancePolicyRepository insuranceRepository)
    {
        _insuranceRepository = insuranceRepository;
    }

    /// <summary>
    /// Get user insurance policies
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<InsurancePolicyDto>>>> GetInsurance(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId && !User.IsInRole("support"))
            return Forbid();

        var policies = await _insuranceRepository.GetByUserIdAsync(userId);
        var dtos = policies.Select(p => new InsurancePolicyDto(
            p.Id, p.ProviderName, p.PolicyNumber, p.CoverageType,
            p.CoverageAmount, p.ValidFrom, p.ValidTo, p.IsActive, p.DocumentUrl
        )).ToList();

        return Ok(ApiResponse<List<InsurancePolicyDto>>.SuccessResponse(dtos, null, correlationId));
    }

    /// <summary>
    /// Add or update insurance policy
    /// </summary>
    [HttpPut]
    public async Task<ActionResult<ApiResponse<InsurancePolicyDto>>> UpdateInsurance(
        Guid userId,
        [FromBody] CreateInsurancePolicyRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId)
            return Forbid();

        var policy = new InsurancePolicy
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            ProviderName = request.ProviderName,
            PolicyNumber = request.PolicyNumber,
            CoverageType = request.CoverageType,
            CoverageAmount = request.CoverageAmount,
            ValidFrom = request.ValidFrom,
            ValidTo = request.ValidTo,
            DocumentUrl = request.DocumentUrl ?? string.Empty,
            IsActive = true
        };

        var created = await _insuranceRepository.CreateAsync(policy);
        var dto = new InsurancePolicyDto(
            created.Id, created.ProviderName, created.PolicyNumber, created.CoverageType,
            created.CoverageAmount, created.ValidFrom, created.ValidTo, created.IsActive, created.DocumentUrl
        );

        return Ok(ApiResponse<InsurancePolicyDto>.SuccessResponse(dto, "Insurance policy added", correlationId));
    }
}
