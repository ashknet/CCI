import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'

const resources = {
  en: {
    translation: {
      common: {
        search: 'Search',
        submit: 'Submit',
        cancel: 'Cancel',
        save: 'Save',
        delete: 'Delete',
        edit: 'Edit',
        back: 'Back',
        next: 'Next',
        previous: 'Previous',
        loading: 'Loading...',
      },
      nav: {
        home: 'Home',
        search: 'Search',
        doctors: 'Doctors',
        hospitals: 'Hospitals',
        about: 'About',
        contact: 'Contact',
        login: 'Login',
        register: 'Register',
        dashboard: 'Dashboard',
        profile: 'Profile',
        logout: 'Logout',
      },
      home: {
        hero: {
          title: 'Your Global Healthcare Journey Starts Here',
          subtitle: 'Find top doctors, book appointments, and plan your medical travel with confidence',
          searchPlaceholder: 'Search for doctors, hospitals, or specialties...',
        },
        features: {
          title: 'Why Choose Us?',
          search: {
            title: 'Advanced Search',
            description: 'Find the perfect doctor or hospital based on specialty, location, and patient reviews',
          },
          booking: {
            title: 'Seamless Booking',
            description: 'Book appointments, transportation, and accommodation all in one place',
          },
          support: {
            title: '24/7 Support',
            description: 'Get help anytime with our dedicated support team',
          },
          checklist: {
            title: 'Travel Checklist',
            description: 'Stay organized with personalized pre-travel and post-op checklists',
          },
        },
      },
      auth: {
        login: {
          title: 'Welcome Back',
          subtitle: 'Login to access your medical travel dashboard',
          email: 'Email',
          password: 'Password',
          rememberMe: 'Remember me',
          forgotPassword: 'Forgot password?',
          noAccount: "Don't have an account?",
          signUp: 'Sign up',
        },
        register: {
          title: 'Create Your Account',
          subtitle: 'Start your medical travel journey today',
          firstName: 'First Name',
          lastName: 'Last Name',
          email: 'Email',
          password: 'Password',
          confirmPassword: 'Confirm Password',
          agreeTerms: 'I agree to the Terms and Conditions',
          haveAccount: 'Already have an account?',
          signIn: 'Sign in',
        },
      },
      dashboard: {
        title: 'Dashboard',
        welcome: 'Welcome back, {{name}}!',
        upcomingAppointments: 'Upcoming Appointments',
        recentSearches: 'Recent Searches',
        travelChecklist: 'Travel Checklist',
        messages: 'Messages',
        noAppointments: 'No upcoming appointments',
        bookNow: 'Book an Appointment',
      },
      search: {
        filters: {
          title: 'Filters',
          specialty: 'Specialty',
          location: 'Location',
          language: 'Language',
          rating: 'Minimum Rating',
          priceRange: 'Price Range',
          availability: 'Availability',
        },
        results: {
          title: 'Search Results',
          showing: 'Showing {{count}} results',
          noResults: 'No results found. Try adjusting your filters.',
        },
      },
      booking: {
        title: 'Book Appointment',
        selectDate: 'Select Date',
        selectTime: 'Select Time',
        reasonForVisit: 'Reason for Visit',
        specialRequirements: 'Special Requirements',
        confirmBooking: 'Confirm Booking',
        bookingSuccess: 'Booking confirmed successfully!',
      },
    },
  },
  es: {
    translation: {
      common: {
        search: 'Buscar',
        submit: 'Enviar',
        cancel: 'Cancelar',
        save: 'Guardar',
      },
      nav: {
        home: 'Inicio',
        search: 'Buscar',
        doctors: 'Doctores',
        hospitals: 'Hospitales',
      },
    },
  },
}

i18n
  .use(initReactI18next)
  .init({
    resources,
    lng: 'en',
    fallbackLng: 'en',
    interpolation: {
      escapeValue: false,
    },
  })

export default i18n
