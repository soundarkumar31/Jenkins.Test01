# Step 1: Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy everything
COPY . .

# Restore and build
RUN dotnet restore Jenkins.Test01
RUN dotnet publish Jenkins.Test01 -c Release -o /app/publish

# Step 2: Runtime stage
FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app

# Copy published output
COPY --from=build /app/publish .

# Run console app
ENTRYPOINT ["dotnet", "Jenkins.Test01.dll"]
