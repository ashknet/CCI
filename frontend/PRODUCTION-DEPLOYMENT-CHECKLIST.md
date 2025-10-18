# 🚀 Production Deployment Checklist

## Frontend & Backend Deployment Guide

### 📋 Pre-Deployment Checklist

- [ ] All code committed to repository
- [ ] All environment variables documented
- [ ] CORS configuration reviewed
- [ ] API endpoints tested locally
- [ ] Build succeeds without errors

---

## 🎨 Frontend Deployment

### Step 1: Build Production Bundle

```bash
cd frontend
npm install
npm run build
```

This creates optimized files in `frontend/dist/` folder.

### Step 2: Deploy to Azure

#### Option A: Azure Static Web Apps (Recommended)

```bash
# Install Azure CLI if needed
az login

# Deploy
az staticwebapp create \
  --name medtravel-frontend \
  --resource-group YourResourceGroup \
  --location "East US" \
  --source ./dist \
  --branch main
```

#### Option B: Azure App Service

```bash
# Create and deploy
az webapp up \
  --resource-group YourResourceGroup \
  --name medtravel-frontend \
  --src-path ./dist \
  --html
```

#### Option C: Manual Upload via Azure Portal

1. Go to Azure Portal
2. Navigate to your Static Web App or App Service
3. Upload contents of `dist/` folder

### Step 3: Frontend URL ✅

Production Frontend URL: **`https://cci-kohl.vercel.app`**

**📝 This URL is already configured in all backend CORS settings.**

---

## 🔧 Backend CORS Configuration

### ✅ COMPLETED: CORS Already Configured

All backend services have been updated with your frontend URL: **`https://cci-kohl.vercel.app`**

### Files Updated (4 total): ✅

1. ✅ `backend/HospitalService/src/HospitalService.Api/Program.cs`
2. ✅ `backend/TAService/src/TAService.Api/Program.cs`
3. ✅ `backend/UserManagementService/src/UserManagementService.Api/Program.cs`
4. ✅ `backend/MessagingService/src/MessagingService.Api/Program.cs`

### Current CORS Configuration:

All services now have:
```csharp
options.AddPolicy("Production", b => b
    .WithOrigins(
        "https://cci-kohl.vercel.app",  // ✅ Your production frontend
        "http://localhost:3000",         // Local dev
        "http://localhost:5173",         // Vite HTTP
        "https://localhost:5173"         // Vite HTTPS
    )
    .AllowAnyMethod()
    .AllowAnyHeader()
    .WithExposedHeaders("X-Total-Count", "X-Page-Count")
    .AllowCredentials());
```

**No further CORS updates needed!** You can proceed directly to deployment.

---

## 🖥️ Backend Services Deployment

### For Each Service (4 total):

#### Hospital Service
```bash
cd backend/HospitalService/src/HospitalService.Api
dotnet publish -c Release -o ./publish
az webapp deploy --resource-group YourResourceGroup --name ananthcci --src-path ./publish
```

#### TA Service
```bash
cd backend/TAService/src/TAService.Api
dotnet publish -c Release -o ./publish
az webapp deploy --resource-group YourResourceGroup --name ccita --src-path ./publish
```

#### User Management Service
```bash
cd backend/UserManagementService/src/UserManagementService.Api
dotnet publish -c Release -o ./publish
az webapp deploy --resource-group YourResourceGroup --name ccium --src-path ./publish
```

#### Messaging Service
```bash
cd backend/MessagingService/src/MessagingService.Api
dotnet publish -c Release -o ./publish
az webapp deploy --resource-group YourResourceGroup --name ccims --src-path ./publish
```

---

## ✅ Post-Deployment Verification

### 1. Check Frontend Loads

Visit your frontend URL: `https://your-frontend-url.azurewebsites.net`

- [ ] Page loads without errors
- [ ] Check browser console for errors
- [ ] Verify API configuration in console (development mode shows it)

### 2. Test Each Backend Service

#### Test Hospital Service:
```bash
curl "https://ananthcci.azurewebsites.net/health"
curl "https://ananthcci.azurewebsites.net/api/v1/search/suggest?term=test"
```

#### Test TA Service:
```bash
curl "https://ccita.azurewebsites.net/health"
```

#### Test User Management Service:
```bash
curl "https://ccium.azurewebsites.net/health"
```

#### Test Messaging Service:
```bash
curl "https://ccims.azurewebsites.net/health"
```

### 3. Test CORS from Frontend

