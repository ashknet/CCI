import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useSelector, useDispatch } from 'react-redux'
import { RootState } from '../store/store'
import { logout } from '../store/slices/authSlice'

const Header = () => {
  const { t, i18n } = useTranslation()
  const dispatch = useDispatch()
  const { isAuthenticated, user } = useSelector((state: RootState) => state.auth)

  const toggleLanguage = () => {
    const newLang = i18n.language === 'en' ? 'hi' : 'en'
    i18n.changeLanguage(newLang)
  }

  return (
    <header className="bg-white shadow-sm border-b border-gray-200">
      <nav className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          <Link to="/" className="flex items-center space-x-2">
            <div className="w-10 h-10 bg-primary-600 rounded-lg flex items-center justify-center">
              <span className="text-white font-bold text-xl">MT</span>
            </div>
            <span className="text-xl font-bold text-gray-900">MedTravel</span>
          </Link>

          <div className="flex items-center space-x-6">
            <button
              onClick={toggleLanguage}
              className="text-gray-600 hover:text-gray-900 text-sm font-medium"
              aria-label="Toggle language"
            >
              {i18n.language === 'en' ? 'हिंदी' : 'English'}
            </button>

            {isAuthenticated ? (
              <>
                <Link to="/bookings" className="text-gray-600 hover:text-gray-900">
                  {t('bookings')}
                </Link>
                <Link to="/messages" className="text-gray-600 hover:text-gray-900">
                  {t('messages')}
                </Link>
                <Link to="/profile" className="text-gray-600 hover:text-gray-900">
                  {user?.firstName || t('profile')}
                </Link>
                <button
                  onClick={() => dispatch(logout())}
                  className="btn-secondary text-sm"
                >
                  {t('logout')}
                </button>
              </>
            ) : (
              <>
                <Link to="/login" className="btn-secondary text-sm">
                  {t('login')}
                </Link>
                <Link to="/register" className="btn-primary text-sm">
                  {t('register')}
                </Link>
              </>
            )}
          </div>
        </div>
      </nav>
    </header>
  )
}

export default Header
