# Campus Ride

A Flutter-based ride-sharing and transportation tracking application designed to make campus commutes safer, easier, and more connected for students and faculty.

## Features

* Live Location Tracking: Real-time map tracking using flutter_map and geolocator.
* Firebase Integration: Secure backend, user authentication, and real-time database updates via Firestore.
* Push Notifications: Stay updated on ride statuses with local and push notifications.
* Interactive Maps: OpenStreetMap integration via Flutter Map for accurate campus navigation.
* Cross-Platform: Beautiful and responsive UI for both iOS and Android.

## Tech Stack

* Frontend: Flutter & Dart
* Backend: Firebase (Core & Cloud Firestore)
* Mapping: flutter_map, latlong2
* Location Services: geolocator
* Notifications: flutter_local_notifications
* Storage & Networking: shared_preferences, http

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

* Install Flutter (Ensure you are on the latest stable channel)
* A Firebase project set up for Android/iOS

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/campus-ride.git
   ```
2. Navigate to the project directory:
   ```sh
   cd campus-ride
   ```
3. Install Flutter packages:
   ```sh
   flutter pub get
   ```
4. Set up Firebase:
   * Download your google-services.json (for Android) and GoogleService-Info.plist (for iOS) from your Firebase Console.
   * Place them in the respective android/app and ios/Runner directories.
5. Run the app:
   ```sh
   flutter run
   ```

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

1. Fork the Project
2. Create your Feature Branch (git checkout -b feature/AmazingFeature)
3. Commit your Changes (git commit -m 'Add some AmazingFeature')
4. Push to the Branch (git push origin feature/AmazingFeature)
5. Open a Pull Request
