using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UserManagementService.Core.DTOs;
using UserManagementService.Core.Entities;
using UserManagementService.Core.Interfaces;

namespace UserManagementService.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class NotificationsController : ControllerBase
{
    private readonly INotificationRepository _notificationRepository;
    private readonly ILogger<NotificationsController> _logger;

    public NotificationsController(INotificationRepository notificationRepository, ILogger<NotificationsController> logger)
    {
        _notificationRepository = notificationRepository;
        _logger = logger;
    }

    /// <summary>
    /// Get current user's notifications
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<ApiResponse<PagedResult<NotificationDto>>>> GetNotifications(
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 20)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var notifications = await _notificationRepository.GetUserNotificationsAsync(userId, pageNumber, pageSize);
        var notificationDtos = notifications.Select(MapToDto).ToList();

        var pagedResult = new PagedResult<NotificationDto>
        {
            Items = notificationDtos,
            TotalCount = notificationDtos.Count,
            PageNumber = pageNumber,
            PageSize = pageSize
        };

        return Ok(ApiResponse<PagedResult<NotificationDto>>.SuccessResponse(pagedResult, null, correlationId));
    }

    /// <summary>
    /// Mark a notification as read
    /// </summary>
    [HttpPatch("{id}/read")]
    public async Task<ActionResult<ApiResponse<object>>> MarkAsRead(Guid id)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        await _notificationRepository.MarkAsReadAsync(id);
        return Ok(ApiResponse<object>.SuccessResponse(null, "Notification marked as read", correlationId));
    }

    /// <summary>
    /// Create a notification (admin/system only)
    /// </summary>
    [HttpPost]
    [Authorize(Roles = "support,hospital_admin")]
    public async Task<ActionResult<ApiResponse<NotificationDto>>> CreateNotification([FromBody] CreateNotificationRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var notification = new Notification
        {
            Id = Guid.NewGuid(),
            UserId = request.UserId,
            Type = request.Type,
            Channel = request.Channel,
            Subject = request.Subject,
            Message = request.Message,
            ScheduledFor = request.ScheduledFor ?? DateTime.UtcNow,
            Status = "pending"
        };

        var created = await _notificationRepository.CreateAsync(notification);
        return Ok(ApiResponse<NotificationDto>.SuccessResponse(MapToDto(created), "Notification created", correlationId));
    }

    private static NotificationDto MapToDto(Notification notification)
    {
        return new NotificationDto(
            notification.Id,
            notification.Type,
            notification.Channel,
            notification.Subject,
            notification.Message,
            notification.Status,
            notification.ScheduledFor,
            notification.SentAt,
            notification.ReadAt
        );
    }
}
