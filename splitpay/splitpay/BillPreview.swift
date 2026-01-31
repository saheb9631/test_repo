import SwiftUI

struct BillPreview: View {

    let totalBill: Int
    let selectedPeople: Int

    var yourShare: Int {
        totalBill / selectedPeople
    }

    var body: some View {

        ZStack {

            // ✅ UPDATED PREMIUM BACKGROUND (PayBill theme)
            LinearGradient(
                colors: [
                    Color(red: 0.35, green: 0.20, blue: 0.55),
                    Color(red: 0.95, green: 0.50, blue: 0.30)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {

                Text("Bill Split Preview")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                VStack(spacing: 16) {

                    HStack {
                        Text("Total Bill")
                        Spacer()
                        Text("₹\(totalBill)")
                    }

                    HStack {
                        Text("Number of Person")
                        Spacer()
                        Text("\(selectedPeople)")
                    }

                    Divider()

                    HStack {
                        Text("Your Share")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("₹\(yourShare)")
                            .font(.system(size: 22, weight: .bold))
                    }

                }
                .foregroundColor(.black)
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(18)

                // CONTINUE → PAYMENT
                NavigationLink {
                    Payment(
                        amountToPay: yourShare,
                        totalBill: totalBill,
                        selectedPeople: selectedPeople
                    )
                } label: {
                    Text("Continue to Payment")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
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

                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 8)
            )
            .padding()
        }
        .navigationTitle("Preview")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BillPreview(totalBill: 1800, selectedPeople: 4)
    }
}
