import { useState, useEffect, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useDispatch, useSelector } from 'react-redux'
import { AppDispatch, RootState } from '../store/store'
import { setQuery, fetchSuggestions, performSearch } from '../store/slices/searchSlice'

const SearchBar = ({ large = false }: { large?: boolean }) => {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const dispatch = useDispatch<AppDispatch>()
  const { query, suggestions, loading } = useSelector((state: RootState) => state.search)
  const [showSuggestions, setShowSuggestions] = useState(false)
  const debounceTimerRef = useRef<NodeJS.Timeout | null>(null)

  useEffect(() => {
    // Debounce search for better performance (Google-like experience)
    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current)
    }

    if (query.length >= 2) { // Start searching from 2 characters
      debounceTimerRef.current = setTimeout(() => {
        dispatch(fetchSuggestions(query))
        setShowSuggestions(true)
      }, 150) // 150ms debounce - feels instant but reduces API calls
    } else {
      setShowSuggestions(false)
    }

    return () => {
      if (debounceTimerRef.current) {
        clearTimeout(debounceTimerRef.current)
      }
    }
  }, [query, dispatch])

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    if (query.trim()) {
      dispatch(performSearch({ query }))
      navigate('/search')
      setShowSuggestions(false)
    }
  }

  const handleSuggestionClick = (suggestion: any) => {
    dispatch(setQuery(suggestion.text))
    dispatch(performSearch({ query: suggestion.text, category: suggestion.category }))
    navigate('/search')
    setShowSuggestions(false)
  }

  return (
    <div className="relative w-full">
      <form onSubmit={handleSearch}>
        <div className={`relative ${large ? 'max-w-2xl mx-auto' : ''}`}>
          <input
            type="text"
            value={query}
            onChange={(e) => dispatch(setQuery(e.target.value))}
            placeholder={t('searchPlaceholder')}
            className={`w-full px-4 py-3 pr-12 bg-white text-gray-900 placeholder-gray-500 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 shadow-sm ${large ? 'py-4 text-lg' : ''}`}
            aria-label="Search"
            autoComplete="off"
          />
          <button
            type="submit"
            className="absolute right-2 top-1/2 -translate-y-1/2 px-3 py-1.5 bg-primary-600 text-white rounded-md hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-primary-500"
            aria-label="Submit search"
          >
            🔍
          </button>
          {loading && (
            <div className="absolute right-12 top-1/2 -translate-y-1/2">
              <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-primary-600"></div>
            </div>
          )}
        </div>
      </form>

      {showSuggestions && suggestions.length > 0 && (
        <div className="absolute z-50 w-full mt-2 bg-white rounded-lg shadow-xl border border-gray-200 max-h-96 overflow-y-auto">
          {suggestions.map((suggestion, index) => (
            <button
              key={index}
              onClick={() => handleSuggestionClick(suggestion)}
              className="w-full px-4 py-3 text-left hover:bg-blue-50 flex items-center justify-between border-b border-gray-100 last:border-b-0 transition-colors"
            >
              <div className="flex items-center space-x-3">
                <span className="text-primary-600">
                  {suggestion.category === 'Hospital' && '🏥'}
                  {suggestion.category === 'Doctor' && '👨‍⚕️'}
                  {suggestion.category === 'City' && '📍'}
                  {suggestion.category === 'Specialty' && '⚕️'}
                  {suggestion.category === 'Disease' && '🩺'}
                </span>
                <div>
                  <div className="text-gray-900 font-medium">{suggestion.text}</div>
                  <div className="text-xs text-gray-500">{suggestion.category}</div>
                </div>
              </div>
              <span className="text-xs text-gray-400">→</span>
            </button>
          ))}
        </div>
      )}

      {showSuggestions && !loading && suggestions.length === 0 && query.length >= 2 && (
        <div className="absolute z-50 w-full mt-2 bg-white rounded-lg shadow-xl border border-gray-200 px-4 py-3">
          <p className="text-gray-500 text-sm">No results found for "{query}"</p>
        </div>
      )}
    </div>
  )
}

export default SearchBar
