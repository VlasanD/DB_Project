package app.controller;

import app.single_point_access.GUIFrameSinglePointAccess;
import app.view.ReceptionistView;

import java.sql.*;

public class ReceptionistController {
    private ReceptionistView receptionistView;
    private TableController tableController;
    private final String fiscal = "{call proiectreteaclinica.BonFiscal(?, ?, ?, ?)}";
    private final String appointment = "{call proiectreteaclinica.Programare(?, ?, ?, ?, ?, ?, ?, ?)}";
    private final String register="{call proiectreteaclinica.adaugaPacient(?, ?, ?, ?)}";
    private final String scheduleP="{call proiectreteaclinica.programariReceptioner(?, ?)}";

    public void startLogic(Connection connection, int nr_contract) {
        receptionistView = new ReceptionistView();
        GUIFrameSinglePointAccess.changePanel(receptionistView.getRPanel(), "Receptionist");
        tableController = new TableController();

        receptionistView.getDatePersonalaButton().addActionListener(e -> {
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

        receptionistView.getSalariuButton().addActionListener(e -> {
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

        receptionistView.getOrarButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(LoginController.SHOW_PERSONAL_SCHEDULE);
                preparedStatement.setInt(1, nr_contract);
                preparedStatement.setDate(2, Date.valueOf(receptionistView.getZiuaTextField().getText()));

                preparedStatement.execute();

                ResultSet schedule = preparedStatement.getResultSet();

                tableController.startLogic(connection, schedule, nr_contract);

            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        receptionistView.getEmiteBonFiscalButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(fiscal);
                preparedStatement.setString(1, receptionistView.getNumePacientTextField1().getText());
                preparedStatement.setString(2, receptionistView.getPrenumePacientTextField1().getText());
                preparedStatement.setDate(3, Date.valueOf(receptionistView.getDataTextField1().getText()));
                preparedStatement.setInt(4, Integer.parseInt(receptionistView.getNumarContractMedicTextField().getText()));


                preparedStatement.execute();

                ResultSet entity = preparedStatement.getResultSet();

                tableController.startLogic(connection, entity, nr_contract);

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        receptionistView.getCreazaProgramareButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(appointment);
                preparedStatement.setString(1, receptionistView.getNumePacientTextField().getText());
                preparedStatement.setString(2, receptionistView.getPrenumePacientTextField().getText());
                preparedStatement.setString(3, receptionistView.getNumeDoctorTextField().getText());
                preparedStatement.setString(4, receptionistView.getPrenumeDoctorTextField().getText());
                preparedStatement.setString(5, receptionistView.getServiciuTextField().getText());
                preparedStatement.setDate(6, Date.valueOf(receptionistView.getDataTextField().getText()));
                preparedStatement.setTime(7, Time.valueOf(receptionistView.getOraTextField().getText()));
                preparedStatement.setInt(8, nr_contract);

                preparedStatement.execute();

                preparedStatement.close();
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        receptionistView.getInregistreazaPacientButton().addActionListener(e->{
            try {
                PreparedStatement preparedStatement=connection.prepareCall(register);
                preparedStatement.setString(1,receptionistView.getNumeTextField().getText());
                preparedStatement.setString(2,receptionistView.getPrenumeTextField().getText());
                preparedStatement.setString(3,receptionistView.getCNPTextField().getText());
                preparedStatement.setString(4,receptionistView.getAdresaTextField().getText());

                preparedStatement.execute();

                preparedStatement.close();

            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        receptionistView.getProgramariZiButton().addActionListener(e -> {
            tableController = new TableController();
            try {
                PreparedStatement preparedStatement = connection.prepareCall(scheduleP);
                preparedStatement.setInt(1, nr_contract);
                preparedStatement.setDate(2, Date.valueOf(receptionistView.getDataTextField().getText()));

                preparedStatement.execute();

                ResultSet schedule = preparedStatement.getResultSet();

                tableController.startLogic(connection, schedule, nr_contract);

            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });

        receptionistView.getLogOutButton().addActionListener(e -> {
            LoginController loginController = new LoginController();
            loginController.startLogic(connection);
        });
    }
}
