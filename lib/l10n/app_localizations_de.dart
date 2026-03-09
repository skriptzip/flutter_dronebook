// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'DroneBook';

  @override
  String get navMap => 'Karte';

  @override
  String get navFlightLogs => 'Flugprotokolle';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get appearance => 'Darstellung';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get language => 'Sprache';

  @override
  String get account => 'Konto';

  @override
  String get logout => 'Abmelden';

  @override
  String get loginTitle => 'DroneBook Login';

  @override
  String get signInTitle => 'Anmelden';

  @override
  String get createAccountTitle => 'Konto erstellen';

  @override
  String get confirmationEmailNotice =>
      'Eine Bestatigungsmail wird gesendet, um deine Adresse zu verifizieren';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get emailRequired => 'Bitte E-Mail eingeben';

  @override
  String get emailInvalid => 'Bitte eine gultige E-Mail eingeben';

  @override
  String get passwordRequired => 'Bitte ein Passwort eingeben';

  @override
  String get passwordTooShort => 'Passwort muss mindestens 6 Zeichen haben';

  @override
  String get signInButton => 'Anmelden';

  @override
  String get signUpButton => 'Registrieren';

  @override
  String get needAccountSignUp => 'Noch kein Konto? Registrieren';

  @override
  String get alreadyHaveAccountSignIn => 'Schon ein Konto? Anmelden';

  @override
  String get errorDialogTitle => 'Fehler';

  @override
  String get ok => 'OK';

  @override
  String get authErrorEmailRegistered =>
      'Diese E-Mail ist bereits registriert. Bitte anmelden oder eine andere E-Mail verwenden.';

  @override
  String get authErrorInvalidEmail =>
      'Bitte eine gultige E-Mail-Adresse eingeben.';

  @override
  String get authErrorWeakPassword =>
      'Passwort ist zu schwach. Mindestens 8 Zeichen mit Zahlen und Symbolen verwenden.';

  @override
  String get authErrorEmailNotConfirmedSignUp =>
      'Eine Bestatigungsmail wurde gesendet. Bitte E-Mail prufen und Konto aktivieren.';

  @override
  String get authErrorTooManyAttempts =>
      'Zu viele Versuche. Bitte einige Minuten warten und erneut versuchen.';

  @override
  String get authErrorInvalidCredentials =>
      'E-Mail oder Passwort ist ungultig.';

  @override
  String get authErrorEmailNotConfirmedSignIn =>
      'Bitte E-Mail bestatigen. Prufe deinen Posteingang.';

  @override
  String get authErrorTooManyAttemptsLater =>
      'Zu viele Versuche. Bitte spater erneut versuchen.';

  @override
  String get authErrorUnexpected =>
      'Ein unerwarteter Fehler ist aufgetreten. Bitte erneut versuchen.';

  @override
  String errorWithMessage(Object message) {
    return 'Fehler: $message';
  }

  @override
  String get accountCreatedTitle => 'Konto erstellt';

  @override
  String accountCreatedMessage(Object email) {
    return 'Dein Konto wurde erfolgreich erstellt! Eine Bestatigungsmail wurde an $email gesendet. Bitte prufe deine E-Mail und bestatige dein Konto, um dich anzumelden.';
  }

  @override
  String get mapTitle => 'DroneBook';

  @override
  String get searchHint => 'Adresse eingeben...';

  @override
  String get addressInvalid => 'Adressdaten sind ungultig';

  @override
  String positionSet(Object lat, Object lng) {
    return 'Position gesetzt: $lat, $lng';
  }

  @override
  String get addressNotFound => 'Adresse nicht gefunden';

  @override
  String searchError(Object error) {
    return 'Suchfehler: $error';
  }

  @override
  String get flightRadiusLabel => 'Flugradius';

  @override
  String get radiusShow => 'Radius anzeigen';

  @override
  String get sampleNoFlyZoneName => 'Flughafen-Zone';

  @override
  String get sampleNoFlyZoneDesc => 'Keine Drohnenfluge erlaubt';

  @override
  String get flightLogsTitle => 'Flugprotokolle';

  @override
  String get noLogsTitle => 'Noch keine Flugprotokolle';

  @override
  String get noLogsSubtitle => 'Starte mit dem Protokollieren deiner Fluge!';

  @override
  String get deleteFlightLogTitle => 'Flugprotokoll loschen';

  @override
  String get deleteFlightLogMessage =>
      'Mochtest du dieses Flugprotokoll wirklich loschen?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Loschen';

  @override
  String get flightLogDeleted => 'Flugprotokoll geloscht';

  @override
  String get addressLabel => 'Adresse';

  @override
  String get addressLoading => 'Wird geladen...';

  @override
  String get addressUnavailable => 'Adresse nicht verfugbar';

  @override
  String get modelLabel => 'Modell';

  @override
  String get pilotLabel => 'Pilot';

  @override
  String get coordinatesLabel => 'Koordinaten';

  @override
  String get maxAltitudeLabel => 'Max. Hohe';

  @override
  String get endTimeLabel => 'Endzeit';

  @override
  String get durationLabel => 'Dauer';

  @override
  String get weatherLabel => 'Wetter';

  @override
  String get notesLabel => 'Notizen';

  @override
  String get newFlightButton => 'Neuer Flug';

  @override
  String get logFlightTitle => 'Flug protokollieren';

  @override
  String get locationNotAvailable =>
      'Position nicht verfugbar. Bitte GPS aktivieren oder Position auf der Karte setzen.';

  @override
  String get flightLogSaved => 'Flugprotokoll erfolgreich gespeichert!';

  @override
  String get flightLogSaveFailed =>
      'Flugprotokoll konnte nicht gespeichert werden. Prufe deine Supabase-Konfiguration.';

  @override
  String get manualPosition => 'Manuell gesetzte Position';

  @override
  String get gpsPosition => 'GPS Position';

  @override
  String get gpsUpdate => 'GPS aktualisieren';

  @override
  String get droneInfoTitle => 'Drohneninformationen';

  @override
  String get droneNameLabel => 'Drohnenname *';

  @override
  String get droneModelLabel => 'Drohnenmodell *';

  @override
  String get pilotNameLabel => 'Pilot Name';

  @override
  String get droneNameRequired => 'Bitte Drohnenname eingeben';

  @override
  String get droneModelRequired => 'Bitte Drohnenmodell eingeben';

  @override
  String get flightDetailsTitle => 'Flugdetails';

  @override
  String get startTimeLabel => 'Startzeit';

  @override
  String get endTimeOptionalLabel => 'Endzeit (optional)';

  @override
  String get notSet => 'Nicht gesetzt';

  @override
  String get maxAltitudeLabelMeters => 'Max. Hohe (Meter)';

  @override
  String get weatherConditionsLabel => 'Wetterbedingungen';

  @override
  String get saveFlightLog => 'Flugprotokoll speichern';

  @override
  String adressLabel(Object address) {
    return 'Addresse: $address';
  }

  @override
  String get notAvailable => 'Nicht verfügbar';

  @override
  String locationLabel(Object lat, Object lng) {
    return 'Position: $lat, $lng';
  }

  @override
  String latLngLabel(Object lat, Object lng) {
    return 'Breite: $lat\nLänge: $lng';
  }

  @override
  String get aircraft_origin => 'Herkunft';

  @override
  String get aircraft_speed => 'Geschwindigkeit';

  @override
  String get aircraft_altitude => 'Höhe';

  @override
  String get aircraft_heading => 'Kurs';

  @override
  String get aircraft_type => 'Typ';

  @override
  String get aircraft_onground => 'Am Boden';

  @override
  String get weatherSunny => 'Sonnig';

  @override
  String get weatherPartlyCloudy => 'Teilweise bewölkt';

  @override
  String get weatherCloudy => 'Bewölkt';

  @override
  String get weatherOvercast => 'Bedeckt';

  @override
  String get weatherLightRain => 'Leichter Regen';

  @override
  String get weatherRain => 'Regen';

  @override
  String get weatherThunderstorm => 'Gewitter';

  @override
  String get weatherSnow => 'Schnee';

  @override
  String get weatherFog => 'Nebel';

  @override
  String get weatherWindy => 'Windig';

  @override
  String get aircraftCat0 => 'Keine Information';

  @override
  String get aircraftCat1 => 'Leicht (< 15500 lbs)';

  @override
  String get aircraftCat2 => 'Klein (15500 bis 75000 lbs)';

  @override
  String get aircraftCat3 => 'Groß (75000 bis 300000 lbs)';

  @override
  String get aircraftCat4 => 'Hohe Wirbelschleppe Groß';

  @override
  String get aircraftCat5 => 'Schwer (> 300000 lbs)';

  @override
  String get aircraftCat6 => 'Hochleistung (>5g Beschl. und >400kt)';

  @override
  String get aircraftCat7 => 'Drehflügler';

  @override
  String get aircraftCat8 => 'Reserviert';

  @override
  String get aircraftCat9 => 'Segelflugzeug';

  @override
  String get aircraftCat10 => 'Leichter als Luft';

  @override
  String get aircraftCat11 => 'Fallschirmspringer';

  @override
  String get aircraftCat12 => 'Ultraleicht / Drachen / Gleitschirm';

  @override
  String get aircraftCat13 => 'Reserviert';

  @override
  String get aircraftCat14 => 'Unbemanntes Luftfahrzeug';

  @override
  String get aircraftCat15 => 'Weltraum / Trans-atmosphärisches Fahrzeug';

  @override
  String get aircraftCat16 => 'Reserviert';

  @override
  String get aircraftCat17 => 'Bodenfahrzeug - Einsatzfahrzeug';

  @override
  String get aircraftCat18 => 'Bodenfahrzeug - Servicefahrzeug';

  @override
  String get aircraftCat19 => 'Punkthindernis';

  @override
  String get aircraftCat20 => 'Gruppenhindernis';

  @override
  String get aircraftCatOther => 'Sonstiges';

  @override
  String get hideAircraft => 'Flugzeuge ausblenden';

  @override
  String get showAircraft => 'Flugzeuge anzeigen';

  @override
  String get flightRadius => 'Flugradius';

  @override
  String get recentlyUsed => 'Zuletzt verwendet';

  @override
  String get flightDesignation => 'Flugbezeichnung';

  @override
  String get flightDesignationRequired => 'Bitte Flugbezeichnung eingeben';

  @override
  String get droneIdLabel => 'Drohnen-ID';

  @override
  String get droneIdRequired => 'Bitte Drohnen-ID eingeben';

  @override
  String get windSpeedLabel => 'Windgeschwindigkeit';

  @override
  String get windSpeedUnit => 'km/h';

  @override
  String get removeCustomWeather => 'Entfernen';

  @override
  String get addCustomWeather => 'Benutzerdefiniertes Wetter hinzufügen';

  @override
  String get customWeatherLabel => 'Benutzerdefiniertes Wetter';

  @override
  String get customWeatherHint => 'Wetterbedingung eingeben';

  @override
  String get windspeedLabel2 => 'Windgeschwindigkeit';

  @override
  String get droneRegistrationId => 'Drohnen-Registrierungs-ID';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get availableLanguages => 'Verfügbare Sprachen';
}
