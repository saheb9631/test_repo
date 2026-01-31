import Foundation
import SwiftUI
import Combine

@MainActor
class RestaurantViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var restaurants: [Restaurant] = []
    @Published var searchResults: [Restaurant] = []
    @Published var cities: [String] = ["Delhi", "Mumbai", "Bangalore", "Pune", "Hyderabad"]
    @Published var selectedCity: String = "Delhi"
    @Published var isLoading: Bool = false
    @Published var isSearching: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchQuery: String = ""
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Init
    init() {
        // Load initial data
        Task {
            await loadInitialData()
        }
    }
    
    // MARK: - Load Initial Data
    func loadInitialData() async {
        isLoading = true
        errorMessage = nil
        
        // Fetch cities first
        do {
            let fetchedCities = try await networkManager.fetchCities()
            if !fetchedCities.isEmpty {
                cities = fetchedCities
                if let firstCity = fetchedCities.first {
                    selectedCity = firstCity
                }
            }
        } catch {
            print("⚠️ Failed to fetch cities: \(error.localizedDescription)")
            // Keep default cities
        }
        
        // Fetch restaurants for selected city
        await fetchRestaurants()
    }
    
    // MARK: - Fetch Restaurants
    func fetchRestaurants() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedRestaurants = try await networkManager.fetchRestaurants(city: selectedCity)
            restaurants = fetchedRestaurants
            print("✅ Loaded \(fetchedRestaurants.count) restaurants for \(selectedCity)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error fetching restaurants: \(error.localizedDescription)")
            // Keep existing data or show empty state
        }
        
        isLoading = false
    }
    
    // MARK: - Change City
    func changeCity(to city: String) {
        guard city != selectedCity else { return }
        selectedCity = city
        
        Task {
            await fetchRestaurants()
        }
    }
    
    // MARK: - Search Restaurants
    func search(query: String) {
        // Cancel previous search task
        searchTask?.cancel()
        
        guard !query.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        
        // Capture the selected city for the async task
        let cityToSearch = selectedCity
        
        // Debounce search - wait 300ms before making API call
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            guard !Task.isCancelled else { return }
            
            do {
                // Pass the selected city to filter search results
                let results = try await networkManager.searchRestaurants(query: query, city: cityToSearch)
                
                guard !Task.isCancelled else { return }
                
                searchResults = results
                print("🔍 Found \(results.count) restaurants in \(cityToSearch) for '\(query)'")
            } catch {
                print("❌ Search error: \(error.localizedDescription)")
                searchResults = []
            }
            
            isSearching = false
        }
    }
    
    // MARK: - Refresh
    func refresh() async {
        await fetchRestaurants()
    }
}
