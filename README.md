# NEUQuest 🎯

**Discover Events. Plan Trips. Explore Your City.**

NEUQuest is a comprehensive Android application designed to help users discover local events and plan personalized trips with budget management. Built as a collaborative project for Northeastern University's Mobile Application Development course.

---

## 📱 Project Overview

NEUQuest bridges the gap between event discovery and trip planning, offering users a seamless way to explore what's happening around them and organize their adventures. The app combines real-time event discovery with intelligent trip planning features, making it easier than ever to make the most of your time and budget.

---

## ✨ Key Features

### 🔐 User Authentication & Profiles
- Secure Firebase Authentication with email verification
- User profile management with customizable interests
- Interest-based event recommendations
- Email verification reminders

### 🎪 Event Discovery
- **Right Now**: Discover events happening in real-time
- **Explore**: Browse events by category (Art, Nature, Photography, Travel, Music, Movies, Food, Sports)
- Event details with images, location, pricing, and registration links
- Comment system for community engagement
- Event reporting and moderation

### 🗺️ Trip Planning
- Create personalized trips with date ranges and locations
- Budget management with min/max budget settings
- Include/exclude meals and transportation in budget calculations
- Automatic event matching based on trip dates and location
- Timeline view for visualizing trip schedules
- Add multiple events to a single trip

### 🛠️ Admin Features
- Admin console for event moderation
- User and content management capabilities

---

## 🛠️ Technology Stack

### Core Technologies
- **Language**: Java
- **Platform**: Android (API 27+)
- **Build System**: Gradle with Kotlin DSL
- **Architecture**: MVC Pattern

### Backend & Services
- **Firebase Authentication**: User authentication and email verification
- **Firebase Realtime Database**: Real-time data synchronization
- **Firebase Storage**: Image storage and management
- **Google Generative AI**: AI-powered features

### Libraries & Dependencies
- **Picasso/Glide**: Image loading and caching
- **Material Design Components**: Modern UI components
- **Timeline View**: Trip timeline visualization
- **AndroidX Libraries**: AppCompat, ConstraintLayout, CoordinatorLayout
- **Work Manager**: Background task scheduling

---

## 📁 Project Structure

```
NEUQuest/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/edu/northeastern/numad24su_group9/
│   │   │   │   ├── Activities/
│   │   │   │   │   ├── MainActivity.java
│   │   │   │   │   ├── LoginActivity.java
│   │   │   │   │   ├── SignUpActivity.java
│   │   │   │   │   ├── RightNowActivity.java
│   │   │   │   │   ├── PlanningTripActivity.java
│   │   │   │   │   ├── EventDetailsActivity.java
│   │   │   │   │   └── ...
│   │   │   │   ├── model/
│   │   │   │   │   ├── Event.java
│   │   │   │   │   ├── Trip.java
│   │   │   │   │   ├── User.java
│   │   │   │   │   └── Comment.java
│   │   │   │   ├── firebase/
│   │   │   │   │   ├── AuthConnector.java
│   │   │   │   │   ├── DatabaseConnector.java
│   │   │   │   │   ├── StorageConnector.java
│   │   │   │   │   └── repository/
│   │   │   │   └── recycler/
│   │   │   │       ├── EventAdapter.java
│   │   │   │       ├── TripAdapter.java
│   │   │   │       └── ...
│   │   │   └── res/
│   │   │       ├── layout/
│   │   │       ├── values/
│   │   │       └── drawable/
│   │   └── androidTest/
└── gradle/
```

---

## 🚀 Getting Started

### Prerequisites
- Android Studio Hedgehog or later
- JDK 8 or higher
- Android SDK (API 27+)
- Firebase project with Authentication, Realtime Database, and Storage enabled

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd NEUQuest
   ```

2. **Set up Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password)
   - Enable Realtime Database
   - Enable Storage
   - Download `google-services.json` and place it in the `app/` directory

3. **Build and Run**
   ```bash
   ./gradlew build
   ```
   Or use Android Studio's built-in build and run functionality.

---

## 🎨 Features in Detail

### Event Management
- **Create Events**: Users can create events with details including title, description, date/time, location, price, category, and images
- **Browse Events**: Filter events by category or discover what's happening right now
- **Event Details**: View comprehensive event information with image galleries, location maps, and registration links
- **Comments**: Engage with the community through event comments

### Trip Planning
- **Smart Matching**: Automatically suggests events that match your trip dates and location
- **Budget Planning**: Set minimum and maximum budgets with options to include/exclude meals and transportation
- **Timeline Visualization**: See your trip schedule in an intuitive timeline format
- **Multi-Event Trips**: Add multiple events to create comprehensive trip itineraries

### User Experience
- **Interest-Based Discovery**: Select interests during signup to receive personalized event recommendations
- **Real-Time Updates**: Firebase Realtime Database ensures you always see the latest events
- **Offline Support**: Cached data allows basic functionality when offline
- **Modern UI**: Material Design components provide a polished, intuitive interface

---

## 👥 Team

**Group 9 - Northeastern University**

- **Kaustubha Eluri**
- **Agllai Papaj**
- **Winston Heinrichs**
- **Harshitha Chava**
- **Sampada Kulkarni**

---

## 📝 Course Information

**Course**: Mobile Application Development (NUMAD24Su)  
**Institution**: Northeastern University  
**Semester**: Summer 2024

---

## 🔒 Security & Privacy

- Email verification required for account activation
- Secure Firebase Authentication
- User-reported content moderation
- Admin oversight for content management

---

## 📄 License

This project was developed as part of a university course assignment.

---

## 🎯 Future Enhancements

Potential improvements for future iterations:
- Push notifications for event reminders
- Social features (friends, shared trips)
- Advanced filtering and search capabilities
- Integration with calendar apps
- Weather integration for trip planning
- Reviews and ratings system

---

## 📸 Screenshots

*Add screenshots of your app here to showcase the UI*

---

## 🤝 Contributing

This project was developed as a collaborative effort for academic purposes. For questions or feedback, please contact the team members listed above.

---

**Built with ❤️ by Group 9**
