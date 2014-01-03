package pack;

import java.io.*;
import java.net.*;
import java.util.*;
import java.security.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Statement;

import org.json.simple.*;
import org.json.simple.parser.*;

@SuppressWarnings("unchecked")
public class Client implements Runnable{
    public enum ClientStatus { NOT_AUTHORIZED, AUTHORIZED, DEAD}

    ClientStatus cs;
    private int userID;
    private int sessionID;
    
    Connection conn = null;
    Statement stmt = null;

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
            String pass = "df9qfEZVoXl/8MW4";
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
        MessageDigest md = null;
        ResultSet rs = null;
        String user = "";
        String pass = "";
        String sql = "";
        String email = "";
        byte hash[] = null;
        byte salt[] = null;
        byte digest[] = null;
        int id = 0;
        
        //get hashing algorithm 
        try{
            md = MessageDigest.getInstance("SHA-256");
        } catch(NoSuchAlgorithmException e){}

        //tell the user to login
        json.put("message","login");
        sendJSONObject(json);
        
        //get username and password
        while(true){
            json = (JSONObject)getJSONObject();
            user = (String)json.get("user");
            pass = (String)json.get("pass");

            try{
                stmt = conn.createStatement();
                sql = "SELECT id FROM users WHERE email='" + user + "'";
                rs = stmt.executeQuery(sql);
                id = rs.getInt("id");
                email = rs.getString("email");
                hash = rs.getBytes("hash");
                salt = rs.getBytes("salt");
            } catch(SQLException e) {}

            pass += new String(salt);
            md.update(pass.getBytes());
            digest = md.digest();

            if(Arrays.equals(hash,digest))
                System.out.println("Authenticated!");
            else
                System.out.println("Failed!");

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
