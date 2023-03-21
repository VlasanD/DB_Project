package app.controller;

import app.single_point_access.GUIFrameSinglePointAccess;
import app.view.AsView;

import java.sql.*;

public class AsController {
    AsView asView;
    TableController tableController;
    private final String showAnalyze = "{call proiectreteaclinica.vizualizareAnalize(?,?)}";
    private final String addAnalyze = "{call proiectreteaclinica.adaugaAnalize(?, ?, ?, ?, ?, ?, ?)}";

    private final String showHistory="{call proiectreteaclinica.vizualizareIstoric(?, ?)}";

    private final String addReport="{call proiectreteaclinica.creareRaportMedical(?, ?, ?, ?, ?, ?, ?, ?)}";

    public void startLogic(Connection connection, int nr_contract) {
        asView = new AsView();
        GUIFrameSinglePointAccess.changePanel(asView.getAsPanel(), "Nurse");

        asView.getSalariuButton().addActionListener(e -> {
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

        asView.getDatePersonaleButton().addActionListener(e -> {
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

        asView.getOrarButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(LoginController.SHOW_PERSONAL_SCHEDULE);
                preparedStatement.setInt(1, nr_contract);
                preparedStatement.setDate(2, Date.valueOf(asView.getDataTextField().getText()));

                preparedStatement.execute();

                ResultSet schedule = preparedStatement.getResultSet();

                tableController.startLogic(connection, schedule, nr_contract);

            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        asView.getVizualizareAnalizeButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(showAnalyze);
                preparedStatement.setString(1, asView.getNumePacientTextField().getText());
                preparedStatement.setString(2, asView.getPrenumePacientTextField().getText());


                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        asView.getAdaugaAnalizeButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(addAnalyze);
                preparedStatement.setString(1, asView.getNumePacientTextField().getText());
                preparedStatement.setString(2, asView.getPrenumePacientTextField().getText());
                preparedStatement.setDate(3, Date.valueOf(asView.getDataTextField2().getText()));
                preparedStatement.setString(4,asView.getTipAnalizeTextField().getText());
                preparedStatement.setInt(5, Integer.parseInt(asView.getValoareTextField().getText()));
                preparedStatement.setInt(6, Integer.parseInt(asView.getValoareReferintaTextField().getText()));
                preparedStatement.setInt(7,Integer.parseInt(asView.getPozitivNegativTextField().getText()));

                preparedStatement.execute();

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        asView.getVizualizareRaportButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(showHistory);
                preparedStatement.setString(1, asView.getNumePacientTextField1().getText());
                preparedStatement.setString(2, asView.getNumePacientTextField2().getText());

                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        asView.getAdaugaRaportButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(addReport);
                preparedStatement.setString(1, asView.getNumePacientTextField1().getText());
                preparedStatement.setString(2, asView.getNumePacientTextField2().getText());
                preparedStatement.setString(3,asView.getNumeDoctorTextField().getText());
                preparedStatement.setString(4,asView.getPrenumeDoctorTextField().getText());
                preparedStatement.setString(5,asView.getNumeRecomandareTextField().getText());
                preparedStatement.setString(6,asView.getPrenumeRecomandareTextField().getText());
                preparedStatement.setInt(7,nr_contract);
                preparedStatement.setDate(8, Date.valueOf(asView.getDataTextField1().getText()));

                preparedStatement.execute();

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        asView.getLogOutButton().addActionListener(e -> {
            LoginController loginController = new LoginController();
            loginController.startLogic(connection);
        });

    }

}
