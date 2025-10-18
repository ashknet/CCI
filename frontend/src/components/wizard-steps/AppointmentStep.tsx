import React, { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { RootState } from '../../store/store'
import { setAppointmentData } from '../../store/slices/wizardSlice'
import { 
  CalendarIcon,
  ClockIcon,
  UserIcon,
  BuildingOfficeIcon,
  CheckIcon
} from '@heroicons/react/24/outline'

const AppointmentStep: React.FC = () => {
  const dispatch = useDispatch()
  const { appointmentData } = useSelector((state: RootState) => state.wizard)
  const [availableSlots, setAvailableSlots] = useState<any[]>([])
  const [loading, setLoading] = useState(false)

  // Generate mock available slots for the next 30 days
  const generateMockSlots = (): any[] => {
    const slots: any[] = []
    const today = new Date()
    
    // Standard time slots for each day
    const standardTimeSlots = ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00']
    
    // Generate slots for the next 30 days (including today)
    for (let i = 0; i <= 30; i++) {
      const date = new Date(today)
      date.setDate(today.getDate() + i)
      const dateString = date.toISOString().split('T')[0]
      
      // Generate slots for ALL days (including weekends for better availability)
      // Add all standard time slots for each day
      standardTimeSlots.forEach(time => {
        const endTime = `${String(parseInt(time.split(':')[0]) + 1).padStart(2, '0')}:00`
        
        slots.push({
          id: `${dateString}-${time}`,
          date: dateString,
          startTime: time,
          endTime: endTime,
          isAvailable: true
        })
      })
    }
    
    console.log(`Generated ${slots.length} slots for dates ${today.toISOString().split('T')[0]} to ${new Date(today.getTime() + 30*24*60*60*1000).toISOString().split('T')[0]}`)
    console.log('Sample slots:', slots.slice(0, 5))
    
    return slots
  }

  useEffect(() => {
    // Load slots when doctor is set OR when component mounts (for testing)
    loadAvailableSlots()
  }, [appointmentData.doctor])

  // Reload slots when date changes
  useEffect(() => {
    if (appointmentData.selectedDate && appointmentData.doctor) {
      // In a real app, you would fetch slots for the specific date
      // For now, we'll just use the existing slots and filter by date
    }
  }, [appointmentData.selectedDate])

  const loadAvailableSlots = async () => {
    setLoading(true)
    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1000))
      const slots = generateMockSlots()
      console.log('Generated slots:', slots.slice(0, 10)) // Log first 10 slots
      setAvailableSlots(slots)
    } catch (error) {
      console.error('Failed to load available slots:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleDateChange = (date: string) => {
    dispatch(setAppointmentData({ selectedDate: date }))
  }

  const handleTimeChange = (time: string) => {
    dispatch(setAppointmentData({ selectedTime: time }))
  }

  const handleReasonChange = (reason: string) => {
    dispatch(setAppointmentData({ reasonForVisit: reason }))
  }

  const getMinDate = () => {
    const today = new Date()
    return today.toISOString().split('T')[0]
  }

  const getMaxDate = () => {
    const maxDate = new Date()
    maxDate.setDate(maxDate.getDate() + 30)
    return maxDate.toISOString().split('T')[0]
  }

  const getAvailableTimesForDate = (date: string) => {
    const slots = availableSlots.filter(slot => slot.date === date && slot.isAvailable)
    console.log(`Available slots for ${date}:`, slots)
    return slots
  }

  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return date.toLocaleDateString('en-US', { 
      weekday: 'long', 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    })
  }

  const isStepValid = () => {
    return appointmentData.selectedDate && 
           appointmentData.selectedTime && 
           appointmentData.reasonForVisit.trim().length > 0
  }

  return (
    <div className="space-y-6">
      <div className="text-center">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          Book Your Appointment
        </h2>
        <p className="text-gray-600">
          Select your preferred date, time, and provide details about your visit
        </p>
      </div>

      {/* Doctor/Hospital Info */}
      {appointmentData.doctor && (
        <div className="bg-primary-50 border border-primary-200 rounded-lg p-4">
          <div className="flex items-center space-x-4">
            <div className="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center">
              <UserIcon className="w-6 h-6 text-gray-400" />
            </div>
            <div className="flex-1">
              <h3 className="font-semibold text-primary-900">
                Dr. {appointmentData.doctor.firstName} {appointmentData.doctor.lastName}
              </h3>
              <p className="text-sm text-primary-700">{appointmentData.doctor.qualification}</p>
              <div className="flex items-center space-x-4 mt-1">
                <span className="text-sm text-primary-600">
                  <BuildingOfficeIcon className="w-4 h-4 inline mr-1" />
                  {appointmentData.doctor.hospital.name}
                </span>
                <span className="text-sm font-semibold text-primary-600">
                  ₹{appointmentData.doctor.consultationFee}
                </span>
              </div>
            </div>
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Appointment Form */}
        <div className="space-y-6">
          {/* Date Selection */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <CalendarIcon className="w-4 h-4 inline mr-1" />
              Select Date
            </label>
            <input
              type="date"
              value={appointmentData.selectedDate}
              onChange={(e) => handleDateChange(e.target.value)}
              min={getMinDate()}
              max={getMaxDate()}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              required
            />
            {appointmentData.selectedDate && (
              <p className="text-sm text-gray-600 mt-1">
                {formatDate(appointmentData.selectedDate)}
              </p>
            )}
          </div>

          {/* Time Selection */}
          {appointmentData.selectedDate && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                <ClockIcon className="w-4 h-4 inline mr-1" />
                Available Time Slots
              </label>
              {loading ? (
                <div className="flex items-center justify-center py-4">
                  <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-primary-500"></div>
                  <span className="ml-2 text-gray-600">Loading slots...</span>
                </div>
              ) : (
                <>
                  {getAvailableTimesForDate(appointmentData.selectedDate).length > 0 ? (
                    <div className="grid grid-cols-2 gap-2">
                      {getAvailableTimesForDate(appointmentData.selectedDate).map((slot) => (
                        <button
                          key={slot.id}
                          onClick={() => handleTimeChange(slot.startTime)}
                          className={`px-4 py-2 rounded-lg border transition-colors ${
                            appointmentData.selectedTime === slot.startTime
                              ? 'bg-primary-600 text-white border-primary-600'
                              : 'bg-white text-gray-700 border-gray-300 hover:border-primary-500'
                          }`}
                        >
                          {slot.startTime.substring(0, 5)}
                        </button>
                      ))}
                    </div>
                  ) : (
                    <div className="text-center py-4">
                      <ClockIcon className="w-8 h-8 text-gray-400 mx-auto mb-2" />
                      <p className="text-gray-600 text-sm">No available slots for this date</p>
                      <p className="text-gray-500 text-xs mt-1">Please try selecting a different date</p>
                    </div>
                  )}
                </>
              )}
            </div>
          )}

          {/* Reason for Visit */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Reason for Visit
            </label>
            <textarea
              value={appointmentData.reasonForVisit}
              onChange={(e) => handleReasonChange(e.target.value)}
              rows={4}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              placeholder="Please describe your symptoms or reason for consultation..."
              required
            />
          </div>
        </div>

        {/* Appointment Summary */}
        <div className="space-y-4">
          <div className="bg-gray-50 rounded-lg p-4">
            <h3 className="font-semibold text-gray-900 mb-3">Appointment Summary</h3>
            <div className="space-y-2 text-sm">
              <div className="flex justify-between">
                <span className="text-gray-600">Doctor:</span>
                <span className="font-medium">
                  {appointmentData.doctor ? 
                    `Dr. ${appointmentData.doctor.firstName} ${appointmentData.doctor.lastName}` : 
                    'Not selected'
                  }
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Hospital:</span>
                <span className="font-medium">
                  {appointmentData.hospital?.name || 'Not selected'}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Date:</span>
                <span className="font-medium">
                  {appointmentData.selectedDate ? formatDate(appointmentData.selectedDate) : 'Not selected'}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Time:</span>
                <span className="font-medium">
                  {appointmentData.selectedTime || 'Not selected'}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Consultation Fee:</span>
                <span className="font-medium">
                  {appointmentData.doctor ? `₹${appointmentData.doctor.consultationFee}` : 'Not available'}
                </span>
              </div>
            </div>
          </div>

          {/* Booking Information */}
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <h4 className="font-medium text-blue-900 mb-2">Important Information</h4>
            <ul className="text-sm text-blue-800 space-y-1">
              <li>• Please arrive 15 minutes before your appointment</li>
              <li>• Bring your medical records and insurance documents</li>
              <li>• Free cancellation up to 24 hours before appointment</li>
              <li>• You will receive confirmation via email and SMS</li>
            </ul>
          </div>

          {/* Validation Status */}
          <div className={`rounded-lg p-4 ${
            isStepValid() ? 'bg-green-50 border border-green-200' : 'bg-yellow-50 border border-yellow-200'
          }`}>
            <div className="flex items-center">
              {isStepValid() ? (
                <CheckIcon className="w-5 h-5 text-green-500 mr-2" />
              ) : (
                <ClockIcon className="w-5 h-5 text-yellow-500 mr-2" />
              )}
              <span className={`text-sm font-medium ${
                isStepValid() ? 'text-green-800' : 'text-yellow-800'
              }`}>
                {isStepValid() ? 'Appointment details complete' : 'Please complete all fields'}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default AppointmentStep
