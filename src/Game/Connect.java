/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Game;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author DELL
 */
public class Connect {
    public static Connection conn = null;
    public static String UserID = "";
    public static String name = "";
    public static String getConnection(){
        String conString = "jdbc:sqlserver://DESKTOP-KLIV45M;databaseName=QL_Lich_Su_Game;user=nghia;password=123";
        String kq = "";
        try {
            conn = DriverManager.getConnection(conString);
        } catch (SQLException ex) {
            kq = "lỗi kết nối "+ ex;
        }
        return kq;
    }
}
