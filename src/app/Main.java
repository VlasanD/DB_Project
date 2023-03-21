package app;

import app.controller.LoginController;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;

public class Main {
    public static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    public static final String DB_URL = "jdbc:mysql://localhost:3306/proiectreteaclinica";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    public static LocalDate getCurrentWeekDay(DayOfWeek dayOfWeekRequired) {
        LocalDate today = LocalDate.now();
        DayOfWeek dayOfWeek = today.getDayOfWeek();
        int daysToRequiredDay = dayOfWeekRequired.getValue() - dayOfWeek.getValue();
        if (daysToRequiredDay < 0) {
            return today.minusDays((-daysToRequiredDay));
        }
        return today.plusDays(daysToRequiredDay);
    }

    public static void main(String[] args)  {
        try {
            Class.forName(JDBC_DRIVER);

            System.out.println("Connecting to database...");
            Connection connection = DriverManager.getConnection(DB_URL, USER, PASSWORD);
            System.out.println("Connected.");

            LoginController loginController = new LoginController();

            loginController.startLogic(connection);

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

    }

}
