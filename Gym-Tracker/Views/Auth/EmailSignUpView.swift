import SwiftUI

struct EmailSignUpView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var acceptedTerms = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                TextField("Email", text: $email)
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
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
            
            // Terms and Conditions Checkbox
            HStack(alignment: .top) {
                Button(action: { acceptedTerms.toggle() }) {
                    Image(systemName: acceptedTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(acceptedTerms ? .blue : .gray)
                        .imageScale(.large)
                }
                
                Text("I accept the ")
                    .foregroundColor(.black) +
                Text("Terms of Service")
                    .foregroundColor(.blue)
                    .underline() +
                Text(" and ")
                    .foregroundColor(.black) +
                Text("Privacy Policy")
                    .foregroundColor(.blue)
                    .underline()
            }
            .padding(.horizontal)
            
            // Create Account Button
            Button(action: handleSignUp) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 50)
            .background(acceptedTerms ? Color.blue : Color.gray)
            .cornerRadius(25)
            .padding(.horizontal)
            .disabled(!acceptedTerms)
            .padding(.bottom, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Create Account")
        .background(Color.white)
    }
    
    private func handleSignUp() {
        guard acceptedTerms else { 
            print("Terms not accepted")
            return 
        }
        guard password == confirmPassword else {
            print("Password mismatch")
            authViewModel.error = AuthError.passwordMismatch
            return
        }
        print("Sign up button tapped - Email: \(email)")
        authViewModel.signUp(email: email, password: password)
    }
}

#Preview {
    NavigationStack {
        EmailSignUpView()
            .environmentObject(AuthViewModel())
    }
} 