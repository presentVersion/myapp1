# Project Blueprint

## 1. ARCHITECTURE & NAVIGATION

*   **Navigation:** The Bottom Bar must ONLY have two tabs: HOME (The Dashboard) and CALENDAR (The Progress Hub).
*   **Home Screen (Daily Dashboard):** This is the functional "Battle Station."
    *   **Filter Logic:** ONLY show habits/tasks scheduled for `DateTime.now().weekday`.
    *   **The "Floating Action Button" (FAB):** Restore the habit creation button. It must open a "Squishy" modal.
    *   **Rest Day Logic:** If no habits are scheduled for today, display `homepage.svg` and the text: "Enjoy your rest day! Your streak is protected." The FAB must still be present.
*   **Progress Hub (Accessed via Streak Icon):** This screen is pushed when tapping the Top Bar Streak Icon.

## 2. THE "FREQUENCY" ENGINE (HABIT CREATION)

*   **The Model (`lib/models/habit.dart`):** A habit MUST contain `Map<int, bool> scheduledDays` where the `int` is the weekday (`DateTime.monday`, etc.) and `bool` indicates if it is scheduled.
*   **Streak Logic:** A streak ONLY resets if a habit is missed on a day it was scheduled. "Off-days" (Rest days) do not break streaks.
*   **Perfect Day Logic:** A day is "Perfect" (Gold Blob in Calendar) only if 100% of scheduled habits for that specific day were completed.

## 3. THE "PROGRESS HUB"

*   **Access:** This screen must be pushed when tapping the Top Bar Streak Icon.
*   **Section 1: The Toggle:** [Perfect Day | Specific Habit]. Rounded, squishy buttons using `Continuebuttonstatebeforepressed.svg`.
*   **Section 2: The Duolingo Calendar:**
    *   Build a grid with "Blob" connections. If Day 1 and Day 2 are "Perfect," draw a thick orange bridge between them.
    *   Use day-specific SVGs: `Mondaychecked.svg`, `Tuesdayfreezed.svg`, etc.
*   **Section 3: Milestone Path:** Staggered nodes (Left, Center, Right) connected by an 8px Dashed Line (CustomPainter). Use `streakchamp.svg` for unlocked milestones.
*   **Section 4: The Trophy Case (Achievements):**
    *   Move Achievements here. Remove the separate tab.
    *   Display titled badges: "7-Day Perfect Streak", "30-Day Gym King", etc.
    *   Use a 3-column grid with `Trophy.svg`. Locked achievements must be Greyscale.

## 4. UI SPECIFICATIONS (THE DESIGN LAWS)

*   **The "Pill" Header:** Wrap Top Bar stats (Streak/Gems) in containers with: `Border.all(color: Color(0xFFE5E5E5), width: 2)` and `borderRadius: 12`.
*   **Colors:**
    *   Primary Green: `#58CC02`
    *   Streak Orange: `#FF9600`
    *   Gem Blue: `#1CB0F6`
    *   Border Grey: `#E5E5E5`
*   **Shapes:** NO SHARP CORNERS. Minimum `BorderRadius` is 16.0.
*   **Animations:** Trigger `Animation1.mp4` ONLY for Milestones (10, 30, 50 days) with a bottom-third text overlay: "X days to your next milestone!"

## 5. ASSET INTEGRATION

*   Use the exact filenames from `assets/images/`:
    *   `streak.svg`, `streakchamp.svg`, `checked.svg`, `unchecked.svg`, `freezed.svg`, `Trophy.svg`, `Goals.svg`, `homepage.svg`, `Continuebuttonstatebeforepressed.svg`, `Mondaychecked.svg`, `Tuesdayfreezed.svg`.

