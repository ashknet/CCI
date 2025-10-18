import React, { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { RootState } from '../../store/store'
import { setTravelData } from '../../store/slices/wizardSlice'
import { 
  PaperAirplaneIcon,
  TruckIcon,
  MapPinIcon,
  CalendarIcon,
  UserGroupIcon,
  CheckIcon,
  ClockIcon
} from '@heroicons/react/24/outline'

const TravelStep: React.FC = () => {
  const dispatch = useDispatch()
  const { travelData, appointmentData } = useSelector((state: RootState) => state.wizard)
  const [searchResults, setSearchResults] = useState<any[]>([])
  const [loading, setLoading] = useState(false)

  // Mock travel options
  const mockFlights = [
    {
      id: 1,
      type: 'flight',
      airline: 'Air India',
      flightNumber: 'AI-101',
      from: 'Delhi',
      to: 'Hyderabad',
      departureTime: '08:00',
      arrivalTime: '10:30',
      duration: '2h 30m',
      price: 8500,
      date: '2024-01-19',
      stops: 'Non-stop',
      class: 'Economy'
    },
    {
      id: 2,
      type: 'flight',
      airline: 'IndiGo',
      flightNumber: '6E-205',
      from: 'Delhi',
      to: 'Hyderabad',
      departureTime: '14:00',
      arrivalTime: '16:30',
      duration: '2h 30m',
      price: 7200,
      date: '2024-01-19',
      stops: 'Non-stop',
      class: 'Economy'
    },
    {
      id: 3,
      type: 'flight',
      airline: 'SpiceJet',
      flightNumber: 'SG-301',
      from: 'Delhi',
      to: 'Hyderabad',
      departureTime: '18:00',
      arrivalTime: '20:30',
      duration: '2h 30m',
      price: 6800,
      date: '2024-01-19',
      stops: 'Non-stop',
      class: 'Economy'
    }
  ]

  const mockTrains = [
    {
      id: 4,
      type: 'train',
      trainName: 'Rajdhani Express',
      trainNumber: '12001',
      from: 'New Delhi',
      to: 'Hyderabad',
      departureTime: '16:50',
      arrivalTime: '14:30+1',
      duration: '21h 40m',
      price: 2500,
      date: '2024-01-19',
      class: 'AC 2 Tier'
    },
    {
      id: 5,
      type: 'train',
      trainName: 'Shatabdi Express',
      trainNumber: '12002',
      from: 'New Delhi',
      to: 'Hyderabad',
      departureTime: '06:00',
      arrivalTime: '04:00+1',
      duration: '22h 00m',
      price: 1800,
      date: '2024-01-19',
      class: 'AC Chair Car'
    }
  ]

  useEffect(() => {
    // Set default values based on appointment
    if (appointmentData.hospital?.city) {
      dispatch(setTravelData({
        to: appointmentData.hospital.city
      }))
    }
  }, [appointmentData.hospital, dispatch])

  const handleTypeChange = (type: 'flight' | 'train') => {
    dispatch(setTravelData({ type }))
    setSearchResults([])
  }

  const handleFieldChange = (field: string, value: any) => {
    dispatch(setTravelData({ [field]: value }))
  }

  const handleSearch = async () => {
    if (!travelData.from || !travelData.to || !travelData.departureDate) {
      alert('Please fill in all required fields')
      return
    }

    setLoading(true)
    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1500))
      
      // Mock search results
      const results = travelData.type === 'flight' ? mockFlights : mockTrains
      setSearchResults(results)
    } catch (error) {
      console.error('Search failed:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleSelectOption = (option: any) => {
    dispatch(setTravelData({ selectedOption: option }))
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

  const renderTravelOption = (option: any) => (
    <div 
      key={option.id}
      className={`p-4 border rounded-lg cursor-pointer transition-all ${
        travelData.selectedOption?.id === option.id
          ? 'border-primary-500 bg-primary-50'
          : 'border-gray-200 hover:border-gray-300'
      }`}
      onClick={() => handleSelectOption(option)}
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <div className="flex-shrink-0">
            {option.type === 'flight' ? (
              <PaperAirplaneIcon className="w-8 h-8 text-blue-600" />
            ) : (
              <TruckIcon className="w-8 h-8 text-green-600" />
            )}
          </div>
          <div className="flex-1">
            <div className="flex items-center space-x-2">
              <h3 className="font-semibold text-gray-900">
                {option.type === 'flight' ? option.airline : option.trainName}
              </h3>
              <span className="text-sm text-gray-500">
                {option.type === 'flight' ? option.flightNumber : option.trainNumber}
              </span>
              {travelData.selectedOption?.id === option.id && (
                <CheckIcon className="w-5 h-5 text-primary-500" />
              )}
            </div>
            <div className="flex items-center space-x-4 mt-1">
              <span className="text-sm text-gray-600">
                {option.from} → {option.to}
              </span>
              <span className="text-sm text-gray-600">
                <ClockIcon className="w-4 h-4 inline mr-1" />
                {option.duration}
              </span>
            </div>
            <div className="flex items-center space-x-4 mt-1">
              <span className="text-sm text-gray-600">
                Departure: {option.departureTime}
              </span>
              <span className="text-sm text-gray-600">
                Arrival: {option.arrivalTime}
              </span>
              {option.class && (
                <span className="text-sm text-gray-600">
                  Class: {option.class}
                </span>
              )}
            </div>
          </div>
        </div>
        <div className="text-right">
          <div className="text-lg font-bold text-primary-600">
            ₹{option.price.toLocaleString()}
          </div>
          <div className="text-sm text-gray-500">per person</div>
        </div>
      </div>
    </div>
  )

  return (
    <div className="space-y-6">
      <div className="text-center">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          Book Your Travel
        </h2>
        <p className="text-gray-600">
          Choose your preferred mode of transportation
        </p>
      </div>

      {/* Travel Type Selection */}
      <div className="flex justify-center space-x-4">
        <button
          onClick={() => handleTypeChange('flight')}
          className={`flex items-center px-6 py-3 rounded-lg border transition-colors ${
            travelData.type === 'flight'
              ? 'bg-primary-600 text-white border-primary-600'
              : 'bg-white text-gray-700 border-gray-300 hover:border-primary-500'
          }`}
        >
          <PaperAirplaneIcon className="w-5 h-5 mr-2" />
          Flights
        </button>
        <button
          onClick={() => handleTypeChange('train')}
          className={`flex items-center px-6 py-3 rounded-lg border transition-colors ${
            travelData.type === 'train'
              ? 'bg-primary-600 text-white border-primary-600'
              : 'bg-white text-gray-700 border-gray-300 hover:border-primary-500'
          }`}
        >
          <TruckIcon className="w-5 h-5 mr-2" />
          Trains
        </button>
      </div>

      {/* Search Form */}
      <div className="bg-gray-50 rounded-lg p-6">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <MapPinIcon className="w-4 h-4 inline mr-1" />
              From
            </label>
            <input
              type="text"
              value={travelData.from}
              onChange={(e) => handleFieldChange('from', e.target.value)}
              placeholder={travelData.type === 'flight' ? 'Delhi (DEL)' : 'New Delhi Station'}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <MapPinIcon className="w-4 h-4 inline mr-1" />
              To
            </label>
            <input
              type="text"
              value={travelData.to}
              onChange={(e) => handleFieldChange('to', e.target.value)}
              placeholder={travelData.type === 'flight' ? 'Hyderabad (HYD)' : 'Hyderabad Station'}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <CalendarIcon className="w-4 h-4 inline mr-1" />
              Departure Date
            </label>
            <input
              type="date"
              value={travelData.departureDate}
              onChange={(e) => handleFieldChange('departureDate', e.target.value)}
              min={getMinDate()}
              max={getMaxDate()}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <UserGroupIcon className="w-4 h-4 inline mr-1" />
              Passengers
            </label>
            <select
              value={travelData.passengers}
              onChange={(e) => handleFieldChange('passengers', parseInt(e.target.value))}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              {[1, 2, 3, 4, 5, 6].map(num => (
                <option key={num} value={num}>{num} {num === 1 ? 'Passenger' : 'Passengers'}</option>
              ))}
            </select>
          </div>
        </div>

        {travelData.type === 'flight' && (
          <div className="mt-4">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Preference
            </label>
            <select
              value={travelData.preference}
              onChange={(e) => handleFieldChange('preference', e.target.value)}
              className="w-full md:w-48 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="cheapest">Cheapest</option>
              <option value="fastest">Fastest</option>
              <option value="best">Best Value</option>
            </select>
          </div>
        )}

        <div className="mt-6">
          <button
            onClick={handleSearch}
            disabled={loading || !travelData.from || !travelData.to || !travelData.departureDate}
            className="w-full md:w-auto px-6 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
          >
            {loading ? (
              <>
                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white inline mr-2"></div>
                Searching...
              </>
            ) : (
              'Search Options'
            )}
          </button>
        </div>
      </div>

      {/* Search Results */}
      {searchResults.length > 0 && (
        <div>
          <h3 className="text-lg font-semibold text-gray-900 mb-4">
            Available {travelData.type === 'flight' ? 'Flights' : 'Trains'}
          </h3>
          <div className="space-y-4">
            {searchResults.map(renderTravelOption)}
          </div>
        </div>
      )}

      {/* Selected Option Summary */}
      {travelData.selectedOption && (
        <div className="bg-green-50 border border-green-200 rounded-lg p-4">
          <h4 className="font-medium text-green-900 mb-2">Selected Travel Option:</h4>
          <div className="flex items-center justify-between">
            <div>
              <p className="text-green-800">
                {travelData.selectedOption.type === 'flight' 
                  ? `${travelData.selectedOption.airline} ${travelData.selectedOption.flightNumber}`
                  : `${travelData.selectedOption.trainName} ${travelData.selectedOption.trainNumber}`
                }
              </p>
              <p className="text-sm text-green-700">
                {travelData.selectedOption.from} → {travelData.selectedOption.to} • {travelData.selectedOption.duration}
              </p>
            </div>
            <div className="text-right">
              <p className="font-semibold text-green-800">
                ₹{travelData.selectedOption.price.toLocaleString()}
              </p>
              <p className="text-sm text-green-700">
                × {travelData.passengers} passenger(s)
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default TravelStep
