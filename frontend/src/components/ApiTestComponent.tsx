import { useState } from 'react';
import { apiClient, API_ENDPOINTS } from '../config/api';

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
      const response = await apiClient.get('/health');
      addTestResult('Health Check', response.data);
    } catch (error: any) {
      addTestResult('Health Check', null, error.response?.data || error.message);
    } finally {
      setLoading(false);
    }
  };

  const testSearchSuggestions = async () => {
    setLoading(true);
    try {
      const response = await apiClient.get(`${API_ENDPOINTS.SEARCH.SUGGESTIONS}?query=hospital`);
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
      const response = await apiClient.get(`${API_ENDPOINTS.SEARCH.HOSPITALS}?query=hospital`);
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
      const response = await apiClient.get(`${API_ENDPOINTS.SEARCH.DOCTORS}?query=doctor`);
      addTestResult('Doctor Search', response.data);
    } catch (error: any) {
      addTestResult('Doctor Search', null, error.response?.data || error.message);
    } finally {
      setLoading(false);
    }
  };

  const clearResults = () => {
    setTestResults([]);
  };

  return (
    <div className="max-w-4xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-6">Hospital Service API Test</h1>
      
      <div className="mb-6">
        <h2 className="text-xl font-semibold mb-4">API Endpoints Test</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <button
            onClick={testHealthEndpoint}
            disabled={loading}
            className="btn-primary"
          >
            Test Health
          </button>
          <button
            onClick={testSearchSuggestions}
            disabled={loading}
            className="btn-primary"
          >
            Test Suggestions
          </button>
          <button
            onClick={testHospitals}
            disabled={loading}
            className="btn-primary"
          >
            Test Hospitals
          </button>
          <button
            onClick={testDoctors}
            disabled={loading}
            className="btn-primary"
          >
            Test Doctors
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
        <p className="text-blue-700 text-sm">
          <strong>Base URL:</strong> https://localhost:64685/api<br/>
          <strong>Health Endpoint:</strong> /health<br/>
          <strong>Search Endpoints:</strong> /Search/suggestions, /Search/hospitals, /Search/doctors<br/>
          <strong>Hospital Endpoints:</strong> /Hospitals/&#123;id&#125;<br/>
          <strong>Doctor Endpoints:</strong> /Doctors/&#123;id&#125;<br/>
          <strong>Appointment Endpoints:</strong> /Appointments/*
        </p>
      </div>
    </div>
  );
};

export default ApiTestComponent;
