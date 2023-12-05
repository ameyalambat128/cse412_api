# Savnac (CSE412 Final Project)

This is Savnac a student/teacher dashboard.

## Features

### Tech Stack

- iOS app (SwiftUI)
- FastAPI (Python)
- PostgreSQL

## Installation and Setup

> ⚠️ Please follow the steps in the order given below.

## Database Setup (PostgreSQL)

This project uses a PostgreSQL database. Follow the steps below to set up the database.

### Creating the Database

First, create a new database:

```bash
# Login to your database command line
# For PostgreSQL, it's typically done using:
psql

# Create a new database
CREATE DATABASE cse412final;
```

### Importing the Database Dump

```bash
# Import the dump into your database
psql cse412_final < backend/src/db/cse412final_dump.sql
```

## API Setup (FastAPI)

```bash
# Clone the repository
git clone [repository URL]

# Navigate to the project directory
cd savnac_CSE412

# Create a virtual environment
python -m venv .venv

# Activate the virtual environment
# On Windows:
venv\Scripts\activate

# On Unix or MacOS:
source .venv/bin/activate

# Install the dependencies
pip install -r requirements.txt

# Set environment variables
# Add instructions or a script to set environment variables (DB connection, API keys, etc.)

# Run the application
uvicorn main:app --reload
```

- Go to `backend/src/db/database.py`
- Update the `get_db_connection()` function with your `psql` username.

```python
def get_db_connection():
    try:
        conn = psycopg2.connect(
            host="localhost",
            dbname="cse412final",
            user="<Enter Your psql Username>",
            password="",
        )
        return conn
    except OperationalError as e:
        print(f"An error occurred: {e}")
        return None
```

## Frontend Setup (SwiftUI)

### Setup Xcode

### Build and Run

```bash
cd ios
```

- Build the project and Run.

## Usage
