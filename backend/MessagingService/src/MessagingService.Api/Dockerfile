FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["backend/Shared/MedTravel.Shared/MedTravel.Shared.csproj", "Shared/MedTravel.Shared/"]
COPY ["backend/Shared/MedTravel.Shared.Auth/MedTravel.Shared.Auth.csproj", "Shared/MedTravel.Shared.Auth/"]
COPY ["backend/Shared/MedTravel.Shared.Logging/MedTravel.Shared.Logging.csproj", "Shared/MedTravel.Shared.Logging/"]
COPY ["backend/Shared/MedTravel.Shared.Validation/MedTravel.Shared.Validation.csproj", "Shared/MedTravel.Shared.Validation/"]
COPY ["backend/MessagingService/src/MessagingService.Api/MessagingService.Api.csproj", "MessagingService/"]
COPY ["backend/MessagingService/src/MessagingService.Core/MessagingService.Core.csproj", "MessagingService.Core/"]
RUN dotnet restore "MessagingService/MessagingService.Api.csproj"
COPY backend/Shared/ Shared/
COPY backend/MessagingService/src/ MessagingService/
WORKDIR "/src/MessagingService"
RUN dotnet build "MessagingService.Api.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "MessagingService.Api.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MessagingService.Api.dll"]
