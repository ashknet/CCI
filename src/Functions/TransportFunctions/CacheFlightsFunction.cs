using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace TransportFunctions;

public class CacheFlightsFunction
{
    [Function("CacheFlightsFunction")]
    public void Run([TimerTrigger("0 0 */6 * * *")] TimerInfo timerInfo, FunctionContext context)
    {
        var logger = context.GetLogger("CacheFlightsFunction");
        logger.LogInformation("Refreshing flight cache at {time}", DateTime.UtcNow);
        // TODO: fetch popular routes and cache
    }
}
