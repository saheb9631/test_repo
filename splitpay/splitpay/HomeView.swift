import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = RestaurantViewModel()
    @State private var showCityPicker = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                
                // TOP BAR
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("EazyDiner")
                            .font(.system(size: 16, weight: .semibold))
                        
                        // City Selector Button
                        Button {
                            showCityPicker = true
                        } label: {
                            HStack(spacing: 4) {
                                Text(viewModel.selectedCity)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 12))
                        Text("Be Prime")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text("S")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                        )
                }
                .padding(.horizontal)
                
                // SEARCH BAR
                NavigationLink {
                    SearchView(viewModel: viewModel)
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        Text("Search for Restaurants")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // BANNER
                Image("img1")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 190)
                    .clipped()
                    .cornerRadius(16)
                    .padding(.horizontal)
                
                // 🔥 OFFER BOXES
                HStack(spacing: 12) {
                    offerBox(
                        title: "Flat 30%\nOFF",
                        icon: "tag.fill",
                        colors: [Color.orange, Color.red]
                    )
                    
                    offerBox(
                        title: "Family\nDining",
                        icon: "person.2.fill",
                        colors: [Color.green, Color.teal]
                    )
                    
                    offerBox(
                        title: "Buffet\nSpecial",
                        icon: "fork.knife",
                        colors: [Color.blue, Color.teal]
                    )
                }
                .padding(.horizontal)
                
                // SECTION HEADER
                HStack {
                    Text("Nearby Dining in \(viewModel.selectedCity)")
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
                .padding(.horizontal)
                
                // ERROR STATE
                if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        
                        Text("Unable to load restaurants")
                            .font(.headline)
                        
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            Task {
                                await viewModel.refresh()
                            }
                        } label: {
                            Text("Try Again")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(Color.orange)
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // LOADING STATE
                if viewModel.isLoading && viewModel.restaurants.isEmpty {
                    ForEach(0..<3, id: \.self) { _ in
                        ShimmerCard()
                    }
                }
                
                // RESTAURANT CARDS FROM API
                if !viewModel.restaurants.isEmpty {
                    ForEach(viewModel.restaurants, id: \.id) { restaurant in
                        restaurantCard(restaurant: restaurant)
                    }
                } else if !viewModel.isLoading && viewModel.errorMessage == nil {
                    // Empty state
                    VStack(spacing: 12) {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No restaurants found")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Try selecting a different city")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(40)
                }
                
                Spacer(minLength: 30)
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .sheet(isPresented: $showCityPicker) {
            CityPickerView(
                cities: viewModel.cities,
                selectedCity: viewModel.selectedCity,
                onSelect: { city in
                    viewModel.changeCity(to: city)
                    showCityPicker = false
                }
            )
        }
    }
    
    // OFFER BOX (EazyDiner style)
    func offerBox(
        title: String,
        icon: String,
        colors: [Color]
    ) -> some View {
        
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
        .frame(width: 110, height: 90)
        .background(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
    }
    
    // RESTAURANT CARD - Now using API data
    func restaurantCard(restaurant: Restaurant) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .bottomLeading) {
                // Use local image assets based on restaurant ID
                Image(restaurant.displayImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(14)
                
                Text(restaurant.displayOffer)
                    .font(.system(size: 12, weight: .medium))
                    .padding(6)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .padding(8)
            }
            
            HStack {
                Text(restaurant.name)
                    .font(.system(size: 15, weight: .semibold))
                
                Spacer()
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.orange)
                    Text(restaurant.displayRating)
                        .font(.system(size: 12, weight: .medium))
                }
            }
            
            HStack {
                Text(restaurant.displayLocation)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                if let cuisine = restaurant.cuisine {
                    Text("• \(cuisine)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - City Picker View
struct CityPickerView: View {
    let cities: [String]
    let selectedCity: String
    let onSelect: (String) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cities, id: \.self) { city in
                    Button {
                        onSelect(city)
                    } label: {
                        HStack {
                            Text(city.capitalized)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            if city.lowercased() == selectedCity.lowercased() {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Select City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Search View
struct SearchView: View {
    @ObservedObject var viewModel: RestaurantViewModel
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Search Results
            if viewModel.isSearching {
                ProgressView("Searching...")
                    .padding()
            } else if !viewModel.searchResults.isEmpty {
                List(viewModel.searchResults, id: \.id) { restaurant in
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: restaurant.displayImage)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Image("img1").resizable().scaledToFill()
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(restaurant.name)
                                .font(.headline)
                            
                            Text(restaurant.displayLocation)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                            Text(restaurant.displayRating)
                                .font(.caption)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            } else if !searchText.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No results for '\(searchText)'")
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: .infinity)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("Search for restaurants")
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .searchable(text: $searchText, prompt: "Search restaurants")
        .onChange(of: searchText) { _, newValue in
            viewModel.search(query: newValue)
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Shimmer Loading Card
struct ShimmerCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray5))
                .frame(height: 140)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: 180, height: 16)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: 120, height: 12)
        }
        .padding(.horizontal)
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
