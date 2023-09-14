import 'package:cirilla/constants/app.dart' as acf;

class Endpoints {
  Endpoints._();

  // base url
  static const String restUrl = String.fromEnvironment('BASE_URL', defaultValue: "${acf.baseUrl}${acf.restPrefix}");
  static const String consumerKey = String.fromEnvironment('CONSUMER_KEY', defaultValue: acf.consumerKey);
  static const String consumerSecret = String.fromEnvironment('CONSUMER_SECRET', defaultValue: acf.consumerSecret);
  static const List<String> allowPathAuthenticationRestApiKeys = ['/wc/v3/', '/wc/v2/', '/wc-appointments/v1/'];

  // receiveTimeout
  static const int receiveTimeout = 50000;

  // connectTimeout
  static const int connectionTimeout = 50000;

  // Woocommerce API: ==================================================================================================

  // orders endpoints
  static const String getOrders = "/wc/v3/orders";

  // cancel order
  static const String cancelOrder = "/app-builder/v1/cancel-order";

  // products endpoints
  static const String getProducts = "/wc/v3/products";
  // get appointment time stamp
  static const String getAppointmentTimeStamp = "/wc-appointments/v1/slots";

  // get appointment staffs
  static const String getAppointmentStaffs = "/wc-appointments/v1/staff";

  // get appointment product
  static const String getAppointmentProduct = "/wc-appointments/v1/products";

  // product categories endpoints
  static const String getProductCategories = "/wc/v3/products/categories";

  // attributes endpoints
  static const String getAttributes = "/wc/v3/products/attributes";

  // Min - max price in category
  static const String getMinMaxPrices = "/wc/v3/min-max-prices";

  // Get Term Product Count
  static const String getTermProductCount = "/wc/v3/term-product-counts";

  // Get brand
  static const String getBrands = "/wc/v2/products/brands";

  // Like video product
  static const String likeProductVideo = "/app-builder-shopping-video-addons/v1/likes";

  // App Builder API: ==================================================================================================

  // categories endpoints
  static const String getCategories = "/app-builder/v1/categories";

  // Settings endpoints
  static const String getSettings = "/app-builder/v1/settings";

  static const String getTemplates = "/app-builder/v1/template-mobile";

  // Login with Email and Username
  static const String login = "/app-builder/v1/login";

  // Login with Facebook
  static const String loginFacebook = "/app-builder/v1/facebook";

  // Login with Google
  static const String loginGoogle = "/app-builder/v1/google";

  // Login with Apple
  static const String loginApple = "/app-builder/v1/apple";

  // Login with Facebook
  static const String loginWidthFacebook = "/app-builder/v1/facebook";

  // Login with Google
  static const String loginWithGoogle = "/app-builder/v1/google";

  // Login with Apple
  static const String loginWithApple = "/app-builder/v1/apple";

  // Login with OTP
  static const String loginWithOtp = "/app-builder/v1/login-otp";

  // Register
  static const String register = "/app-builder/v1/register";

  // Change Email
  static const String changeEmail = "/app-builder/v1/change-email";

  // Forgot password
  static const String forgotPassword = "/app-builder/v1/lost-password";

  // Forgot password
  static const String loginToken = "/app-builder/v1/login-token";

  // Change password
  static const String changePassword = "/app-builder/v1/change-password";

  // Variable endpoints
  static const String getProductVariable = "/app-builder/v1/product-variations";

  // Cart endpoints
  static const String current = "/app-builder/v1/current";

  // Update user token endpoints
  static const String updateUserToken = "/push-notify/v1/update-user-token";

  // Remove user token endpoints
  static const String removeUserToken = "/push-notify/v1/remove-user-token";

  // Remove all
  static const String removeAllNotify = "/push-notify/v1/delete";

  // Get notification by user_id
  static const String getNotify = "/push-notify/v1/notifications";

  /// Get unRead
  static const String getUnRead = "/push-notify/v1/unread";

  /// Get Read
  static const String putRead = "/push-notify/v1/read";

