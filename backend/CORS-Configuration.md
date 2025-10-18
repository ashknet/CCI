# CORS Configuration Guide for Production Deployment

## 🌐 Overview

All backend services need to allow requests from the production frontend URL. This document explains how to configure CORS for production deployment.

## 📋 Current Frontend URLs

### Development:
- `http://localhost:5173` (Vite dev server)
- `http://localhost:3000` (Alternative port)

### Production (Azure):
**⚠️ IMPORTANT: Add your actual production frontend URL here**

Common patterns for Azure deployments:
- Azure Static Web Apps: `https://<your-app-name>.azurestaticapps.net`
- Azure App Service: `https://<your-app-name>.azurewebsites.net`
- Custom Domain: `https://www.yourdomain.com`

## 🔧 Required CORS Updates

### Update Required in All Services:

1. **Hospital Service** (`backend/HospitalService/src/HospitalService.Api/Program.cs`)
2. **TA Service** (`backend/TAService/src/TAService.Api/Program.cs`)
3. **User Management Service** (`backend/UserManagementService/src/UserManagementService.Api/Program.cs`)
4. **Messaging Service** (`backend/MessagingService/src/MessagingService.Api/Program.cs`)

### Current CORS Configuration:

```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", b => b
        .AllowAnyOrigin()
        .AllowAnyMethod()
        .AllowAnyHeader()
        .WithExposedHeaders("X-Total-Count", "X-Page-Count"));
    
    // Production CORS policy for specific domains
    options.AddPolicy("Production", b => b
        .WithOrigins(
            "https://ananthcci.azurewebsites.net",  // OLD - Hospital Service URL (NOT frontend)
            "https://cci-kohl.vercel.app",
            "https://*.vercel.app",
            "https://*.netlify.app",
            "http://localhost:3000",
            "http://localhost:5173"
        )
        .AllowAnyMethod()
        .AllowAnyHeader()
        .WithExposedHeaders("X-Total-Count", "X-Page-Count")
        .AllowCredentials());
});
```

### ⚠️ Issue Found:
The current configuration includes `"https://ananthcci.azurewebsites.net"` which is actually the **Hospital Service backend URL**, not the frontend URL!

## ✅ Recommended CORS Configuration

### Option 1: Specific Frontend URL (Recommended for Production)

Replace the Production CORS policy with:

```csharp
options.AddPolicy("Production", b => b
    .WithOrigins(
        "https://YOUR-FRONTEND-APP.azurewebsites.net",     // Replace with your actual frontend URL
        "https://YOUR-FRONTEND-APP.azurestaticapps.net",   // If using Static Web Apps
        "https://www.yourdomain.com",                       // If using custom domain
        "https://cci-kohl.vercel.app",                     // Existing Vercel deployment
        "http://localhost:3000",                            // Local development
        "http://localhost:5173"                             // Vite dev server
    )
    .AllowAnyMethod()
    .AllowAnyHeader()
    .WithExposedHeaders("X-Total-Count", "X-Page-Count")
    .AllowCredentials());
```

### Option 2: Wildcard for Azure Subdomains (Less Secure, but Flexible)

```csharp
options.AddPolicy("Production", b => b
    .SetIsOriginAllowed(origin =>
    {
        // Allow localhost for development
        if (origin.StartsWith("http://localhost")) return true;
        if (origin.StartsWith("https://localhost")) return true;
        
        // Allow your Azure domains
        if (origin.EndsWith(".azurewebsites.net")) return true;
        if (origin.EndsWith(".azurestaticapps.net")) return true;
        
        // Allow specific production domains
        if (origin == "https://www.yourdomain.com") return true;
        if (origin == "https://cci-kohl.vercel.app") return true;
        
        return false;
    })
    .AllowAnyMethod()
    .AllowAnyHeader()
    .WithExposedHeaders("X-Total-Count", "X-Page-Count")
    .AllowCredentials());
```

### Option 3: Environment Variable Based (Most Flexible)

Add to `appsettings.json`:

```json
{
  "CorsSettings": {
    "AllowedOrigins": [
      "https://YOUR-FRONTEND-APP.azurewebsites.net",
      "https://cci-kohl.vercel.app",
      "http://localhost:3000",
      "http://localhost:5173"
    ]
  }
}
```

Then in `Program.cs`:

```csharp
var allowedOrigins = builder.Configuration
    .GetSection("CorsSettings:AllowedOrigins")
    .Get<string[]>() ?? Array.Empty<string>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("Production", b => b
        .WithOrigins(allowedOrigins)
        .AllowAnyMethod()
        .AllowAnyHeader()
        .WithExposedHeaders("X-Total-Count", "X-Page-Count")
        .AllowCredentials());
});
```

## 🚀 Deployment Steps

### 1. Determine Your Frontend URL

