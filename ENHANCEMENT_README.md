# Rakshak App Enhancements

This document outlines the three new safety modules added to the Rakshak women's safety Flutter app.

## 🎨 Design System

The app now uses a modern color palette:
- **Deep Indigo** (#3D348B) - Primary background, headers, bottom navigation
- **Mint Green** (#3FE0D0) - Primary buttons, highlights, active states, map pins
- **Soft Sand** (#F5E6CC) - Card backgrounds, containers, neutral areas
- **Sunset Orange** (#FF6B35) - Alerts, "Report Crime" button, urgent highlights
- **Golden Amber** (#FFB703) - Icons, secondary buttons, category tags
- **SOS Red** (#FF0000) - SOS Button (unchanged)

Typography: Poppins font family with rounded card designs throughout.

## 🚨 New Safety Modules

### 1. WaySecure - Unsafe Zone Alerts

**Features:**
- Interactive map using Flutter OSM plugin with red polygon overlays for unsafe zones
- Real-time location monitoring with automatic alerts when entering flagged zones
- Bottom sheet with recent crime news when tapping unsafe zones
- "Report Unsafe Area" functionality with local database storage
- Local notifications and SMS alerts to trusted contacts
- Severity levels (1-5) for different zones

**Technical Implementation:**
- Uses `flutter_osm_plugin` for map functionality
- `flutter_local_notifications` for push alerts
- `telephony` package for SMS functionality
- SQLite database for storing unsafe zones and crime reports
- Real-time location tracking with `geolocator`

### 2. SheConnect - Anonymous Location-Based Group Chats

**Features:**
- New tab in bottom navigation for group chats
- Location-based group discovery within configurable radius
- Anonymous authentication (nickname only, no personal details)
- Real-time chat using Firebase Realtime Database
- Location sharing in chat with mint green highlights
- Group creation and management
- Member count and activity tracking

**Technical Implementation:**
- Firebase Realtime Database for chat synchronization
- Anonymous Firebase authentication
- Location-based group filtering
- Real-time message updates
- Anonymous user management

### 3. Voice-Activated SOS

**Features:**
- Voice wake word detection ("SOS", "Help", "Bachao", "Emergency", "Danger")
- Automatic SMS alerts to trusted contacts with GPS location
- Manual SOS trigger button
- Trusted contacts management
- SOS history logging
- Local notifications for voice activation

**Technical Implementation:**
- `speech_to_text` plugin for voice recognition
- `telephony` package for SMS functionality
- SQLite database for trusted contacts and SOS logs
- Real-time location tracking
- Local notification system

## 📱 Navigation Updates

The bottom navigation now includes 5 tabs:
1. **News** - Existing news functionality
2. **Safety Tools** - Existing safety tools
3. **Home** - Main dashboard with new safety module cards
4. **SheConnect** - New anonymous group chat feature
5. **Profile** - Existing profile/settings

## 🏠 Home Screen Integration

The home screen now includes:
- Emergency Services section (existing)
- New "Safety Modules" section with cards for:
  - WaySecure (Unsafe Zone Alerts)
  - Voice SOS (Voice-Activated Alerts)
- Interactive map section (existing)

## 🔧 Dependencies Added

```yaml
dependencies:
  flutter_osm_plugin: ^0.40.0
  flutter_local_notifications: ^17.2.2
  speech_to_text: ^7.0.0
  sms_maintained: ^0.2.3
  flutter_polyline_points: ^2.0.0
  uuid: ^4.4.0
```

## 🚀 Getting Started

1. Run `flutter pub get` to install new dependencies
2. The app will automatically initialize all new services
3. Grant necessary permissions (location, microphone, SMS) when prompted
4. Start using the new safety features from the home screen or navigation

## 🔐 Permissions Required

- **Location**: For unsafe zone detection and group location features
- **Microphone**: For voice-activated SOS functionality
- **SMS**: For sending emergency alerts to trusted contacts
- **Notifications**: For local push notifications

## 📊 Database Schema

### Unsafe Zones Database
- `unsafe_zones` table for storing flagged areas
- `crime_reports` table for incident reports
- `trusted_contacts` table for emergency contacts

### Voice SOS Database
- `trusted_contacts` table for emergency contacts
- `sos_logs` table for tracking SOS events

### SheConnect (Firebase)
- Real-time chat messages
- Group information and member management
- Anonymous user sessions

## 🎯 Key Features Summary

1. **WaySecure**: Proactive safety through unsafe zone awareness
2. **SheConnect**: Community support through anonymous group chats
3. **Voice SOS**: Hands-free emergency assistance
4. **Modern UI**: Consistent design system with new color palette
5. **Real-time Updates**: Live location tracking and instant notifications

All modules work together to provide comprehensive women's safety features while maintaining user privacy and anonymity where appropriate.
