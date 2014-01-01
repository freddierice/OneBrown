package pack;

import java.io.*;
import java.net.*;
import java.util.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Main {
    
    static final int hostPort = 20000; 
    public static void main(String [ ] args)
    {
        System.out.print("Initializing the MySQL Libraries... ");
        loadMySQL();
        System.out.print("done!\nInitializing server... ");
        List<Thread> clients = new ArrayList<Thread>();
        System.out.print("done!\n");
        while(true)
        {
            /* Attempt to add new clients */
            ServerSocket listener = null;
            Socket sock = null;
            Thread client = null;
            try{
                    listener = new ServerSocket(hostPort);
                    System.out.print("Waiting for client to connect... ");
                    sock = listener.accept();
                    System.out.println("client connected!");
                    client = new Thread((Runnable)new Client(sock));
                    client.start();
                    clients.add(client);
            }catch( IOException e ){}

            /* Remove all references to closed clients */
            for(Thread c : clients){
                if( !c.isAlive() )
                    c = null;
            }
        }
    }
    
    public static void loadMySQL()
    {
        try {
                Class.forName("com.mysql.jdbc.Driver").newInstance();
             } catch (Exception ex) {
                 System.out.println("The server could not start because MySQL libraries could not load."); 
                 System.exit(0);
            }
    }
}
