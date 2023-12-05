
import Foundation
import SwiftUI

//MARK: Teacher View

struct TeacherView: View {
    var username: String
    var userType: String
    var id: Int32
    @State private var showingSheet = false
    @State private var courses = [Course]()

    var body: some View {
            VStack {
                List(courses) { course in
                                NavigationLink(destination: CourseDetailsView(course: course,teacherName: username)) {
                                    VStack(alignment: .leading) {
                                        Text(course.courseName).font(.headline)
                                    }
                                }
                            }
                            .onAppear(perform: loadCourses)
            }
            .onAppear(perform: loadCourses)
            .navigationBarItems(trailing: Button(action: {
                showingSheet = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingSheet) {
                SheetContentView(isShowing: $showingSheet, id: id, onCourseAdded: loadCourses)
            }
        
    }

    func loadCourses() {
        guard let url = URL(string: "http://localhost:8000/teacher/courses") else {
            print("Invalid URL")
            return
        }

        let body: [String: Int32] = ["user_id": id]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error encoding data")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(CoursesResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.courses = decodedResponse.courses
                    }
                } else {
                    print("Decoding failed")
                }
            } else if let error = error {
                print("Error making POST request: \(error)")
            }
        }.resume()
    }
}

//MARK: Sheet Content View

struct SheetContentView: View {
    @Binding var isShowing: Bool
    var id: Int32
    @State private var courseName: String = ""
    @State private var courseDescription: String = ""
    var onCourseAdded: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Add Course")
                        .padding()
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }) {
                        Image(systemName: "xmark")
                    }
                    .padding()
                }
                
                Text("Course Name")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                
                            TextField("", text: $courseName)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(5.0)
                                .padding(.horizontal)
                                
                            // Label for Description
                            Text("Description")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                
                TextEditor(text: $courseDescription)
                    .frame(minHeight: 150)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(Color(.secondarySystemBackground), lineWidth: 2)
                    )
                    .padding(.horizontal)

                Button("Add Course") {
                    addCourse()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
    
    
    
    func addCourse() {
            guard let url = URL(string: "http://localhost:8000/teacher/createCourse") else {
                print("Invalid URL")
                return
            }

            let body: [String: Any] = [
                "user_id": id,
                "course_name": courseName,
                "description": courseDescription
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                print("Error encoding data")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making POST request: \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    print("Error: HTTP \(response.statusCode)")
                    return
                }
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                                DispatchQueue.main.async {
                                    self.isShowing = false
                                    self.onCourseAdded()
                                }
                            }
                print("Course added successfully")
            }.resume()
        }
}

//MARK: Course Details View

struct CourseDetailsView: View {
    var course: Course
    var teacherName: String
    @State private var moduleDetails: [ModuleDetail] = []
    @State private var showingSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(course.courseName)
                    .font(.largeTitle)
                    .bold()

