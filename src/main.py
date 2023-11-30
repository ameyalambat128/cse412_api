from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from .db.database import (
    authenticate_user,
    register_user,
    enroll_student_in_course,
    create_course,
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

    return {"message": "User logged in successfully", "user": user}


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


class CourseCreate(BaseModel):
    teacher_id: int
    course_name: str
    description: str


@app.post("/teacher/create_course")
async def create_course_endpoint(course_data: CourseCreate):
    result = create_course(
        course_data.teacher_id, course_data.course_name, course_data.description
    )
    if result == "Course with this name already exists":
        raise HTTPException(status_code=400, detail=result)
    return {"message": result}


class CourseEnrollment(BaseModel):
    student_id: int
    course_id: int


@app.post("/student/enroll")
async def add_course(course_enrollment: CourseEnrollment):
    result = enroll_student_in_course(
        course_enrollment.student_id, course_enrollment.course_id
    )
    if result == "Student already enrolled in this course":
        raise HTTPException(status_code=400, detail="Already enrolled in course")
    return {"message": result}


@app.get("/student/courses")
async def get_student_courses():
    # Fetch courses for the student from the database.
    return {"message": "Courses for student"}


@app.get("/teacher/courses")
async def get_teacher_courses():
    # Fetch courses taught by the teacher from the database.
    return {"message": "Courses for teacher"}
