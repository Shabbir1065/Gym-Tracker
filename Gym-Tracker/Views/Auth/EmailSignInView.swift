import SwiftUI

struct EmailSignInView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                TextField("Email or username", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text("minimum 6 characters")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                    }
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding(.horizontal)
            
            Button(action: {}) {
                Text("Forgot Password?")
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
            
            Button(action: handleSignIn) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 50)
            .background(Color(.systemGray4))
            .cornerRadius(25)
            .padding(.horizontal)
            
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
                
                Text("or")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .padding(.vertical)
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "apple.logo")
                            .imageScale(.large)
                        Text("Sign in with Apple")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                }
                
                Button(action: {}) {
                    HStack {
                        Image("google-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                        Text("Sign in with Google")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                }
                
            }
            .padding(.horizontal)
            
            Spacer()
            
            .padding(.bottom, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Login")
        .background(Color.white)
    }
    
    private func handleSignIn() {
        print("Sign in button tapped - Email: \(email)")
        authViewModel.signIn(email: email, password: password)
    }
}

#Preview {
    NavigationStack {
        EmailSignInView()
            .environmentObject(AuthViewModel())
    }
} 

