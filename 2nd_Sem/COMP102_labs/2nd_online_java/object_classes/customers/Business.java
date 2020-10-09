package object_classes.customers;
public class Business extends Client {
	private int discount;

	public int getDiscount() {
		return discount;
	}

	public void setDiscount(int discount) {
		this.discount = discount;
	}
	
	public Business (String name, int afm2, long tel2, String town2, String country2, int discount) 
	{
		super(name,afm2,tel2,town2,country2);
		this.discount = discount;
	}
	
	@Override
	public void print()
	{
		System.out.println("==============CLIENT==============");
		System.out.println("Customer's Name: " + this.getFullName());
		System.out.println("Customer's Tax Number: " + this.getAfm());
		System.out.println("Customer's Phone: " + this.getTel());
		System.out.println("Customer's Town of Residence: "+ this.getTown());
		System.out.println("Customer's Country of Residence: "+ this.getCountry());
		System.out.println("Company's Discount: "+ this.getDiscount()+"%");
	}

}
