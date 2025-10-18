import { useState, useEffect } from 'react'
import { useParams, Link } from 'react-router-dom'
import { apiClient, API_ENDPOINTS } from '../config/api'

interface HospitalData {
  id: string
  name: string
  description: string
  address: string
  city: string
  state: string
  country: string
  latitude?: number
  longitude?: number
  phone: string
  email: string
  website: string
  bedCapacity?: number
  yearEstablished?: number
  averageRating: number
  totalReviews: number
  specialties: string[]
  accreditations: string[]
}

const HospitalProfilePage = () => {
  const { id } = useParams<{ id: string }>()
  const [hospital, setHospital] = useState<HospitalData | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [departments, setDepartments] = useState<any[]>([])
  const [reviews, setReviews] = useState<any[]>([])

  useEffect(() => {
    if (id) {
      fetchHospitalDetails()
    }
  }, [id])

  const fetchHospitalDetails = async () => {
    try {
      setLoading(true)
      setError(null)

      // Try the v1 endpoint first (more detailed)
      try {
        const response = await apiClient.get(`${API_ENDPOINTS.HOSPITALS.GET_BY_ID}/${id}`)
        const hospitalData = response.data.data || response.data
        
        setHospital({
          id: hospitalData.id,
          name: hospitalData.name,
          description: hospitalData.description,
          address: hospitalData.address,
          city: hospitalData.city,
          state: hospitalData.state,
          country: hospitalData.country,
          latitude: hospitalData.latitude,
          longitude: hospitalData.longitude,
          phone: hospitalData.phone,
          email: hospitalData.email,
          website: hospitalData.website,
          bedCapacity: hospitalData.bedCapacity,
          yearEstablished: hospitalData.yearEstablished,
          averageRating: hospitalData.averageRating,
          totalReviews: hospitalData.totalReviews,
          specialties: hospitalData.specialties || [],
          accreditations: hospitalData.accreditations || []
        })

        // Fetch additional data
        await Promise.all([
          fetchDepartments(),
          fetchReviews()
        ])
      } catch (v1Error) {
        console.warn('V1 endpoint failed, trying basic endpoint:', v1Error)
        
        // Fallback to basic endpoint
        const response = await apiClient.get(`/api/Hospitals/${id}`)
        const hospitalData = response.data.data || response.data
        
        setHospital({
          id: hospitalData.id,
          name: hospitalData.name,
          description: hospitalData.description,
          address: hospitalData.address,
          city: hospitalData.city,
          state: hospitalData.state,
          country: hospitalData.country,
          latitude: hospitalData.latitude,
          longitude: hospitalData.longitude,
          phone: hospitalData.phone,
          email: hospitalData.email,
          website: hospitalData.website,
          bedCapacity: hospitalData.bedCapacity,
          yearEstablished: hospitalData.yearEstablished,
          averageRating: hospitalData.averageRating,
          totalReviews: hospitalData.totalReviews,
          specialties: [],
          accreditations: []
        })

        // Fetch additional data
        await Promise.all([
          fetchDepartments(),
          fetchReviews()
        ])
      }
    } catch (error: any) {
      console.error('Failed to fetch hospital details:', error)
      setError(error.response?.data?.message || 'Failed to load hospital details')
    } finally {
      setLoading(false)
    }
  }

  const fetchDepartments = async () => {
    try {
      const response = await apiClient.get(`/api/Hospitals/${id}/departments`)
      const departmentsData = response.data.data || response.data
      setDepartments(Array.isArray(departmentsData) ? departmentsData : [])
    } catch (error) {
      console.error('Failed to fetch departments:', error)
    }
  }

  const fetchReviews = async () => {
    try {
      const response = await apiClient.get(`/api/Hospitals/${id}/reviews`)
      const reviewsData = response.data.data?.items || response.data.data || response.data
      setReviews(Array.isArray(reviewsData) ? reviewsData : [])
    } catch (error) {
      console.error('Failed to fetch reviews:', error)
    }
  }

  if (loading) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="text-center py-12">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading hospital details...</p>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="text-center py-12">
          <div className="text-red-500 text-6xl mb-4">⚠️</div>
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Error Loading Hospital</h2>
          <p className="text-gray-600 mb-4">{error}</p>
          <Link to="/search" className="btn-primary">
            Back to Search
          </Link>
        </div>
      </div>
    )
  }

  if (!hospital) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="text-center py-12">
          <div className="text-gray-400 text-6xl mb-4">🏥</div>
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Hospital Not Found</h2>
          <p className="text-gray-600 mb-4">The hospital you're looking for doesn't exist.</p>
          <Link to="/search" className="btn-primary">
            Back to Search
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="mb-8">
        <Link to="/search" className="text-primary-600 hover:text-primary-700 mb-4 inline-block">
          ← Back to Search
        </Link>
        
        <div className="card">
          <div className="flex items-start space-x-6">
            <div className="w-32 h-32 bg-gradient-to-br from-primary-100 to-primary-200 rounded-lg flex items-center justify-center flex-shrink-0">
              <span className="text-4xl">🏥</span>
            </div>
            <div className="flex-1">
              <h1 className="text-3xl font-bold mb-2">{hospital.name}</h1>
              <p className="text-gray-600 mb-2">{hospital.address}</p>
              <p className="text-gray-600 mb-4">{hospital.city}, {hospital.state}, {hospital.country}</p>
              
              <div className="flex items-center space-x-6 mb-4">
                <div className="flex items-center">
                  <span className="text-yellow-500">⭐</span>
                  <span className="ml-1 font-medium">{hospital.averageRating.toFixed(1)}</span>
                  <span className="text-gray-500 ml-1">({hospital.totalReviews} reviews)</span>
                </div>
                {hospital.bedCapacity && (
                  <span className="text-gray-600">🛏️ {hospital.bedCapacity} beds</span>
                )}
                {hospital.yearEstablished && (
                  <span className="text-gray-600">📅 Est. {hospital.yearEstablished}</span>
                )}
              </div>

              <div className="flex space-x-4">
                <Link
                  to={`/appointment/book?hospitalId=${hospital.id}`}
                  className="btn-primary"
                >
                  Book Appointment
                </Link>
                <Link
                  to={`/accommodation?city=${hospital.city}`}
                  className="btn-secondary"
                >
                  Find Accommodation
                </Link>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Main Content */}
        <div className="lg:col-span-2 space-y-6">
          {/* About */}
          <div className="card">
            <h2 className="text-xl font-semibold mb-4">About</h2>
            <p className="text-gray-700 leading-relaxed">
              {hospital.description || 'No description available for this hospital.'}
            </p>
          </div>

          {/* Contact Information */}
          <div className="card">
            <h2 className="text-xl font-semibold mb-4">Contact Information</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {hospital.phone && (
                <div>
                  <span className="font-medium text-gray-700">Phone:</span>
                  <p className="text-gray-600">{hospital.phone}</p>
                </div>
              )}
              {hospital.email && (
                <div>
                  <span className="font-medium text-gray-700">Email:</span>
                  <p className="text-gray-600">{hospital.email}</p>
                </div>
              )}
              {hospital.website && (
                <div>
                  <span className="font-medium text-gray-700">Website:</span>
                  <p className="text-gray-600">
                    <a href={hospital.website} target="_blank" rel="noopener noreferrer" className="text-primary-600 hover:text-primary-700">
                      {hospital.website}
                    </a>
                  </p>
                </div>
              )}
            </div>
          </div>

          {/* Departments */}
          {departments.length > 0 && (
            <div className="card">
              <h2 className="text-xl font-semibold mb-4">Departments</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {departments.map((dept) => (
                  <div key={dept.id} className="border rounded-lg p-4">
                    <h3 className="font-semibold text-gray-900">{dept.name}</h3>
                    {dept.description && (
                      <p className="text-gray-600 text-sm mt-1">{dept.description}</p>
                    )}
                    {dept.headOfDepartment && (
                      <p className="text-gray-500 text-sm mt-2">
                        Head: {dept.headOfDepartment}
                      </p>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Reviews */}
          {reviews.length > 0 && (
            <div className="card">
              <h2 className="text-xl font-semibold mb-4">Recent Reviews</h2>
              <div className="space-y-4">
                {reviews.slice(0, 5).map((review) => (
                  <div key={review.id} className="border-b border-gray-200 pb-4 last:border-b-0">
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center">
                        <span className="text-yellow-500">⭐</span>
                        <span className="ml-1 font-medium">{review.rating}</span>
                      </div>
                      <span className="text-gray-500 text-sm">
                        {new Date(review.createdAt).toLocaleDateString()}
                      </span>
                    </div>
                    {review.comment && (
                      <p className="text-gray-700">{review.comment}</p>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Specialties */}
          {hospital.specialties.length > 0 && (
            <div className="card">
              <h3 className="font-semibold mb-3">Specialties</h3>
              <div className="flex flex-wrap gap-2">
                {hospital.specialties.map((specialty, index) => (
                  <span key={index} className="bg-primary-100 text-primary-700 px-3 py-1 rounded-full text-sm">
                    {specialty}
                  </span>
                ))}
              </div>
            </div>
          )}

          {/* Accreditations */}
          {hospital.accreditations.length > 0 && (
            <div className="card">
              <h3 className="font-semibold mb-3">Accreditations</h3>
              <div className="space-y-2">
                {hospital.accreditations.map((accreditation, index) => (
                  <div key={index} className="flex items-center text-sm">
                    <span className="text-green-500 mr-2">✓</span>
                    <span className="text-gray-700">{accreditation}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Quick Actions */}
          <div className="card">
            <h3 className="font-semibold mb-3">Quick Actions</h3>
            <div className="space-y-3">
              <Link
                to={`/appointment/book?hospitalId=${hospital.id}`}
                className="w-full btn-primary text-center block"
              >
                Book Appointment
              </Link>
              <Link
                to={`/accommodation?city=${hospital.city}`}
                className="w-full btn-secondary text-center block"
              >
                Find Hotels
              </Link>
              <Link
                to={`/messages?hospitalId=${hospital.id}`}
                className="w-full btn-outline text-center block"
              >
                Contact Hospital
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default HospitalProfilePage
