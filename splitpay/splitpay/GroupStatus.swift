import SwiftUI

struct GroupStatus: View {

    // ✅ DATA COMES FROM PREVIOUS SCREEN
    let totalBill: Int
    let totalPeople: Int
    let paidUserIDs: [String]

    // AUTO CALCULATIONS
    var perPerson: Int {
        totalBill / totalPeople
    }

    var collectedAmount: Int {
        perPerson * paidUserIDs.count
    }

    var pendingAmount: Int {
        totalBill - collectedAmount
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

                VStack {
                    Spacer()

                    VStack(spacing: 20) {

                        Image(systemName: "person.3.fill")
                            .foregroundColor(.orange)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .cornerRadius(14)

                        Text("Group Payment Status")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)

                        Text("Table 7–9")
                            .foregroundColor(.gray)

                        // COLLECTED / PENDING
                        HStack(spacing: 12) {
                            statusBox("Collected", collectedAmount, .green)
                            statusBox("Pending", pendingAmount, .orange)
                        }

                        // USER LIST
                        VStack(spacing: 10) {

                            headerRow()

                            userRow(id: "U01", phone: "98XXXX1234", paid: false)
                            userRow(id: "U02", phone: "98XXXX5678", paid: false)
                            userRow(id: "U03", phone: "98XXXX4321", paid: false)
                            userRow(id: "U49 (You)", phone: "65XXXX5657", paid: true)

                        }
                        .padding(14)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)

                        // PROGRESS
                        VStack(alignment: .leading, spacing: 6) {

                            ProgressView(
                                value: Double(paidUserIDs.count),
                                total: Double(totalPeople)
                            )
                            .tint(.green)

                            Text("\(paidUserIDs.count)/\(totalPeople) paid")
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

                    Spacer()
                }
                .padding()
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
            Text("User ID")
            Spacer()
            Text("Phone")
            Spacer()
            Text("Amount")
            Spacer()
            Text("Status")
        }
        .font(.system(size: 12))
        .foregroundColor(.gray)
    }

    func userRow(id: String, phone: String, paid: Bool) -> some View {
        HStack {
            Text(id)
                .foregroundColor(paid ? .orange : .black)
            Spacer()
            Text(phone)
                .foregroundColor(.gray)
            Spacer()
            Text("₹\(perPerson)")
                .foregroundColor(.black)
            Spacer()
            Text(paid ? "✔ Paid" : "✘ Unpaid")
                .foregroundColor(paid ? .green : .red)
        }
        .font(.system(size: 13))
    }
}

