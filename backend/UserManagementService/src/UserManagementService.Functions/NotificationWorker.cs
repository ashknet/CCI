using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using UserManagementService.Core.Interfaces;

namespace UserManagementService.Functions;

public class NotificationWorker
{
    private readonly ILogger<NotificationWorker> _logger;
    private readonly INotificationRepository _notificationRepository;

    public NotificationWorker(ILogger<NotificationWorker> logger, INotificationRepository notificationRepository)
    {
        _logger = logger;
        _notificationRepository = notificationRepository;
    }

    [Function("ProcessPendingNotifications")]
    public async Task ProcessPendingNotifications([TimerTrigger("0 */5 * * * *")] TimerInfo myTimer)
    {
        _logger.LogInformation("Processing pending notifications at: {Time}", DateTime.UtcNow);

        var pendingNotifications = await _notificationRepository.GetPendingNotificationsAsync(100);

        foreach (var notification in pendingNotifications)
        {
            try
            {
                // Simulate sending notification
                _logger.LogInformation("Sending {Type} notification to user {UserId}: {Subject}",
                    notification.Type, notification.UserId, notification.Subject);

                notification.Status = "sent";
                notification.SentAt = DateTime.UtcNow;
                await _notificationRepository.UpdateAsync(notification);

                _logger.LogInformation("Notification {NotificationId} sent successfully", notification.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to send notification {NotificationId}", notification.Id);
                notification.Status = "failed";
                notification.ErrorMessage = ex.Message;
                notification.RetryCount++;
                await _notificationRepository.UpdateAsync(notification);
            }
        }

        _logger.LogInformation("Processed {Count} notifications", pendingNotifications.Count());
    }
}
