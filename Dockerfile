# Use the .NET SDK image as the build stage
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine as build-env

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out



# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "SuperHeroAPI.dll"]

ENV ASPNETCORE_URLS http://+:5000
EXPOSE 5000
 