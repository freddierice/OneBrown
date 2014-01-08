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
public class Network extends Thread {
    
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
    
    ArrayList<JSONObject> cmds;
    
    Network(Socket sock){
        this.sock = sock;
        cmds = new ArrayList<JSONObject>();
        try{
            inStream = sock.getInputStream();
            outStream = sock.getOutputStream();
            in = new BufferedReader(new InputStreamReader(inStream));
            out = new PrintWriter( sock.getOutputStream(), true);
        }catch( IOException e ){}
        //initializeSSL();
    }
    
    public void run()
    {
        String str = "";
        int bufSize = 0;
        int par = 0;
        byte buf[] = new byte[1024];
        int i = 0;
        
        while(true){
            if(par == 0)
                str = "";
            bufSize = recv(buf,false);
            i = 0;
            while((char)buf[i] != '{' &&  i != bufSize)
                ++i;
            for(; i < bufSize; ++i){
                if((char)buf[i] == '{')
                    ++par;
                if((char)buf[i] == '}')
                    --par;
                str += ((Character)((char)(buf[i]))).toString();
                if(par == 0){
                    pushJSONObject(str);
                    str = "";
                    while((char)buf[i] != '{' && i != bufSize)
                        ++i;
                }
            }
            Thread.sleep(100);
        }
    }

    public void pushJSONObject(String str)
    {
        Object obj  = null;
        JSONParser parser = new JSONParser();
        
        try{
            obj = parser.parse(str);
        } catch( ParseException e ){}
        
        cmds.add((JSONObject)obj);
    }

    public JSONObject pullJSONObject()
    {
        while(cmds.size() == 0){
            try{
                Thread.sleep(100);
            }catch( InterruptedException e){
                continue;
            }
        }
        JSONObject obj = cmds.get(0);
        cmds.remove(0);
        return obj;
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

    public int recv(byte arr[], boolean ssl)
    {
        int bufSize = -1;
        while(bufSize == -1){
            try{
                if(ssl)
                    bufSize = inStreamSSL.read(arr);
                else
                    bufSize = inStream.read(arr);
            }catch(IOException e){}
            Thread.sleep(100);
        }
        return bufSize;
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
