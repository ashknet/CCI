FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["backend/Shared/MedTravel.Shared/MedTravel.Shared.csproj", "Shared/MedTravel.Shared/"]
COPY ["backend/Shared/MedTravel.Shared.Auth/MedTravel.Shared.Auth.csproj", "Shared/MedTravel.Shared.Auth/"]
COPY ["backend/Shared/MedTravel.Shared.Logging/MedTravel.Shared.Logging.csproj", "Shared/MedTravel.Shared.Logging/"]
COPY ["backend/Shared/MedTravel.Shared.Validation/MedTravel.Shared.Validation.csproj", "Shared/MedTravel.Shared.Validation/"]
COPY ["backend/HospitalService/src/HospitalService.Api/HospitalService.Api.csproj", "HospitalService/HospitalService.Api/"]
COPY ["backend/HospitalService/src/HospitalService.Core/HospitalService.Core.csproj", "HospitalService/HospitalService.Core/"]
COPY ["backend/HospitalService/src/HospitalService.Infrastructure/HospitalService.Infrastructure.csproj", "HospitalService/HospitalService.Infrastructure/"]
RUN dotnet restore "HospitalService/HospitalService.Api/HospitalService.Api.csproj"
COPY backend/Shared/ Shared/
COPY backend/HospitalService/src/ HospitalService/
WORKDIR "/src/HospitalService/HospitalService.Api"
RUN dotnet build "HospitalService.Api.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "HospitalService.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HospitalService.Api.dll"]
