import java.io.IOException;
import java.util.Vector;
import tuc.eced.cs201.io.*;
public class Eshop implements Storable
{
	private Vector <User> users;

    public void addusr(User u)
    {
        users.add(u);
    }

    public Eshop()
    {
        this.users = new Vector<User>();
        addusr(new Client("client1","client1","client1"));
        addusr(new Admin("admin1", "admin", "admin"));
    }
    
	public static void main(String[] args)
	{
		StandardInputRead reader = new StandardInputRead();
        Eshop shop = new Eshop();
        try 
        {
			FileStore fstore = new FileStore("users.txt");
			fstore.loadFromFile(shop);
			fstore.print(shop);
		} catch (IOException e) {
			System.out.println("Error reading file:"+e.getMessage());
			System.exit(0);
		}
        shop.menu();
        //System.out.println(shop.marshal());
        int x = reader.readPositiveInt("Choice: ");
        while(x<3)
        {
	        if(x == 1)
	        {
	            shop.fillUser();
	        }
	        if(x == 2)
	        {
	        	String login = reader.readString("Enter Login: ");
	        	String passwd = reader.readString("Enter Password: ");
				try
				{
					User userLogged = shop.authenticate(login, passwd);
					userLogged.printMenu();
				} 
				catch (EshopAuthException e)
				{
					
					System.out.println(e.getLogin() + " " + e.getMessage());
				}
				/*
	        	if(userLogged != null)
	        	{
	        		userLogged.printMenu();
	        	}
	        	else 
	        	{
	        		System.out.println("Login Error");
				}
				*/
	        }
	        shop.menu();
	        x = reader.readPositiveInt("Choice: ");
        }
	}
	
	public void menu()
    {
        System.out.println("1.) Add User ");
        System.out.println("2.) Auth ");
    }

    public void fillUser()
    {
        StandardInputRead reader = new StandardInputRead();
        String x = reader.readString("enter user name: ");
        String y = reader.readString("enter user login: ");
        String z = reader.readString("enter user pass: ");

        addusr(new Client(x,y,z));
    }
    
    public User authenticate(String login, String passwd) throws EshopAuthException
    {
    	for(int i=0;i<users.size();i++)
    	{
    		if(users.elementAt(i).checkUser(login, passwd))
    		{
    			return users.elementAt(i);
    		}
    	}
    	throw new EshopAuthException("User could not be Authenticated", login);
    }

	@Override
	public String marshal()
	{
		String data = "";
		for (int i=0;i<users.size();i++)
		{
			data += users.elementAt(i).marshal()+"\n";
		}
		return data;
	}

	@Override
	public void unMarshal(String data)
	{
		User user;
		String[] lines = data.split("\n");
		for(String line:lines)
		{
			String[] tokens = line.split("\\|");
			String type = tokens[0];
			String name = tokens[1];
			String login = tokens[2];
			String pass = tokens[3];
			user = (type.equals("client"))?new Client(name,login,pass):new Admin(name,login,pass);
			users.add(user);
		}
	}
}
