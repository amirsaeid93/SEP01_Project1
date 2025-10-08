package dao;
import datasource.ConnectionDB;

import java.sql.*;
import model.User;

public class UserDao {
    public void register(User user) {
        String sql = "INSERT INTO users (username, password, confirmPassword) VALUES (?, ?, ?)";

        try (Connection conn = ConnectionDB.obtenerConexion()) {
            // Check if connection is null
            if (conn == null) {
                System.err.println("Database connection failed - cannot register user");
                return;
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, user.getUsername());
                stmt.setString(2, user.getPassword());
                stmt.setString(3, user.getConfirmPassword());
                stmt.executeUpdate();

                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setId(rs.getInt(1));
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Database error during registration: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Unexpected error during registration: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection conn = ConnectionDB.obtenerConexion()) {
            if (conn == null) {
                System.err.println("Database connection failed - cannot perform login");
                return null;
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        User user = new User(
                                rs.getString("username"),
                                rs.getString("password")
                        );
                        user.setId(rs.getInt("id"));
                        return user;
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Database error during login: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Unexpected error during login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}