# Align App - Developer Guide

## 📋 Overview

Align is a wellness and mental health tracking Flutter application with a Flask backend. This guide provides comprehensive documentation for developers taking over or contributing to the project.

## 🏗️ Architecture Overview

### Frontend (Flutter)
The Flutter app follows a **Clean Architecture** pattern with clear separation of concerns:

```
lib/
├── core/                    # Core application logic
│   ├── constants/          # App-wide constants
│   ├── theme/             # Theming system
│   └── animations/        # Reusable animations
├── data/                   # Data layer
│   ├── models/            # Data models
│   ├── repositories/      # Repository pattern
│   └── services/          # API services
├── screens/               # UI screens
│   ├── checkin/          # Check-in flow screens
│   └── community/        # Community screens
└── shared/               # Shared widgets
    └── widgets/          # Reusable UI components
```

### Backend (Flask)
- **Framework**: Flask with CORS enabled
- **Database**: Firebase Firestore
- **AI Services**: Google Gemini AI, OpenAI, Replicate
- **Authentication**: API key-based authentication
- **Notifications**: Apple Push Notification Service (APNs)

## 🔑 Environment Setup

### Required Environment Variables (.env)
```env
# API Authentication
ALIGN_API_KEY=your_align_api_key_here

# AI Services
GEMINI_KEY=your_gemini_api_key_here
OPENAI_API_KEY=your_openai_api_key_here
REPLICATE_API_KEY=your_replicate_api_key_here

# Email Configuration
SMTP_SERVER=smtp.office365.com
SMTP_PORT=587
SMTP_USERNAME=your_smtp_username_here
SMTP_PASSWORD=your_smtp_password_here

# Backend URL
BACKEND_URL=http://localhost:5001
```

### Required Files
- `server-flask/align-admin.json`: Firebase Admin SDK credentials
- `server-flask/apns-dev-cert.pem`: Apple Push Notification certificate

## 🎨 Design System

### Theme System
All styling is centralized in the theme system:

- **Colors**: `lib/core/theme/app_colors.dart`
- **Typography**: `lib/core/theme/app_text_styles.dart`
- **Theme Configuration**: `lib/core/theme/app_theme.dart`
- **Constants**: `lib/core/constants/app_constants.dart`

### Usage Example
```dart
// Use predefined colors
Container(color: AppColors.primary)

// Use predefined text styles
Text('Hello', style: AppTextStyles.h1)

// Use predefined constants
BorderRadius.circular(AppConstants.borderRadius)
```

## 🧩 Reusable Components

### Animations
- **EarthAnimationWidget**: Animated rotating earth icon
- **ExitConfirmationWidget**: Double-tap exit confirmation with animation

### UI Components
- **CustomButton**: Configurable button with different types
- **CustomCard**: Consistent card styling with shadows
- **WellnessCard**: Specialized card for wellness content

### Usage Example
```dart
CustomButton(
  text: 'Save',
  type: ButtonType.primary,
  onPressed: () => _save(),
)

WellnessCard(
  title: 'Meditation',
  description: 'Daily meditation practice',
  progress: 0.6,
  completed: 6,
  total: 10,
  icon: Icons.self_improvement,
  onTap: () => _openMeditation(),
)
```

## 📊 Data Layer

### Models
All data models are located in `lib/data/models/`:
- **MoodOption**: Mood selection data
- **WellnessActivity**: Wellness activity data
- **CheckinData**: Complete check-in session data
- **ChatMessage**: AI coach chat messages
- **LearningModule**: AI-generated learning content

### Repository Pattern
Repositories abstract data access:
- **CheckinRepository**: Check-in related data operations
- **ApiService**: Centralized API communication

### Usage Example
```dart
final checkinRepo = CheckinRepository();
final moods = checkinRepo.getMoodOptions();
await checkinRepo.saveCheckinData(checkinData);
```

## 🔌 API Integration

### Backend Endpoints
- `GET /`: Service status check
- `POST /sendNotification/`: Send push notification
- `POST /createLearningModule`: Generate AI learning content
- `POST /sendSupportEmail`: Send support emails
- `GET /user/<user_id>`: Get user information
- `POST /generateImage`: Generate AI images

### API Service Usage
```dart
final apiService = ApiService();
final module = await apiService.createLearningModule(
  userId: 'user123',
  topic: 'Mindfulness',
  // ... other parameters
);
```

## 🧪 Testing Strategy

### Current Test Coverage
- **Widget Tests**: Comprehensive check-in flow testing (307 lines)
- **Test Location**: `test/checkin_flow_test.dart`

### Testing Approach
```dart
// Example widget test
testWidgets('Complete check-in flow', (WidgetTester tester) async {
  await tester.pumpWidget(const AlignApp());
  await tester.pumpAndSettle();
  
  // Test interactions
  await tester.tap(find.text('Check-in: How are you feeling?'));
  await tester.pumpAndSettle();
  
  // Verify navigation
  expect(find.text('How would you describe your mood?'), findsOneWidget);
});
```

