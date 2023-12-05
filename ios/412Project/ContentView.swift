
import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isShowingSignUp = false
    @State private var showingLoginAlert = false
    @State private var loginAlertMessage = ""
    @State private var isActiveStudentView = false
    @State private var isActiveTeacherView = false
    @State private var loggedInUsername: String = ""
    @State private var loggedInUserType: String = ""
    @State private var loggedInId: Int32 = 0
    @State private var isPasswordVisible: Bool = false


        var body: some View {
            NavigationView{
                VStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        .padding()
                    
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    ZStack(alignment: .trailing) {
                                   Group {
                                       if isPasswordVisible {
                                           TextField("Password", text: $password)
                                       } else {
                                           SecureField("Password", text: $password)
                                       }
                                   }
                                   .autocapitalization(.none)
                                   .padding()
                                   .background(Color(.secondarySystemBackground))
                                   .cornerRadius(5.0)
                                   .overlay(
                                       Button(action: {
                                           isPasswordVisible.toggle()
                                       }) {
                                           Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                               .foregroundColor(.blue)
                                       }
                                       .padding(.trailing, 35)
                                       , alignment: .trailing
                                   )
                               }
                               .padding(.bottom, 20)

                    
                    Button(action: login) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                            .cornerRadius(15.0)
                    }
                    
                    NavigationLink(destination: SignUpView(), isActive: $isShowingSignUp) {
                        Button("Sign Up") {
                            isShowingSignUp = true
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.green)
                        .cornerRadius(15.0)
                    }
                    NavigationLink(destination: StudentView(username: loggedInUsername, userType: loggedInUserType, id: loggedInId), isActive: $isActiveStudentView) { EmptyView() }
                        NavigationLink(destination: TeacherView(username: loggedInUsername, userType: loggedInUserType, id: loggedInId), isActive: $isActiveTeacherView) { EmptyView() }
                }
                .padding()
                .alert(isPresented: $showingLoginAlert) {
                        Alert(
                            title: Text("Login Failed"),
                            message: Text(loginAlertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            }
        }
    
    func login() {
        guard let url = URL(string: "http://localhost:8000/login") else {
            print("Invalid URL")
            return
        }

        let body: [String: String] = [
            "username": username,
            "password": password
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
                do {
                    let decoder = JSONDecoder()
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        let successResponse = try decoder.decode(LoginSuccessResponse.self, from: data)
                        print("User logged in successfully: \(successResponse.username), UserType: \(successResponse.userType)")
                        DispatchQueue.main.async {
                                self.loggedInUsername = successResponse.username
                                self.loggedInUserType = successResponse.userType
                                self.loggedInId = successResponse.id
                                self.isActiveStudentView = successResponse.userType == "Student"
                                self.isActiveTeacherView = successResponse.userType == "Teacher"
                            }
                    } else {
                        let errorResponse = try decoder.decode(LoginErrorResponse.self, from: data)
                        print("Login failed: \(errorResponse.detail)")
                        // Handle login error here
                        DispatchQueue.main.async {
                                                self.loginAlertMessage = errorResponse.detail
                                                self.showingLoginAlert = true
                                            }
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }

}

