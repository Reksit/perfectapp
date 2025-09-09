class ApiConstants {
  static const String baseUrl = 'https://backend-7y12.onrender.com/api';
  
  // Auth endpoints
  static const String signin = '/auth/signin';
  static const String signup = '/auth/signup';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String changePassword = '/auth/change-password';
  
  // Assessment endpoints
  static const String generateAiAssessment = '/assessments/generate-ai';
  static const String studentAssessments = '/assessments/student';
  static const String professorAssessments = '/assessments/professor';
  static const String assessments = '/assessments';
  static const String searchStudents = '/assessments/search-students';
  
  // Task endpoints
  static const String tasks = '/tasks';
  
  // Chat endpoints
  static const String chatAi = '/chat/ai';
  static const String chatConversations = '/chat/conversations';
  static const String chatUsers = '/chat/users';
  static const String chatSend = '/chat/send';
  static const String chatHistory = '/chat/history';
  static const String chatMarkRead = '/chat/mark-read';
  
  // Management endpoints
  static const String managementStats = '/management/stats';
  static const String managementAlumni = '/management/alumni';
  static const String managementStudentsSearch = '/management/students/search';
  static const String managementAlumniAvailable = '/management/alumni-available';
  static const String managementAlumniEventRequests = '/management/alumni-event-requests';
  static const String managementEventRequests = '/management/management-event-requests';
  static const String managementRequestAlumniEvent = '/management/request-alumni-event';
  static const String managementStudentsAts = '/management/students/ats-data';
  static const String managementAiStudentAnalysis = '/management/ai-student-analysis';
  static const String managementSearchStudentProfiles = '/management/search-student-profiles';
  
  // Student endpoints
  static const String studentsProfile = '/students/profile';
  static const String studentsMyProfile = '/students/my-profile';
  static const String studentsAssessmentHistory = '/students/assessment-history';
  static const String studentsMyAssessmentHistory = '/students/my-assessment-history';
  
  // Professor endpoints
  static const String professorsProfile = '/professors/profile';
  static const String professorsMyProfile = '/professors/my-profile';
  static const String professorsTeachingStats = '/professors/teaching-stats';
  static const String professorsMyTeachingStats = '/professors/my-teaching-stats';
  
  // Alumni endpoints
  static const String alumniProfile = '/alumni/profile';
  static const String alumniMyProfile = '/alumni/my-profile';
  static const String alumniStats = '/alumni/stats';
  static const String alumniPendingRequests = '/alumni/pending-requests';
  static const String alumniAcceptManagementRequest = '/alumni/accept-management-request';
  static const String alumniRejectManagementRequest = '/alumni/reject-management-request';
  static const String alumniCompleteProfile = '/alumni-profiles/complete-profile';
  
  // Activity endpoints
  static const String activities = '/activities';
  static const String activitiesUser = '/activities/user';
  static const String activitiesHeatmap = '/activities/heatmap';
  
  // Connection endpoints
  static const String connectionsSendRequest = '/connections/send-request';
  static const String connectionsAccept = '/connections/accept';
  static const String connectionsReject = '/connections/reject';
  static const String connectionsPending = '/connections/pending';
  static const String connectionsAccepted = '/connections/accepted';
  static const String connectionsStatus = '/connections/status';
  static const String connectionsCount = '/connections/count';
  
  // Resume endpoints
  static const String resumesUpload = '/resumes/upload';
  static const String resumesMy = '/resumes/my';
  static const String resumesCurrent = '/resumes/current';
  static const String resumesAnalyzeAts = '/resumes/analyze-ats';
  static const String resumesSendAtsToManagement = '/resumes/send-ats-to-management';
  static const String resumesSearch = '/resumes/search';
  static const String resumesUser = '/resumes/user';
  static const String resumesManagementAll = '/resumes/management/all';
  static const String resumesManagementWithAts = '/resumes/management/with-ats';
  static const String resumesManagementAnalyzeStudents = '/resumes/management/analyze-students';
  
  // Alumni Directory endpoints
  static const String alumniDirectory = '/api/alumni-directory';
  static const String alumniDirectoryForAlumni = '/api/alumni-directory/for-alumni';
  static const String alumniDirectorySearch = '/api/alumni-directory/search';
  static const String alumniDirectoryStatistics = '/api/alumni-directory/statistics';
  
  // Events endpoints
  static const String eventsApproved = '/api/events/approved';
  static const String eventsAttendance = '/api/events/attendance';
  static const String alumniEventsRequest = '/api/alumni-events/request';
  static const String alumniEventsApproved = '/api/alumni-events/approved';
  
  // Circular endpoints
  static const String circulars = '/circulars';
  static const String circularsMyReceived = '/circulars/my-received';
  static const String circularsMySent = '/circulars/my-sent';
  static const String circularsUnreadCount = '/circulars/unread-count';
  static const String circularsStats = '/circulars/stats';
  static const String circularsAll = '/circulars/all';
  
  // Debug endpoints
  static const String debugEvents = '/debug/events';
}