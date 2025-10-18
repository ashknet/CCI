import axios from 'axios';

// Determine if we're in production or development
const isProduction = import.meta.env.PROD || import.meta.env.VITE_ENV === 'production';

// Service URLs - automatically switch between local and production
const HOSPITAL_SERVICE_URL = isProduction 
  ? (import.meta.env.VITE_HOSPITAL_SERVICE_URL || 'https://ananthcci.azurewebsites.net')
  : (import.meta.env.VITE_HOSPITAL_SERVICE_URL || 'https://localhost:64685');

const TASERVICE_URL = isProduction
  ? (import.meta.env.VITE_TA_SERVICE_URL || 'https://ccita.azurewebsites.net')
  : (import.meta.env.VITE_TA_SERVICE_URL || 'https://localhost:64686');

const USER_MANAGEMENT_URL = isProduction
  ? (import.meta.env.VITE_USER_MANAGEMENT_URL || 'https://ccium.azurewebsites.net')
  : (import.meta.env.VITE_USER_MANAGEMENT_URL || 'https://localhost:64687');

const MESSAGING_SERVICE_URL = isProduction
  ? (import.meta.env.VITE_MESSAGING_SERVICE_URL || 'https://ccims.azurewebsites.net')
  : (import.meta.env.VITE_MESSAGING_SERVICE_URL || 'https://localhost:64688');

// Default API Configuration (for backward compatibility)
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || HOSPITAL_SERVICE_URL;

// Log current environment and URLs (only in development)
if (!isProduction) {
  console.log('🌐 API Configuration:', {
    environment: isProduction ? 'Production' : 'Development',
    hospitalService: HOSPITAL_SERVICE_URL,
    taService: TASERVICE_URL,
    userManagement: USER_MANAGEMENT_URL,
    messagingService: MESSAGING_SERVICE_URL
  });
}

