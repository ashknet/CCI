import React, { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { RootState } from '../../store/store'
import { setAccommodationData } from '../../store/slices/wizardSlice'
import { 
  BuildingOfficeIcon,
  MapPinIcon,
  CalendarIcon,
  UserGroupIcon,
  StarIcon,
  CheckIcon
} from '@heroicons/react/24/outline'

const AccommodationStep: React.FC = () => {
  const dispatch = useDispatch()
  const { accommodationData, appointmentData } = useSelector((state: RootState) => state.wizard)
  const [hotels, setHotels] = useState<any[]>([])
  const [selectedHotelRooms, setSelectedHotelRooms] = useState<any[]>([])
  const [loading, setLoading] = useState(false)

  // Mock hotels data
  const mockHotels = [
    {
      id: 1,
      name: 'Taj Krishna',
      address: 'Road No. 1, Banjara Hills',
      city: 'Hyderabad',
      rating: 4.8,
      priceRange: '₹8,000 - ₹15,000',
      amenities: ['WiFi', 'Parking', 'Restaurant', 'Gym', 'Pool'],
      distance: '2.5 km from hospital',
      imageUrl: null
    },
    {
      id: 2,
      name: 'ITC Kakatiya',
      address: 'Begumpet',
      city: 'Hyderabad',
      rating: 4.6,
      priceRange: '₹6,000 - ₹12,000',
      amenities: ['WiFi', 'Parking', 'Restaurant', 'Spa'],
      distance: '3.2 km from hospital',
      imageUrl: null
    },
    {
      id: 3,
      name: 'Novotel Hyderabad',
      address: 'HITEC City',
      city: 'Hyderabad',
      rating: 4.4,
      priceRange: '₹4,500 - ₹8,000',
      amenities: ['WiFi', 'Parking', 'Restaurant', 'Business Center'],
      distance: '5.1 km from hospital',
      imageUrl: null
    }
  ]

  const mockRooms = [
    {
      id: 1,
      hotelId: 1,
      type: 'Deluxe Room',
      description: 'Spacious room with city view',
      price: 8500,
      maxOccupancy: 2,
      amenities: ['WiFi', 'AC', 'TV', 'Mini Bar'],
      available: true
    },
    {
      id: 2,
      hotelId: 1,
      type: 'Executive Suite',
      description: 'Luxury suite with separate living area',
      price: 12000,
      maxOccupancy: 4,
      amenities: ['WiFi', 'AC', 'TV', 'Mini Bar', 'Kitchenette'],
      available: true
    },
    {
      id: 3,
      hotelId: 2,
      type: 'Standard Room',
      description: 'Comfortable room with modern amenities',
      price: 6500,
      maxOccupancy: 2,
      amenities: ['WiFi', 'AC', 'TV'],
      available: true
    },
    {
      id: 4,
      hotelId: 3,
      type: 'Business Room',
      description: 'Room designed for business travelers',
      price: 5500,
      maxOccupancy: 2,
      amenities: ['WiFi', 'AC', 'TV', 'Work Desk'],
      available: true
    }
  ]

  useEffect(() => {
    // Set default city based on appointment
    if (appointmentData.hospital?.city) {
      dispatch(setAccommodationData({ city: appointmentData.hospital.city }))
    }
  }, [appointmentData.hospital, dispatch])

  const handleFieldChange = (field: string, value: any) => {
    dispatch(setAccommodationData({ [field]: value }))
  }

  const handleSearch = async () => {
    if (!accommodationData.city || !accommodationData.checkIn || !accommodationData.checkOut) {
      alert('Please fill in all required fields')
      return
    }

    setLoading(true)
    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1500))
      setHotels(mockHotels)
    } catch (error) {
      console.error('Search failed:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleHotelSelect = async (hotel: any) => {
    dispatch(setAccommodationData({ selectedHotel: hotel }))
    
    // Load rooms for selected hotel
    setLoading(true)
    try {
      await new Promise(resolve => setTimeout(resolve, 1000))
      const hotelRooms = mockRooms.filter(room => room.hotelId === hotel.id)
      setSelectedHotelRooms(hotelRooms)
    } catch (error) {
      console.error('Failed to load rooms:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleRoomSelect = (room: any) => {
    dispatch(setAccommodationData({ selectedRoom: room }))
  }

  const getMinDate = () => {
    const today = new Date()
    return today.toISOString().split('T')[0]
  }

  const getMaxDate = () => {
    const maxDate = new Date()
    maxDate.setDate(maxDate.getDate() + 90)
    return maxDate.toISOString().split('T')[0]
  }

  const calculateNights = () => {
    if (!accommodationData.checkIn || !accommodationData.checkOut) return 0
    const checkIn = new Date(accommodationData.checkIn)
    const checkOut = new Date(accommodationData.checkOut)
    const diffTime = Math.abs(checkOut.getTime() - checkIn.getTime())
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  }

  const calculateTotalCost = () => {
    if (!accommodationData.selectedRoom) return 0
    const nights = calculateNights()
    return accommodationData.selectedRoom.price * nights * accommodationData.rooms
  }

  const renderHotelCard = (hotel: any) => (
    <div 
      key={hotel.id}
      className={`p-4 border rounded-lg cursor-pointer transition-all ${
        accommodationData.selectedHotel?.id === hotel.id
          ? 'border-primary-500 bg-primary-50'
          : 'border-gray-200 hover:border-gray-300'
      }`}
      onClick={() => handleHotelSelect(hotel)}
    >
      <div className="flex items-start space-x-4">
        <div className="w-20 h-20 bg-gray-200 rounded-lg flex items-center justify-center">
          <BuildingOfficeIcon className="w-8 h-8 text-gray-400" />
        </div>
        <div className="flex-1">
          <div className="flex items-center justify-between">
            <h3 className="font-semibold text-gray-900">{hotel.name}</h3>
            {accommodationData.selectedHotel?.id === hotel.id && (
              <CheckIcon className="w-5 h-5 text-primary-500" />
            )}
          </div>
          <p className="text-sm text-gray-600">{hotel.address}</p>
          <p className="text-sm text-gray-600">{hotel.city}</p>
          <div className="flex items-center space-x-4 mt-2">
            <div className="flex items-center space-x-1">
              <StarIcon className="w-4 h-4 text-yellow-400" />
              <span className="text-sm font-medium">{hotel.rating}</span>
            </div>
            <span className="text-sm text-gray-500">{hotel.distance}</span>
            <span className="text-sm font-semibold text-primary-600">{hotel.priceRange}</span>
          </div>
          <div className="flex flex-wrap gap-1 mt-2">
            {hotel.amenities.map((amenity: string, index: number) => (
              <span key={index} className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                {amenity}
              </span>
            ))}
          </div>
        </div>
      </div>
    </div>
  )

  const renderRoomCard = (room: any) => (
    <div 
      key={room.id}
      className={`p-4 border rounded-lg cursor-pointer transition-all ${
        accommodationData.selectedRoom?.id === room.id
          ? 'border-primary-500 bg-primary-50'
          : 'border-gray-200 hover:border-gray-300'
      }`}
      onClick={() => handleRoomSelect(room)}
    >
      <div className="flex items-center justify-between">
        <div className="flex-1">
          <div className="flex items-center justify-between">
            <h4 className="font-medium text-gray-900">{room.type}</h4>
            {accommodationData.selectedRoom?.id === room.id && (
              <CheckIcon className="w-5 h-5 text-primary-500" />
            )}
          </div>
          <p className="text-sm text-gray-600 mt-1">{room.description}</p>
          <div className="flex items-center space-x-4 mt-2">
            <span className="text-sm text-gray-500">
              Max {room.maxOccupancy} guests
            </span>
            <span className="text-sm text-gray-500">
              {room.amenities.join(', ')}
            </span>
          </div>
        </div>
        <div className="text-right ml-4">
          <div className="text-lg font-bold text-primary-600">
            ₹{room.price.toLocaleString()}
          </div>
          <div className="text-sm text-gray-500">per night</div>
        </div>
      </div>
    </div>
  )

  return (
    <div className="space-y-6">
      <div className="text-center">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          Book Your Accommodation
        </h2>
        <p className="text-gray-600">
          Find a comfortable place to stay during your visit
        </p>
      </div>

      {/* Search Form */}
      <div className="bg-gray-50 rounded-lg p-6">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <MapPinIcon className="w-4 h-4 inline mr-1" />
              City
            </label>
            <input
              type="text"
              value={accommodationData.city}
              onChange={(e) => handleFieldChange('city', e.target.value)}
              placeholder="Hyderabad"
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <CalendarIcon className="w-4 h-4 inline mr-1" />
              Check-in Date
            </label>
            <input
              type="date"
              value={accommodationData.checkIn}
              onChange={(e) => handleFieldChange('checkIn', e.target.value)}
              min={getMinDate()}
              max={getMaxDate()}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <CalendarIcon className="w-4 h-4 inline mr-1" />
              Check-out Date
            </label>
            <input
              type="date"
              value={accommodationData.checkOut}
              onChange={(e) => handleFieldChange('checkOut', e.target.value)}
              min={accommodationData.checkIn || getMinDate()}
              max={getMaxDate()}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <UserGroupIcon className="w-4 h-4 inline mr-1" />
              Guests
            </label>
            <select
              value={accommodationData.guests}
              onChange={(e) => handleFieldChange('guests', parseInt(e.target.value))}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              {[1, 2, 3, 4, 5, 6].map(num => (
                <option key={num} value={num}>{num} {num === 1 ? 'Guest' : 'Guests'}</option>
              ))}
            </select>
          </div>
        </div>

        <div className="mt-4">
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Rooms
          </label>
          <select
            value={accommodationData.rooms}
            onChange={(e) => handleFieldChange('rooms', parseInt(e.target.value))}
            className="w-full md:w-32 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            {[1, 2, 3, 4].map(num => (
              <option key={num} value={num}>{num} {num === 1 ? 'Room' : 'Rooms'}</option>
            ))}
          </select>
        </div>

        <div className="mt-6">
          <button
            onClick={handleSearch}
            disabled={loading || !accommodationData.city || !accommodationData.checkIn || !accommodationData.checkOut}
            className="w-full md:w-auto px-6 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
          >
            {loading ? (
              <>
                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white inline mr-2"></div>
                Searching...
              </>
            ) : (
              'Search Hotels'
            )}
          </button>
        </div>
      </div>

      {/* Hotels List */}
      {hotels.length > 0 && (
        <div>
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Available Hotels</h3>
          <div className="space-y-4">
            {hotels.map(renderHotelCard)}
          </div>
        </div>
      )}

      {/* Rooms Selection */}
      {accommodationData.selectedHotel && selectedHotelRooms.length > 0 && (
        <div>
          <h3 className="text-lg font-semibold text-gray-900 mb-4">
            Select Room at {accommodationData.selectedHotel.name}
          </h3>
          {loading ? (
            <div className="flex items-center justify-center py-8">
              <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-primary-500"></div>
              <span className="ml-2 text-gray-600">Loading rooms...</span>
            </div>
          ) : (
            <div className="space-y-4">
              {selectedHotelRooms.map(renderRoomCard)}
            </div>
          )}
        </div>
      )}

      {/* Booking Summary */}
      {accommodationData.selectedRoom && (
        <div className="bg-green-50 border border-green-200 rounded-lg p-4">
          <h4 className="font-medium text-green-900 mb-2">Accommodation Summary:</h4>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between">
              <span className="text-green-800">Hotel:</span>
              <span className="font-medium text-green-800">{accommodationData.selectedHotel.name}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-green-800">Room:</span>
              <span className="font-medium text-green-800">{accommodationData.selectedRoom.type}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-green-800">Duration:</span>
              <span className="font-medium text-green-800">
                {calculateNights()} nights ({accommodationData.checkIn} to {accommodationData.checkOut})
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-green-800">Guests:</span>
              <span className="font-medium text-green-800">{accommodationData.guests} guests, {accommodationData.rooms} room(s)</span>
            </div>
            <div className="flex justify-between border-t border-green-300 pt-2">
              <span className="font-medium text-green-800">Total Cost:</span>
              <span className="font-bold text-green-800">₹{calculateTotalCost().toLocaleString()}</span>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default AccommodationStep