  // archives post
  static const String archives = "/app-builder/v1/archives";

  // vendor
  static const String getVendor = "/app-builder/v1/vendors";

  // Category vendor
  static const String getCategoryVendor = "/app-builder/v1/vendors/categories";

  // vendor
  static const String getCountryLocale = "/app-builder/v1/get-country-locale";

  // address
  static const String getAddress = "/app-builder/v1/address";

  static const String deleteAccount = "/app-builder/v1/delete";

  static const String sendOptDeleteAccount = "/app-builder/v1/send-otp-delete";

  static const String getCaptcha = "/app-builder/v1/captcha/get";
  static const String validateCaptcha = "/app-builder/v1/captcha/validate";
  static const String addressBooks = "/app-builder/v1/address-books";

  // Wordpress API: ====================================================================================================

  // Search
  static const String search = "/wp/v2/search";

  // Get posts
  static const String getPosts = "/wp/v2/posts";

  // Get post comments
  static const String getPostComments = "/wp/v2/comments";

  // Get post categories
  static const String getPostCategories = "/wp/v2/categories";

  // Get post categories
  static const String getPostAuthor = "/wp/v2/users";

  // Get post tags
  static const String getPostTags = "/wp/v2/tags";

  static const String getPage = "/wp/v2/pages";

  static const String getMedia = "/wp/v2/media";

  static const String getAmountBalance = "/wc/v2/wallet/balance";

  static const String getTransactionWallet = "/wc/v2/wallet";

  // Dokan API: ========================================================================================================

  static const String getDokanVendor = "/dokan/v1/stores";

  // Cart API: =========================================================================================================

  // Get cart list
  static const String getCart = "/wc/store/cart";

  // Add to cart
  static const String addToCart = "/wc/store/cart/add-item";

  // Apply coupon
  static const String applyCoupon = "/wc/store/cart/apply-coupon";

  // List coupon
  static const String coupons = "/wc/store/cart/coupons";

  // Remove coupon
  static const String removeCoupon = "/wc/store/cart/remove-coupon";

  // Remove cart
  static const String removeCart = "/wc/store/cart/remove-item";

  // Remove cart
  static const String checkout = "/wc/store/checkout";

  static const String progressServer = "/app-builder/v1/confirm-payment";

  // Remove cart
  static const String gateways = "/wc/v3/payment_gateways";

  // Clean cart
  static const String cleanCart = "/app-builder/v1/clean-cart";

  // Update cart
  static const String updateCart = "/wc/store/cart/update-item";

  /// shipping cart
  static const String shippingCart = '/wc/store/cart/select-shipping-rate';

  /// Update-customer cart
  static const String updateCustomerCart = '/wc/store/cart/update-customer';

  // Contact API: ======================================================================================================

  // orders endpoints
  static const String contactForm7 = "/contact-form-7/v1/contact-forms";

  // country
  static const String getCountries = "/wc/v3/data/countries";

  // update user account
  static const String postAccount = "/wp/v2/users";

  // update customer
  static const String postCustomer = "/app-builder/v1/customers";

  // update customer
  static const String getCustomer = "/wc/v3/customers";

  // Review API: =======================================================================================================

  // write review
  static const String writeReview = "/app-builder/v1/reviews";

  // get reviews
  static const String getReviews = "/wc/v3/products/reviews";

  // get rating count
  static const String ratingCount = "/app-builder/v1/rating-count";

  // Digits API: =======================================================================================================
  static const String digitsLogin = "/digits/v1/login_user";
  static const String digitsRegister = "/digits/v1/create_user";
  static const String digitsSendOtp = '/digits/v1/send_otp';
  static const String digitsReSendOtp = '/digits/v1/resend_otp';
  static const String digitsVerifyOtp = '/digits/v1/verify_otp';

  // Wishlist API: ======================================================================================================
  static const String getWishlistByUser = "/wc/v3/wishlist/get_by_user";

  static const String wishlistProduct = "/wc/v3/wishlist";

  static const String removeWishlistProduct = "/wc/v3/wishlist/remove_product";
}
