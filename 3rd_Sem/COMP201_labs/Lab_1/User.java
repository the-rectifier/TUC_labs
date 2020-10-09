public abstract class User implements Storable
{
	private String name;
	private String login;
	private String password;
	
	public String getName()
	{
		return name;
	}
	public void setName(String name)
	{
		this.name = name;
	}
	public String getLogin()
	{
		return login;
	}
	public void setLogin(String login)
	{
		this.login = login;
	}
	public String getPassword()
	{
		return password;
	}
	public void setPassword(String password)
	{
		this.password = password;
	}
	
	public User()
	{
	}
	
	public User(String n, String l, String p)
	{
		this.name = n;
		this.login = l;
		this.password = p;
	}
	
	public void setPassword(String oldP, String newP)
	{
		if(this.password.equals(oldP))
		{
			this.password = newP;
		}
	}
	
	public abstract void printMenu();
	
	public boolean checkUser(String login, String passwd)
	{
		if(login.equals(this.login) && passwd.equals(this.password))
		{
			return true;
		}
		return false;
	}
	
	public String marshal()
	{
		return this.name+"|"+this.login+"|"+this.password;
	}
	
	public void unMarshal(String data)
	{
		
	}
}
