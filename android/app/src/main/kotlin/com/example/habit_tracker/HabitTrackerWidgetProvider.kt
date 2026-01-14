package com.example.habit_tracker

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import com.example.habit_tracker.R
import es.antonborri.home_widget.HomeWidgetPlugin

class HabitTrackerWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.habit_tracker_widget).apply {
                val streakCount = widgetData.getInt("streak_count", 0)
                setTextViewText(R.id.streak_count, streakCount.toString())
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
