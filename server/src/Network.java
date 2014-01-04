package pack;

import java.io.*;
import java.net.*;
import java.util.*;
import java.security.*;

import javax.net.*;
import javax.net.ssl.*;

import org.json.simple.*;
import org.json.simple.parser.*;

@SuppressWarnings("unchecked")
public class Network {
    
    Socket sock = null;
    PrintWriter out = null;
    BufferedReader in = null;
    InputStream inStream = null;
    OutputStream outStream = null;
    
    ServerSocket sslListener = null;
    Socket sslSock = null;
    PrintWriter outSSL = null;
    BufferedReader inSSL = null;
    InputStream inStreamSSL = null;
    OutputStream outStreamSSL = null;
    boolean sslConnection = false;
    
    
    Network(Socket sock){
        this.sock = sock;
        try{
            inStream = sock.getInputStream();
            outStream = sock.getOutputStream();
            in = new BufferedReader(new InputStreamReader(inStream));
            out = new PrintWriter( sock.getOutputStream(), true);
        }catch( IOException e ){}
        //initializeSSL();
    }
    
    public void closeConnections()
    {
        try{
            if(sock.isClosed())
                sock.close();
            //if(sslSock.isClosed())
                //sslSock.close();
        } catch (IOException e) {}
    }
    
    public void sendJSONObject(JSONObject json, boolean ssl)
    {
        try{
            StringWriter sw = new StringWriter();
            String str = null;
            
            json.writeJSONString(sw);
            str = sw.toString();
            
            sendString(str,ssl);
            
        } catch( IOException e ){}
    }
    
    public Object getJSONObject(boolean ssl)
    {
        Object obj  = null;
        String str = "";
        JSONParser parser = new JSONParser();
        int length;
        
        str = recvString(ssl);
        
        try{
            obj = parser.parse(str);
        } catch( ParseException e ){}
        
        return obj;
    }

    public void sendString(String str,boolean ssl)
    {
        if(ssl)
            outSSL.println(str);
        else
            out.println(str);
    }
    
    public String recvString(boolean ssl)
    {   
        try{
            if(ssl)
                return inSSL.readLine();
            else
                return in.readLine();
        } catch( IOException e) {return "";}
    }
    
    public void send(byte arr[], boolean ssl)
    {
        try{
            outStream.write(arr);
            outStream.flush();
        }catch(IOException e){}
    }

    public byte[] recv(boolean ssl)
    {
        byte arr[] = new byte[1024];
        try{
            if(ssl)
                inStreamSSL.read(arr);
            else
                inStream.read(arr);
        }catch(IOException e){}
        return arr;
    }
    
    public void initSSL()
    {
        Random rand = new Random();
        JSONObject json = null;
        boolean foundPort = false;
        int sslPort = 0;
        
        json = new JSONObject();
        json.put("message","startssl");
        sendJSONObject(json,false);
        
        ServerSocketFactory ssocketFactory = SSLServerSocketFactory.getDefault();
        while(!foundPort)
        {
            try{
                sslPort = rand.nextInt(44535) + 21000; // (21000,65535)
                sslListener = ssocketFactory.createServerSocket(sslPort);
            }catch( IOException e ){}
        }
        
        json = new JSONObject();
        json.put("sslport",(Integer)sslPort);
        sendJSONObject(json,false);
        
        try{
            sslSock = sslListener.accept();
            inStreamSSL = sslSock.getInputStream();
            outStreamSSL = sslSock.getOutputStream();
            inSSL = new BufferedReader(new InputStreamReader(inStreamSSL));
            outSSL = new PrintWriter( sslSock.getOutputStream(), true);
        }catch( IOException e ){}
    }
}
