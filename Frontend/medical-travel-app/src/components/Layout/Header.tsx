import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  IconButton,
  Menu,
  MenuItem,
  Avatar,
  Box,
  Container,
  useTheme,
  useMediaQuery,
} from '@mui/material'
import {
  LocalHospital,
  AccountCircle,
  Dashboard,
  Message,
  Settings,
  ExitToApp,
  Menu as MenuIcon,
} from '@mui/icons-material'
import { useAuthStore } from '@/store/authStore'
import { useTranslation } from 'react-i18next'

const Header = () => {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const theme = useTheme()
  const isMobile = useMediaQuery(theme.breakpoints.down('md'))
  const { isAuthenticated, user, clearAuth } = useAuthStore()
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null)
  const [mobileMenuAnchor, setMobileMenuAnchor] = useState<null | HTMLElement>(null)

  const handleProfileMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget)
  }

  const handleProfileMenuClose = () => {
    setAnchorEl(null)
  }

  const handleMobileMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
    setMobileMenuAnchor(event.currentTarget)
  }

  const handleMobileMenuClose = () => {
    setMobileMenuAnchor(null)
  }

  const handleLogout = () => {
    clearAuth()
    handleProfileMenuClose()
    navigate('/')
  }

  return (
    <AppBar position="sticky" color="primary" elevation={1}>
      <Container maxWidth="xl">
        <Toolbar disableGutters>
          {/* Logo */}
          <LocalHospital sx={{ display: { xs: 'none', md: 'flex' }, mr: 1 }} />
          <Typography
            variant="h6"
            noWrap
            component={Link}
            to="/"
            sx={{
              mr: 2,
              display: { xs: 'none', md: 'flex' },
              fontWeight: 700,
              color: 'inherit',
              textDecoration: 'none',
            }}
          >
            MedTravel
          </Typography>

          {/* Mobile Menu */}
          {isMobile && (
            <>
              <IconButton
                size="large"
                aria-label="menu"
                onClick={handleMobileMenuOpen}
                color="inherit"
              >
                <MenuIcon />
              </IconButton>
              <Menu
                anchorEl={mobileMenuAnchor}
                open={Boolean(mobileMenuAnchor)}
                onClose={handleMobileMenuClose}
              >
                <MenuItem onClick={() => { navigate('/'); handleMobileMenuClose(); }}>
                  {t('nav.home')}
                </MenuItem>
                <MenuItem onClick={() => { navigate('/search'); handleMobileMenuClose(); }}>
                  {t('nav.search')}
                </MenuItem>
                {isAuthenticated && (
                  <MenuItem onClick={() => { navigate('/dashboard'); handleMobileMenuClose(); }}>
                    {t('nav.dashboard')}
                  </MenuItem>
                )}
              </Menu>
            </>
          )}

          {/* Desktop Navigation */}
          {!isMobile && (
            <Box sx={{ flexGrow: 1, display: 'flex', ml: 3 }}>
              <Button color="inherit" component={Link} to="/">
                {t('nav.home')}
              </Button>
              <Button color="inherit" component={Link} to="/search">
                {t('nav.search')}
              </Button>
              {isAuthenticated && (
                <Button color="inherit" component={Link} to="/dashboard">
                  {t('nav.dashboard')}
                </Button>
              )}
            </Box>
          )}

          <Box sx={{ flexGrow: isMobile ? 1 : 0 }} />

          {/* User Menu */}
          {isAuthenticated ? (
            <>
              <IconButton
                size="large"
                aria-label="account of current user"
                onClick={handleProfileMenuOpen}
                color="inherit"
              >
                <Avatar sx={{ width: 32, height: 32, bgcolor: 'secondary.main' }}>
                  {user?.firstName?.charAt(0)}
                </Avatar>
              </IconButton>
              <Menu
                anchorEl={anchorEl}
                open={Boolean(anchorEl)}
                onClose={handleProfileMenuClose}
                transformOrigin={{ horizontal: 'right', vertical: 'top' }}
                anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
              >
                <MenuItem onClick={() => { navigate('/profile'); handleProfileMenuClose(); }}>
                  <AccountCircle sx={{ mr: 1 }} />
                  {t('nav.profile')}
                </MenuItem>
                <MenuItem onClick={() => { navigate('/dashboard'); handleProfileMenuClose(); }}>
                  <Dashboard sx={{ mr: 1 }} />
                  {t('nav.dashboard')}
                </MenuItem>
                <MenuItem onClick={() => { navigate('/messages'); handleProfileMenuClose(); }}>
                  <Message sx={{ mr: 1 }} />
                  Messages
                </MenuItem>
                <MenuItem onClick={handleLogout}>
                  <ExitToApp sx={{ mr: 1 }} />
                  {t('nav.logout')}
                </MenuItem>
              </Menu>
            </>
          ) : (
            <Box sx={{ display: 'flex', gap: 1 }}>
              <Button color="inherit" component={Link} to="/login">
                {t('nav.login')}
              </Button>
              <Button
                variant="contained"
                color="secondary"
                component={Link}
                to="/register"
                sx={{ display: { xs: 'none', sm: 'inline-flex' } }}
              >
                {t('nav.register')}
              </Button>
            </Box>
          )}
        </Toolbar>
      </Container>
    </AppBar>
  )
}

export default Header
