package datasource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionDB {
    public static Connection obtenerConexion() {
        String url = "jdbc:mariadb://host.docker.internal:3306/studyplanner";
        String user = "root";
        String password = "saeidt";

        System.out.println("=== ATTEMPTING CONNECTION ===");
        System.out.println("URL: " + url);
        System.out.println("User: " + user);
        System.out.println("========================");

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, user, password);
            System.out.println("✅ Database connection successful!");
            return connection;
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("❌ Database connection failed: " + e.getMessage());
            return null;
        }
    }
}