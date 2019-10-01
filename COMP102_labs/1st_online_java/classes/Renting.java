package classes;
import java.util.Date;
public class Renting {
	private int code;
	private Date rentdate;
	private Date returndate;
	private double cost;
	private Client client;
	private Car car;
	
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public Date getRentdate() {
		return rentdate;
	}
	public void setRentdate(Date rentdate) {
		this.rentdate = rentdate;
	}
	public Date getReturndate() {
		return returndate;
	}
	public void setReturndate(Date returndate) {
		this.returndate = returndate;
	}
	public double getCost() {
		return cost;
	}
	public void setCost(double cost) {
		this.cost = cost;
	}
	public Client getClient()
	{
		return client;
	}
	public void setClient(Client client)
	{
		this.client = client;
	}
	public Car getCar()
	{
		return car;
	}
	public void setCar(Car car)
	{
		this.car = car;
	}
	public Renting()
	{
		
	}
	public Renting(int code,Client client,Car car,Date rent,Date ret, double cost)
	{
		this.code = code;
		this.client = client;
		this.car = car;
		this.rentdate = rent;
		this.returndate = ret;
		this.cost = cost;
	}
	@Override
	public String toString()
	{
		String x ="\n========================"+"\nCar: "+this.getCar().getModel()+"\nLicense Plates: "+this.getCar().getPlatenum()+"\nRented by "
				+this.getClient().getFullname()+"\nRent number: "+this.getCode()+"\nPrice: "+this.getCost()+"\nRented from: " + this.getRentdate()+"\nUntil: " + this.getReturndate();
		return x;
	}
}
