import { Routes, Route, Navigate } from 'react-router-dom'
import { Box } from '@mui/material'
import Layout from './components/Layout/Layout'
import HomePage from './pages/HomePage'
import SearchResults from './pages/SearchResults'
import DoctorProfile from './pages/DoctorProfile'
import HospitalProfile from './pages/HospitalProfile'
import BookingFlow from './pages/BookingFlow'
import LoginPage from './pages/Auth/LoginPage'
import RegisterPage from './pages/Auth/RegisterPage'
import DashboardPage from './pages/Dashboard/DashboardPage'
import TransportationPage from './pages/Transportation/TransportationPage'
import AccommodationPage from './pages/Accommodation/AccommodationPage'
import ChecklistPage from './pages/Checklist/ChecklistPage'
import MessagesPage from './pages/Messages/MessagesPage'
import PaymentPage from './pages/Payment/PaymentPage'
import ProfilePage from './pages/Profile/ProfilePage'
import PrivateRoute from './components/Auth/PrivateRoute'
import { useAuthStore } from './store/authStore'

function App() {
  const { isAuthenticated } = useAuthStore()

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<HomePage />} />
          <Route path="search" element={<SearchResults />} />
          <Route path="doctors/:doctorId" element={<DoctorProfile />} />
          <Route path="hospitals/:hospitalId" element={<HospitalProfile />} />
          <Route path="login" element={!isAuthenticated ? <LoginPage /> : <Navigate to="/dashboard" />} />
          <Route path="register" element={!isAuthenticated ? <RegisterPage /> : <Navigate to="/dashboard" />} />
          
          {/* Protected Routes */}
          <Route element={<PrivateRoute />}>
            <Route path="dashboard" element={<DashboardPage />} />
            <Route path="booking" element={<BookingFlow />} />
            <Route path="transportation" element={<TransportationPage />} />
            <Route path="accommodation" element={<AccommodationPage />} />
            <Route path="checklist" element={<ChecklistPage />} />
            <Route path="messages" element={<MessagesPage />} />
            <Route path="payment" element={<PaymentPage />} />
            <Route path="profile" element={<ProfilePage />} />
          </Route>
          
          <Route path="*" element={<Navigate to="/" replace />} />
        </Route>
      </Routes>
    </Box>
  )
}

export default App
