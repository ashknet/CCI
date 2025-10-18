import { Routes, Route } from 'react-router-dom'
import Layout from './components/Layout'
import HomePage from './pages/HomePage'
import SearchResultsPage from './pages/SearchResultsPage'
import DoctorProfilePage from './pages/DoctorProfilePage'
import HospitalProfilePage from './pages/HospitalProfilePage'
import AppointmentBookingPage from './pages/AppointmentBookingPage'
import TravelBookingPage from './pages/TravelBookingPage'
import AccommodationPage from './pages/AccommodationPage'
import CheckoutPage from './pages/CheckoutPage'
import MessagingPage from './pages/MessagingPage'
import ProfilePage from './pages/ProfilePage'
import MyBookingsPage from './pages/MyBookingsPage'
import LoginPage from './pages/LoginPage'
import RegisterPage from './pages/RegisterPage'
import BookingWizardPage from './pages/BookingWizardPage'
import ApiTestComponent from './components/ApiTestComponent'

function App() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />
      <Route path="/" element={<Layout />}>
        <Route index element={<HomePage />} />
        <Route path="search" element={<SearchResultsPage />} />
        <Route path="doctor/:id" element={<DoctorProfilePage />} />
        <Route path="hospital/:id" element={<HospitalProfilePage />} />
        <Route path="appointment/book" element={<AppointmentBookingPage />} />
        <Route path="travel" element={<TravelBookingPage />} />
        <Route path="accommodation" element={<AccommodationPage />} />
        <Route path="checkout" element={<CheckoutPage />} />
        <Route path="messages" element={<MessagingPage />} />
        <Route path="profile" element={<ProfilePage />} />
        <Route path="bookings" element={<MyBookingsPage />} />
        <Route path="wizard" element={<BookingWizardPage />} />
        <Route path="api-test" element={<ApiTestComponent />} />
      </Route>
    </Routes>
  )
}

export default App
