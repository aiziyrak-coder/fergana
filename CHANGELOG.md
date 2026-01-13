# Changelog

All notable changes to the Smart City project will be documented in this file.

## [1.1.0] - 2026-01-13

### Fixed 🐛
- ✅ Updated API URLs from `smartcityapi.aiproduct.uz` to `ferganaapi.cdcgroup.uz`
- ✅ Fixed CORS issues by adding production domain to allowed origins
- ✅ Fixed CSRF issues by adding production domain to trusted origins
- ✅ Added production domains to `ALLOWED_HOSTS`
- ✅ Enabled secure cookies for HTTPS in production

### Changed 🔄
- Updated `frontend/services/api.ts` - API base URL
- Updated `frontend/services/auth.ts` - Auth base URL
- Updated `backend/smartcity_backend/settings.py` - Security and CORS settings
- Improved security headers for HTTPS

### Added ➕
- ✨ Created comprehensive deployment guide (`DEPLOY_GUIDE.md`)
- ✨ Added automated deployment script (`deploy.sh`)
- ✨ Added Nginx configuration files
- ✨ Added Gunicorn systemd service file
- ✨ Added server setup script (`setup-server.sh`)
- ✨ Added service health check script (`check-services.sh`)
- ✨ Added log viewer script (`logs.sh`)
- ✨ Added backup script (`backup.sh`)
- ✨ Created comprehensive README
- ✨ Environment variable examples

### Security 🔒
- Enabled HTTPS-only cookies
- Added security headers in Nginx
- Updated SSL/TLS configuration
- Implemented CSRF protection for production

---

## [1.0.0] - 2025-12-XX

### Initial Release 🎉
- ✅ Django backend with REST API
- ✅ React frontend with TypeScript
- ✅ Waste management module
- ✅ Climate control module
- ✅ Dashboard with real-time monitoring
- ✅ User authentication system
- ✅ Organization management
- ✅ IoT device integration
- ✅ Telegram bot integration
- ✅ QR code generation for waste bins
- ✅ Call center module
- ✅ Mobile-responsive design

### Modules
- **Markaz** - Main dashboard
- **Chiqindi** - Waste management
- **Issiqlik** - Climate control
- 9 locked modules (coming soon)

### Tech Stack
- Backend: Django 4.2.7 + DRF
- Frontend: React 18 + TypeScript + Vite
- Database: SQLite (dev) / PostgreSQL (prod)
- Styling: Tailwind CSS + Framer Motion

---

## Future Plans 🚀

### [1.2.0] - Planned
- [ ] Implement remaining locked modules
- [ ] Add PostgreSQL database
- [ ] Add Redis for caching
- [ ] Implement WebSocket for real-time updates
- [ ] Add data analytics dashboard
- [ ] Implement role-based permissions
- [ ] Add API rate limiting
- [ ] Implement automated testing
- [ ] Add CI/CD pipeline

### [1.3.0] - Planned
- [ ] Mobile application (React Native)
- [ ] Advanced reporting features
- [ ] Multi-language support
- [ ] Data export functionality
- [ ] Advanced search and filtering
- [ ] Integration with external systems

---

## Notes

This project follows [Semantic Versioning](https://semver.org/).

**Format:**
- **[MAJOR.MINOR.PATCH]**
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes (backward compatible)
