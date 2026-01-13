import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('ru'),
    Locale('tr')
  ];

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_back;

  /// No description provided for @login_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue your search'**
  String get login_to_continue;

  /// No description provided for @mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobile_number;

  /// No description provided for @send_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get send_verification_code;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_account;

  /// No description provided for @my_bookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get my_bookings;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'bookings'**
  String get bookings;

  /// No description provided for @my_favorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get my_favorites;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'favorites'**
  String get favorites;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'chats'**
  String get chats;

  /// No description provided for @select_theme.
  ///
  /// In en, this message translates to:
  /// **'select theme'**
  String get select_theme;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'select language'**
  String get select_language;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @become_a_renter.
  ///
  /// In en, this message translates to:
  /// **'Become a Renter'**
  String get become_a_renter;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @have_account.
  ///
  /// In en, this message translates to:
  /// **'Do you already have an account ? '**
  String get have_account;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @join_to_find.
  ///
  /// In en, this message translates to:
  /// **'Join us to find your perfect apartment !'**
  String get join_to_find;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @id_document_message.
  ///
  /// In en, this message translates to:
  /// **'Please upload a photo of your ID document for security purposes:'**
  String get id_document_message;

  /// No description provided for @upload_id_message.
  ///
  /// In en, this message translates to:
  /// **'Click to upload ID document'**
  String get upload_id_message;

  /// No description provided for @png_jpg.
  ///
  /// In en, this message translates to:
  /// **'PNG, JPG, PDF up to 10MB'**
  String get png_jpg;

  /// No description provided for @profile_image_message.
  ///
  /// In en, this message translates to:
  /// **'Choose a picture that suits you!\nIf you need that..\n\nyour profile picture will appear when you message your future apartment owner!'**
  String get profile_image_message;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @send_code.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get send_code;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get date_of_birth;

  /// No description provided for @six_digits.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 6-digit PIN code'**
  String get six_digits;

  /// No description provided for @field_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get field_required;

  /// No description provided for @image_required.
  ///
  /// In en, this message translates to:
  /// **'This image is required'**
  String get image_required;

  /// No description provided for @malaz.
  ///
  /// In en, this message translates to:
  /// **'MALAZ'**
  String get malaz;

  /// No description provided for @share_your_property.
  ///
  /// In en, this message translates to:
  /// **'Share your property details with us'**
  String get share_your_property;

  /// No description provided for @add_property.
  ///
  /// In en, this message translates to:
  /// **'Add property'**
  String get add_property;

  /// No description provided for @uploud_photo_property.
  ///
  /// In en, this message translates to:
  /// **'Click to upload photos of your property'**
  String get uploud_photo_property;

  /// No description provided for @essential_details.
  ///
  /// In en, this message translates to:
  /// **'Essential Details'**
  String get essential_details;

  /// No description provided for @bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms:'**
  String get bedrooms;

  /// No description provided for @bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms:'**
  String get bathrooms;

  /// No description provided for @bathrooms_no_dots.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathrooms_no_dots;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area:'**
  String get area;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @property_type.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get property_type;

  /// No description provided for @apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartment;

  /// No description provided for @villa.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get villa;

  /// No description provided for @house.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get house;

  /// No description provided for @farm.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get farm;

  /// No description provided for @country_house.
  ///
  /// In en, this message translates to:
  /// **'Country House'**
  String get country_house;

  /// No description provided for @location_details.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get location_details;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City:'**
  String get city;

  /// No description provided for @syria.
  ///
  /// In en, this message translates to:
  /// **'Syria'**
  String get syria;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate:'**
  String get governorate;

  /// No description provided for @damascus.
  ///
  /// In en, this message translates to:
  /// **'Damascus'**
  String get damascus;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address:'**
  String get address;

  /// No description provided for @address_loc.
  ///
  /// In en, this message translates to:
  /// **'Alhamak,bostan Aldoor'**
  String get address_loc;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @describe_property.
  ///
  /// In en, this message translates to:
  /// **'Describe your property details...'**
  String get describe_property;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @verified_host.
  ///
  /// In en, this message translates to:
  /// **'Verified Host'**
  String get verified_host;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @per_month.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get per_month;

  /// No description provided for @book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get book_now;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @new_.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_;

  /// No description provided for @network_error_message.
  ///
  /// In en, this message translates to:
  /// **'Network error occurred. Please check your internet connection and try again.'**
  String get network_error_message;

  /// No description provided for @request_cancelled_error_message.
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled'**
  String get request_cancelled_error_message;

  /// No description provided for @unexpected_error_message.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get unexpected_error_message;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @warring.
  ///
  /// In en, this message translates to:
  /// **'warring'**
  String get warring;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @identity_verification.
  ///
  /// In en, this message translates to:
  /// **'Identity verification'**
  String get identity_verification;

  /// No description provided for @identity_verification_input.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password to confirm identity'**
  String get identity_verification_input;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get current_password;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @incorrect_password.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Password'**
  String get incorrect_password;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'verification'**
  String get verify;

  /// No description provided for @profile_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated & Cached Successfully'**
  String get profile_updated_success;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @otp_sent_success.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to your phone'**
  String get otp_sent_success;

  /// No description provided for @enter_otp_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to you'**
  String get enter_otp_hint;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @confirm_new_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirm_new_password;

  /// No description provided for @password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get password_mismatch;

  /// No description provided for @password_changed_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed_success;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend_code;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get please_enter_password;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @wronge_otp.
  ///
  /// In en, this message translates to:
  /// **'The entered code is incorrect, please try again'**
  String get wronge_otp;

  /// No description provided for @otp_verified_success.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully'**
  String get otp_verified_success;

  /// No description provided for @booking_request_sent.
  ///
  /// In en, this message translates to:
  /// **'Booking Request Sent To The Owner'**
  String get booking_request_sent;

  /// No description provided for @nights.
  ///
  /// In en, this message translates to:
  /// **'nights'**
  String get nights;

  /// No description provided for @confirm_booking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirm_booking;

  /// No description provided for @reviews_count.
  ///
  /// In en, this message translates to:
  /// **'({count} reviews)'**
  String reviews_count(int count);

  /// No description provided for @no_description.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get no_description;

  /// No description provided for @baths.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get baths;

  /// No description provided for @click_to_view.
  ///
  /// In en, this message translates to:
  /// **'Click to view messages'**
  String get click_to_view;

  /// No description provided for @active_partners.
  ///
  /// In en, this message translates to:
  /// **'Active Partners'**
  String get active_partners;

  /// No description provided for @recent_messages.
  ///
  /// In en, this message translates to:
  /// **'Recent Messages'**
  String get recent_messages;

  /// No description provided for @malaz_chat.
  ///
  /// In en, this message translates to:
  /// **'Malaz Chat'**
  String get malaz_chat;

  /// No description provided for @no_conversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get no_conversations;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @delete_chat_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat?'**
  String get delete_chat_title;

  /// No description provided for @delete_chat_confirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove the conversation.'**
  String get delete_chat_confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @online_now.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get online_now;

  /// No description provided for @editing_message_hint.
  ///
  /// In en, this message translates to:
  /// **'Editing message...'**
  String get editing_message_hint;

  /// No description provided for @type_message_hint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_message_hint;

  /// No description provided for @edit_message.
  ///
  /// In en, this message translates to:
  /// **'Edit Message'**
  String get edit_message;

  /// No description provided for @copy_text.
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get copy_text;

  /// No description provided for @text_copied.
  ///
  /// In en, this message translates to:
  /// **'Text copied'**
  String get text_copied;

  /// No description provided for @delete_message.
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get delete_message;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get edited;

  /// No description provided for @no_favorites_yet.
  ///
  /// In en, this message translates to:
  /// **'No Favorites Yet'**
  String get no_favorites_yet;

  /// No description provided for @explore_and_save.
  ///
  /// In en, this message translates to:
  /// **'Start exploring and save your apartments here.'**
  String get explore_and_save;

  /// No description provided for @damascus_countryside.
  ///
  /// In en, this message translates to:
  /// **'Damascus Countryside'**
  String get damascus_countryside;

  /// No description provided for @jaramana.
  ///
  /// In en, this message translates to:
  /// **'Jaramana'**
  String get jaramana;

  /// No description provided for @aleppo.
  ///
  /// In en, this message translates to:
  /// **'Aleppo'**
  String get aleppo;

  /// No description provided for @homs.
  ///
  /// In en, this message translates to:
  /// **'Homs'**
  String get homs;

  /// No description provided for @hama.
  ///
  /// In en, this message translates to:
  /// **'Hama'**
  String get hama;

  /// No description provided for @latakia.
  ///
  /// In en, this message translates to:
  /// **'Latakia'**
  String get latakia;

  /// No description provided for @tartous.
  ///
  /// In en, this message translates to:
  /// **'Tartous'**
  String get tartous;

  /// No description provided for @idlib.
  ///
  /// In en, this message translates to:
  /// **'Idlib'**
  String get idlib;

  /// No description provided for @deir_alZor.
  ///
  /// In en, this message translates to:
  /// **'Deir ez-Zor'**
  String get deir_alZor;

  /// No description provided for @raqa.
  ///
  /// In en, this message translates to:
  /// **'Alraqa'**
  String get raqa;

  /// No description provided for @al_hasakah.
  ///
  /// In en, this message translates to:
  /// **'AL_Hasaka'**
  String get al_hasakah;

  /// No description provided for @daraa.
  ///
  /// In en, this message translates to:
  /// **'Daraa'**
  String get daraa;

  /// No description provided for @sweida.
  ///
  /// In en, this message translates to:
  /// **'Aweida'**
  String get sweida;

  /// No description provided for @quneitra.
  ///
  /// In en, this message translates to:
  /// **'Quneitra'**
  String get quneitra;

  /// No description provided for @property_manager.
  ///
  /// In en, this message translates to:
  /// **'Property Manager'**
  String get property_manager;

  /// No description provided for @add_new.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get add_new;

  /// No description provided for @my_properties.
  ///
  /// In en, this message translates to:
  /// **'My Properties'**
  String get my_properties;

  /// No description provided for @properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// No description provided for @inbound.
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get inbound;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @no_properties_found.
  ///
  /// In en, this message translates to:
  /// **'No properties added yet.'**
  String get no_properties_found;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @title_hint.
  ///
  /// In en, this message translates to:
  /// **'Jasmine Apartment'**
  String get title_hint;

  /// No description provided for @booking_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Confirming your booking...'**
  String get booking_in_progress;

  /// No description provided for @booking_success_title.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful!'**
  String get booking_success_title;

  /// No description provided for @booking_success_message.
  ///
  /// In en, this message translates to:
  /// **'We will contact you soon to confirm the details.'**
  String get booking_success_message;

  /// No description provided for @action_okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get action_okay;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @verified_account.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED ACCOUNT'**
  String get verified_account;

  /// No description provided for @unknown_location.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get unknown_location;

  /// No description provided for @back_to_top.
  ///
  /// In en, this message translates to:
  /// **'back to up'**
  String get back_to_top;

  /// No description provided for @filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filter Results'**
  String get filter_title;

  /// No description provided for @filter_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filter_reset;

  /// No description provided for @filter_location_section.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get filter_location_section;

  /// No description provided for @filter_current_location.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get filter_current_location;

  /// No description provided for @filter_map_location.
  ///
  /// In en, this message translates to:
  /// **'On Map'**
  String get filter_map_location;

  /// No description provided for @filter_price_section.
  ///
  /// In en, this message translates to:
  /// **'Price Range (Dollar \$)'**
  String get filter_price_section;

  /// No description provided for @filter_type_section.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get filter_type_section;

  /// No description provided for @filter_area_section.
  ///
  /// In en, this message translates to:
  /// **'Area (sqm)'**
  String get filter_area_section;

  /// No description provided for @filter_details_section.
  ///
  /// In en, this message translates to:
  /// **'Property Details'**
  String get filter_details_section;

  /// No description provided for @filter_total_rooms.
  ///
  /// In en, this message translates to:
  /// **'Total Rooms'**
  String get filter_total_rooms;

  /// No description provided for @filter_bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get filter_bedrooms;

  /// No description provided for @filter_bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get filter_bathrooms;

  /// No description provided for @filter_any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filter_any;

  /// No description provided for @filter_apply_button.
  ///
  /// In en, this message translates to:
  /// **'Show Matching Results'**
  String get filter_apply_button;

  /// No description provided for @type_apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get type_apartment;

  /// No description provided for @type_villa.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get type_villa;

  /// No description provided for @type_farm.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get type_farm;

  /// No description provided for @type_country_house.
  ///
  /// In en, this message translates to:
  /// **'Country House'**
  String get type_country_house;

  /// No description provided for @type_studio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get type_studio;

  /// No description provided for @phone_number_hint.
  ///
  /// In en, this message translates to:
  /// **'(963) 999 999 999'**
  String get phone_number_hint;

  /// No description provided for @enter_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter_hint;

  /// No description provided for @new_messages.
  ///
  /// In en, this message translates to:
  /// **'New Messages'**
  String get new_messages;

  /// No description provided for @modify_reservation.
  ///
  /// In en, this message translates to:
  /// **'Modify Reservation'**
  String get modify_reservation;

  /// No description provided for @changing_dates_for.
  ///
  /// In en, this message translates to:
  /// **'Changing dates for {propertyTitle}'**
  String changing_dates_for(Object propertyTitle);

  /// No description provided for @confirm_new_dates.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Dates'**
  String get confirm_new_dates;

  /// No description provided for @cancel_booking_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking?'**
  String get cancel_booking_title;

  /// No description provided for @cancel_booking_msg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your stay at {propertyTitle}? This action cannot be reversed.'**
  String cancel_booking_msg(Object propertyTitle);

  /// No description provided for @keep_stay.
  ///
  /// In en, this message translates to:
  /// **'Keep Stay'**
  String get keep_stay;

  /// No description provided for @yes_cancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yes_cancel;

  /// No description provided for @view_receipt.
  ///
  /// In en, this message translates to:
  /// **'View Receipt'**
  String get view_receipt;

  /// No description provided for @check_in.
  ///
  /// In en, this message translates to:
  /// **'CHECK-IN'**
  String get check_in;

  /// No description provided for @check_out.
  ///
  /// In en, this message translates to:
  /// **'CHECK-OUT'**
  String get check_out;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @status_pending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get status_pending;

  /// No description provided for @status_confirmed.
  ///
  /// In en, this message translates to:
  /// **'CONFIRMED'**
  String get status_confirmed;

  /// No description provided for @status_completed.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get status_completed;

  /// No description provided for @status_canceled.
  ///
  /// In en, this message translates to:
  /// **'CANCELED'**
  String get status_canceled;

  /// No description provided for @status_conflicted.
  ///
  /// In en, this message translates to:
  /// **'CONFLICT'**
  String get status_conflicted;

  /// No description provided for @rate_the_apartment.
  ///
  /// In en, this message translates to:
  /// **'Rate the Apartment'**
  String get rate_the_apartment;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get view_details;

  /// No description provided for @password_length_message.
  ///
  /// In en, this message translates to:
  /// **'The Password must contain at least 6 characters'**
  String get password_length_message;

  /// No description provided for @not_chat_yourself.
  ///
  /// In en, this message translates to:
  /// **'You can\'t chat with yourself'**
  String get not_chat_yourself;

  /// No description provided for @reviews_title.
  ///
  /// In en, this message translates to:
  /// **'Ratings & Reviews'**
  String get reviews_title;

  /// No description provided for @reviews_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get reviews_empty_title;

  /// No description provided for @reviews_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to review this property!'**
  String get reviews_empty_subtitle;

  /// No description provided for @error_generic_title.
  ///
  /// In en, this message translates to:
  /// **'Oops, something went wrong'**
  String get error_generic_title;

  /// No description provided for @action_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get action_retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
