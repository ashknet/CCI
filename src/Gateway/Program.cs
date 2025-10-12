using Yarp.ReverseProxy;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddReverseProxy()
    .LoadFromMemory(new()
    {
        Clusters =
        {
            new("identity-cluster")
            {
                Destinations = { { "d1", new("http://localhost:8081") } }
            },
            new("provider-cluster")
            {
                Destinations = { { "d1", new("http://localhost:8082") } }
            },
            new("appointment-cluster")
            {
                Destinations = { { "d1", new("http://localhost:8083") } }
            },
            new("search-cluster")
            {
                Destinations = { { "d1", new("http://localhost:8084") } }
            },
            new("transport-cluster")
            {
                Destinations = { { "d1", new("http://localhost:8085") } }
            },
            new("accommodation-cluster")
            {
                Destinations = { { "d1", new("http://localhost:8086") } }
            },
            new("checklist-cluster")
            {
                Destinations = { { "d1", new("http://localhost:8087") } }
            },
            new("cost-cluster")
            {
                Destinations = { { "d1", new("http://localhost:8088") } }
            }
        },
        Routes =
        {
            new("identity-route")
            {
                ClusterId = "identity-cluster",
                Match = new() { Path = "/identity/{**catch-all}" },
                Transforms = { new Dictionary<string,string> { { "PathPattern", "/{**catch-all}" } } }
            },
            new("providers-route")
            {
                ClusterId = "provider-cluster",
                Match = new() { Path = "/providers/{**catch-all}" },
                Transforms = { new Dictionary<string,string> { { "PathPattern", "/{**catch-all}" } } }
            },
            new("appointments-route")
            {
                ClusterId = "appointment-cluster",
                Match = new() { Path = "/appointments/{**catch-all}" },
                Transforms = { new Dictionary<string,string> { { "PathPattern", "/{**catch-all}" } } }
            },
            new("search-route")
            {
                ClusterId = "search-cluster",
                Match = new() { Path = "/search/{**catch-all}" },
                Transforms = { new Dictionary<string,string> { { "PathPattern", "/{**catch-all}" } } }
            },
            new("transport-route")
            {
                ClusterId = "transport-cluster",
                Match = new() { Path = "/transport/{**catch-all}" },
                Transforms = { new Dictionary<string,string> { { "PathPattern", "/{**catch-all}" } } }
            },
            new("accommodation-route")
            {
                ClusterId = "accommodation-cluster",
                Match = new() { Path = "/accommodation/{**catch-all}" },
                Transforms = { new Dictionary<string,string> { { "PathPattern", "/{**catch-all}" } } }
            },
            new("checklist-route")
            {
                ClusterId = "checklist-cluster",
                Match = new() { Path = "/checklist/{**catch-all}" },
                Transforms = { new Dictionary<string,string> { { "PathPattern", "/{**catch-all}" } } }
            },
            new("cost-route")
            {
                ClusterId = "cost-cluster",
                Match = new() { Path = "/costs/{**catch-all}" },
                Transforms = { new Dictionary<string,string> { { "PathPattern", "/{**catch-all}" } } }
            }
        }
    });

var app = builder.Build();

app.MapReverseProxy();

app.Run("http://0.0.0.0:8080");