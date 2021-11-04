#######################################################
# Step 1: Build the application in a container        #
#######################################################

FROM mcr.microsoft.com/dotnet/sdk:5.0 as build

# Copy .csproj files for NuGet restore
COPY src/SecretsDemo/SecretsDemo.csproj src/SecretsDemo/
RUN dotnet restore src/SecretsDemo/SecretsDemo.csproj

# Copy the rest of the files over
COPY . .

# Build the application
RUN dotnet publish --output /out/ --configuration Release src/SecretsDemo/SecretsDemo.csproj

#######################################################
# Step 2: Run the build outcome in a container        #
#######################################################

FROM mcr.microsoft.com/dotnet/aspnet:5.0

EXPOSE 80
COPY --from=build /out .

# Start the application
ENTRYPOINT ["dotnet", "SecretsDemo.dll"]
