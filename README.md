# Savnac (CSE412 Final Project)

This is Savnac a student/teacher dashboard.

## Features

### Tech Stack

- iOS app (SwiftUI)
- FastAPI (Python)
- PostgreSQL

## Installation and Setup

> ⚠️ Please follow the steps in the order given below.

## Clone the Repository

```bash
# Clone the repository
git clone https://github.com/ameyalambat128/savnac_CSE412

# Navigate to the project directory
cd savnac_CSE412
```
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
psql cse412final < backend/src/db/cse412final_dump.sql
```

## API Setup (FastAPI)

```bash
# Create a virtual environment
python -m venv .venv

# Activate the virtual environment
# On Windows:
venv\Scripts\activate

# On Unix or MacOS:
source .venv/bin/activate

# Install the dependencies
pip install -r requirements.txt
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
### Run the API

```bash
# Run the application
uvicorn main:app --reload
# or
./start.sh
```

## Frontend Setup (SwiftUI)

### Setup Xcode

### Build and Run

```bash
cd ios
```

- Build the project and Run.

## Usage
