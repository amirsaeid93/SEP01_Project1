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
import model.CurrentUser;
import model.User;

import java.io.IOException;

public class LoginController {
    @FXML
    private TextField usernameField;

    @FXML
    private PasswordField passwordField;

    private UserDao userDao = new UserDao();

    @FXML
    private void handleLogin(ActionEvent event) throws IOException {
        String username = usernameField.getText();
        String password = passwordField.getText();

        if (username.isEmpty() || password.isEmpty()) {
            showAlert("Error", "Username and Password cannot be empty");
            return;
        }

        try {
            User user = userDao.login(username, password);

            if (user != null && user.getPassword().equals(password)) {
                CurrentUser.set(user);
                showAlert("Success", "Login successful! Welcome " + user.getUsername());
                Parent firstViewRoot = FXMLLoader.load(getClass().getResource("/first_view.fxml"));
                Scene firstViewScene = new Scene(firstViewRoot);

                Stage window = (Stage) ((Node) event.getSource()).getScene().getWindow();
                window.setScene(firstViewScene);
                window.show();
            } else {
                showAlert("Error", "Invalid username or password");
            }
        } catch (Exception e) {
            // Handle database connection errors gracefully
            System.err.println("Login error: " + e.getMessage());
            showAlert("Database Error", "Cannot connect to database. Please try again later or check if the database is running.");
        }
    }

    @FXML
    private void handleSignupRedirect(ActionEvent event) throws IOException {
        try {
            Parent signUpRoot = FXMLLoader.load(getClass().getResource("/SignUp.fxml"));
            Scene signUpScene = new Scene(signUpRoot);

            Stage window = (Stage) ((Node) event.getSource()).getScene().getWindow();
            window.setScene(signUpScene);
            window.show();
        } catch (Exception e) {
            System.err.println("Error loading signup page: " + e.getMessage());
            showAlert("Error", "Cannot load signup page. Please try again.");
        }
    }

    private void showAlert(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setContentText(message);
        alert.showAndWait();
    }
}