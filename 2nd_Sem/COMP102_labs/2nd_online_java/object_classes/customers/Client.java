package object_classes.customers;
public abstract class Client {
	private int afm;
	private String FullName;
	private long tel;
	private String Town;
	private String Country;
	
	public Client(String name, int afm2, long tel2, String town2, String country2) {
		this.FullName = name;
		this.afm = afm2;
		this.tel = tel2;
		this.Town = town2;
		this.Country = country2;
	}
	
	public int getAfm() {
		return afm;
	}
	public void setAfm(int afm) {
		this.afm = afm;
	}
	public String getFullName() {
		return FullName;
	}
	public void setFullName(String fullName) {
		FullName = fullName;
	}
	public long getTel() {
		return tel;
	}
	public void setTel(long tel) {
		this.tel = tel;
	}
	public String getTown() {
		return Town;
	}
	public void setTown(String town) {
		Town = town;
	}
	public String getCountry() {
		return Country;
	}
	public void setCountry(String country) {
		Country = country;
	}
	
	public abstract void print();
}
