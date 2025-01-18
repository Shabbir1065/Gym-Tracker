import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showEmailSignIn = false
    @State private var mainContentOpacity: Double = 1
    
    var body: some View {
        NavigationStack {
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
                
                // Main Content
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 40)
                    
                    // App Title and Subtitle
                    VStack(spacing: 8) {
                        Text("Gym Tracker")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Track your fitness journey")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Sign in Buttons
                    VStack(spacing: 16) {
                        // Apple Sign In
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "apple.logo")
                                    .imageScale(.large)
                                Text("Sign up with Apple")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.black)
                            .cornerRadius(12)
                        }
                        
                        // Google Sign In
                        Button(action: {}) {
                            HStack {
                                Image("google-logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 24)
                                Text("Sign up with Google")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        // Email Sign Up
                        NavigationLink(destination: EmailSignUpView()) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .imageScale(.large)
                                Text("Sign up with Email")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Sign In Link
                    NavigationLink(destination: EmailSignInView()) {
                        Text("Already have an account? ")
                            .foregroundColor(.white) +
                        Text("Log In")
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding(.top, 16)
                    
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
                .opacity(mainContentOpacity)
                .animation(.easeInOut(duration: 0.5), value: mainContentOpacity)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
