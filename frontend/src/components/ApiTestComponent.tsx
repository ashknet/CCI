import { useState } from 'react';
import { 
  hospitalServiceClient,
  userManagementClient, 
  messagingServiceClient,
  API_ENDPOINTS 
} from '../config/api';

const ApiTestComponent = () => {
  const [testResults, setTestResults] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  const addTestResult = (test: string, result: any, error?: any) => {
    setTestResults(prev => [...prev, {
      test,
      result,
      error,
      timestamp: new Date().toLocaleTimeString()
    }]);
  };

  const testHealthEndpoint = async () => {
    setLoading(true);
    try {
      const response = await hospitalServiceClient.get('/health');
      addTestResult('Hospital Service Health Check', response.data);
    } catch (error: any) {
      addTestResult('Hospital Service Health Check', null, error.response?.data || error.message);
    } finally {
      setLoading(false);
    }
  };

  const testSearchSuggestions = async () => {
    setLoading(true);
    try {
      const response = await hospitalServiceClient.get(`${API_ENDPOINTS.SEARCH.SUGGESTIONS}?query=hospital`);
      addTestResult('Search Suggestions', response.data);
    } catch (error: any) {
      addTestResult('Search Suggestions', null, error.response?.data || error.message);
    } finally {
      setLoading(false);
    }
  };

  const testHospitals = async () => {
    setLoading(true);
    try {
      const response = await hospitalServiceClient.get(`${API_ENDPOINTS.SEARCH.HOSPITALS}?query=hospital`);
      addTestResult('Hospital Search', response.data);
    } catch (error: any) {
      addTestResult('Hospital Search', null, error.response?.data || error.message);
    } finally {
      setLoading(false);
    }
  };

  const testDoctors = async () => {
    setLoading(true);
    try {
      const response = await hospitalServiceClient.get(`${API_ENDPOINTS.SEARCH.DOCTORS}?query=doctor`);
      addTestResult('Doctor Search', response.data);
    } catch (error: any) {
      addTestResult('Doctor Search', null, error.response?.data || error.message);
    } finally {
      setLoading(false);
    }
  };

  const testUserManagementHealth = async () => {
    setLoading(true);
    try {
      const response = await userManagementClient.get('/health');
      addTestResult('User Management Health Check', response.data);
    } catch (error: any) {
      addTestResult('User Management Health Check', null, error.response?.data || error.message);
    } finally {
      setLoading(false);
    }
  };

  const testMessagingHealth = async () => {
    setLoading(true);
    try {
      const response = await messagingServiceClient.get('/health');
      addTestResult('Messaging Service Health Check', response.data);
    } catch (error: any) {
      addTestResult('Messaging Service Health Check', null, error.response?.data || error.message);
    } finally {
      setLoading(false);
    }
  };

  const clearResults = () => {
    setTestResults([]);
  };

  return (
    <div className="max-w-4xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-6">Multi-Service API Test</h1>
      
      <div className="mb-6">
        <h2 className="text-xl font-semibold mb-4">API Endpoints Test</h2>
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          <button
            onClick={testHealthEndpoint}
            disabled={loading}
            className="btn-primary"
          >
            TA Service Health
          </button>
          <button
            onClick={testUserManagementHealth}
            disabled={loading}
            className="btn-primary"
          >
            User Management Health
          </button>
          <button
            onClick={testMessagingHealth}
            disabled={loading}
            className="btn-primary"
          >
            Messaging Health
          </button>
          <button
            onClick={testSearchSuggestions}
            disabled={loading}
            className="btn-primary"
          >
            Search Suggestions
          </button>
          <button
            onClick={testHospitals}
            disabled={loading}
            className="btn-primary"
          >
            Hospital Search
          </button>
          <button
            onClick={testDoctors}
            disabled={loading}
            className="btn-primary"
          >
            Doctor Search
          </button>
        </div>
        <button
          onClick={clearResults}
          className="btn-secondary mt-4"
        >
          Clear Results
        </button>
      </div>

      {loading && (
        <div className="text-center py-4">
          <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
          <p className="mt-2 text-gray-600">Testing API endpoints...</p>
        </div>
      )}

      <div className="space-y-4">
        <h3 className="text-lg font-semibold">Test Results</h3>
        {testResults.length === 0 ? (
          <p className="text-gray-600">No tests run yet. Click a button above to test the API.</p>
        ) : (
          testResults.map((result, index) => (
            <div key={index} className="card">
              <div className="flex justify-between items-start mb-2">
                <h4 className="font-semibold">{result.test}</h4>
                <span className="text-sm text-gray-500">{result.timestamp}</span>
              </div>
              
              {result.error ? (
                <div className="bg-red-50 border border-red-200 rounded p-3">
                  <p className="text-red-800 font-medium">Error:</p>
                  <pre className="text-red-700 text-sm mt-1 overflow-auto">
                    {JSON.stringify(result.error, null, 2)}
                  </pre>
                </div>
              ) : (
                <div className="bg-green-50 border border-green-200 rounded p-3">
                  <p className="text-green-800 font-medium">Success:</p>
                  <pre className="text-green-700 text-sm mt-1 overflow-auto max-h-64">
                    {JSON.stringify(result.result, null, 2)}
                  </pre>
                </div>
              )}
            </div>
          ))
        )}
      </div>

      <div className="mt-8 p-4 bg-blue-50 border border-blue-200 rounded">
        <h3 className="font-semibold text-blue-800 mb-2">API Configuration</h3>
        <div className="text-blue-700 text-sm space-y-2">
          <div>
            <strong>TA Service (Main):</strong> https://localhost:64686<br/>
            <span className="ml-4">• Health: /health</span><br/>
            <span className="ml-4">• Search: /search/suggest, /search/hospitals, /search/doctors</span><br/>
            <span className="ml-4">• Hospitals: /Hospitals/&#123;id&#125;</span><br/>
            <span className="ml-4">• Doctors: /Doctors/&#123;id&#125;</span><br/>
            <span className="ml-4">• Appointments: /Appointments/*</span>
          </div>
          <div>
            <strong>User Management:</strong> https://localhost:64687<br/>
            <span className="ml-4">• Auth: /auth/login, /auth/register, /auth/profile</span>
          </div>
          <div>
            <strong>Messaging Service:</strong> https://localhost:64688<br/>
            <span className="ml-4">• Messages: /message-threads, /messages</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ApiTestComponent;
