import psycopg2
import bcrypt
from psycopg2 import OperationalError


def get_db_connection():
    try:
        conn = psycopg2.connect(
            host="localhost",
            dbname="cse412final",
            user="ameya",
            password="",
        )
        return conn
    except OperationalError as e:
        print(f"An error occurred: {e}")
        return None


def execute_query(query, args=None, fetch=False):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute(query, args or ())
            if fetch:
                return cursor.fetchall()
            conn.commit()


def authenticate_user(username, password):
    query = "SELECT * FROM Users WHERE Username = %s;"
    user = execute_query(query, (username,), fetch=True)
    if user:
        # Convert the bytea format to bytes
        hashed_password = bytes.fromhex(user[0][2][2:])
        if bcrypt.checkpw(password.encode("utf-8"), hashed_password):
            return user[0]
    return None


def register_user(username, password, user_type):
    # Check if the username already exists
    user_exists_query = "SELECT * FROM Users WHERE Username = %s;"
    if execute_query(user_exists_query, (username,), fetch=True):
        return "User already exists"

    # Hash the password
    hashed_password = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())

    # Start a transaction
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # Insert new user
            insert_user_query = "INSERT INTO Users (Username, Password, UserType) VALUES (%s, %s, %s) RETURNING UserID;"
            cursor.execute(insert_user_query, (username, hashed_password, user_type))
            user_id = cursor.fetchone()[0]

            # Insert into Students or Teachers table
            if user_type == "Student":
                insert_student_query = "INSERT INTO Students (UserID) VALUES (%s);"
                cursor.execute(insert_student_query, (user_id,))
            elif user_type == "Teacher":
                insert_teacher_query = "INSERT INTO Teachers (UserID) VALUES (%s);"
                cursor.execute(insert_teacher_query, (user_id,))

            conn.commit()
            return "User registered successfully"
    except Exception as e:
        conn.rollback()
        return f"An error occurred: {e}"
    finally:
        conn.close()


def create_course(teacher_id, course_name, description):
    # Check if the course already exists
    course_exists_query = "SELECT * FROM Courses WHERE CourseName = %s;"
    if execute_query(course_exists_query, (course_name,), fetch=True):
        return "Course with this name already exists"

    # Insert new course
    insert_query = (
        "INSERT INTO Courses (TeacherID, CourseName, Description) VALUES (%s, %s, %s);"
    )
    execute_query(insert_query, (teacher_id, course_name, description))
    return "Course created successfully"


def enroll_student_in_course(student_id, course_id):
    # Check if the student is already enrolled in the course
    enrollment_exists_query = (
        "SELECT * FROM StudentCourse WHERE StudentID = %s AND CourseID = %s;"
    )
    if execute_query(enrollment_exists_query, (student_id, course_id), fetch=True):
        return "Student already enrolled in this course"

    # Enroll the student in the course
    enroll_query = "INSERT INTO StudentCourse (StudentID, CourseID) VALUES (%s, %s);"
    execute_query(enroll_query, (student_id, course_id))
    return "Student enrolled successfully"
