package com.cms.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {

    // MySQL Configuration
    private static final String MYSQL_URL = "jdbc:mysql://localhost:3306/cms_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String MYSQL_USER = "root";
    private static final String MYSQL_PASS = "password"; // Change as needed

    // Embedded H2 Fallback (creates a local database file in user home if MySQL is offline)
    private static final String H2_URL = "jdbc:h2:~/cms_h2_db;MODE=MySQL;DATABASE_TO_LOWER=TRUE";
    private static final String H2_USER = "sa";
    private static final String H2_PASS = "";

    private static boolean useH2 = false;
    private static boolean initialized = false;

    public static synchronized Connection getConnection() throws SQLException {
        if (!initialized) {
            initDatabase();
        }

        if (useH2) {
            return DriverManager.getConnection(H2_URL, H2_USER, H2_PASS);
        } else {
            return DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASS);
        }
    }

    private static void initDatabase() {
        try {
            // Attempt MySQL connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASS);
            con.close();
            useH2 = false;
            System.out.println("[DBConnection] Connected to MySQL successfully.");
        } catch (Exception e) {
            // MySQL unavailable -> Fallback to Embedded H2
            System.out.println("[DBConnection] MySQL unavailable (" + e.getMessage() + "). Falling back to Embedded H2 database.");
            useH2 = true;
            try {
                Class.forName("org.h2.Driver");
                try (Connection h2Con = DriverManager.getConnection(H2_URL, H2_USER, H2_PASS);
                     Statement st = h2Con.createStatement()) {
                    
                    // Auto-create tables in H2
                    st.execute("CREATE TABLE IF NOT EXISTS admin_users ("
                            + "id INT AUTO_INCREMENT PRIMARY KEY, "
                            + "username VARCHAR(50) UNIQUE NOT NULL, "
                            + "password VARCHAR(255) NOT NULL, "
                            + "full_name VARCHAR(100) NOT NULL)");

                    st.execute("CREATE TABLE IF NOT EXISTS complaints ("
                            + "id INT AUTO_INCREMENT PRIMARY KEY, "
                            + "complaint_id VARCHAR(20) UNIQUE NOT NULL, "
                            + "student_name VARCHAR(100) NOT NULL, "
                            + "student_email VARCHAR(100) NOT NULL, "
                            + "category VARCHAR(50) NOT NULL, "
                            + "title VARCHAR(150) NOT NULL, "
                            + "description CLOB NOT NULL, "
                            + "status VARCHAR(20) DEFAULT 'Pending', "
                            + "admin_remark CLOB, "
                            + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                            + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

                    // Seed Admin User
                    st.execute("MERGE INTO admin_users KEY(username) VALUES (1, 'admin', 'admin123', 'System Administrator')");

                    // Seed Initial Complaints
                    st.execute("MERGE INTO complaints KEY(complaint_id) VALUES "
                            + "(1, 'CMP-1001', 'Aditya Verma', 'aditya@university.edu', 'Infrastructure', "
                            + "'Projector flickering in Lecture Hall B', 'Bulb is dim and HDMI connection disconnects.', "
                            + "'In Progress', 'Electrician assigned. Replacement bulb requisitioned.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
                    st.execute("MERGE INTO complaints KEY(complaint_id) VALUES "
                            + "(2, 'CMP-1002', 'Sneha Nair', 'sneha@university.edu', 'Hostel', "
                            + "'Geyser water heater issue Block C', 'Hot water geyser tripped on the 3rd floor.', "
                            + "'Resolved', 'Heating element replaced by maintenance.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
                    st.execute("MERGE INTO complaints KEY(complaint_id) VALUES "
                            + "(3, 'CMP-1003', 'Rohit Kumar', 'rohit@university.edu', 'Academic', "
                            + "'DBMS Lab Exam Marks Missing', 'Lab grade recorded as absent.', "
                            + "'Pending', 'Awaiting verification from course coordinator.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

                    System.out.println("[DBConnection] Embedded H2 database initialized with seed data.");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        initialized = true;
    }
}
