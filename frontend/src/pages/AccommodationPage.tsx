import { useState } from 'react'
import axios from 'axios'

const AccommodationPage = () => {
  const [city, setCity] = useState('Hyderabad')
  const [checkIn, setCheckIn] = useState('')
  const [checkOut, setCheckOut] = useState('')
  const [guests, setGuests] = useState(2)
  const [rooms] = useState(1)
  const [hotels, setHotels] = useState<any[]>([])
  const [selectedHotel, setSelectedHotel] = useState<any>(null)
  const [hotelRooms, setHotelRooms] = useState<any[]>([])
  const [loading, setLoading] = useState(false)

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    
    try {
      const response = await axios.post('/api/accommodation/search', {
        city,
        checkIn,
        checkOut,
        guests,
        rooms
      })
      setHotels(response.data.data)
      setSelectedHotel(null)
      setHotelRooms([])
    } catch (error) {
      console.error('Search failed', error)
      alert('Failed to search hotels')
    } finally {
      setLoading(false)
    }
  }

  const handleViewRooms = async (hotel: any) => {
    setSelectedHotel(hotel)
    
    try {
      const response = await axios.get(`/api/accommodation/${hotel.id}/rooms`)
      setHotelRooms(response.data.data)
    } catch (error) {
      console.error('Failed to fetch rooms', error)
    }
  }

  const handleBookRoom = async (room: any) => {
    try {
      const response = await axios.post('/api/accommodation/book', {
        hotelId: selectedHotel.id,
        roomId: room.id,
        checkInDate: checkIn,
        checkOutDate: checkOut,
        numberOfGuests: guests,
        numberOfRooms: rooms,
        guestName: 'John Doe',
        guestEmail: 'john@example.com',
        guestPhone: '+1-555-0100',
        specialRequests: ''
      })
      alert('Hotel booked successfully! Reference: ' + response.data.data.bookingReference)
    } catch (error) {
      alert('Booking failed. Please try again.')
    }
  }

  const calculateNights = () => {
    if (!checkIn || !checkOut) return 0
    const start = new Date(checkIn)
    const end = new Date(checkOut)
    return Math.ceil((end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24))
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Find Accommodation</h1>

      <form onSubmit={handleSearch} className="card mb-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
          <div>
            <label className="block text-sm font-medium mb-2">City</label>
            <select value={city} onChange={(e) => setCity(e.target.value)} className="input-field">
              <option value="Hyderabad">Hyderabad</option>
              <option value="Bangalore">Bangalore</option>
              <option value="Mumbai">Mumbai</option>
              <option value="Chennai">Chennai</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Check-in</label>
            <input
              type="date"
              value={checkIn}
              onChange={(e) => setCheckIn(e.target.value)}
              min={new Date().toISOString().split('T')[0]}
              className="input-field"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Check-out</label>
            <input
              type="date"
              value={checkOut}
              onChange={(e) => setCheckOut(e.target.value)}
              min={checkIn}
              className="input-field"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Guests</label>
            <input
              type="number"
              value={guests}
              onChange={(e) => setGuests(parseInt(e.target.value))}
              min="1"
              max="10"
              className="input-field"
            />
          </div>
          <div className="flex items-end">
            <button type="submit" className="w-full btn-primary" disabled={loading}>
              {loading ? 'Searching...' : 'Search Hotels'}
            </button>
          </div>
        </div>
      </form>

      {selectedHotel ? (
        <div>
          <button onClick={() => setSelectedHotel(null)} className="btn-secondary mb-4">
            ← Back to Hotels
          </button>
          
          <div className="card mb-6">
            <h2 className="text-2xl font-semibold mb-2">{selectedHotel.name}</h2>
            <div className="flex items-center space-x-4 text-gray-600 mb-2">
              <span>⭐ {selectedHotel.starRating} Star</span>
              <span>📍 {selectedHotel.distanceToHospitalKm} km to hospital</span>
              <span>⭐ {selectedHotel.averageRating} ({selectedHotel.totalReviews} reviews)</span>
            </div>
            <p className="text-gray-700">{selectedHotel.description}</p>
          </div>

          <h3 className="text-xl font-semibold mb-4">Available Rooms</h3>
          <div className="grid grid-cols-1 gap-4">
            {hotelRooms.map((room) => (
              <div key={room.id} className="card">
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <h4 className="text-lg font-semibold mb-2">{room.roomType}</h4>
                    <p className="text-gray-600 mb-3">{room.description}</p>
                    <div className="flex flex-wrap gap-2 mb-3">
                      {room.amenities.map((amenity: string, i: number) => (
                        <span key={i} className="bg-gray-100 px-3 py-1 rounded-full text-sm">
                          {amenity}
                        </span>
                      ))}
                    </div>
                    <p className="text-sm text-gray-600">Max occupancy: {room.maxOccupancy} guests</p>
                    <p className="text-sm text-gray-600">{room.availableRooms} rooms available</p>
                  </div>
                  <div className="ml-8 text-right">
                    <p className="text-2xl font-bold text-primary-600">₹{room.pricePerNight.toLocaleString()}</p>
                    <p className="text-sm text-gray-600">per night</p>
                    {calculateNights() > 0 && (
                      <p className="text-lg font-semibold mt-2">
                        Total: ₹{(room.pricePerNight * calculateNights() * rooms).toLocaleString()}
                      </p>
                    )}
                    <button onClick={() => handleBookRoom(room)} className="btn-primary mt-3">
                      Book Now
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      ) : (
        <div className="space-y-4">
          {hotels.map((hotel) => (
            <div key={hotel.id} className="card hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <h3 className="text-xl font-semibold mb-2">{hotel.name}</h3>
                  <div className="flex items-center space-x-4 text-sm text-gray-600 mb-2">
                    <span>⭐ {hotel.starRating} Star</span>
                    <span>📍 {hotel.distanceToHospitalKm} km to hospital</span>
                    <span>⭐ {hotel.averageRating} ({hotel.totalReviews} reviews)</span>
                  </div>
                  <p className="text-gray-700 mb-3">{hotel.description}</p>
                  <div className="flex flex-wrap gap-2">
                    {hotel.amenities.slice(0, 5).map((amenity: string, i: number) => (
                      <span key={i} className="bg-gray-100 px-2 py-1 rounded text-sm">
                        {amenity}
                      </span>
                    ))}
                    {hotel.amenities.length > 5 && (
                      <span className="text-sm text-primary-600">+{hotel.amenities.length - 5} more</span>
                    )}
                  </div>
                </div>
                <div className="ml-8 text-right">
                  <button onClick={() => handleViewRooms(hotel)} className="btn-primary">
                    View Rooms
                  </button>
                </div>
              </div>
            </div>
          ))}

          {hotels.length === 0 && !loading && (
            <div className="card text-center py-12">
              <p className="text-gray-600">Search for hotels to see available accommodations near hospitals</p>
            </div>
          )}
        </div>
      )}
    </div>
  )
}

export default AccommodationPage
