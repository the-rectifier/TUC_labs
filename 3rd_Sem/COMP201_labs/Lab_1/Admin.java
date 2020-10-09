public class Admin extends User
{
	public Admin()
	{
	}
	public Admin(String n, String l, String p)
	{
		super(n,l,p);
	}
	
	public void printMenu()
	{
		System.out.println("This is Admin");
	}
	@Override
	public String marshal()
	{
		return "admin"+"|"+super.marshal();
	}
}