// Create axios instances for each service
export const hospitalServiceClient = axios.create({
  baseURL: HOSPITAL_SERVICE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const taServiceClient = axios.create({
  baseURL: TASERVICE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const userManagementClient = axios.create({
  baseURL: USER_MANAGEMENT_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const messagingServiceClient = axios.create({
  baseURL: MESSAGING_SERVICE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Default client (for backward compatibility)
export const apiClient = hospitalServiceClient;

// Helper function to add interceptors to a client
const addInterceptors = (client: any) => {
  // Request interceptor to add auth token
  client.interceptors.request.use(
    (config: any) => {
      const token = localStorage.getItem('authToken');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error: any) => {
      return Promise.reject(error);
    }
  );

  // Response interceptor for error handling
  client.interceptors.response.use(
    (response: any) => {
      return response;
    },
    (error: any) => {
      if (error.response?.status === 401) {
        // Handle unauthorized access
        localStorage.removeItem('authToken');
        window.location.href = '/login';
      }
      return Promise.reject(error);
    }
  );
};

// Add interceptors to all clients
addInterceptors(hospitalServiceClient);
addInterceptors(taServiceClient);
addInterceptors(userManagementClient);
addInterceptors(messagingServiceClient);
addInterceptors(apiClient);

// API Endpoints organized by service (with /api/v1 prefix)
export const API_ENDPOINTS = {
  // User Management Service (https://localhost:64687)
  AUTH: {
    LOGIN: '/api/v1/auth/login',
    REGISTER: '/api/v1/auth/register',
    PROFILE: '/api/v1/auth/profile',
    REFRESH: '/api/v1/auth/refresh',
    LOGOUT: '/api/v1/auth/logout',
  },
  
  // Hospital Service (https://localhost:64685) - Search, Hospitals, Doctors
  HOSPITALS: {
    GET_BY_ID: '/api/v1/Hospitals',
    GET_REVIEWS: '/api/v1/Hospitals',
    GET_DEPARTMENTS: '/api/v1/Hospitals',
    GET_ACCREDITATIONS: '/api/v1/Hospitals',
  },
  
  DOCTORS: {
    GET_BY_ID: '/api/v1/Doctors',
    GET_BY_HOSPITAL: '/api/v1/Doctors/hospital',
    GET_BY_SPECIALTY: '/api/v1/Doctors/specialty',
    GET_REVIEWS: '/api/v1/Doctors',
  },
  
  SEARCH: {
    SUGGESTIONS: '/api/v1/search/suggest',
    HOSPITALS: '/api/v1/search/hospitals',
    DOCTORS: '/api/v1/search/doctors',
  },
  
  // TA Service (https://localhost:64686) - Appointments, Selection Flow
  APPOINTMENTS: {
    CREATE: '/api/v1/Appointments',
    GET_MY: '/api/v1/Appointments/my-appointments',
    GET_AVAILABLE_SLOTS: '/api/v1/Appointments/doctor',
    CANCEL: '/api/v1/Appointments',
  },
  
  SELECTION: {
    DOCTOR: '/api/v1/selection/doctors',
    HOSPITAL: '/api/v1/selection/hospitals',
    CITY: '/api/v1/selection/cities',
    DISEASE: '/api/v1/selection/diseases',
    SPECIALTIES: '/api/v1/selection/specialties',
  },
  
  // Messaging Service (https://localhost:64688)
  MESSAGING: {
    THREADS: '/api/v1/message-threads',
    MESSAGES: '/api/v1/messages',
    SEND_MESSAGE: '/api/v1/messages',
    GET_THREAD: '/api/v1/message-threads',
  },
  
  // Health Check endpoints for each service (no version for health checks)
  HEALTH: {
    HOSPITAL_SERVICE: `${HOSPITAL_SERVICE_URL}/health`,
    TA_SERVICE: `${TASERVICE_URL}/health`,
    USER_MANAGEMENT: `${USER_MANAGEMENT_URL}/health`,
    MESSAGING: `${MESSAGING_SERVICE_URL}/health`,
  },
} as const;

// Helper functions to build URLs for different services
export const buildApiUrl = (endpoint: string, params?: Record<string, string | number>): string => {
  let url = `${API_BASE_URL}${endpoint}`;
  
  if (params) {
    const searchParams = new URLSearchParams();
    Object.entries(params).forEach(([key, value]) => {
      searchParams.append(key, value.toString());
    });
    url += `?${searchParams.toString()}`;
  }
  
  return url;
};

export const buildHospitalServiceUrl = (endpoint: string, params?: Record<string, string | number>): string => {
  let url = `${HOSPITAL_SERVICE_URL}${endpoint}`;
  
  if (params) {
    const searchParams = new URLSearchParams();
    Object.entries(params).forEach(([key, value]) => {
      searchParams.append(key, value.toString());
    });
    url += `?${searchParams.toString()}`;
  }
  
  return url;
};

export const buildTaServiceUrl = (endpoint: string, params?: Record<string, string | number>): string => {
  let url = `${TASERVICE_URL}${endpoint}`;
  
  if (params) {
    const searchParams = new URLSearchParams();
    Object.entries(params).forEach(([key, value]) => {
      searchParams.append(key, value.toString());
    });
    url += `?${searchParams.toString()}`;
  }
  
  return url;
};

export const buildUserManagementUrl = (endpoint: string, params?: Record<string, string | number>): string => {
  let url = `${USER_MANAGEMENT_URL}${endpoint}`;
  
  if (params) {
    const searchParams = new URLSearchParams();
    Object.entries(params).forEach(([key, value]) => {
      searchParams.append(key, value.toString());
    });
    url += `?${searchParams.toString()}`;
  }
  
  return url;
};

export const buildMessagingUrl = (endpoint: string, params?: Record<string, string | number>): string => {
  let url = `${MESSAGING_SERVICE_URL}${endpoint}`;
  
  if (params) {
    const searchParams = new URLSearchParams();
    Object.entries(params).forEach(([key, value]) => {
      searchParams.append(key, value.toString());
    });
    url += `?${searchParams.toString()}`;
  }
  
  return url;
};

// Export service URLs for reference
export const SERVICE_URLS = {
  HOSPITAL_SERVICE: HOSPITAL_SERVICE_URL,
  TA_SERVICE: TASERVICE_URL,
  USER_MANAGEMENT: USER_MANAGEMENT_URL,
  MESSAGING: MESSAGING_SERVICE_URL,
} as const;

export default apiClient;
