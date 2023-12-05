
import Foundation
import SwiftUI
import Foundation
import SwiftUI

struct StudentView: View {
    @State private var showingSheet = false
    @State private var courses: [CourseInfo] = []
    var username: String
    var userType: String
    var id: Int32

    var body: some View {
            NavigationView {
                List(courses, id: \.id) { course in
                    VStack(alignment: .leading) {
                        Text(course.courseName).font(.headline)
                    }
                }
                .refreshable {
                    loadCourses()
                }
                .navigationTitle("Current Courses")
                
                .sheet(isPresented: $showingSheet) {
                    AddCourseView(id: id)
                }
            }
            .onAppear(perform: loadCourses)
            .navigationBarItems(trailing: Button(action: {
                showingSheet = true
            }) {
                Image(systemName: "plus")
            })
        }

    func loadCourses() {
        guard let url = URL(string: "http://localhost:8000/student/courses") else {
            print("Invalid URL")
            return
        }

        let body: [String: Int32] = ["user_id": id]

        guard let requestBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error: Cannot create JSON body")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Error: HTTP \(httpResponse.statusCode)")
                return
            }

            guard let data = data else {
                print("Error: No data in response")
                return
            }

            if let rawJSON = String(data: data, encoding: .utf8) {
                print("Received JSON String: \(rawJSON)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CourseListResponse.self, from: data)
                DispatchQueue.main.async {
                    self.courses = decodedResponse.courses
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

}



struct AddCourseView: View {
    var id: Int32
    @State private var courses: [CourseDetails] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
                    List(courses) { course in
                        NavigationLink(destination: CourseDetailView(course: course, studentId: id)) {
                            VStack(alignment: .leading) {
                                Text(course.courseName).font(.headline)
                                Text("Teacher: \(course.teacherName)").font(.caption)
                            }
                        }
                    }
                    .onAppear(perform: loadCourses)
                    .navigationTitle("Add Courses")
                }
    }

    func loadCourses() {
        guard let url = URL(string: "http://localhost:8000/courses") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(ApiResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.courses = decodedResponse.courses
                        self.isLoading = false
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct CourseDetailView: View {
    var course: CourseDetails
    var studentId: Int32

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Course Name: \(course.courseName)")
                .font(.headline)
            Text("Description: \(course.description)")
                .font(.subheadline)
            Text("Teacher: \(course.teacherName)")
                .font(.caption)
            Text("Student ID: \(studentId)")
                .font(.caption)
            Spacer()
            Button("Register to Course") {
                enrollToCourse(studentId: studentId, courseId: Int32(course.courseId))
            }
            .padding()
        }
        .padding()
        .navigationTitle("Course Details")
    }

    func enrollToCourse(studentId: Int32, courseId: Int32) {
        guard let url = URL(string: "http://localhost:8000/student/enroll") else {
            print("Invalid URL")
            return
        }

        let body: [String: Int32] = [
            "user_id": studentId,
            "course_id": courseId
        ]

        guard let requestBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error: Cannot create JSON body")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Error: HTTP \(httpResponse.statusCode)")
                return
            }

            DispatchQueue.main.async {
                print("Successfully enrolled in the course")
            }
        }.resume()
    }

}
