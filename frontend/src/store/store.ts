import { configureStore } from '@reduxjs/toolkit'
import authReducer from './slices/authSlice'
import searchReducer from './slices/searchSlice'
import appointmentReducer from './slices/appointmentSlice'
import bookingReducer from './slices/bookingSlice'
import wizardReducer from './slices/wizardSlice'

export const store = configureStore({
  reducer: {
    auth: authReducer,
    search: searchReducer,
    appointment: appointmentReducer,
    booking: bookingReducer,
    wizard: wizardReducer,
  },
})

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
