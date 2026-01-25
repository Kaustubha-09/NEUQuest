# NEUQuest 🎯

**Where Budget Meets Adventure**

NEUQuest is the ultimate companion for budget-conscious students at Northeastern University. Discover affordable travel destinations and dining options tailored to your interests and dietary requirements. Our app ensures that every adventure is both exciting and wallet friendly. Whether you're looking to explore new cities or find the best local eats, NEUQuest has you covered. Plan your trips effortlessly, get personalized recommendations, and enjoy exclusive student deals. Join NEUQuest today and let your budget meet adventure!

---

## 📱 Project Overview

NEUQuest is specifically designed for budget travelers enrolled at Northeastern University, providing a unique platform that combines affordable travel discovery with personalized dining recommendations. Unlike generic travel apps, NEUQuest focuses exclusively on the Northeastern University student community, offering tailored experiences and exclusive student deals.

---

## ✨ Key Features

### 🎯 Areas of Deep Exploration

#### 1. Dynamic User Types and Roles
- Implement different user types and admin roles to manage and dynamically affect shared data
- Role-based access control for content management
- Admin dashboard for platform oversight
- Collaborative planning with multiple users working on shared travel plans
- Real-time editing, commenting, and task assignment capabilities

#### 2. Messaging System
- Enable users to report suspicious content directly to admin roles for quick action
- Real-time communication between users and administrators
- Content moderation workflow

#### 3. Personalized Recommendations
- Use user-selected interests to recommend events and activities that match preferences
- Interest-based event discovery
- Tailored travel destination suggestions
- Dietary requirement filtering for dining options

#### 4. Event Details and Budgeting
- Incorporate event details such as location and cost to recommend trips that fit user budgets
- Budget-conscious trip planning with min/max budget settings
- Include/exclude meals and transportation in budget calculations
- Automatic event matching based on trip dates, location, and budget constraints

#### 5. User Engagement
- Track events that users find interesting to algorithmically fine-tune their home feed
- Enhanced engagement through personalized content curation
- User behavior analytics for improved recommendations

### 🔐 User Authentication & Profiles
- Secure Firebase Authentication with email verification
- User profile management with customizable interests
- Interest-based event recommendations
- Email verification reminders

### 🎪 Event & Destination Discovery
- **Right Now**: Discover events happening in real-time
- **Explore**: Browse events by category (Art, Nature, Photography, Travel, Music, Movies, Food, Sports)
- Event details with images, location, pricing, and registration links
- Affordable travel destination recommendations
- Dining options with dietary requirement filters
- Comment system for community engagement
- Event reporting and moderation

### 🗺️ Trip Planning
- Create personalized trips with date ranges and locations
- Budget management with min/max budget settings
- Include/exclude meals and transportation in budget calculations
- Automatic event matching based on trip dates and location
- Timeline view for visualizing trip schedules
- Add multiple events to a single trip
- Exclusive student deals integration
- **Collaborative Planning**: Multiple users can work together on developing travel plans with real-time editing, commenting, task assignment, and version control

### 🛠️ Admin Features
- Admin console for event moderation
- User and content management capabilities
- Messaging system for user reports

---

## 🛠️ Technology Stack

### Core Technologies
- **Language**: Java
- **Platform**: Android (API 27+)
- **Build System**: Gradle with Kotlin DSL
- **Architecture**: MVC Pattern

### Backend & Services
- **Firebase**: User accounts, data syncing, and sharing tools
  - Firebase Authentication: User authentication and email verification
  - Firebase Realtime Database: Real-time data synchronization
  - Firebase Storage: Image storage and management

### Libraries & Dependencies
- **Retrofit**: For making web service calls and fetching data easily
- **Room Database**: To store and manage app data locally on the user's device
- **RxJava/RxAndroid**: For handling asynchronous data and events
- **Glide**: For loading and displaying images quickly
- **Material Design Components**: To ensure a consistent look and feel with Android's official UI components and guidelines
- **Gson**: For converting web service data into Java objects
- **Dagger 2**: For managing the different components and parts of the app
- **Espresso**: For testing the app to ensure it works as expected
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

## 👥 Team

**Group 9 - Northeastern University**

- **Agllai Papaj**
- **Harshitha Chava**
- **Kaustubha Eluri**
- **Sampada Kulkarni**
- **Winston Heinrichs**

---

## 🎯 Target Users

Budget travelers enrolled at Northeastern University seeking affordable travel destinations and dining options tailored to their interests and dietary requirements.

## 🏆 Competitors & Market Analysis

### Competitors

1. **Wanderlog**
   - Trip planning app to build an itinerary
   - Users have complained about navigation difficulties and the cumbersome process of editing itineraries

2. **Tripadvisor**
   - App comparing hotel prices from over 200 booking sites worldwide
   - Criticized for outdated reviews and listings of permanently closed establishments

3. **Other Travel Planning Apps**
   - Various apps offer similar features but lack the exclusive focus on Northeastern University students that NEUQuest provides

### Themes in Competitor Reviews
- Navigation and usability issues
- Outdated information
- Lack of tailored recommendations

