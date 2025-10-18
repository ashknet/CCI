import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { RootState } from '../store/store';
import { fetchSuggestions } from '../store/slices/searchSlice';
import { selectionFlowService } from '../services/selectionFlowService';
import { 
  ChevronRightIcon, 
  UserIcon, 
  BuildingOfficeIcon, 
  MapPinIcon, 
  HeartIcon,
  StarIcon
} from '@heroicons/react/24/outline';

interface SearchWorkflowProps {
  onSelectionComplete?: (selection: any) => void;
}

interface WorkflowStep {
  type: 'search' | 'doctor' | 'hospital' | 'city' | 'disease';
  title: string;
  data?: any;
}

const SearchWorkflow: React.FC<SearchWorkflowProps> = () => {
  const dispatch = useDispatch();
  const { suggestions, loading: searchLoading } = useSelector((state: RootState) => state.search);
  
  const [workflowSteps, setWorkflowSteps] = useState<WorkflowStep[]>([
    { type: 'search', title: 'Search for hospitals, doctors, cities, or diseases' }
  ]);
  const [currentStep, setCurrentStep] = useState(0);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedItem, setSelectedItem] = useState<any>(null);
  const [selectionData, setSelectionData] = useState<any>(null);
  const [loading, setLoading] = useState(false);

  // Debounced search
  useEffect(() => {
    const timer = setTimeout(() => {
      if (searchQuery.length >= 2) {
        dispatch(fetchSuggestions(searchQuery) as any);
      }
    }, 300);

    return () => clearTimeout(timer);
  }, [searchQuery, dispatch]);

  const handleSuggestionClick = async (suggestion: any) => {
    const newStep: WorkflowStep = {
      type: suggestion.category.toLowerCase(),
      title: `Selected ${suggestion.category}: ${suggestion.text}`,
      data: suggestion
    };

    setWorkflowSteps(prev => [...prev, newStep]);
    setCurrentStep(prev => prev + 1);
    setSelectedItem(suggestion);
    setSearchQuery('');

    // Load next level data based on selection type
    await loadNextLevelData(suggestion);
  };

  const loadNextLevelData = async (suggestion: any) => {
    setLoading(true);
    try {
      let data = null;

      switch (suggestion.category.toLowerCase()) {
        case 'doctor':
          data = await selectionFlowService.getDoctorSelection(suggestion.id, {
            includeReviews: true,
            reviewLimit: 5
          });
          break;
        case 'hospital':
          data = await selectionFlowService.getHospitalSelection(suggestion.id, {
            page: 1,
            pageSize: 20,
            includeAvailability: true
          });
          break;
        case 'city':
          data = await selectionFlowService.getCitySelection(suggestion.id, {
            page: 1,
            pageSize: 20
          });
          break;
        case 'disease':
          data = await selectionFlowService.getDiseaseSelection(suggestion.id, {
            page: 1,
            pageSize: 20,
            includeAvailability: true
          });
          break;
        case 'specialty':
          // For specialty, we'll show doctors with that specialty
          data = await selectionFlowService.getDiseaseDoctors(suggestion.id, {
            page: 1,
            pageSize: 20,
            includeAvailability: true
          });
          break;
      }

      if (data) {
        setSelectionData(data);
      }
    } catch (error) {
      console.error('Error loading next level data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleBack = () => {
    if (currentStep > 0) {
      setCurrentStep(prev => prev - 1);
      setWorkflowSteps(prev => prev.slice(0, -1));
    }
  };

  const getCategoryIcon = (category: string) => {
    switch (category.toLowerCase()) {
      case 'doctor':
        return <UserIcon className="w-5 h-5" />;
      case 'hospital':
        return <BuildingOfficeIcon className="w-5 h-5" />;
      case 'city':
        return <MapPinIcon className="w-5 h-5" />;
      case 'disease':
        return <HeartIcon className="w-5 h-5" />;
      case 'specialty':
        return <StarIcon className="w-5 h-5" />;
      default:
        return <StarIcon className="w-5 h-5" />;
    }
  };

  const renderSearchStep = () => (
    <div className="space-y-4">
      <div className="relative">
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder="Search for hospitals, doctors, cities, or diseases..."
          className="w-full px-4 py-3 pr-12 bg-white text-gray-900 placeholder-gray-500 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 shadow-sm"
        />
        {searchLoading && (
          <div className="absolute right-3 top-1/2 transform -translate-y-1/2">
            <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-primary-500"></div>
          </div>
        )}
      </div>

      {suggestions.length > 0 && (
        <div className="bg-white border border-gray-200 rounded-lg shadow-lg max-h-96 overflow-y-auto">
          {suggestions.map((suggestion: any, index: number) => (
            <button
              key={index}
              onClick={() => handleSuggestionClick(suggestion)}
              className="w-full px-4 py-3 text-left hover:bg-gray-50 border-b border-gray-100 last:border-b-0 flex items-center space-x-3"
            >
              <div className="flex-shrink-0 text-primary-500">
                {getCategoryIcon(suggestion.category)}
              </div>
              <div className="flex-1">
                <div className="font-medium text-gray-900">{suggestion.text}</div>
                <div className="text-sm text-gray-500 capitalize">{suggestion.category}</div>
              </div>
              <ChevronRightIcon className="w-5 h-5 text-gray-400" />
            </button>
          ))}
        </div>
      )}

      {searchQuery.length >= 2 && suggestions.length === 0 && !searchLoading && (
        <div className="text-center py-8 text-gray-500">
          <StarIcon className="w-12 h-12 mx-auto mb-4 text-gray-300" />
          <p>No results found for "{searchQuery}"</p>
          <p className="text-sm">Try searching for hospitals, doctors, cities, or diseases</p>
        </div>
      )}
    </div>
  );

  const renderSelectionStep = () => {
    if (!selectedItem) return null;

    if (loading) {
      return (
        <div className="flex items-center justify-center py-12">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-500"></div>
          <span className="ml-3 text-gray-600">Loading...</span>
        </div>
      );
    }

    return (
      <div className="space-y-6">
        <div className="bg-primary-50 border border-primary-200 rounded-lg p-4">
          <div className="flex items-center space-x-3">
            <div className="flex-shrink-0 text-primary-500">
              {getCategoryIcon(selectedItem.category)}
            </div>
            <div>
              <h3 className="font-semibold text-primary-900">{selectedItem.text}</h3>
              <p className="text-sm text-primary-700 capitalize">{selectedItem.category}</p>
            </div>
          </div>
        </div>

        <div className="space-y-4">
          <h4 className="font-medium text-gray-900">Available Options:</h4>
          
          {selectedItem.category.toLowerCase() === 'doctor' && selectionData && (
            <div className="space-y-4">
              {/* Doctor Profile */}
              <div className="p-4 border border-gray-200 rounded-lg">
                <div className="flex items-start space-x-4">
                  {selectionData.doctor.profileImageUrl && (
                    <img 
                      src={selectionData.doctor.profileImageUrl} 
                      alt={selectionData.doctor.firstName}
                      className="w-16 h-16 rounded-full object-cover"
                    />
                  )}
                  <div className="flex-1">
                    <h5 className="font-medium text-gray-900">
                      Dr. {selectionData.doctor.firstName} {selectionData.doctor.lastName}
                    </h5>
                    <p className="text-sm text-gray-600">{selectionData.doctor.qualification}</p>
                    <p className="text-sm text-gray-600">{selectionData.doctor.yearsOfExperience} years experience</p>
                    <div className="flex items-center space-x-2 mt-2">
                      <StarIcon className="w-4 h-4 text-yellow-400" />
                      <span className="text-sm font-medium">{selectionData.doctor.averageRating}</span>
                      <span className="text-sm text-gray-500">({selectionData.doctor.totalReviews} reviews)</span>
                    </div>
                  </div>
                </div>
                <div className="mt-4 flex space-x-2">
                  <button className="px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600">
                    View Full Profile
                  </button>
                  <button className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600">
                    Book Appointment
                  </button>
                </div>
              </div>

              {/* Availability */}
              {selectionData.availability && selectionData.availability.availableSlots.length > 0 && (
                <div className="p-4 border border-gray-200 rounded-lg">
                  <h6 className="font-medium text-gray-900 mb-2">Available Slots</h6>
                  <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
                    {selectionData.availability.availableSlots.slice(0, 6).map((slot: any, index: number) => (
                      <div key={index} className="p-2 bg-gray-50 rounded text-sm text-center">
                        {new Date(slot.date).toLocaleDateString()}
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Recent Reviews */}
              {selectionData.recentReviews && selectionData.recentReviews.length > 0 && (
                <div className="p-4 border border-gray-200 rounded-lg">
                  <h6 className="font-medium text-gray-900 mb-2">Recent Reviews</h6>
                  {selectionData.recentReviews.slice(0, 2).map((review: any, index: number) => (
                    <div key={index} className="mb-2 p-2 bg-gray-50 rounded">
                      <div className="flex items-center space-x-2">
                        <StarIcon className="w-4 h-4 text-yellow-400" />
                        <span className="text-sm font-medium">{review.rating}/5</span>
                      </div>
                      <p className="text-sm text-gray-600 mt-1">{review.comment}</p>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {selectedItem.category.toLowerCase() === 'hospital' && selectionData && (
            <div className="space-y-4">
              {/* Hospital Info */}
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900">{selectionData.hospital.name}</h5>
                <p className="text-sm text-gray-600">{selectionData.hospital.address}</p>
                <p className="text-sm text-gray-600">{selectionData.hospital.city}, {selectionData.hospital.country}</p>
                <div className="flex items-center space-x-4 mt-2">
                  <div className="flex items-center space-x-1">
                    <StarIcon className="w-4 h-4 text-yellow-400" />
                    <span className="text-sm font-medium">{selectionData.hospital.averageRating}</span>
                  </div>
                  <span className="text-sm text-gray-500">{selectionData.hospital.bedCapacity} beds</span>
                </div>
              </div>

              {/* Doctors */}
              {selectionData.doctors && selectionData.doctors.items && (
                <div className="p-4 border border-gray-200 rounded-lg">
                  <h6 className="font-medium text-gray-900 mb-2">Available Doctors ({selectionData.doctors.totalCount})</h6>
                  <div className="space-y-2">
                    {selectionData.doctors.items.slice(0, 3).map((doctor: any, index: number) => (
                      <div key={index} className="flex items-center justify-between p-2 bg-gray-50 rounded">
                        <div>
                          <p className="font-medium text-sm">Dr. {doctor.firstName} {doctor.lastName}</p>
                          <p className="text-xs text-gray-600">{doctor.qualification}</p>
                        </div>
                        <button className="px-3 py-1 bg-primary-500 text-white text-xs rounded hover:bg-primary-600">
                          Select
                        </button>
                      </div>
                    ))}
                  </div>
                  {selectionData.doctors.totalCount > 3 && (
                    <button className="mt-2 text-sm text-primary-600 hover:text-primary-800">
                      View all {selectionData.doctors.totalCount} doctors
                    </button>
                  )}
                </div>
              )}
            </div>
          )}

          {selectedItem.category.toLowerCase() === 'city' && selectionData && (
            <div className="space-y-4">
              {/* City Info */}
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900">{selectionData.city.name}</h5>
                <p className="text-sm text-gray-600">{selectionData.city.state}, {selectionData.city.country}</p>
                <p className="text-sm text-gray-500 mt-1">{selectionData.totalDoctors} doctors available</p>
              </div>

              {/* Hospitals */}
              {selectionData.hospitals && selectionData.hospitals.items && (
                <div className="p-4 border border-gray-200 rounded-lg">
                  <h6 className="font-medium text-gray-900 mb-2">Hospitals ({selectionData.hospitals.totalCount})</h6>
                  <div className="space-y-2">
                    {selectionData.hospitals.items.slice(0, 3).map((hospital: any, index: number) => (
                      <div key={index} className="flex items-center justify-between p-2 bg-gray-50 rounded">
                        <div>
                          <p className="font-medium text-sm">{hospital.name}</p>
                          <p className="text-xs text-gray-600">{hospital.address}</p>
                        </div>
                        <button className="px-3 py-1 bg-primary-500 text-white text-xs rounded hover:bg-primary-600">
                          Select
                        </button>
                      </div>
                    ))}
                  </div>
                  {selectionData.hospitals.totalCount > 3 && (
                    <button className="mt-2 text-sm text-primary-600 hover:text-primary-800">
                      View all {selectionData.hospitals.totalCount} hospitals
                    </button>
                  )}
                </div>
              )}
            </div>
          )}

          {selectedItem.category.toLowerCase() === 'disease' && selectionData && (
            <div className="space-y-4">
              {/* Disease Info */}
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900">{selectionData.disease.name}</h5>
                <p className="text-sm text-gray-600">{selectionData.disease.description}</p>
                <p className="text-sm text-gray-500 mt-1">Category: {selectionData.disease.category}</p>
              </div>

              {/* Doctors */}
              {selectionData.doctors && selectionData.doctors.items && (
                <div className="p-4 border border-gray-200 rounded-lg">
                  <h6 className="font-medium text-gray-900 mb-2">Specialists ({selectionData.doctors.totalCount})</h6>
                  <div className="space-y-2">
                    {selectionData.doctors.items.slice(0, 3).map((doctor: any, index: number) => (
                      <div key={index} className="flex items-center justify-between p-2 bg-gray-50 rounded">
                        <div>
                          <p className="font-medium text-sm">Dr. {doctor.firstName} {doctor.lastName}</p>
                          <p className="text-xs text-gray-600">{doctor.hospital.name}</p>
                        </div>
                        <button className="px-3 py-1 bg-primary-500 text-white text-xs rounded hover:bg-primary-600">
                          Select
                        </button>
                      </div>
                    ))}
                  </div>
                  {selectionData.doctors.totalCount > 3 && (
                    <button className="mt-2 text-sm text-primary-600 hover:text-primary-800">
                      View all {selectionData.doctors.totalCount} specialists
                    </button>
                  )}
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    );
  };

  return (
    <div className="max-w-4xl mx-auto p-6">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">Find Your Healthcare Provider</h2>
        <p className="text-gray-600">Search and select your preferred hospital, doctor, city, or medical condition</p>
      </div>

      {/* Breadcrumb */}
      <div className="mb-6">
        <nav className="flex items-center space-x-2 text-sm">
          {workflowSteps.map((step, index) => (
            <React.Fragment key={index}>
              <button
                onClick={() => setCurrentStep(index)}
                className={`px-3 py-1 rounded-full ${
                  index === currentStep
                    ? 'bg-primary-500 text-white'
                    : index < currentStep
                    ? 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                    : 'bg-gray-100 text-gray-500'
                }`}
              >
                {step.title}
              </button>
              {index < workflowSteps.length - 1 && (
                <ChevronRightIcon className="w-4 h-4 text-gray-400" />
              )}
            </React.Fragment>
          ))}
        </nav>
      </div>

      {/* Current Step Content */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        {currentStep === 0 ? renderSearchStep() : renderSelectionStep()}
      </div>

      {/* Navigation */}
      {currentStep > 0 && (
        <div className="mt-6 flex justify-between">
          <button
            onClick={handleBack}
            className="px-4 py-2 text-gray-600 hover:text-gray-800 flex items-center space-x-2"
          >
            <ChevronRightIcon className="w-4 h-4 rotate-180" />
            <span>Back</span>
          </button>
        </div>
      )}
    </div>
  );
};

export default SearchWorkflow;
