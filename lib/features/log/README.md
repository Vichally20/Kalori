# Log Feature

This directory contains the `log` feature for the Kalori application. It provides a conversational interface for users to easily track their meals and view a detailed breakdown of their daily intake.

## How it works

The Log feature relies on Flutter and the GetX state management library to provide a reactive, chat-like experience for food logging.

### Key Components

*   **Log View (`log_screen.dart`)**: The main user interface for the logging tab. It includes:
    *   **Chat Messages Area**: Displays a conversation history simulating an AI assistant that confirms logged food and reports remaining calories.
    *   **Meal Breakdown Card**: An expandable/collapsible card that lists individual food items logged in the current meal session, along with the total carbs, protein, and fat for those items.
    *   **Suggestion Chips**: Quick-tap action chips (e.g., "ADD BLACK COFFEE", "ADD AVOCADO") that allow the user to instantly add common items to their log.
    *   **Floating Input Bar**: A pinned text input field at the bottom of the screen for manual text entry.
*   **State Management (`log_controller.dart`)**: Manages the state for the log feature, including:
    *   Lists of `chatMessages` and `foodItems`.
    *   Macro totals for the current meal breakdown (`carbsCurrent`, `proteinCurrent`, `fatCurrent`).
    *   The expansion state of the meal breakdown card.
    *   Logic for handling suggestion chip taps and manual text input.
    *   `handleExternalLogInput`: A public method that allows other features (like the Home feature) to programmatically add an entry to the log and trigger an instant UI update.

### Architecture

This feature follows a modular structure:
*   `view/`: Contains the screens, widgets (like `chat_bubble.dart`, `meal_breakdown_card.dart`), and controllers specific to the Log feature.
*   `domain/`: Intended for domain-specific logic, repository interfaces, and data transfer objects (DTOs).
*   `data/`: Intended for data sources and models related to food logging and search.
