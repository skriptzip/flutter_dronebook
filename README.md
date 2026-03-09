# DroneBook

A Flutter application for drone pilots to track flights, view no-fly zones, and manage flight logs with Supabase backend integration.

## Features

- Interactive map using OpenStreetMap with current location
- Location search for places and addresses
- Flight logging with drone details and flight data
- No-fly zone (Flugverbotszonen) overlays
- Flight history list with details

## Getting Started

### Prerequisites

- Flutter SDK 3.11.0 or higher
- Supabase account and project

### Supabase Setup

1. Create a project at https://supabase.com
2. Copy your Project URL and Anon key from Project Settings -> API
3. Create the tables with the SQL below in the Supabase SQL editor

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

## iOS Permissions

Add these keys to [ios/Runner/Info.plist](ios/Runner/Info.plist):

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to show your position on the map</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to your location to track flights</string>
```
