# ByteBridge — Web Forms edition

A small local learning website using **ASP.NET Web Forms on .NET Framework 4.8**. Page markup is in `.aspx`, C# is in `.aspx.cs`, CSS is in `styles`, JavaScript is in `scripts`, and illustrations are in `assets`.

This follows your latest file-format requirement. The earlier proposal named ASP.NET Core MVC and Entity Framework; `.aspx`/`.aspx.cs` instead require classic Web Forms. This edition uses built-in ADO.NET for SQL Server LocalDB rather than EF, avoiding NuGet packages and a separate model/controller structure. It is not a .NET Core project.

## Start it

On Windows, install Visual Studio with **ASP.NET and web development**, the **.NET Framework 4.8 targeting pack**, **IIS Express**, and **SQL Server Express LocalDB**.

1. Extract the complete folder to a normal writable local folder.
2. Double-click **START.cmd** and keep its window running.
3. Open **http://localhost:5081/Default.aspx**. The first request may take a little longer while ASP.NET compiles the website and LocalDB starts.

Alternatively, open **ByteBridge.sln** in Visual Studio. It is an ASP.NET **Web Site**, using `CodeFile` page classes; no `.designer.cs` files or NuGet restore are needed. You can also use File → Open → Web Site and select this folder. Do not open an `.aspx` file directly in the browser: IIS Express must process it.

| Local example account | Email | Password |
|---|---|---|
| Member | member@bytebridge.local | Learn123! |
| Administrator | admin@bytebridge.local | Admin123! |

These are classroom demonstration accounts. Register a separate member account for your own work. The server performs login, role checks, scoring and saving; JavaScript only adds small conveniences.

## How many files?

The clean delivery contains **46 files**, including its two local database files:

| Files | Count |
|---|---:|
| `.aspx` pages | 14 |
| Matching page `.aspx.cs` files | 14 |
| Shared `App_Code/Site.aspx.cs` | 1 |
| `styles/site.css` and `scripts/site.js` | 2 |
| Local SVG assets | 4 |
| `App_Data/Setup.sql` and `App_Data/Seed.xml` | 2 |
| `App_Data/ByteBridge.mdf` and `ByteBridge_log.ldf` | 2 |
| `Web.config`, `START.cmd`, `ByteBridge.sln`, `.gitignore` | 4 |
| README, learning guide and verification report | 3 |
| **Total** | **46** |

That means **14 pages and 15 C# files**, not 28 pages. Visual Studio, IIS Express and SQL Server may generate machine-specific cache or temporary files while running; those are not extra authored pages. The final package manifest and test evidence are recorded in **VERIFICATION.md**.

## The 14 pages

| Page pair | Purpose |
|---|---|
| Default | Home and learning-path cards |
| About | Project purpose and scope |
| Login / Register | Sign in and create a member account |
| Paths | Browse and filter lessons |
| Lesson | Guest preview; member content, completion and confidence |
| Practice | Skill tree, coding checks and teach-it-back reflection |
| Quizzes | Topic quiz catalog and quiz-taking screen |
| Results | Saved quiz scores, history and retakes |
| Dashboard | Personal completion and practice progress |
| Notes | Own notes: create, display, edit and delete |
| Flashcards | Own cards: create, reveal, edit and delete |
| Profile | Display-name editing and read-only email |
| Admin | Topic, lesson and quiz-question CRUD |

Each name means an `.aspx` file plus its matching `.aspx.cs`. Related screens share a page where that keeps the project small. Pages provide obvious return links; phones use dedicated bottom navigation, a compact menu and stacked controls. Georgia headings and Trebuchet MS body text use local font fallbacks.

## Learn through the skill tree

The starting content has **4 paths, 20 lessons, 16 quiz questions and 60 short coding checks**. Lessons teach normal web-development concepts, including the patterns used to build this site.

- Read any lesson freely. Practice follows a prerequisite chain within each path.
- Solve three different coding checks in a skill. The first correct result for each earns **10 XP**; repeats do not add more.
- Write a 40–1500-character explanation, check that you can trace it, explain why it works and describe a change, then save your self-check. The first reflection earns **5 XP** and unlocks the next skill.
- Revisit lessons and repeat checks whenever useful. Explain the idea aloud to a classmate, not just to the text box.

The reflection is **self-assessed**, not automatically graded for meaning. Every short-token exercise requires the spelling and capitalisation shown in the lesson. This protects case-sensitive C#/JavaScript identifiers and CSS class names. SQL itself often accepts keyword case variants, but these small checks use a canonical answer. These checks are not a compiler or a full programming sandbox, and repetition cannot guarantee complete recall.

Answer keys are not embedded in the shared browser script. When a quiz begins, the server keeps a private question-and-answer snapshot in Session; ViewState carries only a random reference to it. Submission checks that the questions have not changed before grading. If an administrator edits the quiz during an attempt, or the session expires, reload the quiz and try again.

## The database stays with the project

`App_Data/ByteBridge.mdf` contains the tables and saved records; `ByteBridge_log.ldf` is its transaction log. Keep both files together. LocalDB runs under your Windows account. The setup helper attaches the database in this folder, or creates and seeds one if it is missing. Schema creation, starting content and example accounts are committed together in one SQL transaction. If first-time seeding fails, its changes roll back so a later request can retry rather than use half-created tables. Normal page visits and restarts do not overwrite saved work.

The tables are Users, Topics, Lessons, Questions, Progress, Attempts, Notes, Flashcards, Exercises, PracticeAttempts and Reflections. SQL foreign keys and application checks protect relationships. Personal queries also filter by the signed-in user's ID. Passwords use salted PBKDF2 hashes.

Use Admin for normal content edits. Seed.xml is initial content, not a live content editor: editing it does not replace records in an existing database. Admin-created lessons can be read and completed, but exercise authoring is not part of the admin interface; the initial skill-tree exercises are seeded. Back up the database before changing its schema or seed process.

## Keep the learning manageable

Read **LEARN-IN-TWO-DAYS.md** for a route through the in-app lessons and actual source. Two days is a practical reading target, not a promise of mastery or assignment marks. Use **VERIFICATION.md** for what was actually tested.

All authored page markup stays in `.aspx`, C# in `.aspx.cs`, and the authored browser behaviour in the external script. ASP.NET generates its normal postback script and hidden state fields at runtime; those are platform output, not additional source files you have to maintain.

This is a local academic application, not a public deployment. Password recovery, email verification, payments, chat, uploads and AI tutoring remain outside scope. If startup fails, check the required Windows components and read the first terminal or browser error. A database attachment error can mean the same `.mdf` is already attached elsewhere; stop the other copy and investigate rather than deleting saved work.

