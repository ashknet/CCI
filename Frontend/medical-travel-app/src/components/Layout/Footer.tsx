import { Box, Container, Grid, Typography, Link, IconButton } from '@mui/material'
import { Facebook, Twitter, LinkedIn, Instagram, Email, Phone } from '@mui/icons-material'

const Footer = () => {
  return (
    <Box
      component="footer"
      sx={{
        py: 6,
        px: 2,
        mt: 'auto',
        backgroundColor: (theme) => theme.palette.grey[900],
        color: 'white',
      }}
    >
      <Container maxWidth="lg">
        <Grid container spacing={4}>
          <Grid item xs={12} sm={4}>
            <Typography variant="h6" gutterBottom>
              Medical Travel Platform
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              Your trusted partner for global healthcare access. We connect you with top hospitals,
              doctors, and comprehensive travel services.
            </Typography>
            <Box>
              <IconButton color="inherit" aria-label="Facebook">
                <Facebook />
              </IconButton>
              <IconButton color="inherit" aria-label="Twitter">
                <Twitter />
              </IconButton>
              <IconButton color="inherit" aria-label="LinkedIn">
                <LinkedIn />
              </IconButton>
              <IconButton color="inherit" aria-label="Instagram">
                <Instagram />
              </IconButton>
            </Box>
          </Grid>

          <Grid item xs={12} sm={4}>
            <Typography variant="h6" gutterBottom>
              Quick Links
            </Typography>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
              <Link href="/search" color="inherit" underline="hover">
                Find Doctors
              </Link>
              <Link href="/search?type=hospitals" color="inherit" underline="hover">
                Browse Hospitals
              </Link>
              <Link href="/about" color="inherit" underline="hover">
                About Us
              </Link>
              <Link href="/faq" color="inherit" underline="hover">
                FAQ
              </Link>
              <Link href="/privacy" color="inherit" underline="hover">
                Privacy Policy
              </Link>
              <Link href="/terms" color="inherit" underline="hover">
                Terms of Service
              </Link>
            </Box>
          </Grid>

          <Grid item xs={12} sm={4}>
            <Typography variant="h6" gutterBottom>
              Contact Us
            </Typography>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1 }}>
              <Email fontSize="small" />
              <Typography variant="body2">support@medicaltravel.com</Typography>
            </Box>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
              <Phone fontSize="small" />
              <Typography variant="body2">+1 (800) 123-4567</Typography>
            </Box>
            <Typography variant="body2" sx={{ mt: 2 }}>
              Available 24/7 for support
            </Typography>
          </Grid>
        </Grid>

        <Box sx={{ mt: 5, pt: 3, borderTop: '1px solid rgba(255,255,255,0.1)' }}>
          <Typography variant="body2" align="center">
            © {new Date().getFullYear()} Medical Travel Booking Platform. All rights reserved.
          </Typography>
        </Box>
      </Container>
    </Box>
  )
}

export default Footer
