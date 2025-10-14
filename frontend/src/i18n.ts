import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'

i18n.use(initReactI18next).init({
  resources: {
    en: {
      translation: {
        welcome: 'Welcome to MedTravel',
        search: 'Search',
        searchPlaceholder: 'Search hospitals, doctors, diseases, or locations...',
        login: 'Login',
        register: 'Register',
        logout: 'Logout',
        profile: 'Profile',
        bookings: 'My Bookings',
        messages: 'Messages',
        findDoctor: 'Find a Doctor',
        bookAppointment: 'Book Appointment',
        viewProfile: 'View Profile',
        bookNow: 'Book Now',
      },
    },
    hi: {
      translation: {
        welcome: 'मेडट्रैवल में आपका स्वागत है',
        search: 'खोज',
        searchPlaceholder: 'अस्पताल, डॉक्टर, रोग, या स्थान खोजें...',
        login: 'लॉगिन',
        register: 'पंजीकरण',
        logout: 'लॉगआउट',
        profile: 'प्रोफ़ाइल',
        bookings: 'मेरी बुकिंग',
        messages: 'संदेश',
      },
    },
  },
  lng: 'en',
  fallbackLng: 'en',
  interpolation: {
    escapeValue: false,
  },
})

export default i18n
