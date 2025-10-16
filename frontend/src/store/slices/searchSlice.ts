import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit'
import axios from 'axios'

interface SearchResult {
  id: string
  name: string
  type: 'hospital' | 'doctor' | 'location'
  city?: string
  rating?: number
  specialties?: string[]
}

interface SearchState {
  query: string
  suggestions: Array<{ text: string; category: string; id?: string }>
  results: SearchResult[]
  loading: boolean
  error: string | null
}

const initialState: SearchState = {
  query: '',
  suggestions: [],
  results: [],
  loading: false,
  error: null,
}

export const fetchSuggestions = createAsyncThunk(
  'search/fetchSuggestions',
  async (query: string) => {
    const response = await axios.get(`/api/search/suggestions?query=${query}`)
    return response.data.data
  }
)

export const performSearch = createAsyncThunk(
  'search/performSearch',
  async (searchParams: { query: string; category?: string }) => {
    const response = await axios.post('/api/search/hospitals', searchParams)
    return response.data.data.items
  }
)

const searchSlice = createSlice({
  name: 'search',
  initialState,
  reducers: {
    setQuery: (state, action: PayloadAction<string>) => {
      state.query = action.payload
    },
    clearResults: (state) => {
      state.results = []
      state.suggestions = []
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchSuggestions.fulfilled, (state, action) => {
        state.suggestions = action.payload
      })
      .addCase(performSearch.pending, (state) => {
        state.loading = true
        state.error = null
      })
      .addCase(performSearch.fulfilled, (state, action) => {
        state.loading = false
        state.results = action.payload
      })
      .addCase(performSearch.rejected, (state, action) => {
        state.loading = false
        state.error = action.error.message || 'Search failed'
      })
  },
})

export const { setQuery, clearResults } = searchSlice.actions
export default searchSlice.reducer
