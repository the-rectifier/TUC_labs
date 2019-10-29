public class Admin extends User
{
    public Admin(String name, String login, String passwd)
    {
        super(name, login, passwd);
    }
    public Admin()
    {

    }

    public void printMenu()
    {
        System.out.println("IM SU!");
    }

    @Override
    public String marshal() {
        return("Admin|" + super.marshal());
    }
}