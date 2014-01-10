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
public class Client extends Thread {
    public enum ClientStatus { NOT_AUTHORIZED, AUTHORIZED, DEAD}

    ClientStatus cs;
    
    Network network;
    Database database;
     
    Client()
    {
        
    }

    Client(Socket sock){
        this.cs = ClientStatus.NOT_AUTHORIZED;
        this.network = new Network(sock);
        this.network.start();
        this.database = Database.getDatabase();
        if(this.database == null)
            cs = ClientStatus.DEAD;
    }
    
    public boolean isDead()
    {
        if(cs.equals(ClientStatus.DEAD))
            return true;
        else
            return false;
    }

    public void run()
    {
        if(cs.equals(ClientStatus.DEAD))
            return;
        authorize();
        
        while(cs.equals(ClientStatus.AUTHORIZED)){
            String msg = null;
            while(msg == null){
                JSONObject json = new JSONObject();
                json.put("message","query");
                network.sendJSONObject(json,false);    
                
                json = network.pullJSONObject();
                if(json == null)
                    continue;
                msg = (String)json.get("message");
            }
            
            if(msg.equals("logout")){
                logout();
                break;
            }
        }
        
        cs = ClientStatus.DEAD;
    }

    public void authorize()
    {
        while(cs.equals(ClientStatus.NOT_AUTHORIZED)){
            String msg = null;
            while(msg == null){
                JSONObject json = new JSONObject();
                json.put("message","login_or_register");
                network.sendJSONObject(json,false);    
            
                json = network.pullJSONObject();
                if(json == null)
                    continue;
                msg = (String)json.get("message");
            }
            if(msg.equals("register"))
                register();
            else if(msg.equals("login"))
                login();
        }
    }

    public void login()
    {
        JSONObject json = new JSONObject();
        MessageDigest md = null;
        String user = null;
        String pass = null;
        String session  = null;
        
        json = network.pullJSONObject();
        if(json == null){
            sendAuth(false);
            return;
        }
        user = (String)json.get("user");
        pass = (String)json.get("pass");
        session  = (String)json.get("session");
        
        if( (user == null || pass == null) && session == null ){
            sendAuth(false);
            return;
        }
        
        if(session != null)
            sendAuth(database.login(session));
        else
            sendAuth(database.login(user,pass));
    }
    
    public void register()
    {
        JSONObject json = network.pullJSONObject();
        String user = null;
        String pass = null;
        
        if(json == null){
            sendReg("reg_failed");
            return;
        }
        user = (String)json.get("user");
        pass = (String)json.get("pass");
        
        if(user == null || pass == null){
            sendReg("reg_failed");
            return;
        }
        
        int res = database.addAccount(user,pass);
        if(res == Database.NO_ERR)
            sendReg("reg_success");
        else if(res == Database.ACCOUNT_EXISTS)
            sendReg("reg_exists");
        else if(res == Database.DATABASE_ERR)
            sendReg("reg_failed");
    }
    
    public void logout()
    {
        database.closeSession();
    }

    public void sendAuth(boolean success)
    {
        JSONObject json = new JSONObject();
        if(success){
            System.out.println("Success!");
            cs = ClientStatus.AUTHORIZED;
            json.put("message","auth_success");
            if(!database.loggedInWithSession)
                json.put("session",database.session);
        }else{
                System.out.println("Failed!");
                json.put("message","auth_failed");
        }
        network.sendJSONObject(json,false);
    }
    
    public void sendReg(String str)
    {
        JSONObject json = new JSONObject();
        json.put("message",str);
        network.sendJSONObject(json,false);
    }
    
    public void closeConnection()
    {
        network.closeConnections();
    }
}
