package com.example.habit_tracker

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.net.Uri
import java.io.File

class HabitTrackerWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        val prefs = context.getSharedPreferences("${context.packageName}_preferences", Context.MODE_PRIVATE)
        val imagePath = prefs.getString("widget_image", null)

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.habit_tracker_widget)
            
            if (imagePath != null) {
                val file = File(imagePath)
                if (file.exists()) {
                    views.setImageViewUri(R.id.widget_background, Uri.fromFile(file))
                    
                    // Hide native text overlays because they are rendered on the Flutter image
                    views.setViewVisibility(R.id.widget_icon, android.view.View.GONE)
                    views.setViewVisibility(R.id.widget_habit_name, android.view.View.GONE)
                    views.setViewVisibility(R.id.widget_streak_count, android.view.View.GONE)
                }
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
