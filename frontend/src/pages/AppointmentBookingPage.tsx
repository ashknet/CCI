import { useState, useEffect } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import { useDispatch } from 'react-redux'
import { AppDispatch } from '../store/store'
import { bookAppointment } from '../store/slices/appointmentSlice'
import { apiClient, API_ENDPOINTS } from '../config/api'

const AppointmentBookingPage = () => {
  const [searchParams] = useSearchParams()
  const navigate = useNavigate()
  const dispatch = useDispatch<AppDispatch>()
  const doctorId = searchParams.get('doctorId')
  
  const [selectedDate, setSelectedDate] = useState('')
  const [selectedTime, setSelectedTime] = useState('')
  const [reasonForVisit, setReasonForVisit] = useState('')
  const [availableSlots, setAvailableSlots] = useState<any[]>([])
  const [loading, setLoading] = useState(false)
  const [doctor, setDoctor] = useState<any>(null)

  useEffect(() => {
    if (doctorId) {
      fetchDoctor()
    }
  }, [doctorId])

  useEffect(() => {
    if (selectedDate && doctorId) {
      fetchAvailableSlots()
    }
  }, [selectedDate])

  const fetchDoctor = async () => {
    try {
      const response = await apiClient.get(`${API_ENDPOINTS.DOCTORS.GET_BY_ID}/${doctorId}`)
      setDoctor(response.data.data || response.data)
    } catch (error) {
      console.error('Failed to fetch doctor', error)
    }
  }

  const fetchAvailableSlots = async () => {
    try {
      const startDate = selectedDate
      const endDate = selectedDate
      const response = await apiClient.get(
        `${API_ENDPOINTS.APPOINTMENTS.GET_AVAILABLE_SLOTS}/${doctorId}/available-slots?startDate=${startDate}&endDate=${endDate}`
      )
      const slots = response.data.data || response.data
      setAvailableSlots(Array.isArray(slots) ? slots.filter((slot: any) => slot.isAvailable) : [])
    } catch (error) {
      console.error('Failed to fetch slots', error)
    }
  }

  const handleBooking = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!doctorId || !selectedDate || !selectedTime || !reasonForVisit) {
      alert('Please fill all fields')
      return
    }

    setLoading(true)
    try {
      await dispatch(bookAppointment({
        doctorId,
        scheduledDate: selectedDate,
        scheduledTime: selectedTime,
        reasonForVisit
      })).unwrap()
      
      alert('Appointment booked successfully!')
      navigate('/bookings')
    } catch (error) {
      alert('Failed to book appointment')
    } finally {
      setLoading(false)
    }
  }

  const getMinDate = () => {
    const tomorrow = new Date()
    tomorrow.setDate(tomorrow.getDate() + 1)
    return tomorrow.toISOString().split('T')[0]
  }

  const getMaxDate = () => {
    const maxDate = new Date()
    maxDate.setDate(maxDate.getDate() + 90)
    return maxDate.toISOString().split('T')[0]
  }

  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Book Appointment</h1>

      {doctor && (
        <div className="card mb-6">
          <div className="flex items-center space-x-4">
            <div className="w-16 h-16 bg-gray-200 rounded-full"></div>
            <div>
              <h2 className="text-xl font-semibold">Dr. {doctor.firstName} {doctor.lastName}</h2>
              <p className="text-gray-600">{doctor.specialties?.join(', ')}</p>
              <p className="text-primary-600 font-semibold">₹{doctor.consultationFee} consultation</p>
            </div>
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div>
          <form onSubmit={handleBooking} className="card space-y-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Select Date
              </label>
              <input
                type="date"
                value={selectedDate}
                onChange={(e) => setSelectedDate(e.target.value)}
                min={getMinDate()}
                max={getMaxDate()}
                className="input-field"
                required
              />
            </div>

            {selectedDate && availableSlots.length > 0 && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Available Time Slots
                </label>
                <div className="grid grid-cols-3 gap-2">
                  {availableSlots.map((slot, index) => (
                    <button
                      key={index}
                      type="button"
                      onClick={() => setSelectedTime(slot.startTime)}
                      className={`px-4 py-2 rounded-lg border transition-colors ${
                        selectedTime === slot.startTime
                          ? 'bg-primary-600 text-white border-primary-600'
                          : 'bg-white text-gray-700 border-gray-300 hover:border-primary-500'
                      }`}
                    >
                      {slot.startTime.substring(0, 5)}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {selectedDate && availableSlots.length === 0 && (
              <p className="text-gray-600">No available slots for this date</p>
            )}

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Reason for Visit
              </label>
              <textarea
                value={reasonForVisit}
                onChange={(e) => setReasonForVisit(e.target.value)}
                rows={4}
                className="input-field"
                placeholder="Please describe your symptoms or reason for consultation"
                required
              />
            </div>

            <button
              type="submit"
              disabled={loading || !selectedDate || !selectedTime}
              className="w-full btn-primary"
            >
              {loading ? 'Booking...' : 'Confirm Appointment'}
            </button>
          </form>
        </div>

        <div>
          <div className="card bg-blue-50 border-blue-200">
            <h3 className="text-lg font-semibold mb-4">Booking Information</h3>
            <ul className="space-y-2 text-sm text-gray-700">
              <li className="flex items-start">
                <span className="text-primary-600 mr-2">✓</span>
                Appointments can be booked up to 90 days in advance
              </li>
              <li className="flex items-start">
                <span className="text-primary-600 mr-2">✓</span>
                You will receive confirmation via email and SMS
              </li>
              <li className="flex items-start">
                <span className="text-primary-600 mr-2">✓</span>
                Please arrive 15 minutes before your appointment time
              </li>
              <li className="flex items-start">
                <span className="text-primary-600 mr-2">✓</span>
                Bring your medical records and insurance documents
              </li>
              <li className="flex items-start">
                <span className="text-primary-600 mr-2">✓</span>
                Free cancellation up to 24 hours before appointment
              </li>
            </ul>
          </div>

          <div className="card mt-4">
            <h3 className="text-lg font-semibold mb-4">Pre-Appointment Checklist</h3>
            <ul className="space-y-2 text-sm">
              <li className="flex items-center">
                <input type="checkbox" className="mr-2" />
                <span>Medical history documents</span>
              </li>
              <li className="flex items-center">
                <input type="checkbox" className="mr-2" />
                <span>Previous test results</span>
              </li>
              <li className="flex items-center">
                <input type="checkbox" className="mr-2" />
                <span>Insurance card and ID proof</span>
              </li>
              <li className="flex items-center">
                <input type="checkbox" className="mr-2" />
                <span>List of current medications</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}

export default AppointmentBookingPage
