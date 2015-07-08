package network;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.LineNumberReader;
import java.io.PrintStream;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Scanner;


public class NetworkBuilder
{
	static String line;
	static BufferedReader br1 = null, br2 =null;
	static ArrayList<String> pList = new ArrayList<String>();
	static ArrayList<String> pdata = new ArrayList<String>();
	static ArrayList<String> rList = new ArrayList<String>();
	
	
	public static void main(String[] args) throws IOException
	{
		
		String fileContent1 = "*Vertices " ;
		String fileContent2 = "*Edges" ;
		
		System.out.println("Enter your current directory: ");
		Scanner scanner = new Scanner(System.in);
		String directory = scanner.nextLine();
		
		try
		{
			br1 =  new BufferedReader(new FileReader(directory + "//people.csv"));
			br2 =  new BufferedReader(new FileReader(directory + "//repo.csv"));
			
		} catch(FileNotFoundException e)
		{
			System.out.println(e.getMessage() + " \n file not found re-run and try again");
			System.exit(0);
		}
		int count = 0;
		try {
			while((line = br1.readLine()) != null){ //skip first line
			while((line = br1.readLine()) != null)
			{
				pList.add(line); // add to array list
				count++ ;	
			}
			}
			
		} catch (IOException error) 
		{
			System.out.println(error.getMessage() + "Error reading file");
		}
		
		System.out.println("Process completed go to directory to see file");
		PrintStream myconsole = new PrintStream(new File(directory + "network.net"));
    	System.setOut(myconsole);
    	
    	/**************Vertices ***************/
        
        int size = pList.size();
        int idstatus = 0; 
        int vert = 0;
        
        /*
         * for loop to count different people_id (*Vertices __ )
         */
        for(int i=0; i < size; i++)
  		{
 	   	
 	    String[] data=(pList.get(i)).split(",");
 	   	if(idstatus!=Integer.parseInt(data[1])) //Skip same people_id eg (2 2)
 	    {
 	   		vert++;
 	   		idstatus = Integer.parseInt(data[1]); //identify people_id
 	    }
  		}
        idstatus = 0;  //reset to 0 (people_id)
        System.out.println(fileContent1 +vert);
        
        
        /*
         * for loop to print the people_id without repeating the same id
         */
        for(int i=0; i < size; i++)
       	{
     	   	
     	   String[] data=(pList.get(i)).split(",");
     	    if(idstatus!=Integer.parseInt(data[1]))
     	    {
     	   		System.out.println(data[1]);
     	   		idstatus = Integer.parseInt(data[1]);
     	    }
       	}
       
       
      	/************* Edges****************/
    	System.out.println(fileContent2);
    	
    	int[] states = new int[vert]; //to declare for later storing of vertices
    	idstatus=0; //reset to 0
    	
    	/*
    	 * for loop to store vertices
    	 */
        for(int i=0; i < size; i++)
        {  	
     	    String[] data=(pList.get(i)).split(",");
     	   	if(idstatus!=Integer.parseInt(data[1])) 
     	    {
     	    	
     	   		idstatus = Integer.parseInt(data[1]); 
     	   		states[idstatus-1]=idstatus; //to store vertices
     	    	
     	    }
       	}
       	
       	////////////////////////////////////
    	idstatus=0;
    	int[] repo = new int[count];
       	int[] repo2 = new int[count];
    	
    	int vert1=0;
    	int common=0;	
    	
       	
       			for(int b=0; b<states.length; b++)
       			{
	       			vert1 = b+1;
	       			for(int c=0; c<count;c++) // store repoid 1
	       			{
	       				String[] data=(pList.get(c)).split(",");
	       				if(Integer.parseInt(data[1])==states[b])   // store repoid of all peopleid 1
	       				{
	       					repo[c]=Integer.parseInt(data[6]);
	       			
	       				}	
	       			}
	       			
	       			for(int d=0; d<states.length; d++)
	       			{
	       				if(states[d]!=vert1)
	       				{
		       				for(int c=0; c<count;c++) // store repoid 2
			       			{
			       				String[] data=(pList.get(c)).split(",");
			       				if(Integer.parseInt(data[1])==states[d]) 
			       				{
			       					repo2[c]=Integer.parseInt(data[6]);  
			       				}	
			       			}
			       		
	       				    //Compare
			       			for(int e=0; e<repo.length; e++)
			       			{
			       				
			       				for(int f=0; f<repo2.length; f++)
			       				{
			       				
			       					if(repo[e]==repo2[f]&&repo[e]!=0&&repo2[f]!=0)
			       					{			       			    		       						
			       						common++;
			       					}
			       					
			       				}
			       			}
			       			 
			       			//remove null values 
			       			if(common!=0){
			       			System.out.println(vert1+" "+(d+1)+" "+common ); 
			       			}
			       			common=0;
			       			// clear
			       			for(int g=0; g<repo2.length; g++)
			       			{
			       				repo2[g]=0;
			       			}
	       				}
	       			}
	       			
	       		// clear
	       			for(int a=0; a<repo.length; a++)
	       			{
	       				repo[a]=0;
	       			}
	       			
	       		}       			    		      		

	} // end of main
	
}

