package datasource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionDB {
    // Get database configuration from environment variables with defaults
    private static final String DB_HOST = System.getenv().getOrDefault("DB_HOST", "localhost");
    private static final String DB_PORT = System.getenv().getOrDefault("DB_PORT", "3306");
    private static final String DB_NAME = System.getenv().getOrDefault("DB_NAME", "studyplanner");
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "root");
    private static final String DB_PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "saeidt");

    private static final String URL = "jdbc:mariadb://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME;

    public static Connection obtenerConexion() {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            System.out.println("Connecting to database: " + DB_HOST + ":" + DB_PORT + "/" + DB_NAME);
            return DriverManager.getConnection(URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            System.err.println("Application will continue without database functionality");
            // Return null but don't crash the application
            return null;
        }
    }
}