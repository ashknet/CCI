import React, { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { RootState } from '../../store/store'
import { setAppointmentData } from '../../store/slices/wizardSlice'
import { 
  UserIcon,
  BuildingOfficeIcon,
  StarIcon,
  CheckIcon
} from '@heroicons/react/24/outline'

const DetailsStep: React.FC = () => {
  const dispatch = useDispatch()
  const { searchData } = useSelector((state: RootState) => state.wizard)
  const [selectedDoctor, setSelectedDoctor] = useState<any>(null)
  const [selectedHospital, setSelectedHospital] = useState<any>(null)
  const [loading, setLoading] = useState(false)

  // Mock data - in real app, this would come from API
  const mockDoctors = [
    {
      id: 1,
      firstName: 'John',
      lastName: 'Smith',
      qualification: 'MD, Cardiology',
      yearsOfExperience: 15,
      averageRating: 4.8,
      totalReviews: 124,
      consultationFee: 1500,
      hospital: {
        id: 1,
        name: 'Apollo Hospital',
        address: '123 Medical Street',
        city: 'Hyderabad',
        phone: '+91-40-12345678'
      },
      specialties: ['Cardiology', 'Internal Medicine'],
      languages: ['English', 'Hindi', 'Telugu'],
      profileImageUrl: null
    },
    {
      id: 2,
      firstName: 'Sarah',
      lastName: 'Johnson',
      qualification: 'MD, Neurology',
      yearsOfExperience: 12,
      averageRating: 4.9,
      totalReviews: 89,
      consultationFee: 1800,
      hospital: {
        id: 2,
        name: 'Fortis Hospital',
        address: '456 Health Avenue',
        city: 'Hyderabad',
        phone: '+91-40-87654321'
      },
      specialties: ['Neurology', 'Pediatrics'],
      languages: ['English', 'Hindi'],
      profileImageUrl: null
    }
  ]

  const mockHospitals = [
    {
      id: 1,
      name: 'Apollo Hospital',
      address: '123 Medical Street',
      city: 'Hyderabad',
      country: 'India',
      averageRating: 4.7,
      bedCapacity: 500,
      specialties: ['Cardiology', 'Neurology', 'Orthopedics', 'Oncology'],
      doctors: mockDoctors.slice(0, 1)
    },
    {
      id: 2,
      name: 'Fortis Hospital',
      address: '456 Health Avenue',
      city: 'Hyderabad',
      country: 'India',
      averageRating: 4.6,
      bedCapacity: 300,
      specialties: ['Neurology', 'Pediatrics', 'Dermatology'],
      doctors: mockDoctors.slice(1, 2)
    }
  ]

  useEffect(() => {
    // Load details based on search selection
    if (searchData.selectedItem) {
      loadDetails()
    }
  }, [searchData.selectedItem])

  const loadDetails = async () => {
    setLoading(true)
    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1000))
      
      // In real app, you would fetch actual data based on searchData.selectedItem
      // For now, we'll use mock data
    } catch (error) {
      console.error('Failed to load details:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleDoctorSelect = (doctor: any) => {
    setSelectedDoctor(doctor)
    setSelectedHospital(doctor.hospital)
    dispatch(setAppointmentData({
      doctor: doctor,
      hospital: doctor.hospital
    }))
  }

  const handleHospitalSelect = (hospital: any) => {
    setSelectedHospital(hospital)
    dispatch(setAppointmentData({
      hospital: hospital
    }))
  }

  const renderDoctorCard = (doctor: any) => (
    <div 
      key={doctor.id}
      className={`p-4 border rounded-lg cursor-pointer transition-all ${
        selectedDoctor?.id === doctor.id
          ? 'border-primary-500 bg-primary-50'
          : 'border-gray-200 hover:border-gray-300'
      }`}
      onClick={() => handleDoctorSelect(doctor)}
    >
      <div className="flex items-start space-x-4">
        <div className="w-16 h-16 bg-gray-200 rounded-full flex items-center justify-center">
          <UserIcon className="w-8 h-8 text-gray-400" />
        </div>
        <div className="flex-1">
          <div className="flex items-center justify-between">
            <h3 className="font-semibold text-gray-900">
              Dr. {doctor.firstName} {doctor.lastName}
            </h3>
            {selectedDoctor?.id === doctor.id && (
              <CheckIcon className="w-5 h-5 text-primary-500" />
            )}
          </div>
          <p className="text-sm text-gray-600">{doctor.qualification}</p>
          <p className="text-sm text-gray-600">{doctor.yearsOfExperience} years experience</p>
          <div className="flex items-center space-x-4 mt-2">
            <div className="flex items-center space-x-1">
              <StarIcon className="w-4 h-4 text-yellow-400" />
              <span className="text-sm font-medium">{doctor.averageRating}</span>
              <span className="text-sm text-gray-500">({doctor.totalReviews} reviews)</span>
            </div>
            <span className="text-sm font-semibold text-primary-600">
              ₹{doctor.consultationFee}
            </span>
          </div>
          <div className="flex flex-wrap gap-1 mt-2">
            {doctor.specialties.map((specialty: string, index: number) => (
              <span key={index} className="bg-primary-100 text-primary-700 px-2 py-1 rounded text-xs">
                {specialty}
              </span>
            ))}
          </div>
          <div className="mt-2">
            <p className="text-xs text-gray-500">
              <BuildingOfficeIcon className="w-3 h-3 inline mr-1" />
              {doctor.hospital.name}
            </p>
          </div>
        </div>
      </div>
    </div>
  )

  const renderHospitalCard = (hospital: any) => (
    <div 
      key={hospital.id}
      className={`p-4 border rounded-lg cursor-pointer transition-all ${
        selectedHospital?.id === hospital.id
          ? 'border-primary-500 bg-primary-50'
          : 'border-gray-200 hover:border-gray-300'
      }`}
      onClick={() => handleHospitalSelect(hospital)}
    >
      <div className="flex items-start space-x-4">
        <div className="w-16 h-16 bg-gray-200 rounded-full flex items-center justify-center">
          <BuildingOfficeIcon className="w-8 h-8 text-gray-400" />
        </div>
        <div className="flex-1">
          <div className="flex items-center justify-between">
            <h3 className="font-semibold text-gray-900">{hospital.name}</h3>
            {selectedHospital?.id === hospital.id && (
              <CheckIcon className="w-5 h-5 text-primary-500" />
            )}
          </div>
          <p className="text-sm text-gray-600">{hospital.address}</p>
          <p className="text-sm text-gray-600">{hospital.city}, {hospital.country}</p>
          <div className="flex items-center space-x-4 mt-2">
            <div className="flex items-center space-x-1">
              <StarIcon className="w-4 h-4 text-yellow-400" />
              <span className="text-sm font-medium">{hospital.averageRating}</span>
            </div>
            <span className="text-sm text-gray-500">{hospital.bedCapacity} beds</span>
          </div>
          <div className="flex flex-wrap gap-1 mt-2">
            {hospital.specialties.map((specialty: string, index: number) => (
              <span key={index} className="bg-green-100 text-green-700 px-2 py-1 rounded text-xs">
                {specialty}
              </span>
            ))}
          </div>
          {hospital.doctors && hospital.doctors.length > 0 && (
            <div className="mt-2">
              <p className="text-xs text-gray-500">
                {hospital.doctors.length} doctor(s) available
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  )

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-500"></div>
        <span className="ml-3 text-gray-600">Loading details...</span>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="text-center">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          Select Your Healthcare Provider
        </h2>
        <p className="text-gray-600">
          Choose a doctor or hospital based on your search
        </p>
      </div>

      {/* Search Context */}
      {searchData.selectedItem && (
        <div className="bg-primary-50 border border-primary-200 rounded-lg p-4">
          <div className="flex items-center space-x-3">
            <div className="flex-shrink-0">
              <span className="text-sm font-medium text-primary-700">Searching for:</span>
            </div>
            <div className="flex-1">
              <span className="font-semibold text-primary-900">{searchData.selectedItem.text}</span>
              <span className="ml-2 text-sm text-primary-700 capitalize">
                ({searchData.selectedItem.category})
              </span>
            </div>
          </div>
        </div>
      )}

      {/* Doctors Section */}
      <div>
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Available Doctors</h3>
        <div className="space-y-4">
          {mockDoctors.map(renderDoctorCard)}
        </div>
      </div>

      {/* Hospitals Section */}
      <div>
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Available Hospitals</h3>
        <div className="space-y-4">
          {mockHospitals.map(renderHospitalCard)}
        </div>
      </div>

      {/* Selection Summary */}
      {(selectedDoctor || selectedHospital) && (
        <div className="bg-green-50 border border-green-200 rounded-lg p-4">
          <h4 className="font-medium text-green-900 mb-2">Selected:</h4>
          {selectedDoctor && (
            <p className="text-green-800">
              Dr. {selectedDoctor.firstName} {selectedDoctor.lastName} - {selectedDoctor.hospital.name}
            </p>
          )}
          {selectedHospital && !selectedDoctor && (
            <p className="text-green-800">{selectedHospital.name}</p>
          )}
        </div>
      )}
    </div>
  )
}

export default DetailsStep
