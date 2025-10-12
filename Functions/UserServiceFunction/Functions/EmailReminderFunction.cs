using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace UserServiceFunction.Functions;

public class EmailReminderFunction
{
    private readonly ILogger _logger;
    private readonly IEmailService _emailService;

    public EmailReminderFunction(
        ILoggerFactory loggerFactory,
        IEmailService emailService)
    {
        _logger = loggerFactory.CreateLogger<EmailReminderFunction>();
        _emailService = emailService;
    }

    /// <summary>
    /// Timer trigger function to send email reminders
    /// Runs every hour to check for pending reminders
    /// </summary>
    [Function("EmailReminderFunction")]
    public async Task Run([TimerTrigger("0 0 * * * *")] TimerInfo myTimer)
    {
        _logger.LogInformation($"Email Reminder Function executed at: {DateTime.UtcNow}");

        try
        {
            // TODO: Query database for pending email reminders
            // TODO: Send emails using IEmailService
            // TODO: Mark reminders as sent

            _logger.LogInformation("Email reminders processed successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing email reminders");
            throw;
        }

        if (myTimer.ScheduleStatus is not null)
        {
            _logger.LogInformation($"Next timer schedule at: {myTimer.ScheduleStatus.Next}");
        }
    }

    /// <summary>
    /// Service Bus trigger for immediate email notifications
    /// </summary>
    [Function("SendEmailNotification")]
    public async Task SendEmailNotification(
        [ServiceBusTrigger("email-queue", Connection = "ServiceBusConnection")] string messageBody)
    {
        _logger.LogInformation($"Processing email notification: {messageBody}");

        try
        {
            // Parse message body
            // TODO: Deserialize messageBody to get email details
            // TODO: Send email using IEmailService

            _logger.LogInformation("Email notification sent successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error sending email notification");
            throw;
        }
    }
}
