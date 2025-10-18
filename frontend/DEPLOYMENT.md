# Deployment Guide

## 🚀 Quick Start

The application is configured to automatically use the correct API URLs based on the environment:

- **Local Development**: Uses `localhost:646XX` URLs
- **Production**: Uses Azure `*.azurewebsites.net` URLs

**No configuration changes needed for deployment!**

## 📋 Production URLs

| Service | Azure URL |
|---------|-----------|
| Hospital Service | `https://ananthcci.azurewebsites.net` |
| TA Service | `https://ccita.azurewebsites.net` |
| User Management | `https://ccium.azurewebsites.net` |
| Messaging Service | `https://ccims.azurewebsites.net` |

## 🏗️ Build & Deploy

### 1. Build for Production

```bash
cd frontend
npm run build
```

This creates optimized production files in the `dist/` folder and automatically configures URLs for Azure services.

### 2. Deploy to Azure Static Web Apps / App Service

#### Option A: Azure Static Web Apps (Recommended)

```bash
# Install Azure Static Web Apps CLI (if not already installed)
npm install -g @azure/static-web-apps-cli

# Deploy
swa deploy ./dist --env production
```

#### Option B: Azure App Service

```bash
# Using Azure CLI
az webapp up --resource-group <resource-group> --name <app-name> --src-path ./dist
```

#### Option C: Manual Deployment

1. Navigate to Azure Portal
2. Go to your Static Web App or App Service
3. Upload the contents of the `dist/` folder

### 3. Configure CORS on Backend Services

Ensure all backend services (Hospital, TA, User Management, Messaging) allow requests from your frontend domain:

```csharp
// In each service's Program.cs
builder.Services.AddCors(options =>
{
    options.AddPolicy("Production", b => b
        .WithOrigins(
            "https://your-frontend-domain.azurewebsites.net",
            "https://your-frontend-domain.com"
        )
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials());
});
```

## 🛠️ Environment-Specific Configuration

### Local Development

```bash
npm run dev
```

Automatically uses localhost URLs:
- Hospital: `https://localhost:64685`
- TA: `https://localhost:64686`
- User Management: `https://localhost:64687`
- Messaging: `https://localhost:64688`

### Testing with Production APIs Locally

Create `.env.development.local`:

```env
VITE_HOSPITAL_SERVICE_URL=https://ananthcci.azurewebsites.net
VITE_TA_SERVICE_URL=https://ccita.azurewebsites.net
VITE_USER_MANAGEMENT_URL=https://ccium.azurewebsites.net
VITE_MESSAGING_SERVICE_URL=https://ccims.azurewebsites.net
```

Then run:
```bash
npm run dev
```

### Preview Production Build Locally

```bash
npm run build
npm run preview
```

This tests the production build on your local machine.

## 🔍 Verification

After deployment, verify the API configuration:

1. Open browser console on your deployed site
2. Look for the log message (in development builds):
   ```
   🌐 API Configuration: { ... }
   ```
3. Test API connectivity using the built-in API test page at `/api-test`

## 📝 Build Scripts

The following scripts are available in `package.json`:

```json
{
  "scripts": {
    "dev": "vite",                    // Development with localhost APIs
    "build": "tsc && vite build",     // Production build with Azure APIs
    "preview": "vite preview"         // Preview production build
  }
}
```

## 🔐 Environment Variables (Optional)

If you need to override the default production URLs:

### Azure App Service / Static Web Apps

Add Application Settings:
```
VITE_HOSPITAL_SERVICE_URL=https://custom-hospital.azurewebsites.net
VITE_TA_SERVICE_URL=https://custom-ta.azurewebsites.net
VITE_USER_MANAGEMENT_URL=https://custom-user.azurewebsites.net
VITE_MESSAGING_SERVICE_URL=https://custom-messaging.azurewebsites.net
```

### GitHub Actions / CI/CD

Add to your workflow:

```yaml
- name: Build
  run: npm run build
  env:
    VITE_HOSPITAL_SERVICE_URL: ${{ secrets.HOSPITAL_SERVICE_URL }}
    VITE_TA_SERVICE_URL: ${{ secrets.TA_SERVICE_URL }}
    VITE_USER_MANAGEMENT_URL: ${{ secrets.USER_MANAGEMENT_URL }}
    VITE_MESSAGING_SERVICE_URL: ${{ secrets.MESSAGING_SERVICE_URL }}
```

## 🐛 Troubleshooting

### Issue: "Failed to fetch" errors in production

**Solution**: Check CORS configuration on backend services. They must allow requests from your frontend domain.

### Issue: APIs still pointing to localhost in production

**Solution**: 
1. Ensure you ran `npm run build` (not `npm run dev`)
2. Check that `import.meta.env.PROD` is `true` in built version
3. Clear browser cache and hard refresh (Ctrl+Shift+R)

### Issue: Mixed content errors (HTTP/HTTPS)

**Solution**: All services must use HTTPS in production. HTTP is not allowed when the frontend is served over HTTPS.

## 📚 Additional Resources

- [Vite Environment Variables](https://vitejs.dev/guide/env-and-mode.html)
- [Azure Static Web Apps](https://docs.microsoft.com/en-us/azure/static-web-apps/)
- [Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/)

## 🎯 Summary

✅ **Automatic environment detection** - No manual configuration needed
✅ **Localhost URLs** in development
✅ **Azure URLs** in production
✅ **Flexible override** options via environment variables
✅ **Zero-config deployment** to Azure

