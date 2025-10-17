import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { RootState } from '../store';
import { fetchSuggestions } from '../store/slices/searchSlice';
import { 
  ChevronRightIcon, 
  UserIcon, 
  BuildingOfficeIcon, 
  MapPinIcon, 
  HeartIcon,
  ClockIcon,
  StarIcon,
  PhoneIcon,
  GlobeAltIcon
} from '@heroicons/react/24/outline';

interface SearchWorkflowProps {
  onSelectionComplete?: (selection: any) => void;
}

interface WorkflowStep {
  type: 'search' | 'doctor' | 'hospital' | 'city' | 'disease';
  title: string;
  data?: any;
}

const SearchWorkflow: React.FC<SearchWorkflowProps> = ({ onSelectionComplete }) => {
  const dispatch = useDispatch();
  const { suggestions, loading } = useSelector((state: RootState) => state.search);
  
  const [workflowSteps, setWorkflowSteps] = useState<WorkflowStep[]>([
    { type: 'search', title: 'Search for hospitals, doctors, cities, or diseases' }
  ]);
  const [currentStep, setCurrentStep] = useState(0);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedItem, setSelectedItem] = useState<any>(null);

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
    try {
      let endpoint = '';
      let data = null;

      switch (suggestion.category.toLowerCase()) {
        case 'doctor':
          // Load doctor profile and availability
          endpoint = `/doctors/${suggestion.id}`;
          break;
        case 'hospital':
          // Load hospital doctors
          endpoint = `/hospitals/${suggestion.id}/doctors`;
          break;
        case 'city':
          // Load city hospitals
          endpoint = `/cities/${suggestion.id}/hospitals`;
          break;
        case 'disease':
          // Load disease doctors
          endpoint = `/diseases/${suggestion.id}/doctors`;
          break;
        case 'specialty':
          // Load doctors by specialty
          endpoint = `/doctors/specialty/${suggestion.id}`;
          break;
      }

      if (endpoint) {
        // TODO: Make API call to load data
        console.log(`Loading data from: ${endpoint}`);
      }
    } catch (error) {
      console.error('Error loading next level data:', error);
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
        {loading && (
          <div className="absolute right-3 top-1/2 transform -translate-y-1/2">
            <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-primary-500"></div>
          </div>
        )}
      </div>

      {suggestions.length > 0 && (
        <div className="bg-white border border-gray-200 rounded-lg shadow-lg max-h-96 overflow-y-auto">
          {suggestions.map((suggestion, index) => (
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

      {searchQuery.length >= 2 && suggestions.length === 0 && !loading && (
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
          <h4 className="font-medium text-gray-900">Next Steps:</h4>
          
          {selectedItem.category.toLowerCase() === 'doctor' && (
            <div className="space-y-3">
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900 mb-2">View Doctor Profile</h5>
                <p className="text-sm text-gray-600">See detailed information, reviews, and credentials</p>
                <button className="mt-2 px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600">
                  View Profile
                </button>
              </div>
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900 mb-2">Check Availability</h5>
                <p className="text-sm text-gray-600">See available appointment slots</p>
                <button className="mt-2 px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600">
                  Check Availability
                </button>
              </div>
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900 mb-2">Book Appointment</h5>
                <p className="text-sm text-gray-600">Schedule your appointment directly</p>
                <button className="mt-2 px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600">
                  Book Now
                </button>
              </div>
            </div>
          )}

          {selectedItem.category.toLowerCase() === 'hospital' && (
            <div className="space-y-3">
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900 mb-2">View Hospital Details</h5>
                <p className="text-sm text-gray-600">See hospital information, amenities, and reviews</p>
                <button className="mt-2 px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600">
                  View Details
                </button>
              </div>
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900 mb-2">Browse Doctors</h5>
                <p className="text-sm text-gray-600">See all doctors at this hospital</p>
                <button className="mt-2 px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600">
                  Browse Doctors
                </button>
              </div>
            </div>
          )}

          {selectedItem.category.toLowerCase() === 'city' && (
            <div className="space-y-3">
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900 mb-2">Browse Hospitals</h5>
                <p className="text-sm text-gray-600">See all hospitals in this city</p>
                <button className="mt-2 px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600">
                  Browse Hospitals
                </button>
              </div>
            </div>
          )}

          {selectedItem.category.toLowerCase() === 'disease' && (
            <div className="space-y-3">
              <div className="p-4 border border-gray-200 rounded-lg">
                <h5 className="font-medium text-gray-900 mb-2">Find Specialists</h5>
                <p className="text-sm text-gray-600">See doctors who treat this condition</p>
                <button className="mt-2 px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600">
                  Find Specialists
                </button>
              </div>
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
