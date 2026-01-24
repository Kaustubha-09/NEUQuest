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
- **Like/Dislike System**: Express approval or disapproval of events on the "Right Now" page to improve personalized recommendations
- **User Feedback Integration**: Continuous improvement based on user testing and feedback

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

#### Itinerary Planning Flow (Figures 1-a, 1-b, 1-c, 1-d)

![Itinerary Planning Wireframes](docs/images/Screenshot_2026-01-24_at_3.28.45_PM-e201d2f0-e1cc-47b1-9091-ba3432761a8e.png)

- **Add Activities Screen**: Intuitive interface for initiating activity addition to itineraries with a prominent plus icon
- **Event Details Input Form**: Comprehensive form for capturing event information including:
  - Event name, optional link, location, time
  - Budget amount (supporting the "Event Details and Budgeting" feature)
  - Category dropdown (enabling "Personalized Recommendations" based on interests)
- **Daily Itinerary View**: Timeline-based visualization showing:
  - Total budget amount prominently displayed
  - Date-specific scheduling
  - Time-stamped events (e.g., "Deadpool & Wolverine" at 10:00, "Lunch" from 13:00-14:00)
  - Tappable event cards for detailed views
- **Event Details Screen**: Comprehensive event information display including:
  - Event title, time range, budget, date, and location
  - Category classification
  - Edit functionality for user-created events

#### Budget Travel Planning Flow (Figures 2-a, 2-b, 2-c, 2-d)

![Budget Travel Planning Wireframes](docs/images/Screenshot_2026-01-24_at_3.29.23_PM-5dd3acc4-d266-47e8-8c6e-ec1358e88630.png)

- **Budget Input Screen**: Initial trip planning interface featuring:
  - Budget amount input (default: $150)
  - Checkboxes for including travel and meals in budget calculations
  - Travel party size selection
  - Interest update section with checkboxes (Music, Art, Sports, Photography)
  - "Plan a trip!" action button
- **Budget Allocation Visualization**: Pie chart breakdown showing:
  - Travel-related expenses
  - Event-related expenses
  - Food-related expenses
  - Option to add additional categories
  - Suggested budget alternatives ($75, $100 options)
- **Event Discovery Screen**: Search and filter interface with:
  - Search bar for events/deals
  - Interest and food-based filters
  - List of recommended activities with location pins
  - Trip planning progress indicator
- **Itinerary Timeline**: Chronological view of planned activities:
  - Time-stamped events (10am Art gallery, 12pm Travel options, 2pm Dining, etc.)
  - "Add to trip!" functionality for extending itineraries

### Prototypes

#### Prototype 1: Main Feed/Discovery Page (Figure 3)

![Prototype 1 - Main Feed](docs/images/Screenshot_2026-01-24_at_3.29.37_PM-b96b0c05-da76-4272-8974-387470b4fcc9.png)

- **Location-Based Content**: Dual location selector (Silicon Valley/Boston dropdown)
- **Event Card Design**: Prominent event listings featuring:
  - Venue name (e.g., "SAP Center")
  - Date and time range
  - Image placeholder
  - Event title/description (e.g., "San Jose Sharks")
  - "Details" link for comprehensive information
- **Navigation**: Bottom navigation bar with Explore, Alerts/Reports, Add, and Profile icons

#### Prototype 2: Deals & Events Feed (Figure 4)

![Prototype 2 - Deals Feed](docs/images/Screenshot_2026-01-24_at_3.29.47_PM-6fa3edf1-e760-4dd9-96a6-c30092a050af.png)

- **Search & Filter**: "Search Events / Deals" bar with "Interest based" filter dropdown
- **Content Cards**: Vertical feed of student-focused deals and events:
  - Image placeholders
  - Student discount highlights (e.g., "IKES sandwich student discount till 6pm!")
  - Event listings (e.g., "Art club event 3rd floor at 2 pm")
  - Grocery deals (e.g., "Sacred heart Santana row Student deals on groceries")
  - "Check this" action buttons on each card

### User Testing & Iterations

Based on user feedback, we implemented several key enhancements:

#### Collaborative Planning Feature (Final Screen Designs)

![Collaborative Planning Feature](docs/images/Screenshot_2026-01-24_at_3.30.19_PM-ed6f5824-f45f-4d97-903a-0c1812325572.png)

- **Feature Description**: Enables multiple users to work together on developing travel plans
- **Key Capabilities**:
  - Real-time editing
  - Commenting system
  - Task assignment
  - Version control
- **User Flow**: 
  - Users create a budget travel itinerary
  - Prompt to share with friends/collaborators
  - Option to add friends or decline sharing
- **Benefits**: Improves plan quality, increases alignment, and makes planning more efficient

#### Like/Dislike System (Right Now/Home Screen)

![Like/Dislike System - Right Now Screen](docs/images/Screenshot_2026-01-24_at_3.30.27_PM-7a6d565e-ee32-4a82-84d3-1d93ca37dd2e.png)

- **User Feedback**: Users requested easier ways to express approval or disapproval of events
- **Implementation**: Added like and dislike buttons to the "Right Now" page
- **Purpose**: Allows users to easily express sentiment towards displayed events, contributing to personalized feed curation and improved recommendations
- **Impact**: Enhances user engagement and enables algorithmic fine-tuning of home feed content

### Design Principles

- **Budget-First Approach**: Budget information is prominently displayed throughout the app
- **Student-Centric**: Exclusive focus on student deals and Northeastern University community
- **Intuitive Navigation**: Clear bottom navigation with consistent iconography
- **Timeline Visualization**: Visual representation of schedules and itineraries
- **Personalization**: Interest-based filtering and recommendations throughout

---

## 📸 Screenshots

### Design Wireframes & Prototypes

All wireframes and prototypes are included below, showcasing the complete design process from initial concepts to user-tested iterations.

#### Additional Design Assets

![Additional Wireframe](docs/images/image-d12b3cd5-c7d5-4955-b7f3-184e391c5026.png)

*Note: Screenshots of the final implemented UI will be added here as the app development progresses.*

---

## 🤝 Contributing

This project was developed as a collaborative effort for academic purposes. For questions or feedback, please contact the team members listed above.

---

**Built with ❤️ by Group 9**
