import React, { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { RootState } from '../store/store'
import { 
  nextStep, 
  previousStep, 
  goToStep, 
  completeStep, 
  updateBookingSummary,
  setLoading,
  setError
} from '../store/slices/wizardSlice'
import { 
  ChevronLeftIcon, 
  ChevronRightIcon,
  CheckIcon,
  XMarkIcon
} from '@heroicons/react/24/outline'

// Import step components
import SearchStep from './wizard-steps/SearchStep'
import DetailsStep from './wizard-steps/DetailsStep'
import AppointmentStep from './wizard-steps/AppointmentStep'
import TravelStep from './wizard-steps/TravelStep'
import AccommodationStep from './wizard-steps/AccommodationStep'
import ReviewStep from './wizard-steps/ReviewStep'

const BookingWizard: React.FC = () => {
  const dispatch = useDispatch()
  const { currentStep, steps, loading, error } = useSelector((state: RootState) => state.wizard)
  const [isSubmitting, setIsSubmitting] = useState(false)

  // Update booking summary whenever relevant data changes
  useEffect(() => {
    dispatch(updateBookingSummary())
  }, [dispatch])

  const handleNext = () => {
    // Validate current step before proceeding
    if (validateCurrentStep()) {
      dispatch(completeStep(currentStep))
      dispatch(nextStep())
    }
  }

  const handlePrevious = () => {
    dispatch(previousStep())
  }

  const handleGoToStep = (stepIndex: number) => {
    // Only allow going to completed steps or the next step
    if (stepIndex <= currentStep + 1 || steps[stepIndex].completed) {
      dispatch(goToStep(stepIndex))
    }
  }

  const validateCurrentStep = (): boolean => {
    switch (currentStep) {
      case 0: // Search step
        return true // Search is always valid
      case 1: // Details step
        return true // Details are always valid
      case 2: // Appointment step
        return true // Will be validated in the step component
      case 3: // Travel step
        return true // Will be validated in the step component
      case 4: // Accommodation step
        return true // Will be validated in the step component
      case 5: // Review step
        return true // Review is always valid
      default:
        return false
    }
  }

  const handleSubmit = async () => {
    setIsSubmitting(true)
    dispatch(setLoading(true))
    
    try {
      // Here you would make API calls to book everything
      // For now, we'll just simulate the process
      await new Promise(resolve => setTimeout(resolve, 2000))
      
      // Show success message and redirect
      alert('Booking completed successfully!')
      // You could redirect to a success page or bookings page here
    } catch (error) {
      dispatch(setError('Failed to complete booking. Please try again.'))
    } finally {
      setIsSubmitting(false)
      dispatch(setLoading(false))
    }
  }

  const renderStepContent = () => {
    switch (currentStep) {
      case 0:
        return <SearchStep />
      case 1:
        return <DetailsStep />
      case 2:
        return <AppointmentStep />
      case 3:
        return <TravelStep />
      case 4:
        return <AccommodationStep />
      case 5:
        return <ReviewStep />
      default:
        return <div>Unknown step</div>
    }
  }

  const canProceed = () => {
    switch (currentStep) {
      case 0:
        return true // Search step can always proceed
      case 1:
        return true // Details step can always proceed
      case 2:
        return true // Will be validated in AppointmentStep
      case 3:
        return true // Will be validated in TravelStep
      case 4:
        return true // Will be validated in AccommodationStep
      case 5:
        return true // Review step can always proceed
      default:
        return false
    }
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-6xl mx-auto px-4 py-8">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Complete Your Medical Travel Booking
          </h1>
          <p className="text-gray-600">
            Follow the steps below to search, book appointments, and arrange travel
          </p>
        </div>

        {/* Progress Steps */}
        <div className="mb-8">
          <div className="flex items-center justify-between">
            {steps.map((step, index) => (
              <div key={step.id} className="flex items-center">
                <div className="flex items-center">
                  <button
                    onClick={() => handleGoToStep(index)}
                    disabled={!steps[index].completed && index > currentStep + 1}
                    className={`flex items-center justify-center w-10 h-10 rounded-full border-2 transition-all duration-200 ${
                      index === currentStep
                        ? 'bg-primary-600 border-primary-600 text-white'
                        : steps[index].completed
                        ? 'bg-green-500 border-green-500 text-white'
                        : index <= currentStep + 1
                        ? 'bg-white border-primary-300 text-primary-600 hover:border-primary-500'
                        : 'bg-gray-100 border-gray-300 text-gray-400 cursor-not-allowed'
                    }`}
                  >
                    {steps[index].completed ? (
                      <CheckIcon className="w-5 h-5" />
                    ) : (
                      <span className="text-sm font-medium">{index + 1}</span>
                    )}
                  </button>
                  <div className="ml-3 hidden sm:block">
                    <p className={`text-sm font-medium ${
                      index === currentStep ? 'text-primary-600' : 
                      steps[index].completed ? 'text-green-600' : 'text-gray-500'
                    }`}>
                      {step.title}
                    </p>
                  </div>
                </div>
                {index < steps.length - 1 && (
                  <div className={`flex-1 h-0.5 mx-4 ${
                    steps[index].completed ? 'bg-green-500' : 'bg-gray-200'
                  }`} />
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Error Display */}
        {error && (
          <div className="mb-6 bg-red-50 border border-red-200 rounded-lg p-4">
            <div className="flex items-center">
              <XMarkIcon className="w-5 h-5 text-red-400 mr-2" />
              <p className="text-red-800">{error}</p>
            </div>
          </div>
        )}

        {/* Step Content */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6 mb-6">
          {renderStepContent()}
        </div>

        {/* Navigation */}
        <div className="flex items-center justify-between">
          <button
            onClick={handlePrevious}
            disabled={currentStep === 0}
            className={`flex items-center px-4 py-2 rounded-lg border transition-colors ${
              currentStep === 0
                ? 'bg-gray-100 text-gray-400 border-gray-200 cursor-not-allowed'
                : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'
            }`}
          >
            <ChevronLeftIcon className="w-4 h-4 mr-2" />
            Previous
          </button>

          <div className="flex items-center space-x-2">
            <span className="text-sm text-gray-500">
              Step {currentStep + 1} of {steps.length}
            </span>
          </div>

          {currentStep === steps.length - 1 ? (
            <button
              onClick={handleSubmit}
              disabled={isSubmitting || loading}
              className="flex items-center px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
            >
              {isSubmitting || loading ? (
                <>
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                  Completing...
                </>
              ) : (
                <>
                  Complete Booking
                  <CheckIcon className="w-4 h-4 ml-2" />
                </>
              )}
            </button>
          ) : (
            <button
              onClick={handleNext}
              disabled={!canProceed() || loading}
              className={`flex items-center px-4 py-2 rounded-lg transition-colors ${
                canProceed() && !loading
                  ? 'bg-primary-600 text-white hover:bg-primary-700'
                  : 'bg-gray-400 text-white cursor-not-allowed'
              }`}
            >
              Next
              <ChevronRightIcon className="w-4 h-4 ml-2" />
            </button>
          )}
        </div>
      </div>
    </div>
  )
}

export default BookingWizard
