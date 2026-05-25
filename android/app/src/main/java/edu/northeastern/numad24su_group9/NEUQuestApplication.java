package edu.northeastern.numad24su_group9;

import android.app.Application;

import com.google.firebase.database.FirebaseDatabase;

public class NEUQuestApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        // Enable offline caching — must be called once before any database reference is created.
        FirebaseDatabase.getInstance().setPersistenceEnabled(true);
        // Register the notification channel for Android O and above.
        NotificationHelper.createNotificationChannel(this);
    }
}
