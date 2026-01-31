import SwiftUI

struct Payment: View {

    // ✅ DATA COMES FROM BillPreview
    let amountToPay: Int
    let totalBill: Int
    let selectedPeople: Int
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
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

                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.orange)
                        .padding(14)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    Text("Confirm Payment")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)

                    Text("Do you want to pay your share now?")
                        .foregroundColor(.gray)

                    // AMOUNT
                    VStack {
                        HStack {
                            Text("Amount to Pay")
                            Spacer()
                            Text("₹\(amountToPay)")
                                .font(.system(size: 22, weight: .bold))
                        }
                        .foregroundColor(.black)
                    }
                    .padding(16)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // ✅ PAY NOW
                    NavigationLink {
                        PaymentSuccess(
                            amountPaid: amountToPay,
                            totalBill: totalBill,
                            selectedPeople: selectedPeople
                        )
                    } label: {
                        Text("✓ Pay Now")
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

                    // ❌ CANCEL NOW → Go back to home
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel Now")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .cornerRadius(18)
                    }

                    Text("You can pay anytime before the bill closes")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(28)
                .background(Color.white)
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.15), radius: 12, y: 8)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    Payment(
        amountToPay: 225,
        totalBill: 900,
        selectedPeople: 4
    )
}
