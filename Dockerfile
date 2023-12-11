# Use the official image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000

# Use SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["SuperHeroAPI.csproj", "./"]
RUN dotnet restore "SuperHeroAPI.csproj"
COPY . .

RUN dotnet build "SuperHeroAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SuperHeroAPI.csproj" -c Release -o /app/publish

# Build the final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "SuperHeroAPI.dll"]
