# See https://aka.ms/customizecontainer to learn how to customize your debug container
# and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Use Alpine as the base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS base
WORKDIR /app

EXPOSE 5000

# Use Alpine as the base image for build
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /src 

RUN dotnet restore 
COPY . .
WORKDIR "/src/super-hero-dotnet-webapi"
RUN dotnet build "SuperHeroAPI.csproj" -c Release -o /app/build

# Continue using Alpine for the publish stage
FROM build AS publish
RUN dotnet publish "SuperHeroAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Use Alpine as the base image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Development

ENTRYPOINT ["dotnet", "SuperHeroAPI.dll"]
