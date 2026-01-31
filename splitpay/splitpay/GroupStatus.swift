import SwiftUI

struct GroupStatus: View {

    // ✅ DATA COMES FROM PREVIOUS SCREEN
    let totalBill: Int
    let totalPeople: Int
    let paidUserIDs: [String]
    
    // Access to user session for current user info
    @StateObject private var userSession = UserSession.shared
    
    // Generate mock group members based on number of people
    var groupMembers: [GroupMember] {
        var members: [GroupMember] = []
        let perPersonAmount = totalBill / totalPeople
        
        // Add current user first (marked as paid)
        members.append(GroupMember(
            name: userSession.userName.isEmpty ? "You" : userSession.userName,
            phone: userSession.phoneNumber.isEmpty ? "XXXXXXXXXX" : userSession.phoneNumber,
            hasPaid: true,
            amount: perPersonAmount,
            isCurrentUser: true
        ))
        
        // Add other mock members
        let mockNames = ["Alex", "Sam", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Quinn", "Avery", "Drew", "Jamie", "Charlie", "Dakota", "Emery", "Finley", "Harper", "Kendall", "Logan"]
        let mockPhones = ["9876543210", "9123456789", "9234567890", "9345678901", "9456789012", "9567890123", "9678901234", "9789012345", "9890123456", "9901234567"]
        
        for i in 1..<totalPeople {
            let nameIndex = (i - 1) % mockNames.count
            let phoneIndex = (i - 1) % mockPhones.count
            let isPaid = paidUserIDs.contains("U\(String(format: "%02d", i + 1))")
            
            members.append(GroupMember(
                name: mockNames[nameIndex],
                phone: mockPhones[phoneIndex],
                hasPaid: isPaid,
                amount: perPersonAmount,
                isCurrentUser: false
            ))
        }
        
        return members
    }

    // AUTO CALCULATIONS
    var perPerson: Int {
        totalBill / totalPeople
    }

    var collectedAmount: Int {
        groupMembers.filter { $0.hasPaid }.reduce(0) { $0 + $1.amount }
    }

    var pendingAmount: Int {
        totalBill - collectedAmount
    }
    
    var paidCount: Int {
        groupMembers.filter { $0.hasPaid }.count
    }

    var body: some View {
        NavigationStack {   // ✅ REQUIRED FOR NAVIGATION
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
                    VStack {
                        Spacer().frame(height: 20)

                        VStack(spacing: 20) {

                            Image(systemName: "person.3.fill")
                                .foregroundColor(.orange)
                                .padding(14)
                                .background(Color(.systemGray6))
                                .cornerRadius(14)

                            Text("Group Payment Status")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)

                            Text("Table 7–9 • \(totalPeople) people")
                                .foregroundColor(.gray)

                            // COLLECTED / PENDING
                            HStack(spacing: 12) {
                                statusBox("Collected", collectedAmount, .green)
                                statusBox("Pending", pendingAmount, .orange)
                            }

                            // USER LIST
                            VStack(spacing: 10) {
                                headerRow()
                                
                                ForEach(groupMembers) { member in
                                    memberRow(member: member)
                                }
                            }
                            .padding(14)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)

                            // PROGRESS
                            VStack(alignment: .leading, spacing: 6) {

                                ProgressView(
                                    value: Double(paidCount),
                                    total: Double(totalPeople)
                                )
                                .tint(.green)

                                Text("\(paidCount)/\(totalPeople) paid")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                            }

                            // ✅ GO TO HOME - Posts notification to pop to root and switch to Home tab
                            Button {
                                NotificationCenter.default.post(name: .popToRoot, object: nil)
                            } label: {
                                Text("Go to Home Page")
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
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(18)
                                    .shadow(color: Color.orange.opacity(0.4), radius: 8, y: 5)
                            }

                        }
                        .padding(26)
                        .background(Color.white)
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.15), radius: 12, y: 8)

                        Spacer().frame(height: 20)
                    }
                    .padding()
                }
            }
        }
    }

    // MARK: - UI COMPONENTS

    func statusBox(_ title: String, _ amount: Int, _ color: Color) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Text("₹\(amount)")
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }

    func headerRow() -> some View {
        HStack {
            Text("Name")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Phone")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Amount")
                .frame(width: 60, alignment: .trailing)
            Text("Status")
                .frame(width: 70, alignment: .trailing)
        }
        .font(.system(size: 11, weight: .medium))
        .foregroundColor(.gray)
    }

    func memberRow(member: GroupMember) -> some View {
        HStack {
            HStack(spacing: 4) {
                Text(member.name)
                    .foregroundColor(member.isCurrentUser ? .orange : .black)
                    .lineLimit(1)
                if member.isCurrentUser {
                    Text("(You)")
                        .font(.system(size: 10))
                        .foregroundColor(.orange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(member.maskedPhone)
                .foregroundColor(.gray)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("₹\(member.amount)")
                .foregroundColor(.black)
                .frame(width: 60, alignment: .trailing)
            
            Text(member.hasPaid ? "✔ Paid" : "✘ Unpaid")
                .foregroundColor(member.hasPaid ? .green : .red)
                .frame(width: 70, alignment: .trailing)
        }
        .font(.system(size: 12))
    }
}

#Preview {
    GroupStatus(totalBill: 2000, totalPeople: 4, paidUserIDs: ["U01"])
}
