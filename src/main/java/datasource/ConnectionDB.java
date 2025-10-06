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

    // Connection retry settings
    private static final int MAX_RETRIES = 30;
    private static final int RETRY_DELAY_MS = 2000; // 2 seconds
    private static final int CONNECTION_TIMEOUT_SECONDS = 10;

    public static Connection obtenerConexion() {
        // Try to connect with retries (wait for database to be ready)
        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try {
                Class.forName("org.mariadb.jdbc.Driver");
                System.out.println("Connecting to database: " + DB_HOST + ":" + DB_PORT + "/" + DB_NAME + " (attempt " + attempt + "/" + MAX_RETRIES + ")");

                // Add connection timeout properties
                String urlWithParams = URL + "?connectTimeout=" + (CONNECTION_TIMEOUT_SECONDS * 1000) +
                        "&socketTimeout=" + (CONNECTION_TIMEOUT_SECONDS * 1000);

                Connection connection = DriverManager.getConnection(urlWithParams, DB_USER, DB_PASSWORD);

                // Test the connection
                if (connection.isValid(5)) { // 5 second validation timeout
                    System.out.println("Database connection successful!");
                    return connection;
                } else {
                    System.err.println("Connection is invalid, closing and retrying...");
                    connection.close();
                }

            } catch (ClassNotFoundException e) {
                System.err.println("MariaDB driver not found: " + e.getMessage());
                return null; // Driver issue, no point in retrying
            } catch (SQLException e) {
                System.err.println("Database connection failed (attempt " + attempt + "/" + MAX_RETRIES + "): " + e.getMessage());

                if (attempt < MAX_RETRIES) {
                    System.out.println("Waiting " + (RETRY_DELAY_MS / 1000) + " seconds before retry...");
                    try {
                        Thread.sleep(RETRY_DELAY_MS);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        System.err.println("Connection retry interrupted");
                        return null;
                    }
                } else {
                    System.err.println("Failed to connect to database after " + MAX_RETRIES + " attempts");
                }
            }
        }

        System.err.println("Giving up on database connection after " + MAX_RETRIES + " attempts");
        return null;
    }

    // Alternative method for quick connection test
    public static boolean testConnection() {
        try (Connection conn = obtenerConexion()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
}