package pack;

import java.io.*;
import java.net.*;
import java.util.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Client implements Runnable{
    public enum ClientStatus { NOT_AUTHORIZED, AUTHORIZED, DEAD}

    private int sessionID;
    Connection conn = null;
    ClientStatus cs;
    Socket sock;
     
    Client()
    {
        
    }

    Client(Socket sock){
        this.sock = sock;
        this.cs = ClientStatus.NOT_AUTHORIZED;
    }
    
    public boolean isAlive()
    {
        if(cs != ClientStatus.DEAD)
            return true;
        else
            return false;
    }
    
    public void dbLogin()
    {
        try{
            System.out.println("Connecting to database... ");
            String url = "jdbc:mysql://127.0.0.1:3306/onebrown";
            String user = "root";
            //String pass = "R3xCtcDbU2mgG84";
            String pass = "";
            conn = DriverManager.getConnection(url,user,pass);
        } catch(SQLException ex) {
            System.out.println("error.");
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        System.out.println("done!");
    }

    public void run()
    {
        dbLogin();
    }

    public void authorize()
    {
        
    }
}
