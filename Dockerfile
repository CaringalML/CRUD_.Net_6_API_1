# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory to /src
WORKDIR /src

# Copy the project files into the container
COPY . .

# Restore dependencies using dotnet restore
RUN dotnet restore "SuperHeroAPI.csproj"

# Build the application
RUN dotnet publish "SuperHeroAPI.csproj" -c Release -o /site

# Set the working directory for the runtime image
WORKDIR /site

# Specify the entry point for the runtime image
ENTRYPOINT ["dotnet", "SuperHeroAPI.dll"]
