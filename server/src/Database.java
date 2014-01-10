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

public class Database {

    Connection conn = null;
    Statement stmt = null;
    String sql = null;
    ResultSet rs = null;
    
    int id;
    String email;
    byte session[];
    
    static final int NO_ERR = 0;
    static final int ACCOUNT_EXISTS = 1;
    static final int DATABASE_ERR = 2;
    
    
    boolean loggedInWithSession = false;

    private Database(Connection conn){
        this.conn = conn;
    }
    
    public static Database getDatabase()
    {
        try{
            String url = "jdbc:mysql://127.0.0.1:3306/onebrown";
            String user = "root";
            String pass = "df9qfEZVoXl/8MW4";
            Connection conn = DriverManager.getConnection(url,user,pass);
            return new Database(conn);
        } catch(SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        
        return null;
    }
    
    public boolean login(String session)
    {
        try{
            stmt = conn.createStatement();
            sql = "SELECT * FROM users WHERE session=FROM_BASE64('" + session + "')";
            rs = stmt.executeQuery(sql);
            if(rs.next()){
                id = rs.getInt("id");
                email = rs.getString("email");
                this.session = Utility.stringToBase64(session);
                loggedInWithSession = true;
                return true;
            }else{
                return false;
            }
        } catch(SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        return false;
    }
    
    public boolean login(String user, String pass)
    {
        byte hash[] = null;
        byte salt[] = null;
        byte digest[] = null;
        MessageDigest md = null;

        try{
            md = MessageDigest.getInstance("SHA-256");
        } catch(NoSuchAlgorithmException e){}
        
        try{
            stmt = conn.createStatement();
            sql = "SELECT * FROM users WHERE email='" + user + "'";
            rs = stmt.executeQuery(sql);
            if(rs.next()){
                id = rs.getInt("id");
                email = rs.getString("email");
                hash = rs.getBytes("hash");
                salt = rs.getBytes("salt");
                session = rs.getBytes("session");
                if(session == null){
                    System.out.println("Session is null");
                    session = Utility.stringToBase64(Utility.runCommand("openssl rand -base64 32"));
                    try{
                        sql = "UPDATE users SET session='" + session + "' WHERE id='" + ((Integer)id).toString() + "'";
                        stmt.executeUpdate(sql);
                    } catch(SQLException ex) {
                        System.out.println("SQLException: " + ex.getMessage());
                        System.out.println("SQLState: " + ex.getSQLState());
                        System.out.println("VendorError: " + ex.getErrorCode());
                        return false;
                    }
                }
            }else{
                System.out.println("Could not find the user");
                return false;
            }
        } catch(SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
            return false;
        }
        
        user = Utility.cleanSQL(user); 
        pass += salt.toString();
        md.update(pass.getBytes());
        digest = md.digest();
        
        System.out.println("After digest");
        
        return Arrays.equals(hash,digest);
    }
    
    public int addAccount(String user, String pass)
    {
        byte hash[] = null;
        byte salt[] = null;
        byte digest[] = null;
        MessageDigest md = null;
        
        try{
            md = MessageDigest.getInstance("SHA-256");
        } catch(NoSuchAlgorithmException e){}
        
        try{
            user = Utility.cleanSQL(user); 
            stmt = conn.createStatement();
            sql = "SELECT * FROM users WHERE email='" + user + "'";
            rs = stmt.executeQuery(sql);
            if(rs.next()){
                return ACCOUNT_EXISTS;
            }
        } catch(SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
            return DATABASE_ERR;
        }
        
        md.update(pass.getBytes());
        digest = md.digest();

        try{
            sql = "INSERT INTO users (email,hash,salt) VALUES ('" + email + "',FROM_BASE64('" + Utility.bytesToBase64(hash) + "'),FROM_BASE64('" + Utility.bytesToBase64(salt) + "'))";
            stmt.executeUpdate(sql);
            return NO_ERR;
        } catch(SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        return DATABASE_ERR;
    }
    
    public boolean closeSession()
    {
        try{
            sql = "UPDATE users SET session=NULL WHERE id='" + ((Integer)id).toString() + "'";
            stmt.executeUpdate(sql);
            return true;
        } catch(SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        
        return false;
    }
}