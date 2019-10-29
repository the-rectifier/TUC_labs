public abstract class User implements Storable
{
    private String Name;
    private String Login;
    private String passwd;

    public User() {
    }

    public User(String Name, String Login, String passwd) {
        this.Name = Name;
        this.Login = Login;
        this.passwd = passwd;
    }

    public String getName() {
        return this.Name;
    }

    public void setName(String Name) {
        this.Name = Name;
    }

    public String getLogin() {
        return this.Login;
    }

    public void setLogin(String Login) {
        this.Login = Login;
    }

    public void setPasswd(String passwd, String old_passwd) {
        
        if(old_passwd == this.passwd)
        {
            this.passwd = passwd;
            System.out.println("Password Changed!");
        }
        else
        {
            System.out.println("Unable to change password!");
        }

    }

    public User Name(String Name) {
        this.Name = Name;
        return this;
    }

    public User Login(String Login) {
        this.Login = Login;
        return this;
    }

    public boolean CheckUserLogin(String login, String passwd)
    {
        if(login.equals(this.Login) && passwd.equals(this.passwd))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public abstract void printMenu();

    @Override
    public String toString() {
        return "{" +
            " Name='" + getName() + "'" +
            ", Login='" + getLogin() +
            "}";
    }

    
    public void Print()
    {
        System.out.println("{" +
        " Name: " + this.getName() + 
        ", Login: " + this.getLogin() +"}");
    }

    @Override
    public String marshal()
    {
        return(this.Name+"|"+this.Login+"|"+this.passwd);
    }

    public void unMarshal(String data)
    {
        String[] tokens = data.split("|");
        this.setName(tokens[1]);
        this.setLogin(tokens[2]);
        this.passwd = tokens[3];
    }
}