After deploying the frontend, note the URL:
- Example: `https://medtravel-frontend.azurewebsites.net`
- Or: `https://medtravel.azurestaticapps.net`

### 2. Update All Backend Services

Update the CORS configuration in **all 4 services**:

```bash
# Hospital Service
backend/HospitalService/src/HospitalService.Api/Program.cs

# TA Service  
backend/TAService/src/TAService.Api/Program.cs

# User Management Service
backend/UserManagementService/src/UserManagementService.Api/Program.cs

# Messaging Service
backend/MessagingService/src/MessagingService.Api/Program.cs
```

### 3. Replace the CORS Origins

Find this section in each service:

```csharp
.WithOrigins(
    "https://ananthcci.azurewebsites.net",  // ❌ REMOVE - This is backend URL
    "https://cci-kohl.vercel.app",
    // ... rest
)
```

Replace with:

```csharp
.WithOrigins(
    "https://YOUR-ACTUAL-FRONTEND-URL.azurewebsites.net",  // ✅ ADD - Your frontend URL
    "https://cci-kohl.vercel.app",
    "http://localhost:3000",
    "http://localhost:5173"
)
```

### 4. Rebuild and Redeploy Services

```bash
# For each service
cd backend/[ServiceName]/src/[ServiceName].Api
dotnet build
dotnet publish -c Release

# Then deploy to Azure
```

## 🧪 Testing CORS Configuration

### Test from Browser Console:

```javascript
// Test from your frontend app in production
fetch('https://ananthcci.azurewebsites.net/api/v1/search/suggest?term=test', {
  method: 'GET',
  credentials: 'include',
  headers: {
    'Content-Type': 'application/json'
  }
})
  .then(response => response.json())
  .then(data => console.log('Success:', data))
  .catch(error => console.error('CORS Error:', error));
```

### Expected Response Headers:

```
Access-Control-Allow-Origin: https://your-frontend-url.azurewebsites.net
Access-Control-Allow-Credentials: true
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: *
Access-Control-Expose-Headers: X-Total-Count, X-Page-Count
```

## 🐛 Troubleshooting

### Issue 1: "No 'Access-Control-Allow-Origin' header"

**Cause**: Frontend URL not in CORS allowed origins

**Solution**: Add your frontend URL to the WithOrigins list

### Issue 2: "The 'Access-Control-Allow-Origin' header contains multiple values"

**Cause**: CORS policy applied multiple times

**Solution**: Ensure `app.UseCors()` is called only once

### Issue 3: "Credentials flag is true but Access-Control-Allow-Credentials is not"

**Cause**: Using `.AllowAnyOrigin()` with `.AllowCredentials()`

**Solution**: Use specific origins with `.WithOrigins()` instead

### Issue 4: Preflight OPTIONS requests failing

**Cause**: CORS policy not handling OPTIONS requests

**Solution**: Ensure `app.UseCors()` is before `app.UseAuthorization()`

## 📝 Service-Specific Notes

### All Services Current State:
- ✅ Development mode uses `AllowAll` policy (permissive)
- ✅ Production mode uses `Production` policy (restrictive)
- ⚠️ Need to update production frontend URL in all services

### Middleware Order (Critical):

```csharp
app.UseMiddleware<CorrelationIdMiddleware>();
app.UseMiddleware<ValidationMiddleware>();
app.UseSwagger();
app.UseSwaggerUI();

// CORS must be here, before authentication
if (app.Environment.IsDevelopment())
{
    app.UseCors("AllowAll");
}
else
{
    app.UseCors("Production");
}

app.UseHttpsRedirection();
app.UseMedTravelAuth(builder.Configuration);  // After CORS
app.MapControllers();
app.MapHealthChecks("/health");
```

## ✅ Checklist

Before deploying to production:

- [ ] Deployed frontend and obtained production URL
- [ ] Updated CORS in Hospital Service
- [ ] Updated CORS in TA Service  
- [ ] Updated CORS in User Management Service
- [ ] Updated CORS in Messaging Service
- [ ] Removed incorrect backend URLs from CORS origins
- [ ] Added correct frontend URL to all services
- [ ] Rebuilt all services
- [ ] Redeployed all services to Azure
- [ ] Tested API calls from production frontend
- [ ] Verified CORS headers in browser dev tools

## 🔒 Security Best Practices

1. **Never use `.AllowAnyOrigin()` in production**
2. **Always specify exact origins** for production
3. **Use `.AllowCredentials()` only when needed** (required for cookies/auth)
4. **Keep development and production policies separate**
5. **Document all allowed origins** and why they're needed
6. **Review CORS settings regularly** as part of security audits

## 📚 Additional Resources

- [ASP.NET Core CORS Documentation](https://docs.microsoft.com/en-us/aspnet/core/security/cors)
- [CORS Best Practices](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [Azure CORS Configuration](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-rest-api)

