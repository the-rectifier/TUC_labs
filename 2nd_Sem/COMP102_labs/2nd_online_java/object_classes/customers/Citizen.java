package object_classes.customers;
public class Citizen extends Client {
	
	public Citizen(String name,int afm, long tel,String town,String country)
	{
		super(name,afm,tel,town,country);
	}
	
	@Override
	public void print()
	{
		System.out.println("===============CLIENT===============");
		System.out.println("Customer's Name: " + this.getFullName());
		System.out.println("Customer's Tax Number: " + this.getAfm());
		System.out.println("Customer's Phone: " + this.getTel());
		System.out.println("Customer's Town of Residence: "+ this.getTown());
		System.out.println("Customer's Country of Residence: "+ this.getCountry());
	}
}
