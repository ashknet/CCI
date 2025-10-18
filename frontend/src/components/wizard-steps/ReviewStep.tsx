import React from 'react'
import { useSelector } from 'react-redux'
import { RootState } from '../../store/store'
import { 
  UserIcon,
  BuildingOfficeIcon,
  PaperAirplaneIcon,
  TruckIcon,
  MapPinIcon,
  CheckIcon,
  ExclamationTriangleIcon
} from '@heroicons/react/24/outline'

const ReviewStep: React.FC = () => {
  const { 
    searchData, 
    appointmentData, 
    travelData, 
    accommodationData
  } = useSelector((state: RootState) => state.wizard)

  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return date.toLocaleDateString('en-US', { 
      weekday: 'long', 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    })
  }

  const calculateNights = () => {
    if (!accommodationData.checkIn || !accommodationData.checkOut) return 0
    const checkIn = new Date(accommodationData.checkIn)
    const checkOut = new Date(accommodationData.checkOut)
    const diffTime = Math.abs(checkOut.getTime() - checkIn.getTime())
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  }

  const calculateAccommodationTotal = () => {
    if (!accommodationData.selectedRoom) return 0
    const nights = calculateNights()
    return accommodationData.selectedRoom.price * nights * accommodationData.rooms
  }

  const calculateTravelTotal = () => {
    if (!travelData.selectedOption) return 0
    return travelData.selectedOption.price * travelData.passengers
  }

  const getTotalCost = () => {
    const appointmentCost = appointmentData.doctor?.consultationFee || 0
    const travelCost = calculateTravelTotal()
    const accommodationCost = calculateAccommodationTotal()
    return appointmentCost + travelCost + accommodationCost
  }

  const isBookingComplete = () => {
    return appointmentData.doctor && 
           appointmentData.selectedDate && 
           appointmentData.selectedTime && 
           appointmentData.reasonForVisit &&
           travelData.selectedOption &&
           accommodationData.selectedRoom
  }

  return (
    <div className="space-y-6">
      <div className="text-center">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          Review Your Booking
        </h2>
        <p className="text-gray-600">
          Please review all details before confirming your medical travel booking
        </p>
      </div>

      {/* Booking Status */}
      <div className={`rounded-lg p-4 ${
        isBookingComplete() 
          ? 'bg-green-50 border border-green-200' 
          : 'bg-yellow-50 border border-yellow-200'
      }`}>
        <div className="flex items-center">
          {isBookingComplete() ? (
            <CheckIcon className="w-5 h-5 text-green-500 mr-2" />
          ) : (
            <ExclamationTriangleIcon className="w-5 h-5 text-yellow-500 mr-2" />
          )}
          <span className={`font-medium ${
            isBookingComplete() ? 'text-green-800' : 'text-yellow-800'
          }`}>
            {isBookingComplete() 
              ? 'All booking details are complete' 
              : 'Some booking details are missing'
            }
          </span>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Left Column - Booking Details */}
        <div className="space-y-6">
          {/* Search Summary */}
          {searchData.selectedItem && (
            <div className="bg-white border border-gray-200 rounded-lg p-4">
              <h3 className="font-semibold text-gray-900 mb-3 flex items-center">
                <MapPinIcon className="w-5 h-5 mr-2 text-primary-600" />
                Search Summary
              </h3>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Searched for:</span>
                  <span className="font-medium">{searchData.selectedItem.text}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Category:</span>
                  <span className="font-medium capitalize">{searchData.selectedItem.category}</span>
                </div>
              </div>
            </div>
          )}

          {/* Appointment Details */}
          {appointmentData.doctor && (
            <div className="bg-white border border-gray-200 rounded-lg p-4">
              <h3 className="font-semibold text-gray-900 mb-3 flex items-center">
                <UserIcon className="w-5 h-5 mr-2 text-primary-600" />
                Appointment Details
              </h3>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Doctor:</span>
                  <span className="font-medium">
                    Dr. {appointmentData.doctor.firstName} {appointmentData.doctor.lastName}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Hospital:</span>
                  <span className="font-medium">{appointmentData.hospital?.name}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Date:</span>
                  <span className="font-medium">
                    {appointmentData.selectedDate ? formatDate(appointmentData.selectedDate) : 'Not selected'}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Time:</span>
                  <span className="font-medium">{appointmentData.selectedTime || 'Not selected'}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Consultation Fee:</span>
                  <span className="font-medium">₹{appointmentData.doctor.consultationFee}</span>
                </div>
                {appointmentData.reasonForVisit && (
                  <div className="mt-2 pt-2 border-t border-gray-200">
                    <span className="text-gray-600">Reason for Visit:</span>
                    <p className="text-sm text-gray-800 mt-1">{appointmentData.reasonForVisit}</p>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* Travel Details */}
          {travelData.selectedOption && (
            <div className="bg-white border border-gray-200 rounded-lg p-4">
              <h3 className="font-semibold text-gray-900 mb-3 flex items-center">
                {travelData.type === 'flight' ? (
                  <PaperAirplaneIcon className="w-5 h-5 mr-2 text-primary-600" />
                ) : (
                  <TruckIcon className="w-5 h-5 mr-2 text-primary-600" />
                )}
                Travel Details
              </h3>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Type:</span>
                  <span className="font-medium capitalize">{travelData.type}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Route:</span>
                  <span className="font-medium">{travelData.from} → {travelData.to}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Date:</span>
                  <span className="font-medium">
                    {travelData.departureDate ? formatDate(travelData.departureDate) : 'Not selected'}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Passengers:</span>
                  <span className="font-medium">{travelData.passengers}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Option:</span>
                  <span className="font-medium">
                    {travelData.selectedOption.type === 'flight' 
                      ? `${travelData.selectedOption.airline} ${travelData.selectedOption.flightNumber}`
                      : `${travelData.selectedOption.trainName} ${travelData.selectedOption.trainNumber}`
                    }
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Duration:</span>
                  <span className="font-medium">{travelData.selectedOption.duration}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Total Cost:</span>
                  <span className="font-medium">₹{calculateTravelTotal().toLocaleString()}</span>
                </div>
              </div>
            </div>
          )}

          {/* Accommodation Details */}
          {accommodationData.selectedRoom && (
            <div className="bg-white border border-gray-200 rounded-lg p-4">
              <h3 className="font-semibold text-gray-900 mb-3 flex items-center">
                <BuildingOfficeIcon className="w-5 h-5 mr-2 text-primary-600" />
                Accommodation Details
              </h3>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Hotel:</span>
                  <span className="font-medium">{accommodationData.selectedHotel?.name}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Room:</span>
                  <span className="font-medium">{accommodationData.selectedRoom.type}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Check-in:</span>
                  <span className="font-medium">
                    {accommodationData.checkIn ? formatDate(accommodationData.checkIn) : 'Not selected'}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Check-out:</span>
                  <span className="font-medium">
                    {accommodationData.checkOut ? formatDate(accommodationData.checkOut) : 'Not selected'}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Duration:</span>
                  <span className="font-medium">{calculateNights()} nights</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Guests:</span>
                  <span className="font-medium">{accommodationData.guests} guests, {accommodationData.rooms} room(s)</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Total Cost:</span>
                  <span className="font-medium">₹{calculateAccommodationTotal().toLocaleString()}</span>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Right Column - Cost Summary */}
        <div className="space-y-6">
          {/* Cost Breakdown */}
          <div className="bg-white border border-gray-200 rounded-lg p-4">
            <h3 className="font-semibold text-gray-900 mb-4">Cost Breakdown</h3>
            <div className="space-y-3">
              {appointmentData.doctor && (
                <div className="flex justify-between items-center">
                  <div>
                    <p className="text-sm font-medium text-gray-900">Medical Consultation</p>
                    <p className="text-xs text-gray-500">
                      Dr. {appointmentData.doctor.firstName} {appointmentData.doctor.lastName}
                    </p>
                  </div>
                  <span className="font-medium">₹{appointmentData.doctor.consultationFee}</span>
                </div>
              )}

              {travelData.selectedOption && (
                <div className="flex justify-between items-center">
                  <div>
                    <p className="text-sm font-medium text-gray-900">Travel</p>
                    <p className="text-xs text-gray-500">
                      {travelData.type} from {travelData.from} to {travelData.to}
                    </p>
                  </div>
                  <span className="font-medium">₹{calculateTravelTotal().toLocaleString()}</span>
                </div>
              )}

              {accommodationData.selectedRoom && (
                <div className="flex justify-between items-center">
                  <div>
                    <p className="text-sm font-medium text-gray-900">Accommodation</p>
                    <p className="text-xs text-gray-500">
                      {accommodationData.selectedHotel?.name} - {calculateNights()} nights
                    </p>
                  </div>
                  <span className="font-medium">₹{calculateAccommodationTotal().toLocaleString()}</span>
                </div>
              )}

              <div className="border-t border-gray-200 pt-3">
                <div className="flex justify-between items-center">
                  <span className="text-lg font-semibold text-gray-900">Total Cost</span>
                  <span className="text-lg font-bold text-primary-600">₹{getTotalCost().toLocaleString()}</span>
                </div>
              </div>
            </div>
          </div>

          {/* Important Information */}
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <h4 className="font-medium text-blue-900 mb-2">Important Information</h4>
            <ul className="text-sm text-blue-800 space-y-1">
              <li>• All bookings are subject to availability</li>
              <li>• You will receive confirmation emails for each booking</li>
              <li>• Cancellation policies vary by service provider</li>
              <li>• Please arrive 15 minutes before your appointment</li>
              <li>• Bring valid ID and insurance documents</li>
            </ul>
          </div>

          {/* Contact Information */}
          <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
            <h4 className="font-medium text-gray-900 mb-2">Need Help?</h4>
            <div className="text-sm text-gray-600 space-y-1">
              <p>📞 Customer Support: +91-800-123-4567</p>
              <p>📧 Email: support@medtravel.com</p>
              <p>💬 Live Chat: Available 24/7</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ReviewStep
