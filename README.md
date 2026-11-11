# ByteBridge – Web-Based Learning Management System

ByteBridge is a web-based learning platform developed using ASP.NET Web Forms and C#. It provides an interactive environment where members can access programming lessons, complete coding exercises, attempt quizzes, and track their learning progress.

The system also includes an administration module that allows administrators to manage learning content and user accounts.

## Features

### Member Features
- Browse programming topics and available lessons.
- Access lesson materials, code examples, and learning reminders.
- Complete coding exercises and submit learning reflections.
- Attempt quizzes and view scores and previous attempts.
- Track learning progress through a personal dashboard.
- Create and manage personal study notes.
- Create and practise flashcards.
- Manage personal profile information.

### Administrator Features
- View an overview of system statistics.
- Create, edit, and delete learning topics.
- Manage lessons and their learning materials.
- Manage quiz questions and answer options.
- View registered member accounts.
- Promote members to administrators or change administrators back to members.
- Remove user accounts while checking for existing related records.

## Technologies Used

| Technology | Purpose |
|---|---|
| ASP.NET Web Forms | Web application framework |
| C# | Server-side programming |
| .NET Framework 4.8.1 | Application runtime |
| HTML5 | Web page structure |
| CSS | Styling and responsive layouts |
| JavaScript | Client-side interactions |
| ADO.NET | Database connectivity and operations |
| SQL Server LocalDB | Relational database |
| Visual Studio | Development environment |

## Database Design

The application uses SQL Server LocalDB with 11 relational database tables:

- `Users`
- `Topics`
- `Lessons`
- `Questions`
- `Progress`
- `Attempts`
- `Notes`
- `Flashcards`
- `Exercises`
- `PracticeAttempts`
- `Reflections`

The database uses primary keys and foreign key relationships to organise application data and maintain data integrity.

## Security Implementation

- Forms Authentication for user login and session management.
- Role-based access control for administrator-only functions.
- Password hashing using PBKDF2 with SHA-256 and individual random salts.
- Parameterised SQL queries to help prevent SQL injection.
- HTML encoding to reduce the risk of cross-site scripting (XSS).
- CSRF token validation for postback requests.
- User ownership checks to prevent unauthorised access to personal notes and flashcards.

## Getting Started

### Prerequisites

- Windows
- Visual Studio with ASP.NET and web development support
- .NET Framework 4.8.1 Developer Pack
- SQL Server LocalDB

### Installation

1. Clone this repository:

```bash
git clone https://github.com/keraitaha/ByteBridge
```

2. Open the solution file (`.sln`) in Visual Studio.

3. Ensure that the .NET Framework 4.8.1 Developer Pack and SQL Server LocalDB are installed.

4. Build the solution and run the application using IIS Express.

5. The application initialises its LocalDB database and prepares the required schema and sample data using the included setup and seed files.

## Project Purpose

ByteBridge was developed as part of a group academic project to provide a structured learning environment for programming students. It combines lesson materials, practical exercises, quizzes, and personal study tools within one web application.