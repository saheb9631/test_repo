import SwiftUI

struct MainHomeView: View {
    
    // Tab selection state - can be controlled via notification
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            PayBillView(selectedTab: $selectedTab)
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
