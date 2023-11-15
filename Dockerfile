#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["core_backend/core_backend.csproj", "core_backend/"]
RUN dotnet restore "core_backend/core_backend.csproj"
COPY . .
WORKDIR "/src/core_backend"
RUN dotnet build "core_backend.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "core_backend.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "core_backend.dll"]