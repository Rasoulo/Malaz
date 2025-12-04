
# What's the L10n Directory?

- The `l10n` directory is responsible for handling everything related to internationalization and localization in the application.

## - How it works?

1.  **Translation Files:** It contains the core `AppLocalizations` class that loads and provides translated strings.
2.  **Asset Files:** The actual translation strings are stored in JSON files located in the `lib/l10n/` directory at the root of the project.

*   **Why is that?**
    By centralizing the localization logic, we create a single, reliable system for managing all text displayed to the user. This makes it easy to add new languages or modify existing strings without touching the UI code.

*   **Example:**
    Instead of `Text('Welcome Back')`, we use `Text(AppLocalizations.of(context)!.welcome_back)`. This automatically displays the correct string based on the user's selected language.
