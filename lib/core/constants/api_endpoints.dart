// core/constant/api_endpoints.dart

class ApiEndpoints {
  ApiEndpoints._();

  // Base
  static const String baseUrl = "https://amisysx.com/juris_law/public/api";

  // ==================== CLIENT ====================

  // --- Auth ---
  static const String clientRequestOtp = "/request_otp";
  static const String clientVerifyOtp = "/verify_otp";
  static const String clientLogout = "/logout";

  // --- Profile ---
  static const String clientProfile = "/profile"; // GET & POST
  static const String clientProfileComplete = "/profile/complete";

  // --- Dashboard ---
  static const String clientDashboard = "/dashboard";

  // --- Advocate Directory ---
  static const String advocateList = "/advocates"; // ?sort=recommended
  static const String advocateFilters = "/advocates/filters";
  static String advocateDetail(String advocateId) => "/advocates/$advocateId";
  static String advocateSlots(String advocateId) => "/advocates/$advocateId/slots";

  // --- Consultations (Client) ---
  static const String myBookings = "/bookings";
  static String bookingDetail(String bookingId) => "/bookings/$bookingId";
  static String bookSlot(String scheduleId) => "/schedules/$scheduleId/book";
  static String rescheduleAccept(String bookingId) =>
      "/bookings/$bookingId/reschedule/accept";
  static String rescheduleDecline(String bookingId) =>
      "/bookings/$bookingId/reschedule/decline";
  static String bookingCancel(String bookingId) => "/bookings/$bookingId/cancel";

  // --- Payments ---
  static String bookingPaymentSummary(String bookingId) =>
      "/bookings/$bookingId/payment";
  static String bookingPay(String bookingId) => "/bookings/$bookingId/pay";
  static String paymentStatus(String transactionId) =>
      "/payments/$transactionId";
  static const String myPayments = "/payments";

  // --- Live Session & Chat (shared with the advocate app) ---
  static String session(String bookingId) => "/session/$bookingId";
  static String sessionMessages(String bookingId) => "/session/$bookingId/messages";
  static String sessionSendMessage(String bookingId) => "/session/$bookingId/message";
  static String sessionEnd(String bookingId) => "/session/$bookingId/end";

  // --- Notifications (shared with the advocate app) ---
  static const String notifications = "/notifications";
  static const String notificationsUnreadCount = "/notifications/unread-count";
  static String notificationMarkRead(String notificationId) =>
      "/notifications/$notificationId/read";
  static const String notificationsReadAll = "/notifications/read-all";

  // ==================== ADVOCATE ====================
  //
  // // --- Auth ---
  // static const String advocateRegister = "/advocate/register";
  // static const String advocateRequestOtp = "/advocate/request_otp";
  // static const String advocateVerifyOtp = "/advocate/verify_otp";
  // static const String advocateLogout = "/advocate/logout";
  //
  // // --- Profile ---
  // static const String advocateProfile = "/advocate/profile"; // GET & POST
  //
  // // --- Dashboard ---
  // static const String advocateDashboard = "/advocate/dashboard";
  //
  // // --- Consultation Requests ---
  // static const String advocateConsultations = "/advocate/consultations";
  // static String consultationAccept(String bookingId) =>
  //     "/advocate/consultations/$bookingId/accept";
  // static String consultationReschedule(String bookingId) =>
  //     "/advocate/consultations/$bookingId/reschedule";
  // static String consultationAcceptRequest(String bookingId) =>
  //     "/advocate/consultations/$bookingId/accept-request";
  // static String consultationReject(String bookingId) =>
  //     "/advocate/consultations/$bookingId/reject";
  //
  // // --- Availability ---
  // static const String advocateSchedules = "/advocate/schedules"; // GET & POST
  // static String deleteSchedule(String scheduleId) =>
  //     "/advocate/schedules/$scheduleId";
  //
  // // --- Wallet & Verification ---
  // static const String advocateWallet = "/advocate/wallet";
  // static const String advocatePayouts = "/advocate/payouts";
  // static const String advocateVerification = "/advocate/verification";
  //
}