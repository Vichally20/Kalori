# Home Feature

This directory contains the `home` feature for the Kalori application. It serves as the primary dashboard and the main entry point after the user opens the app or logs in. 

## How it works

The Home feature is built using Flutter and the GetX state management library. It is responsible for orchestrating the main user interface and bottom navigation.

### Key Components

*   **Home Dashboard (`home_screen.dart`)**: Displays a high-level overview of the user's daily progress. It includes:
    *   **Calorie Ring Widget**: A visual representation of consumed vs. remaining calories, along with macro breakdowns (carbs, protein, fat).
    *   **Quick Stats Row**: A summary of eaten, burned, and net calories.
    *   **Tip of the Day**: A dark card providing daily health tips.
    *   **Recent Logs Section**: A quick look at the most recently logged food items.
*   **State Management (`home_controller.dart`)**: Manages the state for the home dashboard, including reactive variables (`RxInt`, `RxDouble`, etc.) for calories, macros, and recent logs. It also handles the bottom navigation tab state and provides logic for submitting quick chat logs from the floating input.
*   **Bottom Navigation (`KaloriBottomNavBar`)**: The home controller manages the `currentTab` state, allowing the `HomeView` to switch between its main dashboard, the Log view, History view, and Profile view.
*   **Floating Chat Widget**: Allows users to quickly type and submit food logs. Submitting an entry automatically switches the view to the Log tab using the `LogController`.

### Architecture

This feature follows a modular structure:
*   `view/`: Contains the screens, widgets, controllers, and bindings specific to the Home dashboard.
*   `domain/`: Intended for domain-specific logic, repository interfaces, and data transfer objects (DTOs).
*   `data/`: Intended for data sources and models related to the home feature's data needs.
