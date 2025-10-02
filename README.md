# Align App

A wellness and mental health tracking Flutter application with AI-powered features.

## 🏗️ Architecture

This app follows **Clean Architecture** principles with proper separation of concerns:

### Folder Structure
```
lib/
├── core/                    # Core application logic
│   ├── constants/          # App-wide constants
│   ├── theme/             # Centralized theming
│   └── animations/        # Reusable animations
├── data/                   # Data layer
│   ├── models/            # Data models
│   ├── repositories/      # Repository pattern
│   └── services/          # API services
├── screens/               # UI screens
│   ├── checkin/          # Check-in flow
│   └── community/        # Community features
└── shared/               # Shared components
    └── widgets/          # Reusable UI widgets
```

## 🚀 Quick Start

1. **Prerequisites**
   - Flutter SDK (3.9.2+)
   - Dart SDK
   - Android Studio / VS Code
   - Access to backend API keys

2. **Installation**
   ```bash
   git clone [repository-url]
   cd align_app
   flutter pub get
   ```

3. **Environment Setup**
   - Copy `.env.example` to `.env`
   - Fill in required API keys (contact team for credentials)

4. **Run the App**
   ```bash
   flutter run
   ```

## 🎨 Design System

### Theme Usage
```dart
// Use predefined colors
Container(color: AppColors.primary)

// Use predefined text styles  
Text('Title', style: AppTextStyles.h1)

// Use predefined constants
BorderRadius.circular(AppConstants.borderRadius)
```

### Reusable Components
```dart
// Custom buttons
CustomButton(
  text: 'Save',
  type: ButtonType.primary,
  onPressed: () => _save(),
)

// Wellness cards
WellnessCard(
  title: 'Meditation',
  progress: 0.6,
  onTap: () => _openMeditation(),
)

// Animated earth icon
EarthAnimationWidget(size: 30)
```

## 📊 Data Layer

### Repository Pattern
```dart
final checkinRepo = CheckinRepository();
final moods = checkinRepo.getMoodOptions();
await checkinRepo.saveCheckinData(data);
```

### API Integration
```dart
final apiService = ApiService();
final module = await apiService.createLearningModule(
  userId: 'user123',
  topic: 'Mindfulness',
);
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

Current test coverage:
- ✅ Check-in flow widget tests
- ⏳ Unit tests (planned)
- ⏳ Integration tests (planned)

## 🔧 Backend Integration

The app connects to a Flask backend providing:
- 🤖 AI learning module generation
- 📱 Push notifications
- 👥 User management
- 📧 Email support
- 🖼️ AI image generation

## 📱 Features

### Check-in Flow
- Interactive mood selection with circular gesture control
- Detailed mood analysis with tags and activities
- Rich media support (photos, voice memos, text)

### AI Coach
- Personalized wellness coaching
- Real-time chat interface
- AI-generated learning modules

### Wellness Tracking
- Progress visualization
- Module-based learning system
- Achievement tracking

### Community
- Categorized wellness content
- Multiple content types (articles, audio, quizzes)
- Social features and engagement

## 🛠️ Development Guidelines

### Code Organization
- **Animations**: Place in `core/animations/`
- **Reusable Widgets**: Place in `shared/widgets/`
- **Models**: Place in `data/models/`
- **Business Logic**: Use repository pattern

### Styling Guidelines
- Always use theme system (`AppColors`, `AppTextStyles`)
- Use constants for consistent spacing and sizing
- Follow Material Design 3 principles

### Testing Guidelines
- Write widget tests for UI components
- Write unit tests for business logic
- Use repository pattern for testable code

## 📚 Documentation

For detailed developer documentation, see [DEVELOPER_GUIDE.md](./DEVELOPER_GUIDE.md)

## 🤝 Contributing

1. Create feature branch
2. Follow architecture patterns
3. Write tests
4. Submit pull request

## 📞 Support

For questions or issues:
- Check [DEVELOPER_GUIDE.md](./DEVELOPER_GUIDE.md)
- Create GitHub issue
- Contact development team

## 📄 License

[Add your license information here]
