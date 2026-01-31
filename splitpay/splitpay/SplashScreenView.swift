//
//  SplashScreenView.swift
//  demo1
//
//  Created by Eazydiner on 31/01/26.
//

import SwiftUI

struct SplashScreenView: View {
    
    // Animation states
    @State private var isAnimating = false
    @State private var showTitle = false
    @State private var showTagline = false
    @State private var pulseAnimation = false
    @State private var rotationAngle: Double = 0
    @State private var particlesVisible = false
    @State private var navigateToHome = false
    
    // Particle positions for floating effect
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            // MARK: - Animated Gradient Background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.35, blue: 0.13),
                    Color(red: 0.95, green: 0.55, blue: 0.20),
                    Color(red: 0.99, green: 0.75, blue: 0.30)
                ],
                startPoint: isAnimating ? .topLeading : .bottomTrailing,
                endPoint: isAnimating ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isAnimating)
            
            // MARK: - Floating Particles
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.white.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .blur(radius: particle.blur)
                    .offset(x: particle.x, y: particlesVisible ? particle.endY : particle.startY)
                    .animation(
                        .easeInOut(duration: particle.duration)
                        .repeatForever(autoreverses: true)
                        .delay(particle.delay),
                        value: particlesVisible
                    )
            }
            
            // MARK: - Glow Ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 4
                )
                .frame(width: 180, height: 180)
                .scaleEffect(pulseAnimation ? 1.15 : 0.9)
                .opacity(pulseAnimation ? 0.4 : 0.8)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
            
            // MARK: - Second Glow Ring (delayed)
            Circle()
                .stroke(
                    Color.white.opacity(0.2),
                    lineWidth: 2
                )
                .frame(width: 220, height: 220)
                .scaleEffect(pulseAnimation ? 1.3 : 0.85)
                .opacity(pulseAnimation ? 0.2 : 0.6)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(0.3), value: pulseAnimation)
            
            VStack(spacing: 24) {
                
                // MARK: - Logo Container with Glow
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 40,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 20)
                    
                    // Main logo circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color.white.opacity(0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 130, height: 130)
                        .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
                        .overlay(
                            // Fork and Knife Icon
                            ZStack {
                                // Plate circle
                                Circle()
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 3)
                                    .frame(width: 90, height: 90)
                                
                                // Fork and knife
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 50, weight: .medium))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.98, green: 0.35, blue: 0.13),
                                                Color(red: 0.95, green: 0.55, blue: 0.20)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .rotationEffect(.degrees(rotationAngle))
                            }
                        )
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .opacity(isAnimating ? 1.0 : 0.0)
                }
                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0), value: isAnimating)
                
                // MARK: - Title
                VStack(spacing: 8) {
                    Text("EazyDiner")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                        .scaleEffect(showTitle ? 1.0 : 0.8)
                        .opacity(showTitle ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: showTitle)
                    
                    // MARK: - Tagline
                    Text("Discover • Dine • Delight")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(2)
                        .opacity(showTagline ? 1.0 : 0.0)
                        .offset(y: showTagline ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.6), value: showTagline)
                }
                
                // MARK: - Loading Indicator
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                            .scaleEffect(showTagline ? 1.0 : 0.5)
                            .opacity(showTagline ? 1.0 : 0.3)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: showTagline
                            )
                    }
                }
                .padding(.top, 40)
                .opacity(showTagline ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.3).delay(0.8), value: showTagline)
            }
            
            // MARK: - Bottom Decorative Wave
            VStack {
                Spacer()
                
                WaveShape()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 120)
                    .offset(y: isAnimating ? 0 : 120)
                    .animation(.easeOut(duration: 1.2).delay(0.5), value: isAnimating)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            // Initialize particles
            initializeParticles()
            
            // Start animations with delays
            withAnimation {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showTitle = true
                pulseAnimation = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showTagline = true
                particlesVisible = true
            }
            
            // Gentle rotation animation for the icon
            withAnimation(.easeInOut(duration: 2).delay(0.5)) {
                rotationAngle = 360
            }
            
            // Navigate to main app after splash
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    navigateToHome = true
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            MainHomeView()
        }
    }
    
    private func initializeParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<15 {
            let particle = Particle(
                x: CGFloat.random(in: -screenWidth/2...screenWidth/2),
                startY: CGFloat.random(in: 0...screenHeight),
                endY: CGFloat.random(in: -screenHeight/2..<screenHeight/2),
                size: CGFloat.random(in: 4...15),
                opacity: Double.random(in: 0.1...0.4),
                blur: CGFloat.random(in: 0...3),
                duration: Double.random(in: 3...6),
                delay: Double.random(in: 0...2)
            )
            particles.append(particle)
        }
    }
}

// MARK: - Particle Model
struct Particle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let startY: CGFloat
    let endY: CGFloat
    let size: CGFloat
    let opacity: Double
    let blur: CGFloat
    let duration: Double
    let delay: Double
}

// MARK: - Wave Shape
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height * 0.5))
        
        // First wave
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.3),
            control1: CGPoint(x: width * 0.15, y: height * 0.1),
            control2: CGPoint(x: width * 0.35, y: height * 0.5)
        )
        
        // Second wave
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.4),
            control1: CGPoint(x: width * 0.65, y: height * 0.1),
            control2: CGPoint(x: width * 0.85, y: height * 0.5)
        )
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    SplashScreenView()
}
