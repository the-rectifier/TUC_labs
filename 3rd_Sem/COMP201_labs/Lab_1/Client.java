public class Client extends User
{
	public Client()
	{
	}
	
	public Client(String n, String l, String p)
	{
		super(n,l,p);
	}
	
	public void printMenu()
	{
		System.out.println("This is Client");
	}

	public String marshal()
	{
		return "client"+"|"+super.marshal();
	}
}