Open browser console at your frontend URL and run:

```javascript
// Test Hospital Service Search
fetch('https://ananthcci.azurewebsites.net/api/v1/search/suggest?term=hospital')
  .then(r => r.json())
  .then(data => console.log('✅ Hospital Service:', data))
  .catch(err => console.error('❌ CORS Error:', err));

// Test TA Service  
fetch('https://ccita.azurewebsites.net/health')
  .then(r => r.json())
  .then(data => console.log('✅ TA Service:', data))
  .catch(err => console.error('❌ CORS Error:', err));

// Test User Management
fetch('https://ccium.azurewebsites.net/health')
  .then(r => r.json())
  .then(data => console.log('✅ User Management:', data))
  .catch(err => console.error('❌ CORS Error:', err));

// Test Messaging Service
fetch('https://ccims.azurewebsites.net/health')
  .then(r => r.json())
  .then(data => console.log('✅ Messaging Service:', data))
  .catch(err => console.error('❌ CORS Error:', err));
```

### 4. Check Network Tab

In browser DevTools → Network tab:
- [ ] API calls return `200 OK` (not `CORS error`)
- [ ] Response headers include `Access-Control-Allow-Origin`
- [ ] No red CORS errors in console

### 5. Test Key Features

- [ ] Search for hospitals/doctors works
- [ ] User can register/login
- [ ] Appointments can be booked
- [ ] Navigation works correctly

---

## 🐛 Troubleshooting

### Problem: CORS Errors in Production

**Symptoms:**
```
Access to fetch at 'https://ananthcci.azurewebsites.net/api/v1/...' from origin 
'https://your-frontend.azurewebsites.net' has been blocked by CORS policy
```

**Solution:**
1. Verify you updated CORS in ALL 4 backend services
2. Check you used the correct frontend URL
3. Rebuild and redeploy affected backend service
4. Clear browser cache and retry

### Problem: 404 Errors on Frontend Routes

**Cause:** Azure not configured for SPA routing

**Solution:** Add `staticwebapp.config.json` or `web.config`:

```json
{
  "navigationFallback": {
    "rewrite": "/index.html",
    "exclude": ["/images/*.{png,jpg,gif}", "/css/*"]
  }
}
```

### Problem: API Returns 401 Unauthorized

**Cause:** JWT token issues or auth configuration

**Solution:**
1. Check `AuthSettings` in backend `appsettings.json`
2. Verify JWT secret is set correctly
3. Check token is being sent in request headers

### Problem: Mixed Content Errors

**Cause:** Frontend (HTTPS) trying to call backend (HTTP)

**Solution:** Ensure ALL services use HTTPS in production

---

## 📊 Production URLs Summary

| Component | URL | Purpose |
|-----------|-----|---------|
| **Frontend** | `https://YOUR-FRONTEND.azurewebsites.net` | Main UI |
| **Hospital Service** | `https://ananthcci.azurewebsites.net` | Search, Hospitals, Doctors |
| **TA Service** | `https://ccita.azurewebsites.net` | Appointments, Travel, Hotels |
| **User Management** | `https://ccium.azurewebsites.net` | Auth, Profiles |
| **Messaging** | `https://ccims.azurewebsites.net` | Messages, Threads |

---

## 🎯 Quick Deployment Summary

1. **Frontend:**
   ```bash
   cd frontend && npm run build
   # Deploy dist/ folder to Azure
   # Note the URL you get
   ```

2. **Update CORS:**
   ```bash
   # Edit 4 Program.cs files
   # Replace backend URL with your frontend URL
   ```

3. **Backend Services:**
   ```bash
   # For each service:
   dotnet publish -c Release
   # Deploy to Azure
   ```

4. **Test:**
   ```bash
   # Check health endpoints
   # Test CORS from browser console
   # Verify features work end-to-end
   ```

---

## 📞 Support

If you encounter issues:

1. Check `backend/CORS-Configuration.md` for detailed CORS guide
2. Review `backend/CORS-URGENT-FIX.md` for common issues
3. Check Azure logs in Portal → App Service → Log Stream
4. Review browser console and network tab for errors

---

## ✨ Success Criteria

Your deployment is successful when:

- [ ] Frontend loads at production URL
- [ ] No CORS errors in browser console
- [ ] All 4 backend services health endpoints return 200
- [ ] Search functionality works
- [ ] User can login/register
- [ ] Appointments can be created
- [ ] All features work end-to-end

**Congratulations! Your application is live! 🎉**

