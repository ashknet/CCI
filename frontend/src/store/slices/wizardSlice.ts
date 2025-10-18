import { createSlice, PayloadAction } from '@reduxjs/toolkit'

export interface WizardStep {
  id: string
  title: string
  completed: boolean
  data?: any
}

export interface WizardState {
  currentStep: number
  steps: WizardStep[]
  searchData: {
    query: string
    selectedItem: any
    searchResults: any[]
  }
  appointmentData: {
    doctor: any
    hospital: any
    selectedDate: string
    selectedTime: string
    reasonForVisit: string
    availableSlots: any[]
  }
  travelData: {
    type: 'flight' | 'train'
    from: string
    to: string
    departureDate: string
    returnDate: string
    passengers: number
    preference: string
    selectedOption: any
  }
  accommodationData: {
    city: string
    checkIn: string
    checkOut: string
    guests: number
    rooms: number
    selectedHotel: any
    selectedRoom: any
  }
  bookingSummary: {
    totalCost: number
    items: any[]
  }
  loading: boolean
  error: string | null
}

const initialState: WizardState = {
  currentStep: 0,
  steps: [
    { id: 'search', title: 'Search & Select', completed: false },
    { id: 'details', title: 'View Details', completed: false },
    { id: 'appointment', title: 'Book Appointment', completed: false },
    { id: 'travel', title: 'Travel Booking', completed: false },
    { id: 'accommodation', title: 'Hotel Booking', completed: false },
    { id: 'review', title: 'Review & Confirm', completed: false }
  ],
  searchData: {
    query: '',
    selectedItem: null,
    searchResults: []
  },
  appointmentData: {
    doctor: null,
    hospital: null,
    selectedDate: '',
    selectedTime: '',
    reasonForVisit: '',
    availableSlots: []
  },
  travelData: {
    type: 'flight',
    from: '',
    to: '',
    departureDate: '',
    returnDate: '',
    passengers: 1,
    preference: 'cheapest',
    selectedOption: null
  },
  accommodationData: {
    city: '',
    checkIn: '',
    checkOut: '',
    guests: 2,
    rooms: 1,
    selectedHotel: null,
    selectedRoom: null
  },
  bookingSummary: {
    totalCost: 0,
    items: []
  },
  loading: false,
  error: null
}

const wizardSlice = createSlice({
  name: 'wizard',
  initialState,
  reducers: {
    setCurrentStep: (state, action: PayloadAction<number>) => {
      state.currentStep = action.payload
    },
    nextStep: (state) => {
      if (state.currentStep < state.steps.length - 1) {
        state.currentStep += 1
      }
    },
    previousStep: (state) => {
      if (state.currentStep > 0) {
        state.currentStep -= 1
      }
    },
    goToStep: (state, action: PayloadAction<number>) => {
      if (action.payload >= 0 && action.payload < state.steps.length) {
        state.currentStep = action.payload
      }
    },
    completeStep: (state, action: PayloadAction<number>) => {
      if (action.payload >= 0 && action.payload < state.steps.length) {
        state.steps[action.payload].completed = true
      }
    },
    setSearchData: (state, action: PayloadAction<Partial<WizardState['searchData']>>) => {
      state.searchData = { ...state.searchData, ...action.payload }
    },
    setAppointmentData: (state, action: PayloadAction<Partial<WizardState['appointmentData']>>) => {
      state.appointmentData = { ...state.appointmentData, ...action.payload }
    },
    setTravelData: (state, action: PayloadAction<Partial<WizardState['travelData']>>) => {
      state.travelData = { ...state.travelData, ...action.payload }
    },
    setAccommodationData: (state, action: PayloadAction<Partial<WizardState['accommodationData']>>) => {
      state.accommodationData = { ...state.accommodationData, ...action.payload }
    },
    updateBookingSummary: (state) => {
      const items = []
      let totalCost = 0

      // Add appointment cost
      if (state.appointmentData.doctor?.consultationFee) {
        items.push({
          type: 'appointment',
          title: `Appointment with Dr. ${state.appointmentData.doctor.firstName} ${state.appointmentData.doctor.lastName}`,
          cost: state.appointmentData.doctor.consultationFee
        })
        totalCost += state.appointmentData.doctor.consultationFee
      }

      // Add travel cost
      if (state.travelData.selectedOption?.price) {
        items.push({
          type: 'travel',
          title: `${state.travelData.type} from ${state.travelData.from} to ${state.travelData.to}`,
          cost: state.travelData.selectedOption.price
        })
        totalCost += state.travelData.selectedOption.price
      }

      // Add accommodation cost
      if (state.accommodationData.selectedRoom?.price) {
        const nights = Math.ceil(
          (new Date(state.accommodationData.checkOut).getTime() - 
           new Date(state.accommodationData.checkIn).getTime()) / (1000 * 60 * 60 * 24)
        )
        const roomCost = state.accommodationData.selectedRoom.price * nights * state.accommodationData.rooms
        items.push({
          type: 'accommodation',
          title: `${state.accommodationData.selectedHotel?.name} - ${nights} nights`,
          cost: roomCost
        })
        totalCost += roomCost
      }

      state.bookingSummary = { items, totalCost }
    },
    setLoading: (state, action: PayloadAction<boolean>) => {
      state.loading = action.payload
    },
    setError: (state, action: PayloadAction<string | null>) => {
      state.error = action.payload
    },
    resetWizard: () => {
      return { ...initialState }
    }
  }
})

export const {
  setCurrentStep,
  nextStep,
  previousStep,
  goToStep,
  completeStep,
  setSearchData,
  setAppointmentData,
  setTravelData,
  setAccommodationData,
  updateBookingSummary,
  setLoading,
  setError,
  resetWizard
} = wizardSlice.actions

export default wizardSlice.reducer
