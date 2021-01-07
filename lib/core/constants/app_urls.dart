class AppUrls {
  static final base = "http://bulutreyon.test";

  static final api = "/api";

  static final baseApi = "$base$api";

  static final handshake = "$baseApi/handshake";

  static final sliders = "$baseApi/v1/sliders";

  static final categories = "$baseApi/v1/catalog/categories";
  static final products = "$baseApi/v1/catalog/products";
  static final showcaseTypes = "$baseApi/v1/catalog/showcase-types";

  static final login = "$baseApi/v1/member/login";
  static final register = "$baseApi/v1/member/register";
  static final forgotPassword = "$baseApi/v1/member/forgot-password";
  static final favorites = "$baseApi/v1/member/favorites";

  static final cartTotals = "$baseApi/v1/checkout/cart-totals";
  static final cart = "$baseApi/v1/checkout/cart";
  static final billingAddress = "$baseApi/v1/checkout/address/billing";
  static final deliveryAddress = "$baseApi/v1/checkout/address/delivery";
  static final payment = "$baseApi/v1/checkout/payment";
  static final result = "$baseApi/v1/checkout/result";
}