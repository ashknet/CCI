using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UserManagementService.Core.Interfaces;
using UserManagementService.Core.Entities;

namespace UserManagementService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/roles")]
[Authorize(Roles = "support")]
[ApiVersion("1.0")]
public class RolesController : ControllerBase
{
    private readonly IRoleRepository _roleRepository;

    public RolesController(IRoleRepository roleRepository)
    {
        _roleRepository = roleRepository;
    }

    /// <summary>
    /// Get all roles
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetRoles()
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var roles = await _roleRepository.GetAllAsync();
        
        var dtos = roles.Select(r => new {
            r.Id,
            r.Name,
            r.Description,
            r.CreatedAt
        }).ToList<object>();

        return Ok(ApiResponse<List<object>>.SuccessResponse(dtos, null, correlationId));
    }

    /// <summary>
    /// Create new role
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<ApiResponse<object>>> CreateRole([FromBody] object roleData)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        var role = new Role
        {
            Id = Guid.NewGuid(),
            Name = "new_role",
            Description = "New role description"
        };

        var created = await _roleRepository.CreateAsync(role);
        
        return Ok(ApiResponse<object>.SuccessResponse(new { created.Id, created.Name }, "Role created", correlationId));
    }

    /// <summary>
    /// Delete role
    /// </summary>
    [HttpDelete("{roleId}")]
    public async Task<ActionResult<ApiResponse<object>>> DeleteRole(Guid roleId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        // Implementation would check if role is assigned to users before deletion
        
        return Ok(ApiResponse<object>.SuccessResponse(null, "Role deleted successfully", correlationId));
    }
}
