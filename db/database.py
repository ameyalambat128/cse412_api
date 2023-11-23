import psycopg2
from psycopg2 import OperationalError


def get_db_connection():
    try:
        conn = psycopg2.connect(
            host="localhost",
            dbname="cse412final",
            user="ameya",
            password="",
        )
        # Create a cursor
        cursor = conn.cursor()
        print("Connection to database was successful")
        return conn
    except OperationalError as e:
        print(f"An error occurred: {e}")
        return None


def db_operation(conn):
    try:
        # Perform some database operation
        cursor = conn.cursor()
        cursor.execute("DROP DATABASE cse412final;")
        results = cursor.fetchall()
        cursor.close()
        return results
    except OperationalError as e:
        print(f"An error occurred: {e}")
        return None


# Using the functions
conn = get_db_connection()
if conn is not None:
    results = some_db_operation(conn)
    print(results)
    conn.close()
