class ApiConstants {
  static const String baseUrl = 'https://backend-7y12.onrender.com/api';
  
  // Auth endpoints
  static const String login = '/auth/signin';
  static const String register = '/auth/signup';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String changePassword = '/auth/change-password';
  
  // Assessment endpoints
  static const String assessments = '/assessments';
  static const String generateAiAssessment = '/assessments/generate-ai';
  static const String studentAssessments = '/assessments/student';
  static const String professorAssessments = '/assessments/professor';
  static const String searchStudents = '/assessments/search-students';
  
  // Task endpoints
  static const String tasks = '/tasks';
  
  // Chat endpoints
  static const String chatAi = '/chat/ai';
  static const String chatConversations = '/chat/conversations';
  static const String chatUsers = '/chat/users';
  static const String chatHistory = '/chat/history';
  static const String chatSend = '/chat/send';
  static const String chatMarkRead = '/chat/mark-read';
  
  // Events endpoints
  static const String events = '/api/events';
  static const String eventsApproved = '/api/events/approved';
  static const String eventsAttendance = '/api/events/attendance';
  static const String debugEvents = '/debug/events';
  
  // Alumni endpoints
  static const String alumniDirectory = '/api/alumni-directory';
  static const String alumniDirectoryForAlumni = '/api/alumni-directory/for-alumni';
  static const String alumniEventRequest = '/api/alumni-events/request';
  
  // Job endpoints
  static const String jobs = '/jobs';
  
  // Circular endpoints
  static const String circulars = '/circulars';
  static const String myReceivedCirculars = '/circulars/my-received';
  static const String mySentCirculars = '/circulars/my-sent';
  
  // Management endpoints
  static const String managementStats = '/management/stats';
  static const String managementAlumni = '/management/alumni';
  static const String managementAlumniVerifications = '/management/alumni-verifications';
  
  // Student endpoints
  static const String studentProfile = '/students/my-profile';
  static const String studentDashboardStats = '/students/dashboard-stats';
  
  // Alumni endpoints
  static const String alumniProfile = '/alumni/my-profile';
  static const String alumniStats = '/alumni/stats';
  static const String alumniDashboardStats = '/alumni/dashboard-stats';
  
  // Professor endpoints
  static const String professorDashboardStats = '/professors/dashboard-stats';
  
  // Attendance endpoints
  static const String attendance = '/attendance';
  static const String attendanceStudents = '/attendance/students';
  static const String attendanceSubmit = '/attendance/submit';
  static const String attendanceRecords = '/attendance/professor/records';
  static const String attendanceStudentSummary = '/attendance/student/my-summary';
  
  // Connection endpoints
  static const String connections = '/connections';
  static const String connectionsPending = '/connections/pending-received';
  static const String connectionsAccepted = '/connections/accepted';
  static const String connectionsSent = '/connections/sent';
  static const String connectionsCount = '/connections/count';
  static const String connectionsStatus = '/connections/status';
  static const String connectionsSendRequest = '/connections/send-request';
  
  // Resume endpoints
  static const String resumes = '/resumes';
  static const String resumesUpload = '/resumes/upload';
  static const String resumesMy = '/resumes/my';
  static const String resumesCurrent = '/resumes/current';
  
  // Activity endpoints
  static const String activities = '/activities';
  static const String activitiesHeatmap = '/activities/heatmap';
  
  // Notification endpoints
  static const String notifications = '/notifications';
}