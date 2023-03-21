package app.controller;

import app.Main;
import app.single_point_access.GUIFrameSinglePointAccess;
import app.view.LoginView;

import java.sql.*;

public class LoginController {
    private LoginView loginView;

    private static final String USER_HR = "resurseumane";
    private static final String USER_FE = "financiar";
    private static final String USER_DR = "doctor";
    private static final String USER_AS = "asistent";
    private static final String USER_RE = "receptionist";

    private static final String PASSWORD = "root";

    public static final String LOGIN_QUERY =
            "SELECT Utilizator.nr_contract " +
                    "FROM Utilizator " +
                    "WHERE Utilizator.username=? AND Utilizator.parola=? " +
                    "LIMIT 1";
    public static final String ROLE_QUERY =
            "SELECT Utilizator.functie " +
                    "FROM Utilizator " +
                    "WHERE Utilizator.nr_contract=?";

    public static final String PERSONAL_DATA = "SELECT * FROM Utilizator WHERE Utilizator.nr_contract=? LIMIT 1";

    public static final String SHOW_SALARY = "{call proiectreteaclinica.afisareSalariuNonDoctor(?)}";

    public static final String SHOW_PERSONAL_SCHEDULE = "{call proiectreteaclinica.OrarNonDoctor(? ,?)}";

    public void startLogic(Connection connection) {
        loginView = new LoginView();
        GUIFrameSinglePointAccess.changePanel(loginView.getLoginPanel(), "Login");
        loginView.getLogInButton().addActionListener(e -> {

            String username = loginView.getUsernameField().getText();
            String password = new String(loginView.getPasswordField().getPassword());

            try {

                PreparedStatement preparedStatement = connection.prepareStatement(LOGIN_QUERY);
                preparedStatement.setString(1, username);
                preparedStatement.setString(2, password);

                ResultSet login = preparedStatement.executeQuery();

                if (login.next()) {

                    preparedStatement = connection.prepareStatement(ROLE_QUERY);
                    preparedStatement.setString(1, Integer.toString(login.getInt(1)));

                    ResultSet role = preparedStatement.executeQuery();

                    if (role.next()) {
                        switch (role.getString(1)) {
                            case "administrator" -> {
                                AdministratorController administratorController = new AdministratorController();
                                administratorController.startLogic(connection, login.getInt(1), 0);
                            }
                            case "superadministrator" -> {
                                AdministratorController administratorController = new AdministratorController();
                                administratorController.startLogic(connection, login.getInt(1), 1);
                            }
                            case "receptioner" -> {
                                Class.forName(Main.JDBC_DRIVER);

                                Connection connectionRe = DriverManager.getConnection(Main.DB_URL, USER_RE, PASSWORD);
                                ReceptionistController receptionistController = new ReceptionistController();
                                receptionistController.startLogic(connectionRe,login.getInt(1));
                            }
                            case "inspector" -> {
                                Class.forName(Main.JDBC_DRIVER);

                                Connection connectionHR = DriverManager.getConnection(Main.DB_URL, USER_HR, PASSWORD);
                                HumanResourcesController humanResourcesController = new HumanResourcesController();
                                humanResourcesController.startLogic(connectionHR, login.getInt(1));
                            }
                            case "expert" -> {
                                Class.forName(Main.JDBC_DRIVER);

                                Connection connectionFE = DriverManager.getConnection(Main.DB_URL, USER_FE, PASSWORD);
                                FinancialExpertController financialExpertController = new FinancialExpertController();
                                financialExpertController.startLogic(connectionFE, login.getInt(1));
                            }
                            case "medic" -> {
                                Class.forName(Main.JDBC_DRIVER);

                                Connection connectionDR = DriverManager.getConnection(Main.DB_URL, USER_DR, PASSWORD);
                                DoctorController doctorController = new DoctorController();
                                doctorController.startLogic(connectionDR, login.getInt(1));
                            }
                            default -> {
                                Class.forName(Main.JDBC_DRIVER);

                                Connection connectionAs = DriverManager.getConnection(Main.DB_URL, USER_AS, PASSWORD);
                                AsController asController = new AsController();
                                asController.startLogic(connectionAs, login.getInt(1));
                            }
                        }
                    }
                } else {
                    GUIFrameSinglePointAccess.showDialogMessage("Invalid  username or password");
                }
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            } catch (ClassNotFoundException ex) {
                throw new RuntimeException(ex);
            }
        });
    }

    public void startLogic(Connection connection, Integer nr_contract) {
        PreparedStatement preparedStatement = null;
        try {
            preparedStatement = connection.prepareStatement(ROLE_QUERY);
            preparedStatement.setString(1, Integer.toString(nr_contract));

            ResultSet role = preparedStatement.executeQuery();

            if (role.next()) {
                switch (role.getString(1)) {
                    case "administrator" -> {
                        AdministratorController administratorController = new AdministratorController();
                        administratorController.startLogic(connection, nr_contract, 0);
                    }
                    case "superadministrator" -> {
                        AdministratorController administratorController = new AdministratorController();
                        administratorController.startLogic(connection, nr_contract, 1);
                    }
                    case "receptioner" -> {
                        ReceptionistController receptionistController=new ReceptionistController();
                        receptionistController.startLogic(connection, nr_contract);
                    }
                    //TODO add the required logic
                    case "inspector" -> {
                        HumanResourcesController humanResourcesController = new HumanResourcesController();
                        humanResourcesController.startLogic(connection, nr_contract);
                    }
                    case "expert" -> {
                        FinancialExpertController financialExpertController = new FinancialExpertController();
                        financialExpertController.startLogic(connection, nr_contract);
                    }
                    case "medic" -> {
                        DoctorController doctorController = new DoctorController();
                        doctorController.startLogic(connection, nr_contract);
                    }
                    default -> {
                        AsController asController = new AsController();
                        asController.startLogic(connection, nr_contract);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}