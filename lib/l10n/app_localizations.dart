import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DroneBook'**
  String get appTitle;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navFlightLogs.
  ///
  /// In en, this message translates to:
  /// **'Flight Logs'**
  String get navFlightLogs;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'DroneBook Login'**
  String get loginTitle;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInTitle;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @confirmationEmailNotice.
  ///
  /// In en, this message translates to:
  /// **'A confirmation email will be sent to verify your address'**
  String get confirmationEmailNotice;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @needAccountSignUp.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Sign up'**
  String get needAccountSignUp;

  /// No description provided for @alreadyHaveAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccountSignIn;

  /// No description provided for @errorDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorDialogTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @authErrorEmailRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please sign in or use a different email.'**
  String get authErrorEmailRegistered;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Use at least 8 characters with numbers and symbols.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorEmailNotConfirmedSignUp.
  ///
  /// In en, this message translates to:
  /// **'A confirmation email has been sent. Please check your inbox and confirm your email to activate your account.'**
  String get authErrorEmailNotConfirmedSignUp;

  /// No description provided for @authErrorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a few minutes before trying again.'**
  String get authErrorTooManyAttempts;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailNotConfirmedSignIn.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email before signing in. Check your email inbox.'**
  String get authErrorEmailNotConfirmedSignIn;

  /// No description provided for @authErrorTooManyAttemptsLater.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get authErrorTooManyAttemptsLater;

  /// No description provided for @authErrorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get authErrorUnexpected;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(Object message);

  /// No description provided for @accountCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Created'**
  String get accountCreatedTitle;

  /// No description provided for @accountCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully! A confirmation email has been sent to {email}. Please check your email and confirm your account to log in.'**
  String accountCreatedMessage(Object email);

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'DroneBook'**
  String get mapTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter address...'**
  String get searchHint;

  /// No description provided for @addressInvalid.
  ///
  /// In en, this message translates to:
  /// **'Address data is invalid'**
  String get addressInvalid;

  /// No description provided for @positionSet.
  ///
  /// In en, this message translates to:
  /// **'Position set: {lat}, {lng}'**
  String positionSet(Object lat, Object lng);

  /// No description provided for @addressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found'**
  String get addressNotFound;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Search error: {error}'**
  String searchError(Object error);

  /// No description provided for @flightRadiusLabel.
  ///
  /// In en, this message translates to:
  /// **'Flight radius'**
  String get flightRadiusLabel;

  /// No description provided for @radiusShow.
  ///
  /// In en, this message translates to:
  /// **'Show radius'**
  String get radiusShow;

  /// No description provided for @sampleNoFlyZoneName.
  ///
  /// In en, this message translates to:
  /// **'Airport Zone'**
  String get sampleNoFlyZoneName;

  /// No description provided for @sampleNoFlyZoneDesc.
  ///
  /// In en, this message translates to:
  /// **'No drone flights allowed'**
  String get sampleNoFlyZoneDesc;

  /// No description provided for @flightLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flight Logs'**
  String get flightLogsTitle;

  /// No description provided for @noLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'No flight logs yet'**
  String get noLogsTitle;

  /// No description provided for @noLogsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start logging your drone flights!'**
  String get noLogsSubtitle;

  /// No description provided for @deleteFlightLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Flight Log'**
  String get deleteFlightLogTitle;

  /// No description provided for @deleteFlightLogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this flight log?'**
  String get deleteFlightLogMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @flightLogDeleted.
  ///
  /// In en, this message translates to:
  /// **'Flight log deleted'**
  String get flightLogDeleted;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @addressLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get addressLoading;

  /// No description provided for @addressUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Address not available'**
  String get addressUnavailable;

  /// No description provided for @modelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelLabel;

  /// No description provided for @pilotLabel.
  ///
  /// In en, this message translates to:
  /// **'Pilot'**
  String get pilotLabel;

  /// No description provided for @coordinatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinatesLabel;

  /// No description provided for @maxAltitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Altitude'**
  String get maxAltitudeLabel;

  /// No description provided for @endTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTimeLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @weatherLabel.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @newFlightButton.
  ///
  /// In en, this message translates to:
  /// **'New Flight'**
  String get newFlightButton;

  /// No description provided for @logFlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Flight'**
  String get logFlightTitle;

  /// No description provided for @locationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Location not available. Please enable GPS or set a position on the map.'**
  String get locationNotAvailable;

  /// No description provided for @flightLogSaved.
  ///
  /// In en, this message translates to:
  /// **'Flight log saved successfully!'**
  String get flightLogSaved;

  /// No description provided for @flightLogSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save flight log. Check your Supabase configuration.'**
  String get flightLogSaveFailed;

  /// No description provided for @manualPosition.
  ///
  /// In en, this message translates to:
  /// **'Manually set position'**
  String get manualPosition;

  /// No description provided for @gpsPosition.
  ///
  /// In en, this message translates to:
  /// **'GPS position'**
  String get gpsPosition;

  /// No description provided for @gpsUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update GPS'**
  String get gpsUpdate;

  /// No description provided for @droneInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Drone Information'**
  String get droneInfoTitle;

  /// No description provided for @droneNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Drone Name *'**
  String get droneNameLabel;

  /// No description provided for @droneModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Drone Model *'**
  String get droneModelLabel;

  /// No description provided for @pilotNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Pilot Name'**
  String get pilotNameLabel;

  /// No description provided for @droneNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter drone name'**
  String get droneNameRequired;

  /// No description provided for @droneModelRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter drone model'**
  String get droneModelRequired;

  /// No description provided for @flightDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flight Details'**
  String get flightDetailsTitle;

  /// No description provided for @startTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTimeLabel;

  /// No description provided for @endTimeOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'End Time (Optional)'**
  String get endTimeOptionalLabel;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @maxAltitudeLabelMeters.
  ///
  /// In en, this message translates to:
  /// **'Max Altitude (meters)'**
  String get maxAltitudeLabelMeters;

  /// No description provided for @weatherConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Weather Conditions'**
  String get weatherConditionsLabel;

  /// No description provided for @saveFlightLog.
  ///
  /// In en, this message translates to:
  /// **'Save Flight Log'**
  String get saveFlightLog;

  /// No description provided for @adressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address: {address}'**
  String adressLabel(Object address);

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location: {lat}, {lng}'**
  String locationLabel(Object lat, Object lng);

  /// No description provided for @latLngLabel.
  ///
  /// In en, this message translates to:
  /// **'Lat: {lat}\nLng: {lng}'**
  String latLngLabel(Object lat, Object lng);

  /// No description provided for @aircraft_origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get aircraft_origin;

  /// No description provided for @aircraft_speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get aircraft_speed;

  /// No description provided for @aircraft_altitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get aircraft_altitude;

  /// No description provided for @aircraft_heading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get aircraft_heading;

  /// No description provided for @aircraft_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get aircraft_type;

  /// No description provided for @aircraft_onground.
  ///
  /// In en, this message translates to:
  /// **'On Ground'**
  String get aircraft_onground;

  /// No description provided for @weatherSunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get weatherSunny;

  /// No description provided for @weatherPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly Cloudy'**
  String get weatherPartlyCloudy;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherOvercast.
  ///
  /// In en, this message translates to:
  /// **'Overcast'**
  String get weatherOvercast;

  /// No description provided for @weatherLightRain.
  ///
  /// In en, this message translates to:
  /// **'Light Rain'**
  String get weatherLightRain;

  /// No description provided for @weatherRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get weatherRain;

  /// No description provided for @weatherThunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherThunderstorm;

  /// No description provided for @weatherSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get weatherSnow;

  /// No description provided for @weatherFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get weatherFog;

  /// No description provided for @weatherWindy.
  ///
  /// In en, this message translates to:
  /// **'Windy'**
  String get weatherWindy;

  /// No description provided for @aircraftCat0.
  ///
  /// In en, this message translates to:
  /// **'No information'**
  String get aircraftCat0;

  /// No description provided for @aircraftCat1.
  ///
  /// In en, this message translates to:
  /// **'Light (< 15500 lbs)'**
  String get aircraftCat1;

  /// No description provided for @aircraftCat2.
  ///
  /// In en, this message translates to:
  /// **'Small (15500 to 75000 lbs)'**
  String get aircraftCat2;

  /// No description provided for @aircraftCat3.
  ///
  /// In en, this message translates to:
  /// **'Large (75000 to 300000 lbs)'**
  String get aircraftCat3;

  /// No description provided for @aircraftCat4.
  ///
  /// In en, this message translates to:
  /// **'High Vortex Large'**
  String get aircraftCat4;

  /// No description provided for @aircraftCat5.
  ///
  /// In en, this message translates to:
  /// **'Heavy (> 300000 lbs)'**
  String get aircraftCat5;

  /// No description provided for @aircraftCat6.
  ///
  /// In en, this message translates to:
  /// **'High Performance (>5g accel and >400kt)'**
  String get aircraftCat6;

  /// No description provided for @aircraftCat7.
  ///
  /// In en, this message translates to:
  /// **'Rotorcraft'**
  String get aircraftCat7;

  /// No description provided for @aircraftCat8.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get aircraftCat8;

  /// No description provided for @aircraftCat9.
  ///
  /// In en, this message translates to:
  /// **'Glider / sailplane'**
  String get aircraftCat9;

  /// No description provided for @aircraftCat10.
  ///
  /// In en, this message translates to:
  /// **'Lighter-than-air'**
  String get aircraftCat10;

  /// No description provided for @aircraftCat11.
  ///
  /// In en, this message translates to:
  /// **'Parachutist / Skydiver'**
  String get aircraftCat11;

  /// No description provided for @aircraftCat12.
  ///
  /// In en, this message translates to:
  /// **'Ultralight / hang-glider / paraglider'**
  String get aircraftCat12;

  /// No description provided for @aircraftCat13.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get aircraftCat13;

  /// No description provided for @aircraftCat14.
  ///
  /// In en, this message translates to:
  /// **'Unmanned Aerial Vehicle'**
  String get aircraftCat14;

  /// No description provided for @aircraftCat15.
  ///
  /// In en, this message translates to:
  /// **'Space / Trans-atmospheric vehicle'**
  String get aircraftCat15;

  /// No description provided for @aircraftCat16.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get aircraftCat16;

  /// No description provided for @aircraftCat17.
  ///
  /// In en, this message translates to:
  /// **'Surface Vehicle - Emergency Vehicle'**
  String get aircraftCat17;

  /// No description provided for @aircraftCat18.
  ///
  /// In en, this message translates to:
  /// **'Surface Vehicle - Service Vehicle'**
  String get aircraftCat18;

  /// No description provided for @aircraftCat19.
  ///
  /// In en, this message translates to:
  /// **'Point Obstacle'**
  String get aircraftCat19;

  /// No description provided for @aircraftCat20.
  ///
  /// In en, this message translates to:
  /// **'Cluster Obstacle'**
  String get aircraftCat20;

  /// No description provided for @aircraftCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get aircraftCatOther;

  /// No description provided for @hideAircraft.
  ///
  /// In en, this message translates to:
  /// **'Hide Aircraft'**
  String get hideAircraft;

  /// No description provided for @showAircraft.
  ///
  /// In en, this message translates to:
  /// **'Show Aircraft'**
  String get showAircraft;

  /// No description provided for @flightRadius.
  ///
  /// In en, this message translates to:
  /// **'Flight Radius'**
  String get flightRadius;

  /// No description provided for @recentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Recently Used'**
  String get recentlyUsed;

  /// No description provided for @flightDesignation.
  ///
  /// In en, this message translates to:
  /// **'Flight Designation'**
  String get flightDesignation;

  /// No description provided for @flightDesignationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter flight designation'**
  String get flightDesignationRequired;

  /// No description provided for @droneIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Drone ID'**
  String get droneIdLabel;

  /// No description provided for @droneIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter drone ID'**
  String get droneIdRequired;

  /// No description provided for @windSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeedLabel;

  /// No description provided for @windSpeedUnit.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get windSpeedUnit;

  /// No description provided for @removeCustomWeather.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeCustomWeather;

  /// No description provided for @addCustomWeather.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Weather'**
  String get addCustomWeather;

  /// No description provided for @customWeatherLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Weather'**
  String get customWeatherLabel;

  /// No description provided for @customWeatherHint.
  ///
  /// In en, this message translates to:
  /// **'Enter weather condition'**
  String get customWeatherHint;

  /// No description provided for @windspeedLabel2.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windspeedLabel2;

  /// No description provided for @droneRegistrationId.
  ///
  /// In en, this message translates to:
  /// **'Drone Registration ID'**
  String get droneRegistrationId;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @availableLanguages.
  ///
  /// In en, this message translates to:
  /// **'Available Languages'**
  String get availableLanguages;
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
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