### Recommended Test Additions
1. **Unit Tests**: Test business logic in repositories and services
2. **Integration Tests**: Test complete user flows
3. **API Tests**: Test backend endpoints
4. **Performance Tests**: Test animation performance

## 🔄 State Management

### Current Approach
- **Local State**: `setState()` for simple UI state
- **Data Persistence**: Repository pattern with API service

### Recommended Improvements
Consider implementing:
- **Provider** or **Riverpod** for global state management
- **Hive** or **SharedPreferences** for local data persistence
- **BLoC** pattern for complex state logic

## 🚀 Development Workflow

### Getting Started
1. **Clone Repository**
   ```bash
   git clone [repository-url]
   cd align-app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Set Environment Variables**
   - Update `.env` file with required API keys
   - Ensure backend credentials are in place

4. **Run Application**
   ```bash
   flutter run
   ```

### Code Style Guidelines
- **Imports**: Group imports by type (Flutter, core, data, screens, widgets)
- **Naming**: Use descriptive names for variables and methods
- **Comments**: Document complex logic and business rules
- **Formatting**: Use `dart format` for consistent formatting

### File Organization Rules
- **Animations**: Place in `core/animations/`
- **Reusable Widgets**: Place in `shared/widgets/`
- **Screen-specific Widgets**: Keep with respective screens
- **Models**: Place in `data/models/`
- **Services**: Place in `data/services/`

## 🎯 Key Features

### Check-in Flow
1. **Mood Selection**: Circular mood selector with gesture interaction
2. **Depth Analysis**: Tag selection and activity tracking
3. **Final Details**: Text input, photo upload, voice memo recording

### AI Coach
- **Chat Interface**: Real-time messaging with AI responses
- **Learning Modules**: AI-generated personalized content
- **Progress Tracking**: Conversation limits and usage analytics

### Wellness Tracking
- **Module Progress**: Visual progress indicators
- **Content Categories**: Learn vs Practice sections
- **Achievement System**: Completion tracking

### Community Features
- **Content Browsing**: Categorized wellness content
- **Media Types**: Articles, audio guides, quizzes
- **Engagement Features**: Favorites, sharing, progress tracking

## 🐛 Common Issues & Solutions

### Import Errors
- **Issue**: Missing imports after refactoring
- **Solution**: Use IDE auto-import or check file paths

### Theme Inconsistencies
- **Issue**: Hardcoded colors/styles
- **Solution**: Always use theme system constants

### Animation Performance
- **Issue**: Laggy animations on older devices
- **Solution**: Use `RepaintBoundary` and optimize custom painters

### API Connectivity
- **Issue**: Network timeouts or failures
- **Solution**: Implement proper error handling and retry logic

## 📈 Performance Optimization

### Current Optimizations
- **Reusable Components**: Reduced widget rebuilds
- **Theme System**: Consistent styling without redundancy
- **Repository Pattern**: Efficient data access

### Recommended Improvements
1. **Image Optimization**: Implement image caching and compression
2. **Lazy Loading**: Load content on demand
3. **Memory Management**: Proper disposal of controllers and streams
4. **Bundle Size**: Remove unused dependencies

## 🔒 Security Considerations

### API Security
- All endpoints require API key authentication
- Sensitive data encrypted in transit
- Firebase security rules properly configured

### Local Security
- API keys stored in environment variables
- No sensitive data in source code
- Proper certificate management for APNs

## 📱 Platform-Specific Notes

### iOS
- **APNs Setup**: Requires proper certificate configuration
- **Info.plist**: Configure permissions for camera, microphone
- **Bundle ID**: Ensure matches Apple Developer account

### Android
- **Permissions**: Configure in `AndroidManifest.xml`
- **Firebase**: Ensure `google-services.json` is included
- **ProGuard**: Configure rules for release builds

## 🚀 Deployment

### Frontend Deployment
```bash
# Build for release
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

### Backend Deployment
- **Platform**: Google Cloud Run
- **Container**: Docker-based deployment
- **Environment**: Production environment variables in Google Cloud Secret Manager

## 📞 Support & Maintenance

### Monitoring
- **Backend**: Google Cloud monitoring and logging
- **Frontend**: Firebase Crashlytics (recommended)
- **Analytics**: Firebase Analytics (recommended)

### Maintenance Tasks
- **Regular Updates**: Keep dependencies updated
- **Security Patches**: Monitor for security vulnerabilities
- **Performance Monitoring**: Track app performance metrics
- **User Feedback**: Implement feedback collection system

## 🤝 Contributing

### Code Review Checklist
- [ ] Follows architecture patterns
- [ ] Uses theme system consistently
- [ ] Includes appropriate tests
- [ ] Documents complex logic
- [ ] Handles errors gracefully
- [ ] Optimized for performance

### Git Workflow
1. Create feature branch from `main`
2. Implement changes following guidelines
3. Write/update tests
4. Submit pull request with description
5. Address code review feedback
6. Merge after approval

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Google Gemini AI Documentation](https://ai.google.dev/)

For questions or support, contact the development team or create an issue in the repository.
