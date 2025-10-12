# Multi-stage build for .NET microservices
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY ["MedicalTravelBooking.sln", "./"]
COPY ["Services/UserService/UserService.csproj", "Services/UserService/"]
COPY ["Services/ProviderService/ProviderService.csproj", "Services/ProviderService/"]
COPY ["Services/AppointmentService/AppointmentService.csproj", "Services/AppointmentService/"]
COPY ["Services/SearchService/SearchService.csproj", "Services/SearchService/"]
COPY ["Services/TransportationService/TransportationService.csproj", "Services/TransportationService/"]
COPY ["Services/AccommodationService/AccommodationService.csproj", "Services/AccommodationService/"]
COPY ["Services/PaymentService/PaymentService.csproj", "Services/PaymentService/"]
COPY ["Services/MessagingService/MessagingService.csproj", "Services/MessagingService/"]
COPY ["Services/NotificationService/NotificationService.csproj", "Services/NotificationService/"]
COPY ["Services/AnalyticsService/AnalyticsService.csproj", "Services/AnalyticsService/"]
COPY ["Services/ReviewService/ReviewService.csproj", "Services/ReviewService/"]
COPY ["Services/ChecklistService/ChecklistService.csproj", "Services/ChecklistService/"]
COPY ["Gateway/ApiGateway/ApiGateway.csproj", "Gateway/ApiGateway/"]

# Restore dependencies
RUN dotnet restore

# Copy everything else
COPY . .

# Build argument to specify which service to build
ARG SERVICE_NAME=UserService

# Build the specified service
WORKDIR /src/Services/${SERVICE_NAME}
RUN dotnet build "${SERVICE_NAME}.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "${SERVICE_NAME}.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "UserService.dll"]
