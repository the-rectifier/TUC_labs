public abstract class User
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

    public String getPasswd() {
        return this.passwd;
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

    public User passwd(String passwd) {
        this.passwd = passwd;
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
            ", Login='" + getLogin() + "'" +
            ", passwd='" + getPasswd() + "'" +
            "}";
    }

    
    public void Print()
    {
        System.out.println("{" +
        " Name: " + this.getName() + 
        ", Login: " + this.getLogin() + 
        ", passwd: " + this.getPasswd() + "}");
    }
}