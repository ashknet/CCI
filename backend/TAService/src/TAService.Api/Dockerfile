FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["backend/Shared/MedTravel.Shared/MedTravel.Shared.csproj", "Shared/MedTravel.Shared/"]
COPY ["backend/Shared/MedTravel.Shared.Auth/MedTravel.Shared.Auth.csproj", "Shared/MedTravel.Shared.Auth/"]
COPY ["backend/Shared/MedTravel.Shared.Logging/MedTravel.Shared.Logging.csproj", "Shared/MedTravel.Shared.Logging/"]
COPY ["backend/Shared/MedTravel.Shared.Validation/MedTravel.Shared.Validation.csproj", "Shared/MedTravel.Shared.Validation/"]
COPY ["backend/TransportationAccommodationService/src/TransportationAccommodationService.Api/TransportationAccommodationService.Api.csproj", "TransportationAccommodationService/"]
COPY ["backend/TransportationAccommodationService/src/TransportationAccommodationService.Core/TransportationAccommodationService.Core.csproj", "TransportationAccommodationService.Core/"]
RUN dotnet restore "TransportationAccommodationService/TransportationAccommodationService.Api.csproj"
COPY backend/Shared/ Shared/
COPY backend/TransportationAccommodationService/src/ TransportationAccommodationService/
WORKDIR "/src/TransportationAccommodationService"
RUN dotnet build "TransportationAccommodationService.Api.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "TransportationAccommodationService.Api.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TransportationAccommodationService.Api.dll"]
