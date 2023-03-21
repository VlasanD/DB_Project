package app.controller;

import app.Main;
import app.single_point_access.GUIFrameSinglePointAccess;
import app.view.FinancialExpertView;

import java.sql.*;
import java.time.DayOfWeek;

public class FinancialExpertController {
    FinancialExpertView financialExpertView;
    TableController tableController;
    private final String schedule="call proiectreteaclinica.orarDinHR(?, ?, ?)";
    private final String vacation = "{call proiectreteaclinica.vizualizareConcediu(?, ?)}";
    private final String generatedRevenueDoctor = "{call proiectreteaclinica.profitMedic(?)}";
    private final String generatedRevenueClinic = "{call proiectreteaclinica.profitClinica(?)}";
    private final String generatedRevenueSpeciality = "{call proiectreteaclinica.profitSpecialitate(?)}";


    public void startLogic(Connection connection, int nr_contract) {
        financialExpertView = new FinancialExpertView();
        GUIFrameSinglePointAccess.changePanel(financialExpertView.getFinancialPane(), "HR");

        tableController = new TableController();

        financialExpertView.getDatePersonaleButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement statement = connection.prepareStatement(LoginController.PERSONAL_DATA);
                statement.setInt(1, nr_contract);

                statement.execute();

                ResultSet d = statement.getResultSet();

                tableController.startLogic(connection, d, nr_contract);

                statement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        financialExpertView.getSalariuButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement statement = connection.prepareCall(LoginController.SHOW_SALARY);
                statement.setInt(1, nr_contract);

                statement.execute();

                ResultSet salary = statement.getResultSet();

                tableController.startLogic(connection, salary, nr_contract);

                statement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }

        });

        financialExpertView.getConcediiButton().addActionListener(e->{
            try {
                PreparedStatement preparedStatement = connection.prepareCall(vacation);
                preparedStatement.setString(1, financialExpertView.getNumeTextField().getText());
                preparedStatement.setString(2, financialExpertView.getPrenumeTextField().getText());

                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        financialExpertView.getVizualizareOrarButton().addActionListener(e -> {
            tableController = new TableController();
            Date date;
            switch(financialExpertView.getComboBox1().getSelectedItem().toString()){
                case "Luni" -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.MONDAY));
                case "Marti" -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.TUESDAY));
                case "Miercuri" -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.WEDNESDAY));
                case "Joi" -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.THURSDAY));
                default -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.FRIDAY));
            }
            try {
                PreparedStatement preparedStatement = connection.prepareCall(schedule);
                preparedStatement.setString(1,financialExpertView.getNumeTextField().getText());
                preparedStatement.setString(2,financialExpertView.getPrenumeTextField().getText());
                preparedStatement.setDate(3, date);

                preparedStatement.execute();

                ResultSet schedule = preparedStatement.getResultSet();

                tableController.startLogic(connection, schedule, nr_contract);

            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        financialExpertView.getAfisareProfitButton1().addActionListener(e -> {
            try {
                PreparedStatement preparedStatement = connection.prepareCall(generatedRevenueClinic);
                preparedStatement.setString(1, financialExpertView.getClinicaTextField().getText());
                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        financialExpertView.getAfisareProfitButton().addActionListener(e -> {
            try {
                PreparedStatement preparedStatement = connection.prepareCall(generatedRevenueSpeciality);
                preparedStatement.setString(1, financialExpertView.getSpecialitateTextField().getText());
                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        financialExpertView.getAfisareProfitButton2().addActionListener(e -> {
            try {
                PreparedStatement preparedStatement = connection.prepareCall(generatedRevenueDoctor);
                preparedStatement.setInt(1, Integer.parseInt(financialExpertView.getNumarContractDoctorTextField().getText()));
                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        financialExpertView.getSalariuButton1().addActionListener(e->{
            try {
                PreparedStatement preparedStatement = connection.prepareCall(LoginController.SHOW_SALARY);
                preparedStatement.setInt(1, Integer.parseInt(financialExpertView.getNumarContractTextField().getText()));
                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        financialExpertView.getLogOutButton().addActionListener(e -> {
            LoginController loginController = new LoginController();
            loginController.startLogic(connection);
        });
    }

}

