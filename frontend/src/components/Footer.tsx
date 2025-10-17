const Footer = () => {
  return (
    <footer className="bg-gray-900 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h3 className="text-lg font-semibold mb-4">MedTravel</h3>
            <p className="text-gray-400 text-sm">
              Your trusted platform for medical tourism in India. Book appointments,
              travel, and accommodation all in one place.
            </p>
          </div>
          <div>
            <h4 className="font-semibold mb-4">Services</h4>
            <ul className="space-y-2 text-sm text-gray-400">
              <li><a href="#" className="hover:text-white">Find Hospitals</a></li>
              <li><a href="#" className="hover:text-white">Find Doctors</a></li>
              <li><a href="#" className="hover:text-white">Book Appointments</a></li>
              <li><a href="#" className="hover:text-white">Travel Planning</a></li>
            </ul>
          </div>
          <div>
            <h4 className="font-semibold mb-4">Support</h4>
            <ul className="space-y-2 text-sm text-gray-400">
              <li><a href="#" className="hover:text-white">Help Center</a></li>
              <li><a href="#" className="hover:text-white">Contact Us</a></li>
              <li><a href="#" className="hover:text-white">FAQs</a></li>
              <li><a href="#" className="hover:text-white">Terms of Service</a></li>
            </ul>
          </div>
          <div>
            <h4 className="font-semibold mb-4">Cities We Serve</h4>
            <ul className="space-y-2 text-sm text-gray-400">
              <li>Hyderabad</li>
              <li>Bangalore</li>
              <li>Mumbai</li>
              <li>Chennai</li>
            </ul>
          </div>
        </div>
        <div className="border-t border-gray-800 mt-8 pt-8 text-center text-sm text-gray-400">
          <p>&copy; 2025 MedTravel. All rights reserved.</p>
        </div>
      </div>
    </footer>
  )
}

export default Footer
