package edu.northeastern.numad24su_group9;

public final class AppConstants {
    private AppConstants() {}

    // SharedPreferences
    public static final String PREFS_USER_INFO = "UserInfo";
    public static final String UID_KEY = "user_id";
    public static final String USER_NAME = "user_name";

    // Firebase defaults
    public static final String DEFAULT_EVENT_IMAGE_NAME = "husky_default_image.png";
    public static final String DEFAULT_PROFILE_IMAGE_NAME = "user_profile.png";

    // Email domain validation
    public static final String NEU_EMAIL_DOMAIN = "@northeastern.edu";
    public static final String NEU_HUSKY_EMAIL_DOMAIN = "@husky.neu.edu";

    // Budget slider
    public static final float BUDGET_SLIDER_MIN = 0f;
    public static final float BUDGET_SLIDER_MAX = 1000f;
    public static final float BUDGET_SLIDER_STEP = 50f;

    // Back press double-tap exit window (ms)
    public static final long BACK_PRESS_INTERVAL_MS = 2000L;

    // RecyclerView off-screen view cache
    public static final int RECYCLER_VIEW_CACHE_SIZE = 20;

    // Permission request codes
    public static final int REQUEST_CAMERA_PERMISSION = 100;
}
