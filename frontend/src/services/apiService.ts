import { 
  hospitalServiceClient,
  taServiceClient, 
  userManagementClient, 
  messagingServiceClient,
  API_ENDPOINTS 
} from '../config/api';

/**
 * Service utility to help determine which API client to use for different operations
 */
export class ApiService {
  // Hospital Service operations (search, hospitals, doctors)
  static get hospitalService() {
    return {
      client: hospitalServiceClient,
      endpoints: {
        hospitals: API_ENDPOINTS.HOSPITALS,
        doctors: API_ENDPOINTS.DOCTORS,
        search: API_ENDPOINTS.SEARCH,
      }
    };
  }

  // TA Service operations (appointments, selection flow)
  static get taService() {
    return {
      client: taServiceClient,
      endpoints: {
        appointments: API_ENDPOINTS.APPOINTMENTS,
        selection: API_ENDPOINTS.SELECTION,
      }
    };
  }

  // User Management Service operations (authentication, user profiles)
  static get userManagement() {
    return {
      client: userManagementClient,
      endpoints: {
        auth: API_ENDPOINTS.AUTH,
      }
    };
  }

  // Messaging Service operations (messages, threads)
  static get messaging() {
    return {
      client: messagingServiceClient,
      endpoints: {
        messaging: API_ENDPOINTS.MESSAGING,
      }
    };
  }

  // Helper methods for common operations
  static async healthCheck() {
    const results = {
      hospitalService: { status: 'unknown', error: null },
      taService: { status: 'unknown', error: null },
      userManagement: { status: 'unknown', error: null },
      messaging: { status: 'unknown', error: null },
    };

    // Check Hospital Service
    try {
      await hospitalServiceClient.get('/health');
      results.hospitalService.status = 'healthy';
    } catch (error: any) {
      results.hospitalService.status = 'unhealthy';
      results.hospitalService.error = error.message;
    }

    // Check TA Service
    try {
      await taServiceClient.get('/health');
      results.taService.status = 'healthy';
    } catch (error: any) {
      results.taService.status = 'unhealthy';
      results.taService.error = error.message;
    }

    // Check User Management Service
    try {
      await userManagementClient.get('/health');
      results.userManagement.status = 'healthy';
    } catch (error: any) {
      results.userManagement.status = 'unhealthy';
      results.userManagement.error = error.message;
    }

    // Check Messaging Service
    try {
      await messagingServiceClient.get('/health');
      results.messaging.status = 'healthy';
    } catch (error: any) {
      results.messaging.status = 'unhealthy';
      results.messaging.error = error.message;
    }

    return results;
  }

  // Get the appropriate client for a given endpoint
  static getClientForEndpoint(endpoint: string) {
    if (endpoint.startsWith('/auth/') || endpoint.includes('user') || endpoint.includes('profile')) {
      return userManagementClient;
    }
    
    if (endpoint.startsWith('/message') || endpoint.includes('thread')) {
      return messagingServiceClient;
    }
    
    if (endpoint.startsWith('/search') || endpoint.startsWith('/Hospitals') || endpoint.startsWith('/Doctors')) {
      return hospitalServiceClient;
    }
    
    // Default to TA Service for appointments, selection flow, etc.
    return taServiceClient;
  }
}

export default ApiService;
