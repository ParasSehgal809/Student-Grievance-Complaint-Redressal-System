# Online Complaint Management System (AIP Mini Project)

A complete Java EE Web Application using **Servlets, JSP, JDBC, Sessions, and CRUD operations**, styled with a modern **Tailwind CSS** responsive interface.

---

## 📁 Project Architecture & Structure

```text
aip_mini_project/
├── pom.xml                               # Maven project configuration & embedded server plugin
├── schema.sql                            # Database schema and seed records
├── src/
│   └── main/
│       ├── java/com/cms/
│       │   ├── model/
│       │   │   ├── Complaint.java        # Grievance OOP Model
│       │   │   └── AdminUser.java        # Administrator user model
│       │   ├── dao/
│       │   │   ├── DBConnection.java     # JDBC connection (MySQL + auto embedded H2 fallback)
│       │   │   └── ComplaintDAO.java     # CRUD operations (PreparedStatements)
│       │   └── controller/
│       │       ├── ComplaintServlet.java # Student submit & track controller
│       │       ├── AdminAuthServlet.java # Session management & login/logout
│       │       └── AdminDashboardServlet.java # Admin CRUD & resolution controller
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml               # Servlet & session deployment descriptor
│           ├── index.jsp                 # Student Portal (Submit & Track)
│           ├── admin-login.jsp           # Administrator Login Page
│           └── admin-dashboard.jsp       # Admin Dashboard with KPI cards & CRUD table
└── .vscode/
    ├── settings.json                     # VS Code Java & Maven settings
    └── tasks.json                        # One-click Run & Build tasks
```

---

## 🚀 How to Run in Visual Studio Code

### Option 1: Using VS Code Tasks (Easiest)
1. Open Visual Studio Code.
2. Go to **File -> Open Folder...** and select `aip_mini_project` from your `Documents` folder:
   ```
   /Users/parassehgal/Documents/aip_mini_project
   ```
3. Press **`Cmd + Shift + B`** (or go to **Terminal -> Run Task -> Run Web App (Jetty Server)**).
4. Open your browser and navigate to:
   ```
   http://localhost:8080/
   ```

### Option 2: Using the Integrated Terminal
Open the terminal in VS Code (`Ctrl + ~`) inside `aip_mini_project` and run:
```bash
mvn jetty:run
```
Then visit [http://localhost:8080/](http://localhost:8080/).

### Option 3: Deploy to Apache Tomcat
If you have a local Apache Tomcat server configured in the **Tomcat Servers** VS Code extension panel:
1. Run `mvn clean package` to generate `target/aip_mini_project.war`.
2. Right-click the `.war` file in VS Code and choose **Deploy to Tomcat Server**.

---

## 🔑 Default Credentials & Test Data

* **Admin Portal Login:**
  * **URL:** `http://localhost:8080/admin-login.jsp`
  * **Username:** `admin`
  * **Password:** `admin123`

* **Sample Complaint Tracking IDs to test:**
  * `CMP-1001` (In Progress)
  * `CMP-1002` (Resolved)
  * `CMP-1003` (Pending)

---

## 🗄️ Database Configuration
* **MySQL (Default):** Connects to `localhost:3306/cms_db` with `root` / `password`.
* **Zero-Config Fallback:** If MySQL is not running on your computer, `DBConnection.java` will **automatically initialize an embedded H2 database** with sample data so the application runs without errors out of the box!
