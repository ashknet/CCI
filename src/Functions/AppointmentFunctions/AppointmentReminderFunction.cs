using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace AppointmentFunctions;

public class AppointmentReminderFunction
{
    [Function("AppointmentReminderFunction")]
    public void Run([TimerTrigger("0 0 7 * * *")] TimerInfo timerInfo, FunctionContext context)
    {
        var logger = context.GetLogger("AppointmentReminderFunction");
        logger.LogInformation("Sending reminders at {time}", DateTime.UtcNow);
        // TODO: pull upcoming appointments and enqueue reminders
    }
}
