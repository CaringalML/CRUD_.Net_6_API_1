# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory to /src
WORKDIR /src

# Copy the project files into the container
COPY . .

# Navigate to the project directory
WORKDIR "/src/super-hero-dotnet-webapi"

# Restore dependencies using dotnet restore
RUN dotnet restore

# Build the application
RUN dotnet build -c Release -o /app

# Set the working directory for the runtime image
WORKDIR /app

# Specify the entry point for the runtime image
ENTRYPOINT ["dotnet", "SuperHeroAPI.dll"]
