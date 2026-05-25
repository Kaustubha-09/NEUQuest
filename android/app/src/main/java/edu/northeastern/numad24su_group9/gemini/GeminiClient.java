package edu.northeastern.numad24su_group9.gemini;

import com.google.ai.client.generativeai.GenerativeModel;
import com.google.ai.client.generativeai.java.GenerativeModelFutures;
import com.google.ai.client.generativeai.type.Content;
import com.google.ai.client.generativeai.type.GenerateContentResponse;
import com.google.common.util.concurrent.Futures;
import com.google.common.util.concurrent.ListenableFuture;

import edu.northeastern.numad24su_group9.BuildConfig;

/**
 * Thin wrapper around the Gemini Generative AI client.
 *
 * <p>The API key is loaded from {@code BuildConfig.GEMINI_API_KEY}, which is
 * injected at build time from either {@code ~/.gradle/gradle.properties} or
 * the {@code GEMINI_API_KEY} environment variable. The key is never committed
 * to source.
 *
 * <p>If no key is configured the client is constructed in a no-op state and
 * {@link #isConfigured()} returns false; {@link #generateResult(String)} will
 * return an immediately-failed Future. Callers should branch on
 * {@link #isConfigured()} so the UI degrades gracefully when there is no key.
 */
public class GeminiClient {

    private static final String MODEL_NAME = "gemini-1.5-flash";

    private final boolean configured;
    private final GenerativeModelFutures model;

    public GeminiClient() {
        String apiKey = BuildConfig.GEMINI_API_KEY;
        if (apiKey == null || apiKey.isEmpty()) {
            this.configured = false;
            this.model = null;
        } else {
            this.configured = true;
            GenerativeModel gm = new GenerativeModel(MODEL_NAME, apiKey);
            this.model = GenerativeModelFutures.from(gm);
        }
    }

    /**
     * True iff a non-empty Gemini API key was injected at build time.
     * Callers should use this to gate AI features and fall back to non-AI
     * paths (chronological feed, user-typed trip names) when false.
     */
    public boolean isConfigured() {
        return configured;
    }

    public GenerativeModelFutures getModel() {
        return model;
    }

    public ListenableFuture<GenerateContentResponse> generateResult(String query) {
        if (!configured) {
            return Futures.immediateFailedFuture(
                new IllegalStateException(
                    "Gemini API key is not configured. Set GEMINI_API_KEY in "
                    + "~/.gradle/gradle.properties or the environment."
                )
            );
        }
        Content content = new Content.Builder()
                .addText(query)
                .build();
        return model.generateContent(content);
    }
}
