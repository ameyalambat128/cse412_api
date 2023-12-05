

import Foundation
import SwiftUI
struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingPasswordAlert = false
    @State private var userType: String = "student"

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            TextField("Username", text: $username)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .padding()
                .textContentType(nil)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .textContentType(nil)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Picker("User Type", selection: $userType) {
                            Text("Student").tag("Student")
                            Text("Teacher").tag("Teacher")
                        }
                        .pickerStyle(SegmentedPickerStyle()) // Style the picker as a segmented control
                        .padding(.bottom, 20)

            Button(action: signUp) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }
        .padding()
        .alert(isPresented: $showingPasswordAlert) { // Alert configuration
                    Alert(
                        title: Text("Error"),
                        message: Text("Passwords do not match."),
                        dismissButton: .default(Text("OK"))
                    )
                }
    }

    func signUp() {
        if passwordsMatch() {
            guard let url = URL(string: "http://localhost:8000/signup") else {
                print("Invalid URL")
                return
            }

            let body: [String: String] = [
                "username": username,
                "password": password,
                "user_type": userType
            ]

            guard let jsonData = try? JSONEncoder().encode(body) else {
                print("Error encoding data")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                }
            }.resume()
        } else {
            showingPasswordAlert = true
        }
    }

    
    func passwordsMatch() -> Bool {
            return password == confirmPassword
        }
}

