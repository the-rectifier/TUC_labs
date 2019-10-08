public class EshopAuthException extends Exception
{

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    private String login;


    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public EshopAuthException(String message, String login)
    {
        super(message);
        this.login = login;
    }
    
}