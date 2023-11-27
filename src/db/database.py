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
