import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import SearchBar from '../components/SearchBar'

const HomePage = () => {
  const { t } = useTranslation()

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="bg-gradient-to-br from-primary-600 to-primary-800 text-white py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-5xl font-bold mb-6">
            {t('welcome')}
          </h1>
          <p className="text-xl mb-8 text-primary-100">
            Find top hospitals and doctors in India. Book appointments, travel, and accommodation seamlessly.
          </p>
          <div className="max-w-3xl mx-auto">
            <SearchBar large />
          </div>
          <div className="mt-8">
            <Link 
              to="/wizard" 
              className="inline-flex items-center px-8 py-4 bg-white text-primary-600 font-semibold rounded-lg hover:bg-gray-50 transition-colors shadow-lg"
            >
              🚀 Start Complete Medical Travel Booking
            </Link>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center mb-12">Why Choose MedTravel?</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              {
                title: 'Top Hospitals',
                description: 'Access to premier medical facilities in Hyderabad, Bangalore, and Mumbai',
                icon: '🏥',
              },
              {
                title: 'Expert Doctors',
                description: 'Consult with highly qualified specialists in various medical fields',
                icon: '👨‍⚕️',
              },
              {
                title: 'Complete Travel Support',
                description: 'We handle flights, trains, accommodation, and all logistics',
                icon: '✈️',
              },
              {
                title: 'Transparent Pricing',
                description: 'Clear cost breakdowns for medical, travel, and accommodation expenses',
                icon: '💰',
              },
              {
                title: 'Secure Messaging',
                description: 'Direct communication with healthcare providers before and after treatment',
                icon: '💬',
              },
              {
                title: 'Multilingual Support',
                description: 'Platform available in English, Hindi, Telugu, Tamil, and more',
                icon: '🌐',
              },
            ].map((feature, index) => (
              <div key={index} className="card text-center">
                <div className="text-4xl mb-4">{feature.icon}</div>
                <h3 className="text-xl font-semibold mb-2">{feature.title}</h3>
                <p className="text-gray-600">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Cities Section */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center mb-12">Cities We Serve</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {[
              { name: 'Hyderabad', image: '🏙️', hospitals: 50 },
              { name: 'Bangalore', image: '🌆', hospitals: 45 },
              { name: 'Mumbai', image: '🏢', hospitals: 60 },
            ].map((city, index) => (
              <div key={index} className="card hover:shadow-md transition-shadow cursor-pointer">
                <div className="text-6xl mb-4 text-center">{city.image}</div>
                <h3 className="text-2xl font-semibold text-center mb-2">{city.name}</h3>
                <p className="text-gray-600 text-center">{city.hospitals}+ Hospitals</p>
              </div>
            ))}
          </div>
        </div>
      </section>
    </div>
  )
}

export default HomePage
