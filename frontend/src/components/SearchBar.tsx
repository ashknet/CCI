import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useDispatch, useSelector } from 'react-redux'
import { AppDispatch, RootState } from '../store/store'
import { setQuery, fetchSuggestions, performSearch } from '../store/slices/searchSlice'

const SearchBar = ({ large = false }: { large?: boolean }) => {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const dispatch = useDispatch<AppDispatch>()
  const { query, suggestions } = useSelector((state: RootState) => state.search)
  const [showSuggestions, setShowSuggestions] = useState(false)

  useEffect(() => {
    if (query.length >= 3) {
      dispatch(fetchSuggestions(query))
      setShowSuggestions(true)
    } else {
      setShowSuggestions(false)
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
            className={`input-field ${large ? 'py-4 text-lg' : ''} pr-12`}
            aria-label="Search"
          />
          <button
            type="submit"
            className="absolute right-2 top-1/2 -translate-y-1/2 btn-primary"
            aria-label="Submit search"
          >
            🔍
          </button>
        </div>
      </form>

      {showSuggestions && suggestions.length > 0 && (
        <div className="absolute z-10 w-full mt-2 bg-white rounded-lg shadow-lg border border-gray-200 max-h-96 overflow-y-auto">
          {suggestions.map((suggestion, index) => (
            <button
              key={index}
              onClick={() => handleSuggestionClick(suggestion)}
              className="w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center justify-between border-b border-gray-100 last:border-b-0"
            >
              <span className="text-gray-900">{suggestion.text}</span>
              <span className="text-xs text-gray-500 bg-gray-100 px-2 py-1 rounded">
                {suggestion.category}
              </span>
            </button>
          ))}
        </div>
      )}
    </div>
  )
}

export default SearchBar
