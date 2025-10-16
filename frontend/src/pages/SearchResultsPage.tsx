import { useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { RootState } from '../store/store'
import SearchBar from '../components/SearchBar'

const SearchResultsPage = () => {
  const { results, loading } = useSelector((state: RootState) => state.search)

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="mb-8">
        <SearchBar />
      </div>

      {loading ? (
        <div className="text-center py-12">Loading...</div>
      ) : (
        <div className="space-y-4">
          <h2 className="text-2xl font-bold mb-4">Search Results ({results.length})</h2>
          {results.map((result) => (
            <div key={result.id} className="card hover:shadow-md transition-shadow">
              <div className="flex items-start justify-between">
                <div className="flex-1">
                  <h3 className="text-xl font-semibold mb-2">{result.name}</h3>
                  <p className="text-gray-600 mb-2">{result.city}</p>
                  {result.specialties && (
                    <div className="flex flex-wrap gap-2 mb-2">
                      {result.specialties.map((specialty, i) => (
                        <span key={i} className="bg-primary-100 text-primary-700 px-2 py-1 rounded text-sm">
                          {specialty}
                        </span>
                      ))}
                    </div>
                  )}
                  {result.rating && (
                    <div className="flex items-center">
                      <span className="text-yellow-500">⭐</span>
                      <span className="ml-1 font-medium">{result.rating}</span>
                    </div>
                  )}
                </div>
                <Link
                  to={result.type === 'doctor' ? `/doctor/${result.id}` : `/hospital/${result.id}`}
                  className="btn-primary"
                >
                  View Details
                </Link>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

export default SearchResultsPage
