package app.controller;

import app.single_point_access.GUIFrameSinglePointAccess;
import app.view.AdministratorView;

import java.sql.*;

public class AdministratorController {
    AdministratorView administratorView;
    private final String CREATE_USER = "{call proiectreteaclinica.createUser(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)}";
    private final String UPDATE_USER = "{call proiectreteaclinica.updateUser(?, ?, ?, ?, ?, ?, ?)}";
    private final String DELETE_USER = "{call proiectreteaclinica.deleteUser(?)}";

    public void startLogic(Connection connection, int nr_contract,int type) {
        administratorView = new AdministratorView();
        GUIFrameSinglePointAccess.changePanel(administratorView.getAdminPanel(), "Administrator");

        administratorView.getAdaugaUtilizatorButton().addActionListener(e -> {

            try {
                PreparedStatement statement = connection.prepareCall(CREATE_USER);

                statement.setInt(1, Integer.parseInt(administratorView.getNumarContractTextField().getText()));
                statement.setString(2, administratorView.getNumeTextField().getText());
                statement.setString(3, administratorView.getPrenumeTextField().getText());
                statement.setString(4, administratorView.getCNPTextField().getText());
                statement.setString(5, administratorView.getTelefonTextField().getText());
                statement.setString(6, administratorView.getEmailTextField().getText());
                statement.setString(7, administratorView.getIBANTextField().getText());
                statement.setDate(8, Date.valueOf(administratorView.getDataAngajariiTextField().getText()));
                statement.setString(9, administratorView.getDepartamentTextField().getText());
                statement.setString(10, administratorView.getFunctieTextField().getText());
                statement.setString(11, administratorView.getAdresaTextField().getText());
                statement.setInt(12, nr_contract);

                statement.execute();

                statement.close();

            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        administratorView.getActualizeazaUtilizatorButton().addActionListener(e -> {
            try {
                PreparedStatement statement = connection.prepareCall(UPDATE_USER);

                statement.setInt(1, Integer.parseInt(administratorView.getNumarContractTextField1().getText()));
                statement.setString(2, administratorView.getNumeTextField1().getText());
                statement.setString(3, administratorView.getPrenumeTextField1().getText());
                statement.setString(4, administratorView.getTelefonTextField1().getText());
                statement.setString(5, administratorView.getEmailTextField1().getText());
                statement.setString(6, administratorView.getIBANTextField1().getText());
                statement.setString(7, administratorView.getAdresaTextField1().getText());

                PreparedStatement statement1=connection.prepareStatement(LoginController.ROLE_QUERY);

                statement1.setInt(1,Integer.parseInt(administratorView.getNumarContractTextField1().getText()));

                ResultSet role=statement1.executeQuery();

                if(role.next()) {
                    if (role.getString(1).equals("administrator")  && type==1)

                    statement.execute();

                    else if (role.getString(1).equals("administrator") && type==0) {
                        GUIFrameSinglePointAccess.showDialogMessage("Nu ai drepturile necesare pentru executare");
                    }
                    else{
                        statement.execute();
                    }
                }
                statement1.close();

                statement.close();

            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        administratorView.getStergeUtilizatorButton().addActionListener(e -> {
            PreparedStatement statement = null;
            try {
                statement = connection.prepareCall(DELETE_USER);

                statement.setInt(1, Integer.parseInt(administratorView.getNumarContractTextField2().getText()));

                PreparedStatement statement1=connection.prepareStatement(LoginController.ROLE_QUERY);

                statement1.setInt(1,Integer.parseInt(administratorView.getNumarContractTextField2().getText()));

                ResultSet role=statement1.executeQuery();

                if(role.next()) {
                    if (role.getString(1).equals("administrator")  && type==1)

                        statement.execute();

                    else if (role.getString(1).equals("administrator") && type==0) {
                        GUIFrameSinglePointAccess.showDialogMessage("Nu ai drepturile necesare pentru executare");
                    }
                    else{
                        statement.execute();
                    }
                }
                statement1.close();

                statement.close();

            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        });
        administratorView.getLogOutButton().addActionListener(e->{
            LoginController loginController=new LoginController();
            loginController.startLogic(connection);
        });

    }
}
