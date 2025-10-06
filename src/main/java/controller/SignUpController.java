package controller;
import dao.UserDao;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import model.User;

import java.io.IOException;

public class SignUpController {
    @FXML
    private TextField usernameField;

    @FXML
    private PasswordField passwordField;

    @FXML
    private PasswordField confirmPasswordField;

    private UserDao userDao = new UserDao();

    @FXML
    private void handleSignUp(ActionEvent event) throws IOException {
        String username = usernameField.getText();
        String password = passwordField.getText();
        String confirmPassword = confirmPasswordField.getText();

        if (username.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            showAlert("Error", "Please fill all fields!");
            return;
        }

        if (!password.equals(confirmPassword)) {
            showAlert("Error", "Passwords do not match!");
            return;
        }

        try {
            // Check if username already exists
            User existingUser = userDao.login(username, password);
            if (existingUser != null) {
                showAlert("Error", "Username already exists!");
                return;
            }

            // Register new user
            User newUser = new User(username, password, confirmPassword);
            userDao.register(newUser);

            showAlert("Success", "Account created successfully!");
            handleLoginRedirect(event);

        } catch (Exception e) {
            System.err.println("Signup error: " + e.getMessage());
            showAlert("Database Error", "Cannot create account at the moment. Please try again later.\n\nError: " + e.getMessage());
        }
    }

    @FXML
    private void handleLoginRedirect(ActionEvent event) throws IOException {
        try {
            Parent loginRoot = FXMLLoader.load(getClass().getResource("/Login.fxml"));
            Scene loginScene = new Scene(loginRoot);

            Stage window = (Stage) ((Node) event.getSource()).getScene().getWindow();
            window.setScene(loginScene);
            window.show();
        } catch (Exception e) {
            System.err.println("Error loading login page: " + e.getMessage());
            showAlert("Error", "Cannot load login page. Please try again.");
        }
    }

    private void showAlert(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setContentText(message);
        alert.showAndWait();
    }
}