-- User table
CREATE TABLE Users (
UserID INT PRIMARY KEY,
UserName VARCHAR(255) NOT NULL, Password VARCHAR(255) NOT NULL, DOB DATE,
Email VARCHAR(255) UNIQUE NOT NULL
);
-- Teacher table
CREATE TABLE Teachers (
ID INT PRIMARY KEY,
UserID INT,
FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
-- Student table
CREATE TABLE Students (
ID INT PRIMARY KEY,
UserID INT,
Name VARCHAR(255) NOT NULL,
FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
-- Course table
CREATE TABLE Courses (
CourseID INT PRIMARY KEY,
CourseName VARCHAR(255) NOT NULL,
CourseTiming TIME,
TeacherID INT,
FOREIGN KEY (TeacherID) REFERENCES Teachers(ID)
);
-- Relationship between Students and Courses
CREATE TABLE Student_Courses ( StudentID INT,
CourseID INT,
FOREIGN KEY (StudentID) REFERENCES Students(ID), FOREIGN KEY (CourseID) REFERENCES Courses(CourseID), PRIMARY KEY (StudentID, CourseID)
);
-- Assignment table
CREATE TABLE Assignments ( AssignmentID INT PRIMARY KEY, Difficulty VARCHAR(255), DueDate DATE, TimeOfCompletion TIME, CourseID INT,
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) );
-- Module table
CREATE TABLE Modules (
ModuleID INT PRIMARY KEY, Name VARCHAR(255) NOT NULL, Data TEXT
);
-- Exam table
CREATE TABLE Exams (
ExamID INT PRIMARY KEY, Questions TEXT, ExpectedAnswers TEXT
);
-- Grades table
CREATE TABLE Grades (
GradeID INT PRIMARY KEY,
StudentID INT,
AssignmentID INT,
ExamID INT,
GradeValue VARCHAR(5),
FOREIGN KEY (StudentID) REFERENCES Students(ID),
FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID), FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);