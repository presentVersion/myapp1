# Project Blueprint

## Overview

A Flutter-based habit tracking application with a modern, Duolingo-inspired design. The app focuses on building streaks, visualizing progress, and providing a rewarding user experience through animations and widgets.

## Core Features

*   **Habit Management:** Add, complete, and track daily habits.
*   **Streak Tracking:**
    *   Calculate and display streaks for individual habits.
    *   Calculate and display a "perfect day" streak for completing all habits on a given day.
*   **Progress Visualization:**
    *   A dedicated progress screen with a calendar view.
    *   Streak lines on the calendar to connect consecutive completed days.
    *   A badge system to reward users for achievements.
*   **Streak Celebration:** A full-screen celebration with video animation when a habit is completed.
*   **Home/Lock Screen Widgets:** Interactive widgets for both Android and iOS.

## Design & UX Specifications

*   **Theme:** Duolingo-inspired, with custom fonts (`DuolingoFeather`, `DINRoundPro`), a dark and light theme, and a consistent color scheme.
*   **Buttons:** Use a custom `ThemedButton` for all primary actions.
*   **Animations:** Use video assets for a dynamic and engaging experience.
*   **Icons:** Use custom SVG icons.

## Detailed Feature Requirements

### 1. Streak Celebration Screen

*   **Trigger:** Appears when a habit is completed.
*   **Animation:**
    *   A full-screen video animation using `assets/videos/streak.mp4`.
    *   The animation should play and loop.
*   **Content (to appear *after* the animation):**
    *   Display the habit's streak count (e.g., "5 Day Streak!").
    *   Show a `WeeklyProgressView` widget that displays the last 7 days of progress for that habit.
*   **Action:** A `ThemedButton` with the text "CONTINUE" to close the screen.

### 2. Progress Screen

*   **Calendar:**
    *   A calendar view that displays all the days of the month.
    *   For each habit, draw streak lines connecting the days the habit was completed consecutively.
*   **Badges:**
    *   A section to display achievement badges.
    *   Each badge should be a card with a background image randomly selected from the widget background assets (`assets/images/widget_backgrounds/`).

### 3. Home/Lock Screen Widgets (Android & iOS)

*   **Functionality:**
    *   Allow users to add multiple widgets to their home and lock screens.
    *   Each widget should be associated with a specific habit.
    *   Allow users to complete a habit directly from the widget.
*   **Dynamic Icons:** The widget icon should change based on the habit's status for the current day:
    *   **Unchecked:** A default icon to check the habit.
    *   **Checked:** A streak icon.
    *   **Missed:** A "freezed" icon (if the user has a streak freeze item).
*   **Layout (Horizontal):**
    1.  **Left:** The dynamic icon.
    2.  **Middle:** The name of the habit.
    3.  **Right:** The current streak count for the habit.
*   **Appearance:**
    *   Use random backgrounds for the widgets from the `assets/images/widget_backgrounds/` directory.
    *   Consider different layouts or visual treatments for widgets with higher streak counts.

## Current Task & Action Plan

1.  **Acknowledge & Apologize:** Done.
2.  **Create Blueprint:** This document.
3.  **Fix Build Error:** The immediate priority is to fix the compilation error in `streak_celebration_screen.dart`.
4.  **Implement `WeeklyProgressView`:** Create and integrate the `WeeklyProgressView` widget.
5.  **Refactor `StreakCelebrationScreen`:**
    *   Ensure it accepts a `Habit` object.
    *   Display the `WeeklyProgressView` as per the requirements.
    *   Fix the layout to correctly display all elements.
6.  **Run Application:** Launch the app on the emulator to verify the fixes and new features.
7.  **Address `ProgressScreen`:** Implement the calendar with streak lines and the badge section with image backgrounds.
8.  **Re-implement Widgets:** Re-enable and enhance the home/lock screen widget functionality as per the detailed requirements.

