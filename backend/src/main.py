from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel

from .db.database import (
    authenticate_user,
    register_user,
    enroll_student_in_course,
    create_course,
    get_teacher_courses,
    get_student_courses,
    get_all_courses,
    get_course_modules,
    create_course_info_for_course,
    create_assignment_for_course,
    create_test_for_course,
)


app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Welcome to Savnac API"}


class LoginModel(BaseModel):
    username: str
    password: str


@app.post("/login")
async def login(login_data: LoginModel):
    user = authenticate_user(login_data.username, login_data.password)
    if user is None:
        raise HTTPException(status_code=401, detail="Incorrect username or password")

    # Extract username and userType from the user record
    id = user[0]
    username = user[1]
    userType = user[3]

    return {
        "message": "User logged in successfully",
        "id": id,
        "username": username,
        "userType": userType,
    }


class SignupModel(BaseModel):
    username: str
    password: str
    user_type: str


@app.post("/signup")
async def signup(user_data: SignupModel):
    if user_data.user_type not in ["Student", "Teacher"]:
        raise HTTPException(status_code=400, detail="Invalid user type")

    result = register_user(user_data.username, user_data.password, user_data.user_type)
    if result == "User already exists":
        raise HTTPException(status_code=400, detail="Username already taken")

    return {"message": result}


"""
Teacher Endpoints

"""


class CourseCreate(BaseModel):
    user_id: int
    course_name: str
    description: str


@app.post("/teacher/createCourse")
async def create_course_endpoint(course_data: CourseCreate):
    result = create_course(
        course_data.user_id, course_data.course_name, course_data.description
    )
    if result == "Course with this name already exists":
        raise HTTPException(status_code=400, detail=result)
    return {"message": result}


class TeacherCourseRequest(BaseModel):
    user_id: int


@app.post("/teacher/courses")
async def teacher_courses(course_request: TeacherCourseRequest):
    courses = get_teacher_courses(course_request.user_id)
    if courses is None:
        raise HTTPException(
            status_code=404,
            detail="No courses found for the teacher or teacher not found",
        )
    return {"courses": courses}


class CourseInfoCreate(BaseModel):
    course_id: int
    information: str


@app.post("/teacher/createCourseInfo")
async def create_course_info_endpoint(course_info: CourseInfoCreate):
    message = create_course_info_for_course(
        course_info.course_id, course_info.information
    )
    return {"message": message}


class CourseAssignmentCreate(BaseModel):
    course_id: int
    assignment_name: str


@app.post("/teacher/createAssignment")
async def create_course_assignment_endpoint(assignment: CourseAssignmentCreate):
    message = create_assignment_for_course(
        assignment.course_id, assignment.assignment_name
    )
    return {"message": message}


class CourseTestCreate(BaseModel):
    course_id: int
    test_name: str


@app.post("/teacher/createTest")
async def create_test_endpoint(test: CourseTestCreate):
    message = create_test_for_course(test.course_id, test.test_name)
    return {"message": message}


class CourseDetailsRequest(BaseModel):
    course_id: int


@app.post("/teacher/courseModules")
async def course_details(course_request: CourseDetailsRequest):
    modules = get_course_modules(course_request.course_id)
    if not modules:
        raise HTTPException(status_code=404, detail="Course modules not found")
    return modules


"""
Student Endpoints

"""


@app.get("/courses")
async def all_courses():
    courses = get_all_courses()
    if not courses:
        raise HTTPException(status_code=404, detail="No courses found")
    return {"courses": courses}


class StudentCourseRequest(BaseModel):
    user_id: int


@app.post("/student/courses")
async def student_courses(course_request: StudentCourseRequest):
    courses = get_student_courses(course_request.user_id)
    if courses is None:
        raise HTTPException(
            status_code=404,
            detail="No courses found for the teacher or teacher not found",
        )
    return {"courses": courses}


class CourseEnrollment(BaseModel):
    user_id: int
    course_id: int


@app.post("/student/enroll")
async def add_course(course_enrollment: CourseEnrollment):
    result = enroll_student_in_course(
        course_enrollment.user_id, course_enrollment.course_id
    )
    if result == "Student already enrolled in this course":
        raise HTTPException(status_code=400, detail="Already enrolled in course")
    return {"message": result}
