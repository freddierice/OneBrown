package pack;

import java.io.*;
import java.net.*;
import java.util.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Client{
    public enum ClientStatus { NOT_AUTHORIZED, AUTHORIZED, DEAD}

    private int sessionID;
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

    public void authorize()
    {
        
    }
}
