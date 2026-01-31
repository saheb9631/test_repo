import SwiftUI

struct ContentView: View {

    @State private var showGroups = false
    @State private var selectedGroup = "Select restaurant group"

    var body: some View {
        ZStack {

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

                        Spacer().frame(height: 16)

                        // USER CARD
                        SoftCard {
                            VStack(spacing: 14) {

                                Text("Split")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.black)
                                + Text("Pay")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.orange)

                                Text("Split bills effortlessly with friends")
                                    .foregroundColor(.gray)

                                SoftField(icon: "person.fill", placeholder: "Your name")
                                SoftField(icon: "phone.fill", placeholder: "Phone number")

                                // DROPDOWN
                                VStack(spacing: 6) {
                                    Button {
                                        showGroups.toggle()
                                    } label: {
                                        HStack {
                                            Image(systemName: "person.3.fill")
                                                .foregroundColor(.orange)

                                            Text(selectedGroup)
                                                .foregroundColor(
                                                    selectedGroup == "Select restaurant group"
                                                    ? .gray : .black
                                                )

                                            Spacer()

                                            Image(systemName: showGroups ? "chevron.up" : "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(14)
                                    }

                                    if showGroups {
                                        VStack(spacing: 0) {
                                            DemoGroupRow(title: "Cafe Demo") {
                                                selectGroup("Cafe Demo")
                                            }
                                            DemoGroupRow(title: "Restaurant A") {
                                                selectGroup("Restaurant A")
                                            }
                                            DemoGroupRow(title: "Restaurant B") {
                                                selectGroup("Restaurant B")
                                            }
                                        }
                                        .background(Color(.systemGray6))
                                        .cornerRadius(14)
                                    }
                                }

                                // ✅ CONTINUE → Goes to ScanQRView
                                NavigationLink {
                                    ScanQRView()
                                } label: {
                                    SoftButton(title: "Continue")
                                }
                            }
                        }

                        // MANAGER CARD
                        SoftCard {
                            VStack(spacing: 14) {

                                Image(systemName: "shield.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(.orange)

                                Text("Manager Access")
                                    .font(.system(size: 20, weight: .semibold))

                                Text("Enter manager code")
                                    .foregroundColor(.gray)

                                SoftField(icon: "lock.fill", placeholder: "Manager code")

                                SoftButton(title: "Verify Access")
                            }
                        }

                        Spacer().frame(height: 20)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }

    func selectGroup(_ name: String) {
        selectedGroup = name
        showGroups = false
    }
}
struct SoftCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background(Color.white)
            .cornerRadius(22)
            .shadow(color: .black.opacity(0.12), radius: 8, y: 5)
    }
}

struct SoftField: View {
    var icon: String
    var placeholder: String
    @State private var text = ""

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
            TextField(placeholder, text: $text)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}

struct DemoGroupRow: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
            }
            .padding(12)
        }
    }
}

struct SoftButton: View {
    var title: String

    var body: some View {
        Text(title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 1.00, green: 0.58, blue: 0.20),
                        Color(red: 0.92, green: 0.35, blue: 0.15)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(18)
    }
}
#Preview(){
    ContentView()
}
