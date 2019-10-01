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
        addusr(new Client("Client_1", "Login_1", "Pass_1"));
        addusr(new Admin("Admin_1", "Login__1", "Pass__1"));
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
            shop.Authenticate();
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

    public void Authenticate()
    {
        int i;
        StandardInputRead reader = new StandardInputRead();
        String user_name = reader.readString("Enter Username: ");
        String pass = reader.readString("enter Pass: ");

        for(i=0;i<users.size();i++)
        {
            if(users.get(i).getLogin().equals(user_name))
            {
                System.out.println(users.get(i).CheckUserLogin(user_name, pass));
            }
        }
    }
}