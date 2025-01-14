import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            // Background Image with Gradient Overlays
            GeometryReader { geometry in
                Image("Cover-Photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay {
                        LinearGradient(
                            colors: [.black.opacity(0.7), .clear, .black.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
            }
            .ignoresSafeArea()
            
            // Content
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.05) // Margin from top
                    
                    // App Title and Subtitle
                    VStack(spacing: 8) {
                        Text("Gym Tracker")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Track your fitness journey")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer() // Flexible space between title and buttons
                    
                    // Sign in Buttons
                    VStack(spacing: 16) { // Margin between buttons
                        // Apple Sign In
                        Button(action: {
                            // Handle Apple sign in
                        }) {
                            HStack {
                                Image(systemName: "apple.logo")
                                    .imageScale(.large)
                                Text("Sign in with Apple")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)  // White text for Apple button
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.black)
                            .cornerRadius(12)
                        }
                        
                        // Google Sign In
                        Button(action: {
                            // Handle Google sign in
                        }) {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                    .imageScale(.large)
                                Text("Sign in with Google")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.black)  // Black text for Google button
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        // Email Sign In
                        Button(action: {
                            // Handle email sign in
                        }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .imageScale(.large)
                                Text("Sign in with Email")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)  // White text for Email button
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    // Terms and Privacy
                    Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
