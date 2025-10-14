import { Link } from 'react-router-dom'

const DoctorProfilePage = () => {
  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 space-y-6">
          <div className="card">
            <div className="flex items-start space-x-6">
              <div className="w-32 h-32 bg-gray-200 rounded-full flex-shrink-0"></div>
              <div className="flex-1">
                <h1 className="text-3xl font-bold mb-2">Dr. Rajesh Kumar</h1>
                <p className="text-gray-600 mb-2">Cardiologist • 15 years experience</p>
                <p className="text-gray-600 mb-4">Apollo Hospitals, Hyderabad</p>
                <div className="flex items-center space-x-4">
                  <div className="flex items-center">
                    <span className="text-yellow-500">⭐</span>
                    <span className="ml-1 font-medium">4.8</span>
                    <span className="text-gray-500 ml-1">(250 reviews)</span>
                  </div>
                  <span className="text-primary-600 font-semibold">₹2000 consultation</span>
                </div>
              </div>
            </div>
          </div>

          <div className="card">
            <h2 className="text-xl font-semibold mb-4">About</h2>
            <p className="text-gray-700">
              Dr. Rajesh Kumar is a renowned cardiologist with over 15 years of experience in treating complex
              heart conditions. He specializes in interventional cardiology and has performed over 5000 successful
              procedures.
            </p>
          </div>

          <div className="card">
            <h2 className="text-xl font-semibold mb-4">Credentials</h2>
            <ul className="space-y-2">
              <li className="flex items-center">
                <span className="text-primary-600 mr-2">✓</span>
                MBBS - AIIMS, New Delhi
              </li>
              <li className="flex items-center">
                <span className="text-primary-600 mr-2">✓</span>
                MD Cardiology - PGI, Chandigarh
              </li>
              <li className="flex items-center">
                <span className="text-primary-600 mr-2">✓</span>
                Fellowship in Interventional Cardiology
              </li>
            </ul>
          </div>
        </div>

        <div>
          <div className="card sticky top-4">
            <h3 className="text-lg font-semibold mb-4">Book Appointment</h3>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-2">Select Date</label>
                <input type="date" className="input-field" />
              </div>
              <Link to="/appointment/book" className="w-full btn-primary block text-center">
                View Available Slots
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default DoctorProfilePage
