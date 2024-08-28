# # Use the official image as a parent image
# FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
# WORKDIR /app
# EXPOSE 5000

# # Use SDK image to build the application
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# WORKDIR /src
# COPY ["SuperHeroAPI.csproj", "./"]
# RUN dotnet restore "SuperHeroAPI.csproj"
# COPY . .

# RUN dotnet build "SuperHeroAPI.csproj" -c Release -o /app/build

# FROM build AS publish
# RUN dotnet publish "SuperHeroAPI.csproj" -c Release -o /app/publish

# # Build the final image
# FROM base AS final
# WORKDIR /app
# COPY --from=publish /app/publish .

# ENV ASPNETCORE_URLS=http://+:5000
# ENV ASPNETCORE_ENVIRONMENT=Production

# ENTRYPOINT ["dotnet", "SuperHeroAPI.dll"]





# Use the official image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000

# Use SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["SuperHeroAPI.csproj", "./"]
RUN dotnet restore "SuperHeroAPI.csproj"

# Copy the remaining application code
COPY . .

# Install dotnet-ef globally
RUN dotnet tool install --global dotnet-ef --version 6.0.6 \
    && export PATH="$PATH:/root/.dotnet/tools"

# Run the EF database migration
RUN dotnet ef database update

# Build the application
RUN dotnet build "SuperHeroAPI.csproj" -c Release -o /app/build

FROM build AS publish

# Publish the application
RUN dotnet publish "SuperHeroAPI.csproj" -c Release -o /app/publish

# Build the final image
FROM base AS final
WORKDIR /app

# Copy the published output to the final image
COPY --from=publish /app/publish .

# Set environment variables
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Production

# Set the entry point for the application
ENTRYPOINT ["dotnet", "SuperHeroAPI.dll"]
