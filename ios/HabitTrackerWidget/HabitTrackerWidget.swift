
import WidgetKit
import SwiftUI

// Define a simple struct to hold habit data
struct Habit: Identifiable {
    let id = UUID()
    let name: String
    let isCompleted: Bool
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), perfectDayStreak: 3, habits: [
            Habit(name: "Workout", isCompleted: true),
            Habit(name: "Read", isCompleted: false)
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), perfectDayStreak: 3, habits: [
            Habit(name: "Workout", isCompleted: true),
            Habit(name: "Read", isCompleted: false)
        ])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let sharedDefaults = UserDefaults(suiteName: "group.com.example.habit_tracker")
        
        let perfectDayStreak = Int(sharedDefaults?.string(forKey: "perfect_day_streak") ?? "0") ?? 0
        
        var habits: [Habit] = []
        // Assuming a max of 5 habits for the widget
        for i in 0..<5 {
            if let habitName = sharedDefaults?.string(forKey: "habit_name_\(i)") {
                let isCompleted = sharedDefaults?.bool(forKey: "habit_completed_\(i)") ?? false
                habits.append(Habit(name: habitName, isCompleted: isCompleted))
            } else {
                // No more habits
                break
            }
        }

        let entry = SimpleEntry(date: Date(), perfectDayStreak: perfectDayStreak, habits: habits)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let perfectDayStreak: Int
    let habits: [Habit]
}

struct HabitTrackerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            Text("This widget size is not supported.")
        }
    }
}

struct MediumWidgetView: View {
    var entry: SimpleEntry

    var body: some View {
        HStack(spacing: 15) {
            StreakView(title: "Perfect Days", streak: entry.perfectDayStreak, backgroundImage: "perfect_day_bg")
            
            VStack(spacing: 10) {
                 if !entry.habits.isEmpty {
                    ForEach(entry.habits.prefix(2)) { habit in
                        HabitRowView(habit: habit)
                    }
                 } else {
                    Text("No habits yet!")
                        .font(.custom("DINRoundPro", size: 16))
                        .foregroundColor(.white)
                 }
            }
        }
        .padding()
        .background(Image("widget_background").resizable().scaledToFill())
    }
}
struct LargeWidgetView: View {
    var entry: SimpleEntry

    var body: some View {
        VStack(spacing: 15) {
            StreakView(title: "Perfect Days", streak: entry.perfectDayStreak, backgroundImage: "perfect_day_bg")
            
            VStack(spacing: 10) {
                 if !entry.habits.isEmpty {
                    ForEach(entry.habits) { habit in
                        HabitRowView(habit: habit)
                    }
                 } else {
                     Text("No habits yet!")
                        .font(.custom("DINRoundPro", size: 16))
                        .foregroundColor(.white)
                 }
            }
            Spacer()
        }
        .padding()
        .background(Image("widget_background").resizable().scaledToFill())
    }
}

struct StreakView: View {
    let title: String
    let streak: Int
    let backgroundImage: String

    var body: some View {
        VStack {
            Text(title)
                .font(.custom("DuolingoFeather", size: 16))
                .foregroundColor(.white)
            Text("\(streak)")
                .font(.custom("DINRoundPro-Bold", size: 36))
                .foregroundColor(.white)
            Text("Day Streak")
                .font(.custom("DINRoundPro", size: 14))
                .foregroundColor(.white)
        }
        .frame(width: 130, height: 130)
        .background(Image(backgroundImage).resizable().scaledToFill())
        .cornerRadius(15)
    }
}

struct HabitRowView: View {
    let habit: Habit

    var body: some View {
        HStack {
            Text(habit.name)
                .font(.custom("DINRoundPro-Bold", size: 18))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(habit.isCompleted ? .green : .white)
                .font(.title)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Image("habit_bg").resizable().scaledToFill())
        .cornerRadius(15)
    }
}


@main
struct HabitTrackerWidget: Widget {
    let kind: String = "HabitTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HabitTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Habit Tracker")
        .description("Track your habits and streaks.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct HabitTrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackerWidgetEntryView(entry: SimpleEntry(date: Date(), perfectDayStreak: 5, habits: [
            Habit(name: "Workout", isCompleted: true),
            Habit(name: "Read", isCompleted: false)
        ]))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
