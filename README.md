# 🍏 Kalori

**A calorie-tracking app built for Nigerians** — log meals conversationally, track macros at a glance, and build healthier habits with smart daily insights.

Built with **Flutter** & **GetX**.

---

## ✨ Features

### 🏠 Home Dashboard
- **Calorie ring** — animated radial gauge showing remaining calories for the day
- **Macro breakdown** — real-time carbs, protein & fat progress bars
- **Quick stats row** — eaten, burned & net calories at a glance
- **Tip of the day** — contextual nutrition tips surfaced in a dark-themed card
- **Recent logs** — scrollable list of your latest food entries
- **Notification bell** — badge-counted bell icon with unread count

### 💬 Conversational Meal Logging
- **Chat-style interface** — log meals by typing naturally (e.g. *"I had jollof rice and chicken"*)
- **AI-powered parsing** — input is interpreted and broken down into individual food items
- **Meal breakdown card** — expandable/collapsible card showing per-item calories and macros
- **Quick suggestion chips** — one-tap shortcuts like *"Add Black Coffee"* or *"Add Avocado"*
- **Floating input bar** — always-accessible chat bar pinned to the bottom of the screen
- **Voice input ready** — microphone icon for future voice logging

### 📊 History
- View past meal logs and calorie trends over time

### 🔔 Notifications
- **Filterable list** — filter by All, Unread, or category
- **Swipe actions** — dismiss or toggle read/unread on individual notifications
- **Mark all as read** — bulk action from the app bar
- **Clear all** — confirmation dialog before permanently removing history
- **Empty states** — friendly illustrations when there's nothing to show

### 👤 Profile
- User profile screen with account management

### 🤖 AI Thinking Indicator
- Animated orbital dots with comet trails and a pulsing glow core
- Breathing per-dot scale animation with hue-shifted colours
- Optional animated ellipsis label (*"Analysing your meal..."*)

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── bindings/        # Global dependency injection
│   ├── config/          # App-wide configuration
│   ├── errors/          # Error handling
│   ├── routes/          # Route definitions (AppRoutes)
│   ├── theme/           # Design system (colours, typography, spacing)
│   └── utilities/       # Shared helpers & constants
├── features/
│   ├── home/            # Dashboard, calorie ring, floating chat
│   ├── log/             # Conversational meal logging
│   ├── history/         # Meal history & trends
│   ├── notifications/   # Notification centre
│   └── profile/         # User profile
└── shared/
    └── widgets/         # Reusable UI components
```

Each feature follows a **clean layered structure**:

```
feature/
├── data/       # Data sources & API clients
├── domain/     # DTOs, models & repositories
└── view/
    ├── bindings/     # Feature-scoped DI
    ├── controllers/  # GetX controllers (state management)
    ├── screens/      # Full-page views
    └── widgets/      # Feature-specific widgets
```

---

## 🛠️ Tech Stack

| Layer              | Technology          |
|--------------------|---------------------|
| Framework          | Flutter             |
| State Management   | GetX                |
| Equality           | Equatable           |
| Functional         | fpdart              |
| Design System      | Custom (Material 3) |

---

## 🚀 Getting Started

```bash
# Clone the repo
git clone https://github.com/Vichally20/kalori.git
cd kalori

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📄 License

MIT — see [LICENSE](LICENSE) for details.
