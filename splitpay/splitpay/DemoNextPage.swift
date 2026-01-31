import SwiftUI

struct DemoNextPage: View {

    @State private var showPeople = false
    @State private var selectedPeople = 4
    @State private var totalBill = Int.random(in: 1000...3000)

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

                VStack(spacing: 18) {

                    Image(systemName: "person.2.fill")
                        .foregroundColor(.orange)
                        .padding(14)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    Text("How Many Person?")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)

                    Text("Select the number of person splitting the bill")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    // DROPDOWN
                    VStack(spacing: 6) {

                        Button {
                            showPeople.toggle()
                        } label: {
                            HStack {
                                Text("\(selectedPeople) person")
                                    .foregroundColor(.black)

                                Spacer()

                                Image(systemName: showPeople ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.orange)
                            }
                            .padding(14)
                            .background(Color(.systemGray6))
                            .cornerRadius(14)
                        }

                        if showPeople {
                            VStack(spacing: 0) {
                                ForEach(2...6, id: \.self) { count in
                                    Button {
                                        selectedPeople = count
                                        showPeople = false
                                    } label: {
                                        HStack {
                                            Text("\(count) person")
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .padding(12)
                                    }
                                }
                            }
                            .background(Color(.systemGray6))
                            .cornerRadius(14)
                        }
                    }

                    // BILL SUMMARY
                    VStack(spacing: 14) {

                        HStack {
                            Text("Total Bill")
                            Spacer()
                            Text("₹\(totalBill)")
                        }

                        HStack {
                            Text("Split Between")
                            Spacer()
                            Text("\(selectedPeople) person")
                        }

                        Divider()

                        HStack {
                            Text("Your Share")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("₹\(totalBill / selectedPeople)")
                                .font(.title3)
                                .fontWeight(.bold)
                        }

                    }
                    .foregroundColor(.black)
                    .padding(16)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // ✅ CONFIRM SPLIT → BILL PREVIEW
                    NavigationLink {
                        BillPreview(
                            totalBill: totalBill,
                            selectedPeople: selectedPeople
                        )
                    } label: {
                        Text("Confirm Split")
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
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DemoNextPage()
    }
}
