import 'package:flutter_dart_course/core/environment.dart';

class StripeServices {
  StripeServices._privateConstructor();
  static final StripeServices _instance = StripeServices._privateConstructor();
  static const String _baseUrl = 'https://api.stripe.com/v1';
  static String _publishableKey = Environment.stripePublishableKey;
  static String _secretKey = Environment.stripeSecretKey;

  // Add methods to interact with Stripe API here
  // For example, methods to create a payment intent, handle webhooks, etc.

  
}