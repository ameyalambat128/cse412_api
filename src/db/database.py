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


def create_course(user_id, course_name, description):
    # Fetch the teacher_id for the given user_id
    teacher_id_query = "SELECT TeacherID FROM Teachers WHERE UserID = %s;"
    teacher_result = execute_query(teacher_id_query, (user_id,), fetch=True)
    if not teacher_result:
        return "Teacher not found"

    teacher_id = teacher_result[0][0]  # Assuming TeacherID is the first column

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


def get_teacher_courses(user_id):
    # Fetch the teacher_id for the given user_id
    teacher_id_query = "SELECT TeacherID FROM Teachers WHERE UserID = %s;"
    teacher_result = execute_query(teacher_id_query, (user_id,), fetch=True)
    if not teacher_result:
        return None

    teacher_id = teacher_result[0][0]  # Assuming TeacherID is the first column

    # Fetch courses taught by the teacher
    courses_query = "SELECT * FROM Courses WHERE TeacherID = %s;"
    result = execute_query(courses_query, (teacher_id,), fetch=True)

    # Format the results as a list of dictionaries
    courses = []
    if result:
        for course in result:
            courses.append(
                {
                    "courseId": course[0],
                    "teacherId": course[1],
                    "courseName": course[2],
                    "description": course[3],
                }
            )
    return courses


def create_course_info_for_course(course_id, information):
    module_query = "SELECT ModuleID FROM Modules WHERE CourseID = %s LIMIT 1;"
    module_result = execute_query(module_query, (course_id,), fetch=True)
    if module_result:
        module_id = module_result[0][0]
    else:
        # Create a new module for the course
        new_module_query = "INSERT INTO Modules (CourseID, ModuleName, Description) VALUES (%s, %s, %s) RETURNING ModuleID;"
        module_name = f"New Module for {course_id}"
        module_description = f"Auto-generated module for {course_id}"
        module_id = execute_query(
            new_module_query, (course_id, module_name, module_description), fetch=True
        )[0][0]

    # Add course info to the newly created module
    query = "INSERT INTO CourseInfo (ModuleID, Information) VALUES (%s, %s);"
    execute_query(query, (module_id, information))

    return "Course information added successfully to a new module"


def create_assignment_for_course(course_id, assignment_name):
    module_query = "SELECT ModuleID FROM Modules WHERE CourseID = %s LIMIT 1;"
    module_result = execute_query(module_query, (course_id,), fetch=True)
    if module_result:
        module_id = module_result[0][0]
    else:
        # Create a new module for the course
        new_module_query = "INSERT INTO Modules (CourseID, ModuleName, Description) VALUES (%s, %s, %s) RETURNING ModuleID;"
        module_name = f"New Module for {assignment_name}"
        module_description = f"Auto-generated module for {assignment_name}"
        module_id = execute_query(
            new_module_query, (course_id, module_name, module_description), fetch=True
        )[0][0]

    # Add assignment to the newly created module
    query = "INSERT INTO Assignments (ModuleID, AssignmentName) VALUES (%s, %s);"
    execute_query(query, (module_id, assignment_name))

    return "Assignment created successfully in a new module"


def create_test_for_course(course_id, test_name):
    module_query = "SELECT ModuleID FROM Modules WHERE CourseID = %s LIMIT 1;"
    module_result = execute_query(module_query, (course_id,), fetch=True)
    if module_result:
        module_id = module_result[0][0]
    else:
        # Create a new module for the course
        new_module_query = "INSERT INTO Modules (CourseID, ModuleName, Description) VALUES (%s, %s, %s) RETURNING ModuleID;"
        module_name = f"New Module for {test_name}"
        module_description = f"Auto-generated module for {test_name}"
        module_id = execute_query(
            new_module_query, (course_id, module_name, module_description), fetch=True
        )[0][0]

    # Add test to the newly created module
    query = "INSERT INTO Tests (ModuleID, TestName) VALUES (%s, %s);"
    execute_query(query, (module_id, test_name))

    return "Test created successfully in a new module"


def get_course_modules(course_id):
    course_modules = {"modules": []}  # Renamed key to "modules"

    # Fetch Modules for the course
    modules_query = (
        "SELECT ModuleID, ModuleName, Description FROM Modules WHERE CourseID = %s;"
    )
    modules = execute_query(modules_query, (course_id,), fetch=True)

    for module in modules:
        module_id = module[0]  # Assuming ModuleID is the first column
        module_detail = {
            "module_id": module_id,
            "module_name": module[1],
            "description": module[2],
            "assignments": [],
            "course_info": [],
            "tests": [],
        }

        # Fetch Assignments for the module
        assignments_query = (
            "SELECT AssignmentID, AssignmentName FROM Assignments WHERE ModuleID = %s;"
        )
        assignments = execute_query(assignments_query, (module_id,), fetch=True)
        for assignment in assignments:
            module_detail["assignments"].append(
                {"assignment_id": assignment[0], "assignment_name": assignment[1]}
            )

        # Fetch Course Info for the module
        course_info_query = (
            "SELECT CourseInfoID, Information FROM CourseInfo WHERE ModuleID = %s;"
        )
        course_infos = execute_query(course_info_query, (module_id,), fetch=True)
        for info in course_infos:
            module_detail["course_info"].append(
                {"course_info_id": info[0], "information": info[1]}
            )

        # Fetch Tests for the module
        tests_query = "SELECT TestID, TestName FROM Tests WHERE ModuleID = %s;"
        tests = execute_query(tests_query, (module_id,), fetch=True)
        for test in tests:
            module_detail["tests"].append({"test_id": test[0], "test_name": test[1]})

        course_modules["modules"].append(module_detail)

    return course_modules


def get_all_courses():
    query = """
    SELECT c.CourseID, c.CourseName, c.Description, t.TeacherID, u.Username
    FROM Courses c
    JOIN Teachers t ON c.TeacherID = t.TeacherID
    JOIN Users u ON t.UserID = u.UserID;
    """
    result = execute_query(query, fetch=True)

    # Format the results as a list of dictionaries
    courses = []
    if result:
        for course in result:
            courses.append(
                {
                    "courseId": course[0],
                    "courseName": course[1],
                    "description": course[2],
                    "teacherId": course[3],
                    "teacherName": course[4],
                }
            )
    return courses


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


def get_student_courses(user_id):
    # Fetch the student_id for the given user_id
    student_id_query = "SELECT StudentID FROM Students WHERE UserID = %s;"
    student_result = execute_query(student_id_query, (user_id,), fetch=True)
    if not student_result:
        return None

    student_id = student_result[0][0]  # Assuming StudentID is the first column

    # Fetch courses the student is enrolled in
    courses_query = """
    SELECT c.CourseID, c.CourseName, c.Description, t.TeacherID 
    FROM Courses c
    INNER JOIN StudentCourse sc ON c.CourseID = sc.CourseID
    INNER JOIN Teachers t ON c.TeacherID = t.TeacherID
    WHERE sc.StudentID = %s;
    """
    result = execute_query(courses_query, (student_id,), fetch=True)

    # Format the results as a list of dictionaries
    courses = []
    if result:
        for course in result:
            courses.append(
                {
                    "CourseID": course[0],
                    "CourseName": course[1],
                    "Description": course[2],
                    "TeacherID": course[3],
                }
            )
    return courses
