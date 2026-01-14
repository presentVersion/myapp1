# Habit Tracker App Blueprint

## Overview

This document outlines the design, features, and implementation of the Habit Tracker application. The goal is to create a beautiful and intuitive mobile app that helps users build and maintain positive habits through a visually engaging and motivating experience.

## Style and Design

- **Theme:** Dark theme with a primary color of orange.
- **Fonts:**
    - `DINRoundPro` for general text.
    - `DuolingoFeather` for large, prominent numbers (streaks).
- **Icons:** Custom image assets for key actions:
    - **Perfect Day Streak:** `app_icon_fire.png` (replaces `lightning.png`)
    - **Calendar:** `book.png`
    - **Add Habit:** `add.png`
    - **Complete Habit:** `check.png` (incomplete) and `unchecked.png` (complete).
- **App Icon:**  A fire icon (`app_icon_fire.png`) is used in the `AppBar` to represent the "Perfect Day" streak.

## Features

### 1. Multi-Habit Tracking

- Users can add multiple habits they want to track.
- Each habit has its own name and streak count.
- The main screen displays a list of all habits.

### 2. Streak Counter

- Each habit has an individual streak counter that increments when the habit is marked as complete.
- A "Perfect Day" streak counter on the main screen tracks the number of consecutive days all habits have been completed.

### 3. Streak Calendar

- A dedicated calendar screen visualizes the user's progress.
- Days with at least one completed habit are marked on the calendar.

### 4. Data Persistence

- The app saves all habit data to the device's local storage.
- Data is loaded when the app starts, so progress is never lost.

### 5. Visually Engaging UI

- The app uses custom fonts and images to create a unique and polished look and feel.
- The UI is designed to be simple, intuitive, and motivating.

## Implementation Details

- **Platform:** Flutter
- **State Management:** `setState` and `SharedPreferences` for local data persistence.
- **Data Model:**
    - A `Habit` class (`lib/models/habit.dart`) with `json_serializable` for easy JSON conversion.
- **Key Packages:**
    - `shared_preferences`: For saving and loading data.
    - `table_calendar`: For the streak calendar view.
    - `uuid`: For generating unique IDs for each habit.
    - `json_serializable` and `build_runner`: For code generation.
