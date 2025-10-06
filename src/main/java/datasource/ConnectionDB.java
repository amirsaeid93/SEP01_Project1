package datasource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionDB {
    private static final String DB_HOST = System.getProperty("db.host", "localhost");
    private static final String URL = "jdbc:mariadb://" + DB_HOST + ":3306/studyplanner";
    private static final String USER = "root";
    private static final String PASSWORD = "saeidt";

    private static final int MAX_RETRIES = 10;
    private static final int RETRY_DELAY_SECONDS = 3;

    public static Connection obtenerConexion() {
        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try {
                System.out.println("Attempting to connect to database... (Attempt " + attempt + "/" + MAX_RETRIES + ")");
                Class.forName("org.mariadb.jdbc.Driver");
                Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("Database connection successful!");
                return connection;
            } catch (SQLException | ClassNotFoundException e) {
                System.err.println("Connection failed: " + e.getMessage());
                if (attempt < MAX_RETRIES) {
                    try {
                        System.out.println("Waiting " + RETRY_DELAY_SECONDS + " seconds before retry...");
                        Thread.sleep(RETRY_DELAY_SECONDS * 1000);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        System.err.println("Database connection retry was interrupted.");
                        return null;
                    }
                } else {
                    System.err.println("Could not connect to the database after " + MAX_RETRIES + " attempts.");
                    e.printStackTrace();
                }
            }
        }
        return null;
    }
}
