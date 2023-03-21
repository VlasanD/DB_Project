package app.controller;

import app.Main;
import app.single_point_access.GUIFrameSinglePointAccess;
import app.view.HumanResourcesView;

import java.sql.*;
import java.time.DayOfWeek;

public class HumanResourcesController {
    private HumanResourcesView humanResourcesView;
    private TableController tableController;
    private final String vacation = "{call proiectreteaclinica.vizualizareConcediu(?, ?)}";
    private final String exceptionalDay = "{call proiectreteaclinica.modificaOrar(?, ?, ?, ?, ?)}";
    private final String schedule="call proiectreteaclinica.orarDinHR(?, ?, ?)";
    public void startLogic(Connection connection,int nr_contract){
        humanResourcesView = new HumanResourcesView();
        GUIFrameSinglePointAccess.changePanel(humanResourcesView.getHRPanel(), "HR");

        tableController=new TableController();

        humanResourcesView.getDatePersonaleButton().addActionListener(e -> {
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

        humanResourcesView.getSalariuButton().addActionListener(e -> {
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

        humanResourcesView.getConcediiButton().addActionListener(e->{
            try {
                PreparedStatement preparedStatement = connection.prepareCall(vacation);
                preparedStatement.setString(1, humanResourcesView.getNumeTextField().getText());
                preparedStatement.setString(2, humanResourcesView.getPrenumeTextField().getText());

                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        humanResourcesView.getAdaugaButton().addActionListener(e->{
            try {
                PreparedStatement preparedStatement = connection.prepareCall(exceptionalDay);
                preparedStatement.setDate(1, Date.valueOf(humanResourcesView.getZiExceptionalaTextField().getText()));
                preparedStatement.setTime(2, Time.valueOf(humanResourcesView.getOraInceputTextField().getText()));
                preparedStatement.setTime(3, Time.valueOf(humanResourcesView.getOraSfarsitTextField().getText()));
                preparedStatement.setString(4, humanResourcesView.getNumeTextField().getText());
                preparedStatement.setString(5, humanResourcesView.getPrenumeTextField().getText());

                preparedStatement.execute();

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        humanResourcesView.getVizualizareButton().addActionListener(e -> {
            tableController = new TableController();
            Date date;
            switch(humanResourcesView.getComboBox1().getSelectedItem().toString()){
                case "Luni" -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.MONDAY));
                case "Marti" -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.TUESDAY));
                case "Miercuri" -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.WEDNESDAY));
                case "Joi" -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.THURSDAY));
                default -> date= Date.valueOf(Main.getCurrentWeekDay(DayOfWeek.FRIDAY));
            }
            try {
                PreparedStatement preparedStatement = connection.prepareCall(schedule);
                preparedStatement.setString(1,humanResourcesView.getNumeTextField().getText());
                preparedStatement.setString(2,humanResourcesView.getPrenumeTextField().getText());
                preparedStatement.setDate(3, date);

                preparedStatement.execute();

                ResultSet schedule = preparedStatement.getResultSet();

                tableController.startLogic(connection, schedule, nr_contract);

            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        humanResourcesView.getLogOutButton().addActionListener(e -> {
            LoginController loginController = new LoginController();
            loginController.startLogic(connection);
        });
    }
}
