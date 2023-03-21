package app.single_point_access;

import javax.swing.*;

public class GUIFrameSinglePointAccess {
    private static JFrame appFrame = initFrame();

    private static JFrame initFrame() {
        JFrame frame = new JFrame();
        frame.setSize(750, 600);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        return frame;
    }

    public static void changePanel(JPanel panel, String frameTitle) {
        appFrame.setContentPane(panel);
        appFrame.setTitle(frameTitle);
        appFrame.getContentPane().revalidate();
        appFrame.getContentPane().repaint();
    }

    public static void showDialogMessage(String message) {
        JOptionPane.showMessageDialog(appFrame, message);
    }
}
