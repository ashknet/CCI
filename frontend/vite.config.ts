import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    port: 3000,
    proxy: {
      '/api/users': 'http://localhost:5001',
      '/api/hospitals': 'http://localhost:5002',
      '/api/search': 'http://localhost:5002',
      '/api/appointments': 'http://localhost:5002',
      '/api/transport': 'http://localhost:5003',
      '/api/accommodation': 'http://localhost:5003',
      '/api/messages': 'http://localhost:5004',
    },
  },
})
