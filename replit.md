# Smart Assessment and Feedback Monitoring System

## Overview

The Smart Assessment and Feedback Monitoring System is a comprehensive educational platform built with React and TypeScript frontend and Java Spring Boot backend. The system serves multiple user roles including Students, Professors, Alumni, and Management, providing tailored dashboards and functionality for each role. Key features include AI-powered assessments, alumni networking, job board, event management, attendance tracking, and real-time messaging.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **Framework**: React 18 with TypeScript for type safety
- **Routing**: React Router DOM for navigation and protected routes
- **Styling**: Tailwind CSS with custom design system featuring glassmorphism components
- **State Management**: React Context API for authentication and toast notifications
- **UI Components**: Custom reusable component library with professional Button, Input, Card, and Grid components
- **Animations**: GSAP for advanced animations and card interactions
- **Charts**: Recharts for data visualization and analytics

### Backend Architecture
- **Framework**: Java Spring Boot with RESTful API design
- **Authentication**: JWT-based authentication with role-based access control
- **Email Service**: Integrated email notifications for various system events
- **File Handling**: Resume and document management capabilities

### Data Storage Solutions
- **Database**: Uses ORM patterns (likely JPA/Hibernate based on Spring Boot setup)
- **User Data**: Comprehensive user profiles with role-specific fields (18+ additional fields for alumni profiles)
- **Assessment Data**: Question banks, assessment results, and analytics
- **Event Data**: Event requests, approvals, and attendance tracking
- **Connection Data**: Alumni networking and mentorship connections

### Authentication and Authorization
- **JWT Tokens**: Secure token-based authentication stored in localStorage
- **Role-Based Access**: Four user roles (STUDENT, PROFESSOR, ALUMNI, MANAGEMENT) with distinct permissions
- **Protected Routes**: Frontend route protection based on user roles
- **OTP Verification**: Email-based verification system for account activation

### Core Functional Modules

#### Assessment System
- AI-powered assessment generation with domain-specific questions
- Professor-created assessments with scheduling and auto-grading
- Real-time assessment taking with timer functionality
- Comprehensive analytics and performance insights

#### Alumni Network
- Complete alumni directory with advanced search and filtering
- Mentorship connection system with request/approval workflow
- Enhanced alumni profiles with 18+ additional fields (LinkedIn, GitHub, skills, etc.)
- Event request system for alumni-organized events

#### Job Board
- Comprehensive job posting with all details displayed directly in cards
- Smart application system with external URL integration
- Job filtering by type, location, and requirements
- Posted by tracking with poster information

#### Event Management
- Multi-level event approval workflow (Alumni → Management → Broadcasting)
- Event categorization and scheduling
- RSVP and attendance tracking
- Email notifications for all event status changes

#### Communication System
- Real-time chat functionality
- Circular/announcement system with read tracking
- Notification system with type-specific icons and actions
- Email integration for important updates

#### Activity Tracking
- Comprehensive activity heatmaps for student engagement
- Attendance management with multiple status options
- Progress tracking and analytics
- System health monitoring

### Design System
- **Glass Morphism**: Consistent glassmorphism design language throughout
- **Professional Components**: Standardized button variants, form inputs, and cards
- **Responsive Design**: Mobile-first approach with intelligent breakpoints
- **Animation Framework**: Smooth transitions and hover effects
- **Color System**: Extended primary, secondary, and gray color palettes
- **Typography**: Inter font family with proper weight hierarchy

### Error Handling and User Experience
- **Toast Notifications**: Comprehensive feedback system for user actions
- **Loading States**: Professional loading animations with branded elements
- **Error Boundaries**: Graceful error handling with user-friendly messages
- **Form Validation**: Client-side validation with helpful error messages
- **Responsive Behavior**: Adaptive layouts for all screen sizes

## External Dependencies

### Frontend Dependencies
- **React Ecosystem**: React 18.3.1, React DOM, React Router DOM 7.8.2
- **UI Libraries**: Lucide React (icons), GSAP (animations), Recharts (charts)
- **HTTP Client**: Axios 1.11.0 for API communication
- **Development Tools**: Vite (build tool), TypeScript, ESLint, Tailwind CSS with PostCSS

### Backend Dependencies
- **Spring Boot Framework**: Web, Data JPA, Security, DevTools
- **Database**: Spring Data JPA with MySQL support
- **Security**: Spring Security with JWT implementation
- **Communication**: Java Mail Sender for email notifications
- **Build Tool**: Maven for dependency management

### Third-Party Services
- **Email Service**: Integrated email system for notifications and verification
- **External APIs**: Support for external job application URLs and portfolio links
- **File Storage**: Resume and document upload capabilities
- **Real-time Features**: Chat and notification systems

### Development and Build Tools
- **Build System**: Vite for fast development and optimized production builds
- **Code Quality**: ESLint with TypeScript support and React-specific rules
- **Styling**: Tailwind CSS with Autoprefixer for cross-browser compatibility
- **Version Control**: Git-based development workflow