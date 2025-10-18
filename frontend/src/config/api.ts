import axios from 'axios';

// API Configuration
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'https://ananthcci.azurewebsites.net/api/v1';

// Create axios instance with base configuration
export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('authToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor for error handling
apiClient.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized access
      localStorage.removeItem('authToken');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// API Endpoints
export const API_ENDPOINTS = {
  // Authentication (Note: These would be from UserManagementService)
  AUTH: {
    LOGIN: '/auth/login',
    REGISTER: '/auth/register',
    PROFILE: '/auth/profile',
    REFRESH: '/auth/refresh',
  },
  
  // Hospital Service - Actual endpoints from Swagger
  HOSPITALS: {
    GET_BY_ID: '/Hospitals',
    GET_REVIEWS: '/Hospitals',
    GET_DEPARTMENTS: '/Hospitals',
    GET_ACCREDITATIONS: '/Hospitals',
  },
  
  DOCTORS: {
    GET_BY_ID: '/Doctors',
    GET_BY_HOSPITAL: '/Doctors/hospital',
    GET_BY_SPECIALTY: '/Doctors/specialty',
    GET_REVIEWS: '/Doctors',
  },
  
  APPOINTMENTS: {
    CREATE: '/Appointments',
    GET_MY: '/Appointments/my-appointments',
    GET_AVAILABLE_SLOTS: '/Appointments/doctor',
    CANCEL: '/Appointments',
  },
  
  SEARCH: {
    SUGGESTIONS: '/search/suggest',
    HOSPITALS: '/search/hospitals',
    DOCTORS: '/search/doctors',
  },
  
  // Selection Flow APIs
  SELECTION: {
    DOCTOR: '/selection/doctors',
    HOSPITAL: '/selection/hospitals',
    CITY: '/selection/cities',
    DISEASE: '/selection/diseases',
    SPECIALTIES: '/selection/specialties',
  },
  
  // Health Check (note: health endpoint is not under /api/v1)
  HEALTH: 'https://ananthcci.azurewebsites.net/health',
} as const;

// Helper function to build URLs
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

export default apiClient;