                if !moduleDetails.isEmpty {
                    ForEach(moduleDetails, id: \.moduleId) { module in
                        GroupBox(label: Text("Modules: ").font(.title2).bold()) {
                            VStack(alignment: .leading, spacing: 10) {
                                // Course Info
                                if !module.courseInfo.isEmpty {
                                    Text("Class Resources:")
                                        .font(.headline)
                                        .padding(.bottom, 5)

                                    ForEach(module.courseInfo, id: \.courseInfoId) { courseInfo in
                                        Text(courseInfo.information)
                                            .padding(.bottom, 2)
                                    }
                                }

                                // Assignments
                                if !module.assignments.isEmpty {
                                    Divider().padding(.vertical, 5)
                                    Text("Assignments:")
                                        .font(.headline)
                                        .padding(.bottom, 5)
                                    VStack(alignment: .leading, spacing: 0) {
                                            ForEach(module.assignments, id: \.assignmentId) { assignment in
                                                HStack {
                                                    Text(assignment.assignmentName)
                                                        .padding()
                                                    Spacer()
                                                }
                                                .frame(maxWidth: .infinity)
                                                .background(Color(UIColor.systemBackground))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 0)
                                                        .stroke(Color(UIColor.separator), lineWidth: 1) 
                                                )
                                            }
                                        }
                                    
                                }

                                // Tests
                                if !module.tests.isEmpty {
                                    Divider().padding(.vertical, 5)
                                    Text("Tests:")
                                        .font(.headline)
                                        .padding(.bottom, 5)
                                    VStack(alignment: .leading, spacing: 0) {
                                            ForEach(module.tests, id: \.testId) { test in
                                                HStack {
                                                    Text(test.testName)
                                                        .padding()
                                                    Spacer()
                                                }
                                                .frame(maxWidth: .infinity)
                                                .background(Color(UIColor.systemBackground))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 0)
                                                        .stroke(Color(UIColor.separator), lineWidth: 1)
                                                )
                                            }
                                        }
                                    
                                }
                            }
                            .padding()
                        }
                        .groupBoxStyle(DefaultGroupBoxStyle())
                        .padding(.bottom, 10)
                    }

                } else {
                    Text("No Course Data present... click on the \'+\' icon to start adding corse modules")
                }

                Text("Taught by \(teacherName)")
                    .font(.headline)
                    .padding(.top)
            }
            .padding()
        }
        .navigationBarTitle("Course Details", displayMode: .inline)
        .onAppear(perform: fetchCourseDetails)
        .navigationBarItems(trailing: Button(action: {
            showingSheet = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showingSheet) {
            AddModuleView(isPresented: $showingSheet, courseId: Int32(course.id))
        }
        .refreshable {
                    fetchCourseDetails()
                }
    }

    func fetchCourseDetails() {
        guard let url = URL(string: "http://localhost:8000/teacher/courseModules") else {
            print("Invalid URL")
            return
        }

        let body: [String: Int32] = ["course_id": Int32(course.id)]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error encoding data")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making POST request: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Error: HTTP \(httpResponse.statusCode)")
                return
            }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(ModuleDetailsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.moduleDetails = response.modules
                    }
                } catch {
                    print("Decoding failed: \(error)")
                }
            }
        }.resume()
    }
}

//MARK: Add Module View

struct AddModuleView: View {
    @Binding var isPresented: Bool
    var courseId: Int32

    var body: some View {
        NavigationView {
            TabView {
                AddInfoView(isPresented: $isPresented, courseId: courseId)
                    .tabItem {
                        Label("Add Info", systemImage: "info.circle")
                    }

                AddAssignmentsView(isPresented: $isPresented, courseId: courseId)
                    .tabItem {
                        Label("Add Assignments", systemImage: "text.badge.plus")
                    }

                AddTestsView(isPresented: $isPresented, courseId: courseId)
                    .tabItem {
                        Label("Add Tests", systemImage: "timer")
                    }
            }
            .navigationBarTitle("Add Module", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
            })
        }
        
    }
}

//MARK: Add Info View
struct AddInfoView: View {
    @Binding var isPresented: Bool
    var courseId: Int32
    @State private var information: String = ""

    var body: some View {
        VStack {
            Text("Add Info for Course ID \(courseId)")
            TextField("Enter information", text: $information)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save Information") {
                postCourseInformation()
            }
            Spacer()
        }
    }

    func postCourseInformation() {
        guard let url = URL(string: "http://localhost:8000/teacher/createCourseInfo") else {
            print("Invalid URL")
            return
        }

        let body: [String: Any] = [
            "course_id": courseId,
            "information": information
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
                self.isPresented = false
            }
        }.resume()
    }
}


//MARK: Add Assignments View
struct AddAssignmentsView: View {
    @Binding var isPresented: Bool
    var courseId: Int32
    @State private var assignmentName: String = ""

    var body: some View {
        VStack {
            Text("Add Assignments for Course ID \(courseId)")
            TextField("Enter assignment name", text: $assignmentName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save Assignment") {
                postAssignment()
            }
            Spacer()
        }
        .padding()
    }

    func postAssignment() {
        guard let url = URL(string: "http://localhost:8000/teacher/createAssignment") else {
            print("Invalid URL")
            return
        }

        let body: [String: Any] = [
            "course_id": courseId,
            "assignment_name": assignmentName
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
                self.isPresented = false
            }
        }.resume()
    }
}



//MARK: Add Exams View
struct AddTestsView: View {
    @Binding var isPresented: Bool
    var courseId: Int32
    @State private var testName: String = ""

    var body: some View {
        VStack {
            Text("Add Tests for Course ID \(courseId)")
            TextField("Enter test name", text: $testName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save Test") {
                postTest()
            }
            Spacer()
        }
        .padding()
    }

    func postTest() {
        guard let url = URL(string: "http://localhost:8000/teacher/createTest") else {
            print("Invalid URL")
            return
        }

        let body: [String: Any] = [
            "course_id": courseId,
            "test_name": testName
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
                self.isPresented = false
            }
        }.resume()
    }
}
