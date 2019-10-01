public class Client extends User
{
    Client(String name, String login, String passwd)
    {
        super(name, login, passwd);
    }

    public void printMenu()
    {
        System.out.println("Im user");
    }
}