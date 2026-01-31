import SwiftUI

struct PaymentSuccess: View {

    let amountPaid: Int
    let totalBill: Int
    let selectedPeople: Int

    let userId: String = "U29"

    var body: some View {

        ZStack {

            // ✅ UPDATED PREMIUM BACKGROUND
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

                VStack(spacing: 22) {

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.green)
                        .padding(14)
                        .background(Color(.systemGray6))
                        .cornerRadius(14)

                    Text("Payment Successful!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)

                    Text("Thanks! Your payment has been processed.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Text("• PAID")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.green)

                    VStack(spacing: 14) {

                        HStack {
                            Text("Amount")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("₹\(amountPaid)")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }

                        HStack {
                            Text("User ID")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(userId)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }

                    }
                    .padding(18)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // VIEW GROUP STATUS
                    NavigationLink {
                        GroupStatus(
                            totalBill: totalBill,
                            totalPeople: selectedPeople,
                            paidUserIDs: [userId]
                        )
                    } label: {
                        Text("View Group Status →")
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
                .padding(28)
                .background(Color.white)
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.15), radius: 12, y: 8)

                Spacer()
            }
            .padding()
        }
    }
}
