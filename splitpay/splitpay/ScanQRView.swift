import SwiftUI
import AVFoundation

struct ScanQRView: View {

    @State private var session = AVCaptureSession()
    @State private var isScanning = false

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

                        Text("Scan the QR code on your table to get started")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        // 🔲 CAMERA BOX
                        ZStack {
                            if isScanning {
                                CameraPreview(session: session)
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
                                    Color.orange,
                                    style: StrokeStyle(lineWidth: 2, dash: [6])
                                )
                        )

                        // ▶️ START CAMERA
                        Button {
                            startCamera()
                        } label: {
                            Text("Start Camera Scan")
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
                        }

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
        }
    }
}
