package datasource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionDB {
    // Get the database host from a system property, default to "localhost"
    private static final String DB_HOST = System.getProperty("db.host", "localhost");
    private static final String URL = "jdbc:mariadb://" + DB_HOST + ":3306/studyplanner";
    private static final String USER = "root";
    private static final String PASSWORD = "saeidt";

    public static Connection obtenerConexion() {
        // --- TEMPORARY DEBUGGING STEP ---
        // Return null immediately to prevent crash in Docker environment.
        // This allows us to verify that the GUI itself can launch.
        System.out.println("Database connection is temporarily disabled for Docker test.");
        return null;
        /*
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return null;
        }
        */
    }
}