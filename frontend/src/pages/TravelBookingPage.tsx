import { useState } from 'react'
import axios from 'axios'

const TravelBookingPage = () => {
  const [travelType, setTravelType] = useState<'flight' | 'train'>('flight')
  const [from, setFrom] = useState('')
  const [to, setTo] = useState('')
  const [departureDate, setDepartureDate] = useState('')
  const [returnDate, setReturnDate] = useState('')
  const [passengers, setPassengers] = useState(1)
  const [preference, setPreference] = useState('cheapest')
  const [results, setResults] = useState<any[]>([])
  const [loading, setLoading] = useState(false)

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    
    try {
      const endpoint = travelType === 'flight' ? '/api/transport/flights/search' : '/api/transport/trains/search'
      const response = await axios.post(endpoint, {
        from,
        to,
        departureDate,
        returnDate: travelType === 'flight' ? returnDate : undefined,
        passengers,
        preference: travelType === 'flight' ? preference : undefined,
        class: travelType === 'train' ? 'Sleeper' : undefined
      })
      setResults(response.data.data)
    } catch (error) {
      console.error('Search failed', error)
      alert('Failed to search. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  const handleBook = async (item: any) => {
    try {
      const response = await axios.post('/api/transport/book', {
        type: travelType,
        referenceId: item.id,
        passengerName: 'John Doe',
        passengerEmail: 'john@example.com',
        passengerPhone: '+1-555-0100'
      })
      alert('Booking confirmed! Reference: ' + response.data.data.bookingReference)
    } catch (error) {
      alert('Booking failed. Please try again.')
    }
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Travel Booking</h1>

      <div className="mb-6 flex space-x-4">
        <button
          onClick={() => setTravelType('flight')}
          className={`px-6 py-2 rounded-lg ${
            travelType === 'flight' ? 'bg-primary-600 text-white' : 'bg-white text-gray-700 border'
          }`}
        >
          ✈️ Flights
        </button>
        <button
          onClick={() => setTravelType('train')}
          className={`px-6 py-2 rounded-lg ${
            travelType === 'train' ? 'bg-primary-600 text-white' : 'bg-white text-gray-700 border'
          }`}
        >
          🚂 Trains
        </button>
      </div>

      <form onSubmit={handleSearch} className="card mb-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <div>
            <label className="block text-sm font-medium mb-2">From</label>
            <input
              type="text"
              value={from}
              onChange={(e) => setFrom(e.target.value)}
              placeholder={travelType === 'flight' ? 'JFK, New York' : 'New Delhi Station'}
              className="input-field"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">To</label>
            <input
              type="text"
              value={to}
              onChange={(e) => setTo(e.target.value)}
              placeholder={travelType === 'flight' ? 'HYD, Hyderabad' : 'Mumbai Central'}
              className="input-field"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Departure Date</label>
            <input
              type="date"
              value={departureDate}
              onChange={(e) => setDepartureDate(e.target.value)}
              min={new Date().toISOString().split('T')[0]}
              className="input-field"
              required
            />
          </div>
          {travelType === 'flight' && (
            <div>
              <label className="block text-sm font-medium mb-2">Return Date</label>
              <input
                type="date"
                value={returnDate}
                onChange={(e) => setReturnDate(e.target.value)}
                min={departureDate}
                className="input-field"
              />
            </div>
          )}
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
          <div>
            <label className="block text-sm font-medium mb-2">Passengers</label>
            <input
              type="number"
              value={passengers}
              onChange={(e) => setPassengers(parseInt(e.target.value))}
              min="1"
              max="9"
              className="input-field"
              required
            />
          </div>
          {travelType === 'flight' && (
            <div>
              <label className="block text-sm font-medium mb-2">Preference</label>
              <select
                value={preference}
                onChange={(e) => setPreference(e.target.value)}
                className="input-field"
              >
                <option value="cheapest">Cheapest</option>
                <option value="fastest">Fastest</option>
                <option value="best">Best Overall</option>
              </select>
            </div>
          )}
          <div className="flex items-end">
            <button type="submit" className="w-full btn-primary" disabled={loading}>
              {loading ? 'Searching...' : 'Search'}
            </button>
          </div>
        </div>
      </form>

      {results.length > 0 && (
        <div className="space-y-4">
          <h2 className="text-2xl font-semibold">{results.length} {travelType === 'flight' ? 'Flights' : 'Trains'} Found</h2>
          
          {results.map((item, index) => (
            <div key={index} className="card hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-between">
                <div className="flex-1">
                  <div className="flex items-center space-x-4 mb-2">
                    <span className="text-2xl">{travelType === 'flight' ? '✈️' : '🚂'}</span>
                    <div>
                      <h3 className="font-semibold text-lg">
                        {travelType === 'flight' ? item.airline : item.trainName}
                      </h3>
                      <p className="text-sm text-gray-600">
                        {travelType === 'flight' ? item.flightNumber : item.trainNumber}
                      </p>
                    </div>
                  </div>
                  
                  <div className="flex items-center space-x-8 mt-4">
                    <div>
                      <p className="text-xl font-semibold">{item.departureTime.substring(11, 16)}</p>
                      <p className="text-sm text-gray-600">
                        {travelType === 'flight' ? item.departureAirport : item.departureStation}
                      </p>
                    </div>
                    
                    <div className="flex-1">
                      <div className="border-t-2 border-gray-300 relative">
                        <span className="absolute -top-3 left-1/2 -translate-x-1/2 bg-white px-2 text-xs text-gray-500">
                          {Math.floor(item.durationMinutes / 60)}h {item.durationMinutes % 60}m
                        </span>
                      </div>
                      <p className="text-center text-xs text-gray-500 mt-2">
                        {travelType === 'flight' && item.isDirect ? 'Direct' : 'With stops'}
                      </p>
                    </div>
                    
                    <div>
                      <p className="text-xl font-semibold">{item.arrivalTime.substring(11, 16)}</p>
                      <p className="text-sm text-gray-600">
                        {travelType === 'flight' ? item.arrivalAirport : item.arrivalStation}
                      </p>
                    </div>
                  </div>
                </div>

                <div className="ml-8 text-right">
                  <p className="text-2xl font-bold text-primary-600">₹{item.price.toLocaleString()}</p>
                  <p className="text-sm text-gray-600">{item.flightClass || item.class}</p>
                  <p className="text-xs text-gray-500 mb-3">{item.availableSeats} seats left</p>
                  <button
                    onClick={() => handleBook(item)}
                    className="btn-primary"
                  >
                    Book Now
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {results.length === 0 && !loading && (
        <div className="card text-center py-12">
          <p className="text-gray-600">Search for flights or trains to see available options</p>
        </div>
      )}
    </div>
  )
}

export default TravelBookingPage
