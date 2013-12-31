package pack;

//import java.lang.Threads;
import java.io.*;
import java.net.*;
import java.util.*;

public class Main {
    
    static final int hostPort = 20000; 
    public static void main(String [ ] args)
    {
        List<Thread> clients = new ArrayList<Thread>();
        while(true)
        {
            /* Attempt to add new clients */
            ServerSocket listener = null;
            Socket sock = null;
            Thread client = null;
            try{
                    listener = new ServerSocket(hostPort);
                    sock = listener.accept();
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

}
