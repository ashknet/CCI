import { configureStore } from '@reduxjs/toolkit'
import authReducer from './slices/authSlice'
import searchReducer from './slices/searchSlice'
import appointmentReducer from './slices/appointmentSlice'
import bookingReducer from './slices/bookingSlice'

export const store = configureStore({
  reducer: {
    auth: authReducer,
    search: searchReducer,
    appointment: appointmentReducer,
    booking: bookingReducer,
  },
})

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
