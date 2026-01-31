import SwiftUI

struct ContentView: View {

    // User session to store data
    @StateObject private var userSession = UserSession.shared
    
    // Local state for UI
    @State private var showGroups = false
    @State private var selectedGroup = "Select restaurant group"
    @State private var showValidationError = false

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

                                // NAME FIELD
                                ValidatedField(
                                    icon: "person.fill",
                                    placeholder: "Your name",
                                    text: $userSession.userName,
                                    isValid: userSession.isNameValid,
                                    keyboardType: .default
                                )
                                
                                // PHONE FIELD - Numbers only, 10 digits
                                VStack(alignment: .leading, spacing: 4) {
                                    ValidatedField(
                                        icon: "phone.fill",
                                        placeholder: "Phone number (10 digits)",
                                        text: $userSession.phoneNumber,
                                        isValid: userSession.isPhoneValid,
                                        keyboardType: .numberPad
                                    )
                                    .onChange(of: userSession.phoneNumber) { oldValue, newValue in
                                        // Only allow digits and max 10 characters
                                        let filtered = newValue.filter { $0.isNumber }
                                        if filtered.count <= 10 {
                                            userSession.phoneNumber = filtered
                                        } else {
                                            userSession.phoneNumber = String(filtered.prefix(10))
                                        }
                                    }
                                    
                                    if !userSession.phoneNumber.isEmpty && !userSession.isPhoneValid {
                                        Text("Phone must be 10 digits")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                // NUMBER OF PEOPLE SELECTOR
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Number of People")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                            .foregroundColor(.orange)
                                        
                                        Spacer()
                                        
                                        // Stepper with buttons
                                        HStack(spacing: 16) {
                                            Button {
                                                if userSession.numberOfPeople > 2 {
                                                    userSession.numberOfPeople -= 1
                                                }
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.system(size: 28))
                                                    .foregroundColor(userSession.numberOfPeople > 2 ? .orange : .gray)
                                            }
                                            .disabled(userSession.numberOfPeople <= 2)
                                            
                                            Text("\(userSession.numberOfPeople)")
                                                .font(.system(size: 22, weight: .bold))
                                                .frame(width: 40)
                                            
                                            Button {
                                                if userSession.numberOfPeople < 20 {
                                                    userSession.numberOfPeople += 1
                                                }
                                            } label: {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.system(size: 28))
                                                    .foregroundColor(userSession.numberOfPeople < 20 ? .orange : .gray)
                                            }
                                            .disabled(userSession.numberOfPeople >= 20)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(14)
                                }

                                // DROPDOWN - Restaurant Group
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

                                // VALIDATION ERROR
                                if showValidationError {
                                    Text("Please fill in all fields correctly")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .transition(.opacity)
                                }

                                // ✅ CONTINUE → Goes to ScanQRView (only if form is valid)
                                NavigationLink {
                                    ScanQRView()
                                } label: {
                                    SoftButton(title: "Continue")
                                }
                                .disabled(!userSession.isFormValid)
                                .opacity(userSession.isFormValid ? 1.0 : 0.5)
                                .simultaneousGesture(TapGesture().onEnded {
                                    if !userSession.isFormValid {
                                        withAnimation {
                                            showValidationError = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                showValidationError = false
                                            }
                                        }
                                    }
                                })
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

// MARK: - Validated Field Component
struct ValidatedField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isValid: Bool
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
            
            if !text.isEmpty {
                Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isValid ? .green : .red)
                    .font(.system(size: 16))
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    text.isEmpty ? Color.clear : (isValid ? Color.green.opacity(0.3) : Color.red.opacity(0.3)),
                    lineWidth: 1
                )
        )
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
