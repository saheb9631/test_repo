import SwiftUI
import AVFoundation

struct ScanQRView: View {

    @State private var session = AVCaptureSession()
    @State private var isScanning = false
    @State private var navigateToDemoPage = false  // Auto-navigation after 4 seconds
    @State private var scanProgress: Double = 0     // Progress indicator

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

                VStack {
                    Spacer()

                    VStack(spacing: 18) {

                        Image(systemName: "bolt.fill")
                            .foregroundColor(.orange)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                        Text("Scan Table QR")
                            .font(.system(size: 22, weight: .bold))

                        Text(isScanning ? "Scanning... Please hold steady" : "Scan the QR code on your table to get started")
                            .font(.system(size: 14))
                            .foregroundColor(isScanning ? .orange : .gray)
                            .multilineTextAlignment(.center)
                            .animation(.easeInOut, value: isScanning)

                        // 🔲 CAMERA BOX
                        ZStack {
                            if isScanning {
                                CameraPreview(session: session)
                                
                                // Scanning overlay animation
                                VStack {
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.orange.opacity(0.5), Color.clear],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(height: 3)
                                        .offset(y: scanProgress * 200 - 100)
                                        .animation(.linear(duration: 2).repeatForever(autoreverses: true), value: scanProgress)
                                }
                            } else {
                                Image(systemName: "qrcode.viewfinder")
                                    .font(.system(size: 42))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 220, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(
                                    isScanning ? Color.green : Color.orange,
                                    style: StrokeStyle(lineWidth: 2, dash: isScanning ? [] : [6])
                                )
                                .animation(.easeInOut, value: isScanning)
                        )
                        
                        // Progress indicator when scanning
                        if isScanning {
                            VStack(spacing: 8) {
                                ProgressView(value: scanProgress, total: 1.0)
                                    .tint(.orange)
                                    .animation(.linear(duration: 0.1), value: scanProgress)
                                
                                Text("QR Code detected... Processing")
                                    .font(.system(size: 12))
                                    .foregroundColor(.green)
                            }
                            .transition(.opacity)
                        }

                        // ▶️ START CAMERA
                        Button {
                            startCamera()
                        } label: {
                            HStack {
                                if isScanning {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                Text(isScanning ? "Scanning..." : "Start Camera Scan")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(
                                LinearGradient(
                                    colors: isScanning ? [Color.green, Color.green.opacity(0.8)] : [
                                        Color(red: 1.00, green: 0.58, blue: 0.20),
                                        Color(red: 0.92, green: 0.35, blue: 0.15)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(18)
                        }
                        .disabled(isScanning)

                        NavigationLink {
                            DemoNextPage()
                        } label: {
                            Text("Demo: Simulate Scan")
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Color(.systemGray6))
                                .cornerRadius(16)
                        }

                    }
                    .padding(28)
                    .background(Color.white)
                    .cornerRadius(28)

                    Spacer()
                }
                .padding()
            }
            // Hidden NavigationLink for programmatic navigation
            .background(
                NavigationLink(
                    destination: DemoNextPage(),
                    isActive: $navigateToDemoPage,
                    label: { EmptyView() }
                )
            )
        }

    // 📸 CAMERA SETUP
    func startCamera() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                setupSession()
            }
        }
    }

    func setupSession() {
        DispatchQueue.main.async {
            session.beginConfiguration()

            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: .back),
                  let input = try? AVCaptureDeviceInput(device: device)
            else { return }

            if session.canAddInput(input) {
                session.addInput(input)
            }

            session.commitConfiguration()
            session.startRunning()
            isScanning = true
            
            // Start scanning animation
            withAnimation {
                scanProgress = 1.0
            }
            
            // Auto-navigate to DemoNextPage after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                // Stop camera
                session.stopRunning()
                isScanning = false
                scanProgress = 0
                
                // Navigate to next page
                navigateToDemoPage = true
            }
        }
    }
}
