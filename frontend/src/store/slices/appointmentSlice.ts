import { createSlice, createAsyncThunk } from '@reduxjs/toolkit'
import axios from 'axios'

interface AppointmentState {
  appointments: any[]
  selectedSlot: { date: string; time: string } | null
  loading: boolean
  error: string | null
}

const initialState: AppointmentState = {
  appointments: [],
  selectedSlot: null,
  loading: false,
  error: null,
}

export const bookAppointment = createAsyncThunk(
  'appointment/book',
  async (appointmentData: any) => {
    const response = await axios.post('/api/appointments', appointmentData)
    return response.data.data
  }
)

export const fetchMyAppointments = createAsyncThunk(
  'appointment/fetchMy',
  async () => {
    const response = await axios.get('/api/appointments/my-appointments')
    return response.data.data.items
  }
)

const appointmentSlice = createSlice({
  name: 'appointment',
  initialState,
  reducers: {
    setSelectedSlot: (state, action) => {
      state.selectedSlot = action.payload
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(bookAppointment.pending, (state) => {
        state.loading = true
        state.error = null
      })
      .addCase(bookAppointment.fulfilled, (state) => {
        state.loading = false
      })
      .addCase(bookAppointment.rejected, (state, action) => {
        state.loading = false
        state.error = action.error.message || 'Booking failed'
      })
      .addCase(fetchMyAppointments.fulfilled, (state, action) => {
        state.appointments = action.payload
      })
  },
})

export const { setSelectedSlot } = appointmentSlice.actions
export default appointmentSlice.reducer
