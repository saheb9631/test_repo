import SwiftUI

struct MainHomeView: View {
    
    // Tab selection state - can be controlled via notification
    @State private var selectedTab = 0
    
    // Shared view model for restaurants - so both Home and PayBill tabs share the same selected city
    @StateObject private var restaurantViewModel = RestaurantViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView(viewModel: restaurantViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            PayBillView(selectedTab: $selectedTab, viewModel: restaurantViewModel)
                .tabItem {
                    Image(systemName: "qrcode")
                    Text("Pay Bill")
                }
                .tag(1)

            Text("Card")
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Card")
                }
                .tag(2)

            Text("Events")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }
                .tag(3)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainHomeView()
}
