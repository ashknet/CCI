import { useState, useEffect } from 'react'
import { useSelector } from 'react-redux'
import { RootState } from '../store/store'
import { taServiceClient } from '../config/api'

const CheckoutPage = () => {
  const { appointment, transport, accommodation } = useSelector((state: RootState) => state.booking)
  const [costBreakdown, setCostBreakdown] = useState<any>(null)
  const [paymentMethod, setPaymentMethod] = useState('card')
  const [processing, setProcessing] = useState(false)

  useEffect(() => {
    fetchCostBreakdown()
  }, [])

  const fetchCostBreakdown = async () => {
    try {
      const response = await taServiceClient.get('/api/v1/accommodation/cost-breakdown')
      setCostBreakdown(response.data.data)
    } catch (error) {
      console.error('Failed to fetch cost breakdown', error)
    }
  }

  const handlePayment = async () => {
    setProcessing(true)
    
    try {
      // Simulate payment processing
      await new Promise(resolve => setTimeout(resolve, 2000))
      alert('Payment successful! You will receive confirmation via email.')
    } catch (error) {
      alert('Payment failed. Please try again.')
    } finally {
      setProcessing(false)
    }
  }

  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Complete Your Booking</h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 space-y-6">
          {/* Appointment Summary */}
          <div className="card">
            <h2 className="text-xl font-semibold mb-4">Medical Appointment</h2>
            {appointment ? (
              <div className="space-y-2">
                <p><span className="font-medium">Doctor:</span> {appointment.doctorName}</p>
                <p><span className="font-medium">Date:</span> {appointment.date}</p>
                <p><span className="font-medium">Time:</span> {appointment.time}</p>
                <p><span className="font-medium">Fee:</span> ₹{appointment.fee?.toLocaleString()}</p>
              </div>
            ) : (
              <p className="text-gray-600">No appointment selected</p>
            )}
          </div>

          {/* Travel Summary */}
          <div className="card">
            <h2 className="text-xl font-semibold mb-4">Travel</h2>
            {transport ? (
              <div className="space-y-2">
                <p><span className="font-medium">From:</span> {transport.from}</p>
                <p><span className="font-medium">To:</span> {transport.to}</p>
                <p><span className="font-medium">Date:</span> {transport.date}</p>
                <p><span className="font-medium">Cost:</span> ₹{transport.price?.toLocaleString()}</p>
              </div>
            ) : (
              <p className="text-gray-600">No travel booked</p>
            )}
          </div>

          {/* Accommodation Summary */}
          <div className="card">
            <h2 className="text-xl font-semibold mb-4">Accommodation</h2>
            {accommodation ? (
              <div className="space-y-2">
                <p><span className="font-medium">Hotel:</span> {accommodation.hotelName}</p>
                <p><span className="font-medium">Check-in:</span> {accommodation.checkIn}</p>
                <p><span className="font-medium">Check-out:</span> {accommodation.checkOut}</p>
                <p><span className="font-medium">Cost:</span> ₹{accommodation.price?.toLocaleString()}</p>
              </div>
            ) : (
              <p className="text-gray-600">No accommodation booked</p>
            )}
          </div>

          {/* Payment Method */}
          <div className="card">
            <h2 className="text-xl font-semibold mb-4">Payment Method</h2>
            <div className="space-y-3">
              <label className="flex items-center p-3 border rounded-lg cursor-pointer hover:border-primary-500">
                <input
                  type="radio"
                  name="payment"
                  value="card"
                  checked={paymentMethod === 'card'}
                  onChange={(e) => setPaymentMethod(e.target.value)}
                  className="mr-3"
                />
                <span>💳 Credit/Debit Card</span>
              </label>
              <label className="flex items-center p-3 border rounded-lg cursor-pointer hover:border-primary-500">
                <input
                  type="radio"
                  name="payment"
                  value="upi"
                  checked={paymentMethod === 'upi'}
                  onChange={(e) => setPaymentMethod(e.target.value)}
                  className="mr-3"
                />
                <span>📱 UPI</span>
              </label>
              <label className="flex items-center p-3 border rounded-lg cursor-pointer hover:border-primary-500">
                <input
                  type="radio"
                  name="payment"
                  value="netbanking"
                  checked={paymentMethod === 'netbanking'}
                  onChange={(e) => setPaymentMethod(e.target.value)}
                  className="mr-3"
                />
                <span>🏦 Net Banking</span>
              </label>
            </div>
          </div>
        </div>

        {/* Cost Summary */}
        <div>
          <div className="card sticky top-4">
            <h2 className="text-xl font-semibold mb-4">Cost Summary</h2>
            
            {costBreakdown ? (
              <div className="space-y-3">
                <div className="flex justify-between">
                  <span className="text-gray-600">Medical Consultation</span>
                  <span className="font-medium">₹{costBreakdown.medicalCost.toLocaleString()}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Travel</span>
                  <span className="font-medium">₹{costBreakdown.transportCost.toLocaleString()}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Accommodation</span>
                  <span className="font-medium">₹{costBreakdown.accommodationCost.toLocaleString()}</span>
                </div>
                <div className="border-t pt-3 mt-3">
                  <div className="flex justify-between text-lg font-semibold">
                    <span>Total Amount</span>
                    <span className="text-primary-600">₹{costBreakdown.totalCost.toLocaleString()}</span>
                  </div>
                </div>
              </div>
            ) : (
              <p className="text-gray-600">Loading cost breakdown...</p>
            )}

            <button
              onClick={handlePayment}
              disabled={processing}
              className="w-full btn-primary mt-6"
            >
              {processing ? 'Processing...' : 'Proceed to Payment'}
            </button>

            <div className="mt-4 p-3 bg-green-50 border border-green-200 rounded-lg">
              <p className="text-sm text-green-800">
                <span className="font-medium">✓ Secure Payment</span><br />
                Your payment information is encrypted and secure
              </p>
            </div>

            <div className="mt-4 text-xs text-gray-600 space-y-1">
              <p>• Free cancellation up to 24 hours before appointment</p>
              <p>• Full refund on cancellations within policy</p>
              <p>• Instant confirmation via email and SMS</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default CheckoutPage
