package app.view;

import javax.swing.*;

public class LoginView {
    private JPanel LoginPanel;
    private JTextField usernameField;
    private JPasswordField passwordField;
    private JButton logInButton;

    public JPanel getLoginPanel() {
        return LoginPanel;
    }

    public JTextField getUsernameField() {
        return usernameField;
    }

    public JPasswordField getPasswordField() {
        return passwordField;
    }

    public JButton getLogInButton() {
        return logInButton;
    }
}
