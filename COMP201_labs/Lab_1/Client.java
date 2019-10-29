public class Client extends User
{
    public Client(String name, String login, String passwd)
    {
        super(name, login, passwd);
    }
    public Client()
    {

    }
    public void printMenu()
    {
        System.out.println("Im user");
    }

    @Override
    public String marshal() {
        return("Client|" + super.marshal());
    }
}