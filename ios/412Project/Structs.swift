
import Foundation

//MARK: Login Details

struct LoginSuccessResponse: Codable {
    var message: String
    var username: String
    var userType: String
    var id: Int32
}

struct LoginErrorResponse: Codable {
    var detail: String
}

//MARK: Course details


struct Course: Codable, Identifiable {
    var id: Int
    var teacherId: Int
    var courseName: String
    var description: String

    enum CodingKeys: String, CodingKey {
        case id = "courseId"
        case teacherId, courseName, description
    }
}

struct CoursesResponse: Codable {
    var courses: [Course]
}

//MARK: Modules
struct ModuleDetailsResponse: Codable {
    var modules: [ModuleDetail]
}

struct ModuleDetail: Codable {
    var moduleId: Int
    var moduleName: String
    var description: String
    var assignments: [AssignmentDetail]
    var courseInfo: [CourseInfoDetail]
    var tests: [TestDetail]

    enum CodingKeys: String, CodingKey {
        case moduleId = "module_id"
        case moduleName = "module_name"
        case description, assignments, courseInfo = "course_info", tests
    }
}

struct AssignmentDetail: Codable {
    var assignmentId: Int
    var assignmentName: String

    enum CodingKeys: String, CodingKey {
        case assignmentId = "assignment_id"
        case assignmentName = "assignment_name"
    }
}

struct CourseInfoDetail: Codable {
    var courseInfoId: Int
    var information: String

    enum CodingKeys: String, CodingKey {
        case courseInfoId = "course_info_id"
        case information
    }
}

struct TestDetail: Codable {
    var testId: Int
    var testName: String

    enum CodingKeys: String, CodingKey {
        case testId = "test_id"
        case testName = "test_name"
    }
}

//MARK: Display all courses


struct CourseDetails: Codable, Identifiable {
    var id: Int { courseId }
    let courseId: Int
    let courseName: String
    let description: String
    let teacherId: Int
    let teacherName: String
}

struct ApiResponse: Codable {
    let courses: [CourseDetails]
}

//MARK: Student Courses

struct CourseInfo: Codable, Identifiable {
    var id: Int { courseId }
    let courseId: Int
    let courseName: String
    let description: String
    let teacherId: Int

    enum CodingKeys: String, CodingKey {
        case courseId = "course_id"
        case courseName = "course_name"
        case description
        case teacherId = "teacher_id"
    }
}

struct CourseListResponse: Codable {
    let courses: [CourseInfo]
    
    enum CodingKeys: String, CodingKey {
        case courses
    }
}
