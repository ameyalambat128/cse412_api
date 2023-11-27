-- Users Table
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    UserType VARCHAR(50) CHECK (UserType IN ('Student', 'Teacher'))
);

-- Students Table
CREATE TABLE Students (
    StudentID SERIAL PRIMARY KEY,
    UserID INT UNIQUE NOT NULL,
    -- Additional columns for student-specific information can be added here
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Teachers Table
CREATE TABLE Teachers (
    TeacherID SERIAL PRIMARY KEY,
    UserID INT UNIQUE NOT NULL,
    -- Additional columns for teacher-specific information can be added here
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Courses Table
CREATE TABLE Courses (
    CourseID SERIAL PRIMARY KEY,
    TeacherID INT NOT NULL,
    CourseName VARCHAR(255) NOT NULL,
    Description TEXT,
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);

-- Modules Table
CREATE TABLE Modules (
    ModuleID SERIAL PRIMARY KEY,
    CourseID INT NOT NULL,
    ModuleName VARCHAR(255) NOT NULL,
    Description TEXT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Tests Table
CREATE TABLE Tests (
    TestID SERIAL PRIMARY KEY,
    ModuleID INT NOT NULL,
    TestName VARCHAR(255) NOT NULL,
    FOREIGN KEY (ModuleID) REFERENCES Modules(ModuleID)
);

-- Assignments Table
CREATE TABLE Assignments (
    AssignmentID SERIAL PRIMARY KEY,
    ModuleID INT NOT NULL,
    AssignmentName VARCHAR(255) NOT NULL,
    FOREIGN KEY (ModuleID) REFERENCES Modules(ModuleID)
);

-- CourseInfo Table
CREATE TABLE CourseInfo (
    CourseInfoID SERIAL PRIMARY KEY,
    ModuleID INT NOT NULL,
    Information TEXT,
    FOREIGN KEY (ModuleID) REFERENCES Modules(ModuleID)
);

-- Grades Table
CREATE TABLE Grades (
    GradeID SERIAL PRIMARY KEY,
    StudentID INT NOT NULL,
    TestID INT,
    AssignmentID INT,
    Grade VARCHAR(10),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (TestID) REFERENCES Tests(TestID),
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID)
);

-- StudentCourse Junction Table for Student and Course Many-to-Many relationship
CREATE TABLE StudentCourse (
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
