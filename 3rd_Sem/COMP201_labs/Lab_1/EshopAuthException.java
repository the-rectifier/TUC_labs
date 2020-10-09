@SuppressWarnings("serial")
public class EshopAuthException extends Exception
{
	private String login;
	
	public String getLogin()
	{
		return this.login;
	}
	
	public EshopAuthException(String m, String l)
	{
		super(m);
		this.login = l;
	}
}
