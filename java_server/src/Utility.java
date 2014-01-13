package pack;

import java.io.*;

public class Utility {
    
    Utility(){}

    public static String cleanSQL(String sql)
    {
        String clean = "";
        for(char c : sql.toCharArray())
            if(Character.isLetterOrDigit(c))
                clean += Character.toString(c);

        return clean;
    }

    public static String runCommand(String cmd)
    {
        String str = null;
        try
        {
            Process proc=Runtime.getRuntime().exec(cmd);
            BufferedReader read=new BufferedReader(new InputStreamReader(proc.getInputStream()));
            
            str = read.readLine();
        }catch(IOException e){}
        return str;
    }
    
    public static String bytesToBase64(byte b[])
    {
        return new String(Base64.encodeToByte(b,false));
    }
    
    public static byte[] stringToBase64(String s)
    {
        return Base64.decode(s.getBytes());
    }
}
