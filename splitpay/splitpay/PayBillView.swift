import SwiftUI

struct PayBillView: View {

    // Tab binding from MainHomeView
    @Binding var selectedTab: Int
    
    // SEARCH STATE
    @State private var showSearch = false
    @State private var selectedRestaurant: Restaurant? = nil
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {

                // BACKGROUND
                LinearGradient(
                    colors: [
                        Color(red: 0.35, green: 0.20, blue: 0.55),
                        Color(red: 0.95, green: 0.50, blue: 0.30)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        Spacer().frame(height: 30)

                        // =========================
                        // HERO CARD
                        // =========================
                        VStack(spacing: 18) {

                            VStack(spacing: 6) {
                                Text("Pay Your Bill")
                                    .font(.system(size: 26, weight: .bold))

                                Text("Fast • Secure • Rewarding")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }

                            Image("img2")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 120)
                                .clipped()
                                .cornerRadius(16)

                            // 🔍 SEARCH RESTAURANT - Now with API
                            Button {
                                showSearch = true
                            } label: {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)

                                    Text(selectedRestaurant?.name ?? "Search restaurant")
                                        .foregroundColor(
                                            selectedRestaurant == nil ? .gray : .black
                                        )

                                    Spacer()
                                    
                                    if selectedRestaurant != nil {
                                        Button {
                                            selectedRestaurant = nil
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(14)
                            }

                            // SCAN & PAY - Goes to ContentView for user details
                            NavigationLink {
                                ContentView()
                            } label: {
                                HStack {
                                    Image(systemName: "qrcode.viewfinder")
                                        .font(.system(size: 22))

                                    Text("Scan & Pay")
                                        .font(.system(size: 18, weight: .bold))

                                    Spacer()
                                }
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.00, green: 0.58, blue: 0.20),
                                            Color(red: 0.92, green: 0.35, blue: 0.15)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(18)
                                .shadow(color: Color.orange.opacity(0.45), radius: 10, y: 6)
                            }

                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(26)
                        .padding(.horizontal)

                        // =========================
                        // ADDITIONAL OFFERS
                        // =========================
                        VStack(alignment: .leading, spacing: 16) {

                            Text("Additional Offers")
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)

                            OfferCard(
                                imageName: "card1",
                                title: "EazyDiner IndusInd Bank Credit Card",
                                points: [
                                    "25% Off upto ₹1000",
                                    "No min. bill value",
                                    "Valid every single time",
                                    "EazyDiner IndusInd Signature Credit Card"
                                ]
                            )

                            Divider()

                            OfferCard(
                                imageName: "card2",
                                title: "EazyDiner IndusInd Bank Credit Card",
                                points: [
                                    "20% Off upto ₹500",
                                    "No min. bill value",
                                    "Valid thrice per card per month",
                                    "EazyDiner IndusInd Platinum Credit Card"
                                ]
                            )

                            Divider()

                            OfferCard(
                                imageName: "card3",
                                title: "Axis Bank",
                                points: [
                                    "30% Off upto ₹1000",
                                    "Min. bill of ₹3000",
                                    "Valid once per month",
                                    "Applicable on Axis Bank premium cards only"
                                ]
                            )
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(26)
                        .padding(.horizontal)

                        Spacer(minLength: 50)
                    }
                }
            }
            // SEARCH SHEET - Now with API integration
            .sheet(isPresented: $showSearch) {
                APIRestaurantSearchView(
                    selectedRestaurant: $selectedRestaurant
                )
            }
            .onReceive(NotificationCenter.default.publisher(for: .popToRoot)) { _ in
                // Clear navigation stack
                navigationPath = NavigationPath()
                // Switch to Home tab
                selectedTab = 0
            }
        }
    }
}

// Notification name for pop to root
extension Notification.Name {
    static let popToRoot = Notification.Name("popToRoot")
}

#Preview {
    PayBillView(selectedTab: .constant(1))
}

// MARK: - API Restaurant Search View
struct APIRestaurantSearchView: View {

    @Environment(\.dismiss) var dismiss
    @Binding var selectedRestaurant: Restaurant?

    @State private var searchText = ""
    @State private var isLoading = true
    @State private var allRestaurants: [Restaurant] = []
    @State private var searchTask: Task<Void, Never>?

    // Filtered results based on search
    var displayedRestaurants: [Restaurant] {
        if searchText.isEmpty {
            return allRestaurants
        } else {
            return allRestaurants.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                (restaurant.cuisine?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (restaurant.address?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Loading restaurants...")
                        .frame(maxHeight: .infinity)
                } else if !displayedRestaurants.isEmpty {
                    List {
                        ForEach(displayedRestaurants, id: \.id) { restaurant in
                            Button {
                                selectedRestaurant = restaurant
                                dismiss()
                            } label: {
                                HStack(spacing: 12) {

                                    // 🖼️ RESTAURANT IMAGE - Use local assets
                                    Image(restaurant.displayImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                        .clipped()

                                    // INFO
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(restaurant.name)
                                            .foregroundColor(.black)
                                            .fontWeight(.medium)
                                        
                                        Text(restaurant.displayLocation)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        if let cuisine = restaurant.cuisine {
                                            Text(cuisine)
                                                .font(.caption2)
                                                .foregroundColor(.orange)
                                        }
                                    }

                                    Spacer()

                                    // RATING
                                    HStack(spacing: 2) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(.orange)
                                        Text(restaurant.displayRating)
                                            .font(.caption)
                                    }
                                    
                                    if selectedRestaurant?.id == restaurant.id {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else if !searchText.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No restaurants found for '\(searchText)'")
                            .foregroundColor(.gray)
                        
                        Text("Try a different search term")
                            .font(.caption)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No restaurants available")
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .searchable(text: $searchText, prompt: "Search restaurants")
            .navigationTitle("Select Restaurant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .task {
                await loadRestaurants()
            }
        }
    }
    
    private func loadRestaurants() async {
        isLoading = true
        
        do {
            // Load restaurants from Delhi (default city)
            let restaurants = try await NetworkManager.shared.fetchRestaurants(city: "Delhi")
            await MainActor.run {
                allRestaurants = restaurants
                isLoading = false
            }
        } catch {
            // If Delhi fails, try to search all
            do {
                let restaurants = try await NetworkManager.shared.searchRestaurants(query: "")
                await MainActor.run {
                    allRestaurants = restaurants
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    allRestaurants = []
                    isLoading = false
                }
            }
        }
    }
}

struct OfferCard: View {

    let imageName: String
    let title: String
    let points: [String]

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .background(Color(.systemGray6))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 6) {

                Text(title)
                    .font(.system(size: 15, weight: .semibold))

                ForEach(points, id: \.self) { point in
                    Text("• \(point)")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
    }
}
