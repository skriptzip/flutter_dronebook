// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DroneBook';

  @override
  String get navMap => 'Map';

  @override
  String get navFlightLogs => 'Flight Logs';

  @override
  String get navSettings => 'Settings';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Logout';

  @override
  String get loginTitle => 'DroneBook Login';

  @override
  String get signInTitle => 'Sign In';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get confirmationEmailNotice =>
      'A confirmation email will be sent to verify your address';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get emailRequired => 'Please enter an email';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Please enter a password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get signInButton => 'Sign In';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get needAccountSignUp => 'Need an account? Sign up';

  @override
  String get alreadyHaveAccountSignIn => 'Already have an account? Sign in';

  @override
  String get errorDialogTitle => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get authErrorEmailRegistered =>
      'This email is already registered. Please sign in or use a different email.';

  @override
  String get authErrorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get authErrorWeakPassword =>
      'Password is too weak. Use at least 8 characters with numbers and symbols.';

  @override
  String get authErrorEmailNotConfirmedSignUp =>
      'A confirmation email has been sent. Please check your inbox and confirm your email to activate your account.';

  @override
  String get authErrorTooManyAttempts =>
      'Too many attempts. Please wait a few minutes before trying again.';

  @override
  String get authErrorInvalidCredentials => 'Invalid email or password.';

  @override
  String get authErrorEmailNotConfirmedSignIn =>
      'Please confirm your email before signing in. Check your email inbox.';

  @override
  String get authErrorTooManyAttemptsLater =>
      'Too many attempts. Please try again later.';

  @override
  String get authErrorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String errorWithMessage(Object message) {
    return 'Error: $message';
  }

  @override
  String get accountCreatedTitle => 'Account Created';

  @override
  String accountCreatedMessage(Object email) {
    return 'Your account has been created successfully! A confirmation email has been sent to $email. Please check your email and confirm your account to log in.';
  }

  @override
  String get mapTitle => 'DroneBook';

  @override
  String get searchHint => 'Enter address...';

  @override
  String get addressInvalid => 'Address data is invalid';

  @override
  String positionSet(Object lat, Object lng) {
    return 'Position set: $lat, $lng';
  }

  @override
  String get addressNotFound => 'Address not found';

  @override
  String searchError(Object error) {
    return 'Search error: $error';
  }

  @override
  String get flightRadiusLabel => 'Flight radius';

  @override
  String get radiusShow => 'Show radius';

  @override
  String get sampleNoFlyZoneName => 'Airport Zone';

  @override
  String get sampleNoFlyZoneDesc => 'No drone flights allowed';

  @override
  String get flightLogsTitle => 'Flight Logs';

  @override
  String get noLogsTitle => 'No flight logs yet';

  @override
  String get noLogsSubtitle => 'Start logging your drone flights!';

  @override
  String get deleteFlightLogTitle => 'Delete Flight Log';

  @override
  String get deleteFlightLogMessage =>
      'Are you sure you want to delete this flight log?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get flightLogDeleted => 'Flight log deleted';

  @override
  String get addressLabel => 'Address';

  @override
  String get addressLoading => 'Loading...';

  @override
  String get addressUnavailable => 'Address not available';

  @override
  String get modelLabel => 'Model';

  @override
  String get pilotLabel => 'Pilot';

  @override
  String get coordinatesLabel => 'Coordinates';

  @override
  String get maxAltitudeLabel => 'Max Altitude';

  @override
  String get endTimeLabel => 'End Time';

  @override
  String get durationLabel => 'Duration';

  @override
  String get weatherLabel => 'Weather';

  @override
  String get notesLabel => 'Notes';

  @override
  String get newFlightButton => 'New Flight';

  @override
  String get logFlightTitle => 'Log Flight';

  @override
  String get locationNotAvailable =>
      'Location not available. Please enable GPS or set a position on the map.';

  @override
  String get flightLogSaved => 'Flight log saved successfully!';

  @override
  String get flightLogSaveFailed =>
      'Failed to save flight log. Check your Supabase configuration.';

  @override
  String get manualPosition => 'Manually set position';

  @override
  String get gpsPosition => 'GPS position';

  @override
  String get gpsUpdate => 'Update GPS';

  @override
  String get droneInfoTitle => 'Drone Information';

  @override
  String get droneNameLabel => 'Drone Name *';

  @override
  String get droneModelLabel => 'Drone Model *';

  @override
  String get pilotNameLabel => 'Pilot Name';

  @override
  String get droneNameRequired => 'Please enter drone name';

  @override
  String get droneModelRequired => 'Please enter drone model';

  @override
  String get flightDetailsTitle => 'Flight Details';

  @override
  String get startTimeLabel => 'Start Time';

  @override
  String get endTimeOptionalLabel => 'End Time (Optional)';

  @override
  String get notSet => 'Not set';

  @override
  String get maxAltitudeLabelMeters => 'Max Altitude (meters)';

  @override
  String get weatherConditionsLabel => 'Weather Conditions';

  @override
  String get saveFlightLog => 'Save Flight Log';

  @override
  String adressLabel(Object address) {
    return 'Address: $address';
  }

  @override
  String get notAvailable => 'Not available';

  @override
  String locationLabel(Object lat, Object lng) {
    return 'Location: $lat, $lng';
  }

  @override
  String latLngLabel(Object lat, Object lng) {
    return 'Lat: $lat\nLng: $lng';
  }

  @override
  String get aircraft_origin => 'Origin';

  @override
  String get aircraft_speed => 'Speed';

  @override
  String get aircraft_altitude => 'Altitude';

  @override
  String get aircraft_heading => 'Heading';

  @override
  String get aircraft_type => 'Type';

  @override
  String get aircraft_onground => 'On Ground';

  @override
  String get weatherSunny => 'Sunny';

  @override
  String get weatherPartlyCloudy => 'Partly Cloudy';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherOvercast => 'Overcast';

  @override
  String get weatherLightRain => 'Light Rain';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherFog => 'Fog';

  @override
  String get weatherWindy => 'Windy';

  @override
  String get aircraftCat0 => 'No information';

  @override
  String get aircraftCat1 => 'Light (< 15500 lbs)';

  @override
  String get aircraftCat2 => 'Small (15500 to 75000 lbs)';

  @override
  String get aircraftCat3 => 'Large (75000 to 300000 lbs)';

  @override
  String get aircraftCat4 => 'High Vortex Large';

  @override
  String get aircraftCat5 => 'Heavy (> 300000 lbs)';

  @override
  String get aircraftCat6 => 'High Performance (>5g accel and >400kt)';

  @override
  String get aircraftCat7 => 'Rotorcraft';

  @override
  String get aircraftCat8 => 'Reserved';

  @override
  String get aircraftCat9 => 'Glider / sailplane';

  @override
  String get aircraftCat10 => 'Lighter-than-air';

  @override
  String get aircraftCat11 => 'Parachutist / Skydiver';

  @override
  String get aircraftCat12 => 'Ultralight / hang-glider / paraglider';

  @override
  String get aircraftCat13 => 'Reserved';

  @override
  String get aircraftCat14 => 'Unmanned Aerial Vehicle';

  @override
  String get aircraftCat15 => 'Space / Trans-atmospheric vehicle';

  @override
  String get aircraftCat16 => 'Reserved';

  @override
  String get aircraftCat17 => 'Surface Vehicle - Emergency Vehicle';

  @override
  String get aircraftCat18 => 'Surface Vehicle - Service Vehicle';

  @override
  String get aircraftCat19 => 'Point Obstacle';

  @override
  String get aircraftCat20 => 'Cluster Obstacle';

  @override
  String get aircraftCatOther => 'Other';

  @override
  String get hideAircraft => 'Hide Aircraft';

  @override
  String get showAircraft => 'Show Aircraft';

  @override
  String get flightRadius => 'Flight Radius';

  @override
  String get recentlyUsed => 'Recently Used';

  @override
  String get flightDesignation => 'Flight Designation';

  @override
  String get flightDesignationRequired => 'Please enter flight designation';

  @override
  String get droneIdLabel => 'Drone ID';

  @override
  String get droneIdRequired => 'Please enter drone ID';

  @override
  String get windSpeedLabel => 'Wind Speed';

  @override
  String get windSpeedUnit => 'km/h';

  @override
  String get removeCustomWeather => 'Remove';

  @override
  String get addCustomWeather => 'Add Custom Weather';

  @override
  String get customWeatherLabel => 'Custom Weather';

  @override
  String get customWeatherHint => 'Enter weather condition';

  @override
  String get windspeedLabel2 => 'Wind Speed';

  @override
  String get droneRegistrationId => 'Drone Registration ID';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'German';

  @override
  String get availableLanguages => 'Available Languages';
}
