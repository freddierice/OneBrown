package pack;


import java.io.*;
import java.net.*;
import java.util.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Main extends Thread {
    
    public static void main(String [ ] args)
    {
        Main main = new Main();
        main.runner();
    }
    
    static final int hostPort = 20000; 
    List<Client> clients = null;
    ServerSocket listener = null;
    
    Main(){}
    
    public void runner()
    {
        System.out.print("Initializing the MySQL Libraries... ");
        loadMySQL();
        System.out.print("done!\nInitializing server... ");
        clients = new ArrayList<Client>();
        try{
            listener = new ServerSocket(hostPort);
        }catch (IOException e){
            System.out.print("error. \nThe port 20000 is in use.");
            System.exit(0);
        }
        start();
        System.out.print("done!\n");
        
        Client client = null;
        Socket sock = null;
        while(true)
        {
            /* Attempt to add new clients */
            try{
                System.out.print("Waiting for client to connect... ");
                sock = listener.accept();
                System.out.println("client connected!");
                client = new Client(sock);
                client.start();
                clients.add(client);
            }catch( IOException e ){
                continue;
            }
        }
    }
    
    /* Remove dead clients in separate thread */
    public void run()
    {
        for(int i = clients.size()-1; i > 0; --i){
            Client c = clients.get(i);
            if( c.isDead() ){
                c.closeConnection();
                c = null;
                clients.remove(i);
            }
        }
        try{
            Thread.sleep(100);
        }catch(InterruptedException e){}
    }
    
    public void loadMySQL()
    {
        try {
                Class.forName("com.mysql.jdbc.Driver").newInstance();
             } catch (Exception ex) {
                 System.out.println("\nThe server could not start because MySQL libraries could not load."); 
                 System.exit(0);
            }
    }
}
