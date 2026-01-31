import Foundation

// MARK: - Restaurant Model (Matches actual API response)
struct Restaurant: Codable, Identifiable {
    let id: Int
    let name: String
    let address: String?
    let city: String?
    let cuisine: String?
    let rating: String?
    let price_range: String?
    let image_url: String?
    let phone_no: String?
    
    // Computed properties for display
    var displayImage: String {
        if let url = image_url, !url.isEmpty {
            return url
        }
        // Return placeholder images based on id
        let images = ["img1", "img2", "img3", "img4", "img5"]
        return images[id % images.count]
    }
    
    var displayLocation: String {
        address ?? city ?? "Unknown Location"
    }
    
    var displayOffer: String {
        // Generate offers based on price range
        switch price_range {
        case "₹₹₹₹": return "20% Off + Premium"
        case "₹₹₹": return "15% Off + 25% Cashback"
        case "₹₹": return "Flat 30% Off"
        default: return "Special Offer"
        }
    }
    
    var displayRating: String {
        rating ?? "4.0"
    }
    
    var displayCuisine: String {
        cuisine ?? "Multi-Cuisine"
    }
    
    var displayPriceRange: String {
        price_range ?? "₹₹"
    }
}

// MARK: - API Response Wrapper (Matches your backend exactly)
struct RestaurantResponse: Codable {
    let success: Bool?
    let city: String?
    let restaurants: [Restaurant]?
    let count: Int?
    let message: String?
    
    // For search endpoint which might return differently
    let data: [Restaurant]?
    let results: [Restaurant]?
    
    var restaurantList: [Restaurant] {
        restaurants ?? data ?? results ?? []
    }
}

// MARK: - City Response
struct CitiesResponse: Codable {
    let success: Bool?
    let cities: [String]?
    let data: [String]?
    
    var cityList: [String] {
        cities ?? data ?? []
    }
}
