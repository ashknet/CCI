# Environment Configuration

This application automatically switches between local development and production API URLs.

## Automatic Environment Detection

The application uses `import.meta.env.PROD` to automatically detect the environment:
- **Development** (npm run dev): Uses localhost URLs
- **Production** (npm run build): Uses Azure production URLs

## Default URLs

### Local Development (Default)
- Hospital Service: `https://localhost:64685`
- TA Service: `https://localhost:64686`
- User Management: `https://localhost:64687`
- Messaging Service: `https://localhost:64688`

### Production (Azure)
- Hospital Service: `https://ananthcci.azurewebsites.net`
- TA Service: `https://ccita.azurewebsites.net`
- User Management: `https://ccium.azurewebsites.net`
- Messaging Service: `https://ccims.azurewebsites.net`

## Environment Variables (Optional Override)

You can override the default URLs by creating `.env.development` or `.env.production` files:

### .env.development
```env
VITE_ENV=development
VITE_HOSPITAL_SERVICE_URL=https://localhost:64685
VITE_TA_SERVICE_URL=https://localhost:64686
VITE_USER_MANAGEMENT_URL=https://localhost:64687
VITE_MESSAGING_SERVICE_URL=https://localhost:64688
```

### .env.production
```env
VITE_ENV=production
VITE_HOSPITAL_SERVICE_URL=https://ananthcci.azurewebsites.net
VITE_TA_SERVICE_URL=https://ccita.azurewebsites.net
VITE_USER_MANAGEMENT_URL=https://ccium.azurewebsites.net
VITE_MESSAGING_SERVICE_URL=https://ccims.azurewebsites.net
```

## Testing Production URLs Locally

To test production URLs in development mode, create a `.env.development.local` file:

```env
VITE_HOSPITAL_SERVICE_URL=https://ananthcci.azurewebsites.net
VITE_TA_SERVICE_URL=https://ccita.azurewebsites.net
VITE_USER_MANAGEMENT_URL=https://ccium.azurewebsites.net
VITE_MESSAGING_SERVICE_URL=https://ccims.azurewebsites.net
```

## Deployment

When deploying to production:
1. Run `npm run build` - automatically uses production URLs
2. No additional configuration needed
3. URLs will automatically point to Azure services

## Debugging

In development mode, the console will display the current API configuration:
```
🌐 API Configuration: {
  environment: 'Development',
  hospitalService: 'https://localhost:64685',
  taService: 'https://localhost:64686',
  userManagement: 'https://localhost:64687',
  messagingService: 'https://localhost:64688'
}
```

