FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy shared projects
COPY ["backend/Shared/MedTravel.Shared/MedTravel.Shared.csproj", "Shared/MedTravel.Shared/"]
COPY ["backend/Shared/MedTravel.Shared.Auth/MedTravel.Shared.Auth.csproj", "Shared/MedTravel.Shared.Auth/"]
COPY ["backend/Shared/MedTravel.Shared.Logging/MedTravel.Shared.Logging.csproj", "Shared/MedTravel.Shared.Logging/"]
COPY ["backend/Shared/MedTravel.Shared.Validation/MedTravel.Shared.Validation.csproj", "Shared/MedTravel.Shared.Validation/"]

# Copy service projects
COPY ["backend/UserManagementService/src/UserManagementService.Api/UserManagementService.Api.csproj", "UserManagementService/UserManagementService.Api/"]
COPY ["backend/UserManagementService/src/UserManagementService.Core/UserManagementService.Core.csproj", "UserManagementService/UserManagementService.Core/"]
COPY ["backend/UserManagementService/src/UserManagementService.Infrastructure/UserManagementService.Infrastructure.csproj", "UserManagementService/UserManagementService.Infrastructure/"]

RUN dotnet restore "UserManagementService/UserManagementService.Api/UserManagementService.Api.csproj"

# Copy all source code
COPY backend/Shared/ Shared/
COPY backend/UserManagementService/src/ UserManagementService/

WORKDIR "/src/UserManagementService/UserManagementService.Api"
RUN dotnet build "UserManagementService.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "UserManagementService.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "UserManagementService.Api.dll"]
