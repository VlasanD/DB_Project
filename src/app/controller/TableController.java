package app.controller;

import app.single_point_access.GUIFrameSinglePointAccess;
import app.view.TableView;

import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public class TableController {
    public void startLogic(Connection connection, ResultSet resultSet, Integer nr_contract) {
        TableView tableView = new TableView();
        GUIFrameSinglePointAccess.changePanel(tableView.getPanel1(), "Table");

        DefaultTableModel model = new DefaultTableModel();
        tableView.getTable1().setModel(model);

        try {
            ResultSetMetaData meta = resultSet.getMetaData();

            int columnCount = meta.getColumnCount();

            String[] columnNames = new String[columnCount];

            for (int i = 0; i < columnCount; i++) {
                columnNames[i] = meta.getColumnName(i + 1);
            }

            model.setColumnIdentifiers(columnNames);

            while (resultSet.next()) {
                Object[] row = new Object[columnCount];
                for (int i = 0; i < columnCount; i++) {
                    row[i] = resultSet.getObject(i + 1);
                }
                model.addRow(row);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        tableView.getInapoiButton().addActionListener(e -> {
            LoginController loginController = new LoginController();
            loginController.startLogic(connection, nr_contract);
        });
    }
}
