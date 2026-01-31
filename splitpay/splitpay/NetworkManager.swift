import Foundation

// MARK: - API Endpoints
enum APIEndpoint {
    // Use localhost for simulator, Mac's IP for real devices
    #if targetEnvironment(simulator)
    static let baseURL = "http://localhost:3000"
    #else
    // Replace this with your Mac's IP address (run `ipconfig getifaddr en0` in Terminal)
    static let baseURL = "http://192.168.3.152:3000"
    #endif
    
    case cities
    case restaurantsByCity(String)
    case search(query: String, city: String?)
    
    var url: URL? {
        switch self {
        case .cities:
            return URL(string: "\(APIEndpoint.baseURL)/restaurants/cities")
        case .restaurantsByCity(let city):
            let cityPath = city.lowercased().addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? city.lowercased()
            return URL(string: "\(APIEndpoint.baseURL)/restaurants/city/\(cityPath)")
        case .search(let query, let city):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            var urlString = "\(APIEndpoint.baseURL)/restaurants/search?q=\(encodedQuery)"
            if let city = city, !city.isEmpty {
                let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
                urlString += "&city=\(encodedCity)"
            }
            return URL(string: urlString)
        }
    }
}

// MARK: - Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to parse data: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Network Manager
class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Fetch Cities
    func fetchCities() async throws -> [String] {
        guard let url = APIEndpoint.cities.url else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            // Debug: Print raw JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🌆 Cities API Response: \(jsonString.prefix(300))")
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            // Try parsing as CitiesResponse first
            if let citiesResponse = try? JSONDecoder().decode(CitiesResponse.self, from: data) {
                return citiesResponse.cityList
            }
            
            // Try parsing as array of strings
            if let cities = try? JSONDecoder().decode([String].self, from: data) {
                return cities
            }
            
            throw NetworkError.noData
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // MARK: - Fetch Restaurants by City
    func fetchRestaurants(city: String) async throws -> [Restaurant] {
        guard let url = APIEndpoint.restaurantsByCity(city).url else {
            throw NetworkError.invalidURL
        }
        
        return try await fetchRestaurantsFromURL(url)
    }
    
    // MARK: - Search Restaurants
    func searchRestaurants(query: String, city: String? = nil) async throws -> [Restaurant] {
        guard let url = APIEndpoint.search(query: query, city: city).url else {
            throw NetworkError.invalidURL
        }
        
        return try await fetchRestaurantsFromURL(url)
    }
    
    // MARK: - Private Helper
    private func fetchRestaurantsFromURL(_ url: URL) async throws -> [Restaurant] {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            // Debug: Print raw JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 API Response: \(jsonString.prefix(500))")
            }
            
            let decoder = JSONDecoder()
            
            // Try parsing as RestaurantResponse wrapper
            if let response = try? decoder.decode(RestaurantResponse.self, from: data) {
                return response.restaurantList
            }
            
            // Try parsing as array of restaurants directly
            if let restaurants = try? decoder.decode([Restaurant].self, from: data) {
                return restaurants
            }
            
            // If all parsing fails, throw error
            throw NetworkError.decodingError(NSError(domain: "Parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to parse restaurant data"]))
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
