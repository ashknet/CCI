import axios from './axios'

export interface RegisterData {
  email: string
  password: string
  firstName: string
  lastName: string
  phoneNumber?: string
  dateOfBirth?: string
  gender?: string
}

export interface LoginData {
  email: string
  password: string
}

export interface AuthResponse {
  success: boolean
  message: string
  data: {
    accessToken: string
    refreshToken: string
    expiresAt: string
    user: {
      userId: string
      email: string
      firstName: string
      lastName: string
      roles: string[]
    }
  }
}

export const authApi = {
  register: async (data: RegisterData): Promise<AuthResponse> => {
    const response = await axios.post('/auth/register', data)
    return response.data
  },

  login: async (data: LoginData): Promise<AuthResponse> => {
    const response = await axios.post('/auth/login', data)
    return response.data
  },

  logout: async (): Promise<void> => {
    await axios.post('/auth/logout')
  },

  refreshToken: async (refreshToken: string): Promise<AuthResponse> => {
    const response = await axios.post('/auth/refresh-token', { refreshToken })
    return response.data
  },

  changePassword: async (currentPassword: string, newPassword: string): Promise<void> => {
    await axios.post('/auth/change-password', { currentPassword, newPassword })
  },

  forgotPassword: async (email: string): Promise<void> => {
    await axios.post('/auth/forgot-password', { email })
  },

  resetPassword: async (token: string, email: string, newPassword: string): Promise<void> => {
    await axios.post('/auth/reset-password', { token, email, newPassword })
  },
}
