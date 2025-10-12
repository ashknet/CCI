using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace IdentityFunctions;

public class UserCleanupFunction
{
    [Function("UserCleanupFunction")]
    public void Run([TimerTrigger("0 0 3 * * *")] TimerInfo timerInfo, FunctionContext context)
    {
        var logger = context.GetLogger("UserCleanupFunction");
        logger.LogInformation("Running user cleanup at {time}", DateTime.UtcNow);
        // TODO: call IdentityService to deactivate old/blocked users
    }
}