### NEUQuest's Competitive Advantage
- Exclusive focus on Northeastern University students
- Budget-conscious approach with student deals
- Personalized recommendations based on interests and dietary requirements
- Real-time, up-to-date information
- Intuitive navigation and user experience

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

## ✅ Project Feasibility

Yes! The team is confident in designing, building, and testing this app before the end of the semester. The chosen technology stack and architecture provide a solid foundation for rapid development and testing.

## 🎯 Future Enhancements

Potential improvements for future iterations:
- Push notifications for event reminders
- Social features (friends, shared trips)
- Advanced filtering and search capabilities
- Integration with calendar apps
- Weather integration for trip planning
- Reviews and ratings system
- Enhanced AI-powered recommendations
- Integration with more student discount platforms

---

## 🎨 UI/UX Design & Development Process

### Initial Wireframes

Our design process began with comprehensive wireframes that mapped out the core user flows:

#### Itinerary Planning Flow

![Itinerary Planning Wireframes](docs/images/Screenshot_2026-01-24_at_3.28.45_PM-e201d2f0-e1cc-47b1-9091-ba3432761a8e.png)

Wireframes showing the complete flow from adding activities, inputting event details (name, location, time, budget, category), viewing daily itineraries with timeline visualization, and accessing detailed event information screens.

#### Budget Travel Planning Flow

![Budget Travel Planning Wireframes](docs/images/Screenshot_2026-01-24_at_3.29.23_PM-5dd3acc4-d266-47e8-8c6e-ec1358e88630.png)

Complete budget travel workflow: budget input with travel/meal options, budget allocation visualization with pie charts, event discovery with search and filters, and itinerary timeline with chronological activity scheduling.

### Prototypes

#### Prototype 1: Main Feed/Discovery Page

![Prototype 1 - Main Feed](docs/images/Screenshot_2026-01-24_at_3.29.37_PM-b96b0c05-da76-4272-8974-387470b4fcc9.png)

Location-based event discovery with dual location selector, prominent event cards showing venue, date/time, and details, plus bottom navigation with Explore, Alerts, Add, and Profile options.

#### Prototype 2: Deals & Events Feed

![Prototype 2 - Deals Feed](docs/images/Screenshot_2026-01-24_at_3.29.47_PM-6fa3edf1-e760-4dd9-96a6-c30092a050af.png)

Student-focused deals feed with search bar, interest-based filters, and vertical cards showcasing student discounts, events, and grocery deals with action buttons.

### User Testing & Iterations

Based on user feedback, we implemented several key enhancements:

#### Collaborative Planning Feature

![Collaborative Planning Feature](docs/images/Screenshot_2026-01-24_at_3.30.19_PM-ed6f5824-f45f-4d97-903a-0c1812325572.png)

Enables multiple users to collaborate on travel plans with real-time editing, commenting, task assignment, and version control. Users can share itineraries with friends and work together to improve plan quality.

#### Like/Dislike System

![Like/Dislike System - Right Now Screen](docs/images/Screenshot_2026-01-24_at_3.30.27_PM-7a6d565e-ee32-4a82-84d3-1d93ca37dd2e.png)

Based on user feedback, added like/dislike buttons to the "Right Now" page, allowing users to express sentiment towards events and enabling algorithmic fine-tuning of personalized feed content.

### Design Principles

- **Budget-First Approach**: Budget information is prominently displayed throughout the app
- **Student-Centric**: Exclusive focus on student deals and Northeastern University community
- **Intuitive Navigation**: Clear bottom navigation with consistent iconography
- **Timeline Visualization**: Visual representation of schedules and itineraries
- **Personalization**: Interest-based filtering and recommendations throughout

![Additional Design Wireframe](docs/images/image-d12b3cd5-c7d5-4955-b7f3-184e391c5026.png)

---

## 📸 Live Demo Screenshots

### Welcome Screen

![Welcome Screen](docs/images/image-1e2d605e-0624-4382-8bf0-f718e7b98b51.png)

The initial entry point of NEUQuest, featuring a clean welcome interface with options to sign up or log in. The app uses a distinctive color scheme with light beige backgrounds and dark brown accent colors.

### Profile Screen

![Profile Screen](docs/images/image-f9e5bd82-a29e-4fb5-9af4-b10bcbd18c90.png)

User profile management screen displaying user information (name and email), profile picture, and account management options including editing interests, logout, and account deletion. Also shows planned trips section and bottom navigation.

### Trip Budget Screen

![Trip Budget Screen](docs/images/image-c7f8fab7-9fb8-4753-afa2-1937302717b2.png)

Budget planning interface with range slider for minimum and maximum budget selection, options to include meals and transport in budget calculations, and form fields for trip dates, times, and location.

### Create Event Screen

![Create Event Screen](docs/images/image-a32d20f4-cf0d-464e-abf7-93154a93d538.png)

Event creation form allowing users to input event details including name, description, price, start/end dates and times, location, and image selection. Features the consistent NEUQuest design language with dark brown header and light beige content area.

---

## 🤝 Contributing

This project was developed as a collaborative effort for academic purposes. For questions or feedback, please contact the team members listed above.

---

**Built with ❤️ by Group 9**
