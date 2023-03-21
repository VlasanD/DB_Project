package app.controller;

import app.single_point_access.GUIFrameSinglePointAccess;
import app.view.DoctorView;

import java.sql.*;

public class DoctorController {
    private TableController tableController;
    private DoctorView doctorView;
    private final String generatedRevenue = "{call proiectreteaclinica.profitMedic(?)}";
    private final String doctorSalary = "{call proiectreteaclinica.AfisareSalariuDoctor(?, ?)}";
    private final String appointments="{call proiectreteaclinica.orarDoctor(?,?)}";
    private final String investigations="{call proiectreteaclinica.vizualizareAnalize(?, ?)}";
    private final String closedReport="{call proiectreteaclinica.parafareRaport(?, ?)}";
    private final String updateReport="{call proiectreteaclinica.updateRaportMedical(?, ?, ?, ?)}";
    private final String showHistory="{call proiectreteaclinica.vizualizareIstoric(?, ?)}";
    public void startLogic(Connection connection, int nr_contract) {
        doctorView = new DoctorView();
        GUIFrameSinglePointAccess.changePanel(doctorView.getDoctorPanel(), "Doctor");

        tableController=new TableController();

        doctorView.getProfitGeneratButton().addActionListener(e -> {
            try {
                PreparedStatement preparedStatement = connection.prepareCall(generatedRevenue);
                preparedStatement.setInt(1, nr_contract);
                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        doctorView.getSalariuButton().addActionListener(e->{
            try {
                PreparedStatement preparedStatement = connection.prepareCall(doctorSalary);
                preparedStatement.setInt(1, nr_contract);
                preparedStatement.setInt(2,Integer.parseInt(doctorView.getLunaTextField().getText()));

                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        doctorView.getProgramariButton().addActionListener(e->{
            try {
                PreparedStatement preparedStatement = connection.prepareCall(appointments);
                preparedStatement.setInt(1, nr_contract);
                preparedStatement.setDate(2, Date.valueOf((doctorView.getDataTextField().getText())));

                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        doctorView.getAnalizeButton().addActionListener(e->{
            try {
                PreparedStatement preparedStatement = connection.prepareCall(investigations);
                preparedStatement.setString(1, doctorView.getNumePacientTextField().getText());
                preparedStatement.setString(2, doctorView.getPrenumePacientTextField().getText());

                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        doctorView.getParafareButton().addActionListener(e->{
            try {
                PreparedStatement preparedStatement = connection.prepareCall(closedReport);
                preparedStatement.setInt(1, Integer.parseInt(doctorView.getNumarRaportTextField().getText()));
                preparedStatement.setInt(2, nr_contract);

                preparedStatement.execute();

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        doctorView.getActualizeazaRaportButton().addActionListener(e -> {
            try {
                PreparedStatement preparedStatement = connection.prepareCall(updateReport);
                preparedStatement.setInt(1, Integer.parseInt(doctorView.getNumarRaportTextField().getText()));
                preparedStatement.setString(2, doctorView.getSimptomeTextField().getText());
                preparedStatement.setString(3, doctorView.getDiagnosticTextField().getText());
                preparedStatement.setString(4, doctorView.getRecomandareTextField().getText());


                preparedStatement.execute();

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        doctorView.getIstoricButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(showHistory);
                preparedStatement.setString(1, doctorView.getNumePacientTextField().getText());
                preparedStatement.setString(2, doctorView.getPrenumePacientTextField().getText());

                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        doctorView.getDatePersonaleButton().addActionListener(e -> {
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

        doctorView.getLogOutButton().addActionListener(e -> {
            LoginController loginController = new LoginController();
            loginController.startLogic(connection);
        });

    }
}
