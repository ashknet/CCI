import { createSlice, PayloadAction } from '@reduxjs/toolkit'

interface BookingState {
  appointment: any | null
  transport: any | null
  accommodation: any | null
  totalCost: number
}

const initialState: BookingState = {
  appointment: null,
  transport: null,
  accommodation: null,
  totalCost: 0,
}

const bookingSlice = createSlice({
  name: 'booking',
  initialState,
  reducers: {
    setAppointment: (state, action: PayloadAction<any>) => {
      state.appointment = action.payload
      state.totalCost = (state.appointment?.fee || 0) + (state.transport?.price || 0) + (state.accommodation?.price || 0)
    },
    setTransport: (state, action: PayloadAction<any>) => {
      state.transport = action.payload
      state.totalCost = (state.appointment?.fee || 0) + (state.transport?.price || 0) + (state.accommodation?.price || 0)
    },
    setAccommodation: (state, action: PayloadAction<any>) => {
      state.accommodation = action.payload
      state.totalCost = (state.appointment?.fee || 0) + (state.transport?.price || 0) + (state.accommodation?.price || 0)
    },
    clearBooking: (state) => {
      state.appointment = null
      state.transport = null
      state.accommodation = null
      state.totalCost = 0
    },
  },
})

export const { setAppointment, setTransport, setAccommodation, clearBooking } = bookingSlice.actions
export default bookingSlice.reducer
