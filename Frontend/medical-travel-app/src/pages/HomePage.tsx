import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  Box,
  Container,
  Typography,
  TextField,
  Button,
  Grid,
  Card,
  CardContent,
  InputAdornment,
} from '@mui/material'
import {
  Search,
  LocalHospital,
  Flight,
  Hotel,
  CheckCircle,
  Language,
  SupportAgent,
} from '@mui/icons-material'
import { useTranslation } from 'react-i18next'

const HomePage = () => {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const [searchQuery, setSearchQuery] = useState('')

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    if (searchQuery.trim()) {
      navigate(`/search?q=${encodeURIComponent(searchQuery)}`)
    }
  }

  const features = [
    {
      icon: <Search sx={{ fontSize: 40 }} />,
      title: t('home.features.search.title'),
      description: t('home.features.search.description'),
    },
    {
      icon: <LocalHospital sx={{ fontSize: 40 }} />,
      title: 'Top Healthcare Providers',
      description: 'Access world-class hospitals and experienced doctors globally',
    },
    {
      icon: <Flight sx={{ fontSize: 40 }} />,
      title: 'Travel Arrangements',
      description: 'Book flights, trains, and buses with ease',
    },
    {
      icon: <Hotel sx={{ fontSize: 40 }} />,
      title: 'Accommodation',
      description: 'Find medical-friendly hotels near your hospital',
    },
    {
      icon: <CheckCircle sx={{ fontSize: 40 }} />,
      title: t('home.features.checklist.title'),
      description: t('home.features.checklist.description'),
    },
    {
      icon: <SupportAgent sx={{ fontSize: 40 }} />,
      title: t('home.features.support.title'),
      description: t('home.features.support.description'),
    },
  ]

  return (
    <Box>
      {/* Hero Section */}
      <Box
        sx={{
          background: 'linear-gradient(135deg, #1976d2 0%, #00bcd4 100%)',
          color: 'white',
          py: 12,
        }}
      >
        <Container maxWidth="md">
          <Typography variant="h2" align="center" gutterBottom sx={{ fontWeight: 700 }}>
            {t('home.hero.title')}
          </Typography>
          <Typography variant="h6" align="center" sx={{ mb: 4, opacity: 0.95 }}>
            {t('home.hero.subtitle')}
          </Typography>

          <Box
            component="form"
            onSubmit={handleSearch}
            sx={{
              display: 'flex',
              gap: 1,
              backgroundColor: 'white',
              borderRadius: 2,
              p: 1,
              boxShadow: 3,
            }}
          >
            <TextField
              fullWidth
              placeholder={t('home.hero.searchPlaceholder')}
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              variant="outlined"
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Search />
                  </InputAdornment>
                ),
                sx: { backgroundColor: 'white' },
              }}
            />
            <Button
              type="submit"
              variant="contained"
              size="large"
              sx={{ minWidth: 120 }}
            >
              {t('common.search')}
            </Button>
          </Box>
        </Container>
      </Box>

      {/* Features Section */}
      <Container maxWidth="lg" sx={{ py: 8 }}>
        <Typography variant="h3" align="center" gutterBottom sx={{ mb: 6 }}>
          {t('home.features.title')}
        </Typography>

        <Grid container spacing={4}>
          {features.map((feature, index) => (
            <Grid item xs={12} sm={6} md={4} key={index}>
              <Card
                sx={{
                  height: '100%',
                  display: 'flex',
                  flexDirection: 'column',
                  transition: 'transform 0.2s',
                  '&:hover': {
                    transform: 'translateY(-8px)',
                    boxShadow: 4,
                  },
                }}
              >
                <CardContent sx={{ flexGrow: 1, textAlign: 'center', pt: 4 }}>
                  <Box sx={{ color: 'primary.main', mb: 2 }}>{feature.icon}</Box>
                  <Typography variant="h6" gutterBottom>
                    {feature.title}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    {feature.description}
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Container>

      {/* CTA Section */}
      <Box sx={{ backgroundColor: 'primary.main', color: 'white', py: 8 }}>
        <Container maxWidth="md" sx={{ textAlign: 'center' }}>
          <Typography variant="h4" gutterBottom>
            Ready to Start Your Healthcare Journey?
          </Typography>
          <Typography variant="body1" sx={{ mb: 4 }}>
            Join thousands of patients who have found quality healthcare worldwide
          </Typography>
          <Button
            variant="contained"
            size="large"
            color="secondary"
            onClick={() => navigate('/register')}
            sx={{ minWidth: 200 }}
          >
            Get Started
          </Button>
        </Container>
      </Box>

      {/* Stats Section */}
      <Container maxWidth="lg" sx={{ py: 8 }}>
        <Grid container spacing={4} sx={{ textAlign: 'center' }}>
          <Grid item xs={12} sm={3}>
            <Typography variant="h3" color="primary" gutterBottom>
              500+
            </Typography>
            <Typography variant="h6">Hospitals</Typography>
          </Grid>
          <Grid item xs={12} sm={3}>
            <Typography variant="h3" color="primary" gutterBottom>
              10,000+
            </Typography>
            <Typography variant="h6">Doctors</Typography>
          </Grid>
          <Grid item xs={12} sm={3}>
            <Typography variant="h3" color="primary" gutterBottom>
              50+
            </Typography>
            <Typography variant="h6">Countries</Typography>
          </Grid>
          <Grid item xs={12} sm={3}>
            <Typography variant="h3" color="primary" gutterBottom>
              100,000+
            </Typography>
            <Typography variant="h6">Happy Patients</Typography>
          </Grid>
        </Grid>
      </Container>
    </Box>
  )
}

export default HomePage
