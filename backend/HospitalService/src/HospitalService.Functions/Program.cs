using Microsoft.Azure.Functions.Worker;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using HospitalService.Core.Interfaces;
using HospitalService.Infrastructure.Data;
using HospitalService.Infrastructure.Repositories;

var host = new HostBuilder()
    .ConfigureFunctionsWebApplication()
    .ConfigureServices((context, services) =>
    {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();

        var connectionString = context.Configuration.GetConnectionString("DefaultConnection");
        services.AddDbContext<HospitalDbContext>(options =>
            options.UseSqlServer(connectionString));

        services.AddScoped<IHospitalRepository, HospitalRepository>();
        services.AddScoped<IDoctorRepository, DoctorRepository>();
        services.AddScoped<IAppointmentRepository, AppointmentRepository>();
        services.AddScoped<IReviewRepository, ReviewRepository>();
        services.AddScoped<ISpecialtyRepository, SpecialtyRepository>();
    })
    .Build();

host.Run();
