package classes;

public class Client {
	private String firstname;
	private String lastname;
	private String permit;
	private String country;
	private int yearsofpermit;
	private String fullname;

	public String getFirstname() {
		return firstname;
	}
	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}
	public String getSurname() {
		return lastname;
	}
	public void setSurname(String lastname) {
		this.lastname = lastname;
	}
	public String getPermit() {
		return permit;
	}
	public void setPermit(String permit) {
		this.permit = permit;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public int getYearsofpermit() {
		return yearsofpermit;
	}
	public void setYearsofpermit(int yearsofpermit) {
		this.yearsofpermit = yearsofpermit;
	}
	public String getFullname() {
		return fullname;
	}
	public Client()
	{
		
	}
	public Client(String fn,String ln,String permit,int yop,String country)
	{
		this.firstname = fn;
		this.lastname = ln;
		this.permit = permit;
		this.yearsofpermit = yop;
		this.country = country;
		this.fullname = this.firstname +" "+ this.lastname;
	}
}
