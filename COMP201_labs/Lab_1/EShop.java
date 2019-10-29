import lib.StandardInputRead;
import java.util.*;

public class EShop implements Storable
{
    private Vector <User> users;

    public void addusr(User u)
    {
        users.add(u);
    }

    public EShop()
    {
        this.users = new Vector<User>();
        addusr(new Client("Client_1", "User1", "User1"));
        addusr(new Admin("Admin_1", "Admin1", "Admin1"));
    }
    public static void main(String[] args)
    {
        StandardInputRead reader = new StandardInputRead();
        EShop shop = new EShop();
        menu();
        int x = reader.readPositiveInt("Choice: ");
        if(x == 1)
        {
            shop.fillUser();
        }
        else if(x == 2)
        {
            String login = reader.readString("Insert login:");
            String password = reader.readString("Insert password:");
            try{
                User userLogged = shop.authenticate(login, password);
                userLogged.printMenu();
            }
            catch (EshopAuthException e)
            {
                System.out.println(e.getLogin()+ " " + e.getMessage());
            }
            /*
            if (userLogged != null)
				userLogged.printMenu();
			else
                System.out.println("Login Error");
                */
        }
        else if(x==3)
        {
            System.out.println(shop.marshal());
        }

    }

    public static void menu()
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

    public User authenticate(String login, String password) throws EshopAuthException
    {
		for (int i=0 ; i<users.size();i++) {
			if (users.elementAt(i).CheckUserLogin(login, password))
				return users.elementAt(i);
		}
		throw new EshopAuthException("User could not be authenticated", login);
    }
    
    public String marshal()
    {
        String data = "";
        for(int i=0; i<users.size();i++)
        {
            data += users.get(i).marshal() + "\n";
        }
        return data;
    }

    public void unMarshal(String data)
    {
        User user;
        for(int i=0; i<users.size();i++)
        {
            String[] lines = data.split("\n");
            for(String t : lines)
            {
                String[] tokens = t.split("|");
                if(tokens[0].equals("Client"))
                {
                    user = new Client();
                }
                else
                {
                    user = new Admin(); 
                }
            }
            
        }
    }
}