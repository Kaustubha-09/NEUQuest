import Foundation

// MARK: - GeminiService
// Calls the Gemini 1.5 Flash API for AI-powered trip name generation.
// NOTE: Add your Gemini API key to Info.plist as "GEMINI_API_KEY" or set it below.
// Get an API key at: https://aistudio.google.com/app/apikey
final class GeminiService {
    static let shared = GeminiService()

    // IMPORTANT: Replace with your actual Gemini API key.
    // For production, store in a secure location (not hardcoded).
    private let apiKey: String = {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let key = dict["GEMINI_API_KEY"] as? String {
            return key
        }
        return "YOUR_GEMINI_API_KEY_HERE"
    }()

    private let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

    private init() {}

    // MARK: - Generate trip name
    func generateTripName(location: String, startDate: String, endDate: String, interests: [String]) async throws -> String {
        guard apiKey != "YOUR_GEMINI_API_KEY_HERE" else {
            // Fallback when no API key is set
            return generateFallbackName(location: location, startDate: startDate, endDate: endDate)
        }

        let prompt = buildPrompt(location: location, startDate: startDate, endDate: endDate, interests: interests)
        let requestBody = GeminiRequest(
            contents: [
                GeminiContent(parts: [GeminiPart(text: prompt)])
            ],
            generationConfig: GeminiGenerationConfig(
                temperature: 0.8,
                maxOutputTokens: 50
            )
        )

        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else {
            throw GeminiError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)
        request.timeoutInterval = 15

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw GeminiError.apiError(statusCode)
        }

        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        guard let text = geminiResponse.candidates.first?.content.parts.first?.text else {
            throw GeminiError.noContent
        }

        return text.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\"", with: "")
            .truncated(to: 50)
    }

    // MARK: - Fallback name generation (no API key)
    private func generateFallbackName(location: String, startDate: String, endDate: String) -> String {
        let adjectives = ["Epic", "Amazing", "Unforgettable", "Spectacular", "Grand", "Vibrant", "Scenic"]
        let nouns = ["Adventure", "Getaway", "Journey", "Escape", "Expedition", "Discovery", "Quest"]
        let adj = adjectives.randomElement() ?? "Amazing"
        let noun = nouns.randomElement() ?? "Adventure"
        let city = location.split(separator: ",").first.map(String.init) ?? location
        return "\(adj) \(city) \(noun)"
    }

    private func buildPrompt(location: String, startDate: String, endDate: String, interests: [String]) -> String {
        let interestStr = interests.isEmpty ? "general sightseeing" : interests.joined(separator: ", ")
        return """
        Generate a creative and catchy trip name for a Northeastern University student.
        Details:
        - Location: \(location)
        - Dates: \(startDate) to \(endDate)
        - Interests: \(interestStr)

        Rules:
        - Return ONLY the trip name, no explanation
        - Keep it under 50 characters
        - Make it fun and exciting
        - Don't include quotes
        """
    }
}

// MARK: - Gemini API Models
private struct GeminiRequest: Codable {
    let contents: [GeminiContent]
    let generationConfig: GeminiGenerationConfig
}

private struct GeminiContent: Codable {
    let parts: [GeminiPart]
}

private struct GeminiPart: Codable {
    let text: String
}

private struct GeminiGenerationConfig: Codable {
    let temperature: Double
    let maxOutputTokens: Int
}

private struct GeminiResponse: Codable {
    let candidates: [GeminiCandidate]
}

private struct GeminiCandidate: Codable {
    let content: GeminiContent
}

// MARK: - GeminiError
enum GeminiError: LocalizedError {
    case invalidURL
    case apiError(Int)
    case noContent

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid API URL"
        case .apiError(let code): return "Gemini API error: \(code)"
        case .noContent: return "No content returned from Gemini"
        }
    }
}
