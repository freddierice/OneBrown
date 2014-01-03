package pack;

import java.io.*;
import java.net.*;
import java.util.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.json.simple.*;
import org.json.simple.parser.*;

@SuppressWarnings("unchecked")
public class Client implements Runnable{
    public enum ClientStatus { NOT_AUTHORIZED, AUTHORIZED, DEAD}

    private int sessionID;
    Connection conn = null;
    ClientStatus cs;
    Socket sock = null;
    PrintWriter out = null;
    BufferedReader in = null;
     
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
            System.out.print("Connecting to database... ");
            String url = "jdbc:mysql://127.0.0.1:3306/onebrown";
            String user = "root";
            String pass = "";
            conn = DriverManager.getConnection(url,user,pass);
        } catch(SQLException ex) {
            System.out.println("error.");
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        cs = ClientStatus.DEAD;
        System.out.println("done!");
    }

    public void run()
    {
        dbLogin();
        initializeSocket();
        authorize();
    }

    public void initializeSocket()
    {
        try {
            in = new BufferedReader(new InputStreamReader(sock.getInputStream()));
            out = new PrintWriter( sock.getOutputStream(), true);
        }catch( IOException e ){}
    }

    public void authorize()
    {
        JSONObject json = new JSONObject();
        String user = "";
        String pass = "";

        //tell the user to login
        json.put("message","login");
        sendJSONObject(json);
        
        //get username and password
        while(true){
            json = (JSONObject)getJSONObject();
            user = (String)json.get("user");
            pass = (String)json.get("pass");

            System.out.println("Username: " + user);
            System.out.println("Password: " + pass);
        }
    }

    public void sendJSONObject(JSONObject json)
    {
        try{
            StringWriter sw = new StringWriter();
            String str = null;

            json.writeJSONString(sw);
            str = sw.toString();

            out.println(str);
        } catch( IOException e ){}
    }

    public Object getJSONObject()
    {
        Object obj  = null;
        String str = "";
        JSONParser parser = new JSONParser();
        int length;
        
        try{
            str = in.readLine();
        } catch( IOException e ){}
        
        try{
            obj = parser.parse(str);
        } catch( ParseException e ){}

        return obj;
    }
}
