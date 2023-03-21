package app.controller;

import app.single_point_access.GUIFrameSinglePointAccess;
import app.view.FinancialExpertView;
import app.view.TableView;

import java.sql.Connection;

public class InspectorController {
    FinancialExpertView financialExpertView;
    TableController tableController;
    public void startLogic(Connection connection,int nr_contract){
        financialExpertView=new FinancialExpertView();
        GUIFrameSinglePointAccess.changePanel(financialExpertView.getFinancialPane(), "HR");

        tableController=new TableController();

    }
}
