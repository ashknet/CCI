import React, { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { RootState } from '../../store/store'
import { setSearchData } from '../../store/slices/wizardSlice'
import { fetchSuggestions } from '../../store/slices/searchSlice'
import { 
  MagnifyingGlassIcon,
  UserIcon,
  BuildingOfficeIcon,
  MapPinIcon,
  HeartIcon,
  StarIcon,
  ChevronRightIcon
} from '@heroicons/react/24/outline'

const SearchStep: React.FC = () => {
  const dispatch = useDispatch()
  const { searchData } = useSelector((state: RootState) => state.wizard)
  const { suggestions, loading, query: globalQuery, results } = useSelector((state: RootState) => state.search)
  
  const [searchQuery, setSearchQuery] = useState(searchData.query || globalQuery)

  // Debounced search
  useEffect(() => {
    const timer = setTimeout(() => {
      if (searchQuery.length >= 2) {
        dispatch(fetchSuggestions(searchQuery) as any)
      }
    }, 300)

    return () => clearTimeout(timer)
  }, [searchQuery, dispatch])

  const handleSuggestionClick = (suggestion: any) => {
    dispatch(setSearchData({
      query: searchQuery,
      selectedItem: suggestion,
      searchResults: [suggestion]
    }))
  }

  const getCategoryIcon = (category: string) => {
    switch (category.toLowerCase()) {
      case 'doctor':
        return <UserIcon className="w-5 h-5" />
      case 'hospital':
        return <BuildingOfficeIcon className="w-5 h-5" />
      case 'city':
        return <MapPinIcon className="w-5 h-5" />
      case 'disease':
        return <HeartIcon className="w-5 h-5" />
      case 'specialty':
        return <StarIcon className="w-5 h-5" />
      default:
        return <StarIcon className="w-5 h-5" />
    }
  }

  const getCategoryColor = (category: string) => {
    switch (category.toLowerCase()) {
      case 'doctor':
        return 'text-blue-600 bg-blue-100'
      case 'hospital':
        return 'text-green-600 bg-green-100'
      case 'city':
        return 'text-purple-600 bg-purple-100'
      case 'disease':
        return 'text-red-600 bg-red-100'
      case 'specialty':
        return 'text-yellow-600 bg-yellow-100'
      default:
        return 'text-gray-600 bg-gray-100'
    }
  }

  return (
    <div className="space-y-6">
      <div className="text-center">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          What are you looking for?
        </h2>
        <p className="text-gray-600">
          Search for hospitals, doctors, cities, or medical conditions
        </p>
      </div>

      {/* Search Input */}
      <div className="relative max-w-2xl mx-auto">
        <div className="relative">
          <MagnifyingGlassIcon className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search for hospitals, doctors, cities, or diseases..."
            className="w-full pl-10 pr-4 py-3 bg-white text-gray-900 placeholder-gray-500 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 shadow-sm"
          />
          {loading && (
            <div className="absolute right-3 top-1/2 transform -translate-y-1/2">
              <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-primary-500"></div>
            </div>
          )}
        </div>

        {/* Search Results */}
        {suggestions.length > 0 && (
          <div className="absolute z-10 w-full mt-2 bg-white border border-gray-200 rounded-lg shadow-lg max-h-96 overflow-y-auto">
            {suggestions.map((suggestion: any, index: number) => (
              <button
                key={index}
                onClick={() => handleSuggestionClick(suggestion)}
                className="w-full px-4 py-3 text-left hover:bg-gray-50 border-b border-gray-100 last:border-b-0 flex items-center space-x-3"
              >
                <div className={`flex-shrink-0 p-2 rounded-full ${getCategoryColor(suggestion.category)}`}>
                  {getCategoryIcon(suggestion.category)}
                </div>
                <div className="flex-1">
                  <div className="font-medium text-gray-900">{suggestion.text}</div>
                  <div className="text-sm text-gray-500 capitalize">{suggestion.category}</div>
                </div>
                <ChevronRightIcon className="w-5 h-5 text-gray-400" />
              </button>
            ))}
          </div>
        )}

        {searchQuery.length >= 2 && suggestions.length === 0 && !loading && (
          <div className="absolute z-10 w-full mt-2 bg-white border border-gray-200 rounded-lg shadow-lg p-8 text-center">
            <StarIcon className="w-12 h-12 mx-auto mb-4 text-gray-300" />
            <p className="text-gray-500">No results found for "{searchQuery}"</p>
            <p className="text-sm text-gray-400">Try searching for hospitals, doctors, cities, or diseases</p>
          </div>
        )}
      </div>

      {/* Search Results from Full Search */}
      {results.length > 0 && !searchData.selectedItem && (
        <div className="max-w-4xl mx-auto">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">
            Search Results ({results.length})
          </h3>
          <div className="grid gap-4">
            {results.map((result: any, index: number) => (
              <button
                key={index}
                onClick={() => handleSuggestionClick({
                  text: result.name,
                  category: result.type || 'Hospital',
                  data: result
                })}
                className="bg-white border border-gray-200 rounded-lg p-4 hover:border-primary-500 hover:shadow-md transition-all text-left"
              >
                <div className="flex items-start space-x-4">
                  <div className={`flex-shrink-0 p-3 rounded-full ${getCategoryColor(result.type || 'Hospital')}`}>
                    {getCategoryIcon(result.type || 'Hospital')}
                  </div>
                  <div className="flex-1">
                    <h4 className="font-semibold text-gray-900 text-lg">{result.name}</h4>
                    {result.city && (
                      <p className="text-sm text-gray-600 mt-1">
                        <MapPinIcon className="w-4 h-4 inline mr-1" />
                        {result.city}
                      </p>
                    )}
                    {result.specialties && result.specialties.length > 0 && (
                      <div className="flex flex-wrap gap-2 mt-2">
                        {result.specialties.slice(0, 3).map((specialty: string, i: number) => (
                          <span key={i} className="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded-full">
                            {specialty}
                          </span>
                        ))}
                      </div>
                    )}
                    {result.rating && (
                      <div className="flex items-center mt-2">
                        <StarIcon className="w-4 h-4 text-yellow-500 fill-yellow-500" />
                        <span className="ml-1 text-sm font-medium text-gray-700">{result.rating}</span>
                      </div>
                    )}
                  </div>
                  <ChevronRightIcon className="w-6 h-6 text-gray-400 flex-shrink-0" />
                </div>
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Selected Item Display */}
      {searchData.selectedItem && (
        <div className="max-w-2xl mx-auto">
          <div className="bg-primary-50 border border-primary-200 rounded-lg p-4">
            <div className="flex items-center space-x-3">
              <div className={`flex-shrink-0 p-2 rounded-full ${getCategoryColor(searchData.selectedItem.category)}`}>
                {getCategoryIcon(searchData.selectedItem.category)}
              </div>
              <div className="flex-1">
                <h3 className="font-semibold text-primary-900">{searchData.selectedItem.text}</h3>
                <p className="text-sm text-primary-700 capitalize">{searchData.selectedItem.category}</p>
              </div>
              <div className="flex-shrink-0">
                <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  Selected
                </span>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Search Tips */}
      <div className="max-w-2xl mx-auto">
        <div className="bg-gray-50 rounded-lg p-4">
          <h4 className="font-medium text-gray-900 mb-2">Search Tips:</h4>
          <ul className="text-sm text-gray-600 space-y-1">
            <li>• Search by doctor name, specialty, or hospital name</li>
            <li>• Try searching by city name to find hospitals in that area</li>
            <li>• Search by disease or medical condition to find specialists</li>
            <li>• Use specific terms for better results</li>
          </ul>
        </div>
      </div>
    </div>
  )
}

export default SearchStep
