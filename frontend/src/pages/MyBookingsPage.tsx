import { useState, useEffect } from 'react'
import { taServiceClient, API_ENDPOINTS } from '../config/api'

const MyBookingsPage = () => {
  const [activeTab, setActiveTab] = useState<'appointments' | 'travel' | 'accommodation'>('appointments')
  const [appointments, setAppointments] = useState<any[]>([])
  const [travelBookings, setTravelBookings] = useState<any[]>([])
  const [hotelBookings, setHotelBookings] = useState<any[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchBookings()
  }, [activeTab])

  const fetchBookings = async () => {
    setLoading(true)
    try {
      if (activeTab === 'appointments') {
        const response = await taServiceClient.get(API_ENDPOINTS.APPOINTMENTS.GET_MY)
        const data = response.data.data || response.data
        setAppointments(data.items || data || [])
      } else if (activeTab === 'travel') {
        // Transport bookings are handled by TA Service
        const response = await taServiceClient.get('/api/v1/transport/bookings')
        setTravelBookings(response.data.data || response.data || [])
      } else {
        // Accommodation bookings are handled by TA Service
        const response = await taServiceClient.get('/api/v1/accommodation/bookings')
        setHotelBookings(response.data.data || response.data || [])
      }
    } catch (error) {
      console.error('Failed to fetch bookings', error)
    } finally {
      setLoading(false)
    }
  }

  const handleCancelAppointment = async (id: string) => {
    if (!confirm('Are you sure you want to cancel this appointment?')) return

    try {
      await taServiceClient.patch(`${API_ENDPOINTS.APPOINTMENTS.CANCEL}/${id}/cancel`, 'User requested cancellation')
      alert('Appointment cancelled successfully')
      fetchBookings()
    } catch (error) {
      alert('Failed to cancel appointment')
    }
  }

  const getStatusColor = (status: string) => {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'scheduled':
        return 'bg-green-100 text-green-800'
      case 'pending':
        return 'bg-yellow-100 text-yellow-800'
      case 'cancelled':
        return 'bg-red-100 text-red-800'
      case 'completed':
        return 'bg-blue-100 text-blue-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">My Bookings</h1>

      <div className="mb-6 flex space-x-4">
        <button
          onClick={() => setActiveTab('appointments')}
          className={`px-6 py-2 rounded-lg ${
            activeTab === 'appointments'
              ? 'bg-primary-600 text-white'
              : 'bg-white text-gray-700 border'
          }`}
        >
          Appointments
        </button>
        <button
          onClick={() => setActiveTab('travel')}
          className={`px-6 py-2 rounded-lg ${
            activeTab === 'travel'
              ? 'bg-primary-600 text-white'
              : 'bg-white text-gray-700 border'
          }`}
        >
          Travel
        </button>
        <button
          onClick={() => setActiveTab('accommodation')}
          className={`px-6 py-2 rounded-lg ${
            activeTab === 'accommodation'
              ? 'bg-primary-600 text-white'
              : 'bg-white text-gray-700 border'
          }`}
        >
          Accommodation
        </button>
      </div>

      {loading ? (
        <div className="card text-center py-12">
          <p className="text-gray-600">Loading bookings...</p>
        </div>
      ) : (
        <div className="space-y-4">
          {/* Appointments Tab */}
          {activeTab === 'appointments' && (
            <>
              {appointments.length > 0 ? (
                appointments.map((apt) => (
                  <div key={apt.id} className="card">
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <div className="flex items-center space-x-3 mb-2">
                          <h3 className="text-xl font-semibold">{apt.doctorName}</h3>
                          <span className={`px-3 py-1 rounded-full text-sm ${getStatusColor(apt.status)}`}>
                            {apt.status}
                          </span>
                        </div>
                        <div className="space-y-1 text-gray-600">
                          <p>📅 {new Date(apt.scheduledDate).toLocaleDateString()}</p>
                          <p>🕐 {apt.scheduledTime}</p>
                          <p>💰 Fee: ₹{apt.fee?.toLocaleString()}</p>
                          <p>📝 Reason: {apt.reasonForVisit}</p>
                        </div>
                      </div>
                      <div className="space-x-2">
                        {apt.status === 'scheduled' && (
                          <>
                            <button className="btn-secondary">Reschedule</button>
                            <button
                              onClick={() => handleCancelAppointment(apt.id)}
                              className="btn-secondary text-red-600"
                            >
                              Cancel
                            </button>
                          </>
                        )}
                      </div>
                    </div>
                  </div>
                ))
              ) : (
                <div className="card text-center py-12">
                  <p className="text-gray-600">No appointments booked yet</p>
                </div>
              )}
            </>
          )}

          {/* Travel Tab */}
          {activeTab === 'travel' && (
            <>
              {travelBookings.length > 0 ? (
                travelBookings.map((booking) => (
                  <div key={booking.id} className="card">
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <div className="flex items-center space-x-3 mb-2">
                          <h3 className="text-xl font-semibold">{booking.type.toUpperCase()}</h3>
                          <span className={`px-3 py-1 rounded-full text-sm ${getStatusColor(booking.status)}`}>
                            {booking.status}
                          </span>
                        </div>
                        <div className="space-y-1 text-gray-600">
                          <p>📍 {booking.from} → {booking.to}</p>
                          <p>📅 {new Date(booking.departureTime).toLocaleString()}</p>
                          <p>💰 ₹{booking.totalPrice?.toLocaleString()}</p>
                          <p>🎫 Booking Ref: {booking.bookingReference}</p>
                        </div>
                      </div>
                      <button className="btn-secondary text-red-600">Cancel</button>
                    </div>
                  </div>
                ))
              ) : (
                <div className="card text-center py-12">
                  <p className="text-gray-600">No travel bookings yet</p>
                </div>
              )}
            </>
          )}

          {/* Accommodation Tab */}
          {activeTab === 'accommodation' && (
            <>
              {hotelBookings.length > 0 ? (
                hotelBookings.map((booking) => (
                  <div key={booking.id} className="card">
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <div className="flex items-center space-x-3 mb-2">
                          <h3 className="text-xl font-semibold">{booking.hotelName}</h3>
                          <span className={`px-3 py-1 rounded-full text-sm ${getStatusColor(booking.status)}`}>
                            {booking.status}
                          </span>
                        </div>
                        <div className="space-y-1 text-gray-600">
                          <p>🛏️ Room Type: {booking.roomType}</p>
                          <p>📅 Check-in: {new Date(booking.checkInDate).toLocaleDateString()}</p>
                          <p>📅 Check-out: {new Date(booking.checkOutDate).toLocaleDateString()}</p>
                          <p>👥 {booking.numberOfGuests} guests, {booking.numberOfRooms} room(s)</p>
                          <p>💰 ₹{booking.totalPrice?.toLocaleString()}</p>
                          <p>🎫 Booking Ref: {booking.bookingReference}</p>
                        </div>
                      </div>
                      <button className="btn-secondary text-red-600">Cancel</button>
                    </div>
                  </div>
                ))
              ) : (
                <div className="card text-center py-12">
                  <p className="text-gray-600">No accommodation bookings yet</p>
                </div>
              )}
            </>
          )}
        </div>
      )}
    </div>
  )
}

export default MyBookingsPage
