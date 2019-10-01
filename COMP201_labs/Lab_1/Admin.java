public class Admin extends User
{
    Admin(String name, String login, String passwd)
    {
        super(name, login, passwd);
    }

    public void printMenu()
    {
        System.out.println("IM SU!");
    }
}