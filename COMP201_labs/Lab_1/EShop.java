import lib.StandardInputRead;
import java.util.*;

public class EShop
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
}