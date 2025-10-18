import { taServiceClient, API_ENDPOINTS } from '../config/api';

export interface DoctorSelection {
  doctor: any;
  availability: any;
  recentReviews: any[];
}

export interface HospitalSelection {
  hospital: any;
  doctors: any;
  availableSpecialties: any[];
}

export interface CitySelection {
  city: any;
  hospitals: any;
  availableSpecialties: any[];
  totalDoctors: number;
}

export interface DiseaseSelection {
  disease: any;
  doctors: any;
  relatedSpecialties: any[];
  topHospitals: any[];
}

export interface SelectionRequest {
  page?: number;
  pageSize?: number;
  sortBy?: string;
  specialty?: string;
  cityId?: string;
  includeAvailability?: boolean;
  startDate?: string;
  endDate?: string;
  includeReviews?: boolean;
  reviewLimit?: number;
  maxDistance?: number;
}

class SelectionFlowService {
  // Doctor Selection Flow
  async getDoctorSelection(doctorId: string, request: SelectionRequest = {}): Promise<DoctorSelection> {
    const params = new URLSearchParams();
    if (request.startDate) params.append('startDate', request.startDate);
    if (request.endDate) params.append('endDate', request.endDate);
    if (request.includeReviews !== undefined) params.append('includeReviews', request.includeReviews.toString());
    if (request.reviewLimit) params.append('reviewLimit', request.reviewLimit.toString());

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.DOCTOR}/${doctorId}?${params}`);
    return response.data.data;
  }

  async getDoctorAvailability(doctorId: string, startDate?: string, endDate?: string): Promise<any> {
    const params = new URLSearchParams();
    if (startDate) params.append('startDate', startDate);
    if (endDate) params.append('endDate', endDate);

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.DOCTOR}/${doctorId}/availability?${params}`);
    return response.data.data;
  }

  // Hospital Selection Flow
  async getHospitalSelection(hospitalId: string, request: SelectionRequest = {}): Promise<HospitalSelection> {
    const params = new URLSearchParams();
    if (request.specialty) params.append('specialty', request.specialty);
    if (request.page) params.append('page', request.page.toString());
    if (request.pageSize) params.append('pageSize', request.pageSize.toString());
    if (request.sortBy) params.append('sortBy', request.sortBy);
    if (request.includeAvailability !== undefined) params.append('includeAvailability', request.includeAvailability.toString());

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.HOSPITAL}/${hospitalId}?${params}`);
    return response.data.data;
  }

  async getHospitalDoctors(hospitalId: string, request: SelectionRequest = {}): Promise<any> {
    const params = new URLSearchParams();
    if (request.specialty) params.append('specialty', request.specialty);
    if (request.page) params.append('page', request.page.toString());
    if (request.pageSize) params.append('pageSize', request.pageSize.toString());
    if (request.sortBy) params.append('sortBy', request.sortBy);
    if (request.includeAvailability !== undefined) params.append('includeAvailability', request.includeAvailability.toString());

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.HOSPITAL}/${hospitalId}/doctors?${params}`);
    return response.data.data;
  }

  // City Selection Flow
  async getCitySelection(cityId: string, request: SelectionRequest = {}): Promise<CitySelection> {
    const params = new URLSearchParams();
    if (request.specialty) params.append('specialty', request.specialty);
    if (request.page) params.append('page', request.page.toString());
    if (request.pageSize) params.append('pageSize', request.pageSize.toString());
    if (request.sortBy) params.append('sortBy', request.sortBy);
    if (request.maxDistance) params.append('maxDistance', request.maxDistance.toString());

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.CITY}/${cityId}?${params}`);
    return response.data.data;
  }

  async getCityHospitals(cityId: string, request: SelectionRequest = {}): Promise<any> {
    const params = new URLSearchParams();
    if (request.specialty) params.append('specialty', request.specialty);
    if (request.page) params.append('page', request.page.toString());
    if (request.pageSize) params.append('pageSize', request.pageSize.toString());
    if (request.sortBy) params.append('sortBy', request.sortBy);
    if (request.maxDistance) params.append('maxDistance', request.maxDistance.toString());

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.CITY}/${cityId}/hospitals?${params}`);
    return response.data.data;
  }

  // Disease Selection Flow
  async getDiseaseSelection(diseaseId: string, request: SelectionRequest = {}): Promise<DiseaseSelection> {
    const params = new URLSearchParams();
    if (request.cityId) params.append('cityId', request.cityId);
    if (request.specialty) params.append('specialty', request.specialty);
    if (request.page) params.append('page', request.page.toString());
    if (request.pageSize) params.append('pageSize', request.pageSize.toString());
    if (request.sortBy) params.append('sortBy', request.sortBy);
    if (request.includeAvailability !== undefined) params.append('includeAvailability', request.includeAvailability.toString());

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.DISEASE}/${diseaseId}?${params}`);
    return response.data.data;
  }

  async getDiseaseDoctors(diseaseId: string, request: SelectionRequest = {}): Promise<any> {
    const params = new URLSearchParams();
    if (request.cityId) params.append('cityId', request.cityId);
    if (request.specialty) params.append('specialty', request.specialty);
    if (request.page) params.append('page', request.page.toString());
    if (request.pageSize) params.append('pageSize', request.pageSize.toString());
    if (request.sortBy) params.append('sortBy', request.sortBy);
    if (request.includeAvailability !== undefined) params.append('includeAvailability', request.includeAvailability.toString());

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.DISEASE}/${diseaseId}/doctors?${params}`);
    return response.data.data;
  }

  // Common helper methods
  async getAvailableSpecialties(cityId?: string, hospitalId?: string): Promise<any[]> {
    const params = new URLSearchParams();
    if (cityId) params.append('cityId', cityId);
    if (hospitalId) params.append('hospitalId', hospitalId);

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.SPECIALTIES}?${params}`);
    return response.data.data;
  }

  async checkDoctorAvailability(doctorId: string, date: string, time: string): Promise<boolean> {
    const params = new URLSearchParams();
    params.append('date', date);
    params.append('time', time);

    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.DOCTOR}/${doctorId}/check-availability?${params}`);
    return response.data.data;
  }

  async getNextAvailableSlot(doctorId: string): Promise<string | null> {
    const response = await taServiceClient.get(`${API_ENDPOINTS.SELECTION.DOCTOR}/${doctorId}/next-available`);
    return response.data.data;
  }
}

export const selectionFlowService = new SelectionFlowService();
