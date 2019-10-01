package object_classes.vehicles;
public abstract class Passenger extends Vehicle {
	private int PassengerNum;
	private int cc;
	
	public int getPassengerNum() {
		return PassengerNum;
	}
	
	public void setPassengerNum(int passengerNum) {
		PassengerNum = passengerNum;
	}
	
	public int getCc() {
		return cc;
	}
	
	public void setCc(int cc) {
		this.cc = cc;
	}
	
	public Passenger(String plate, String model, int releaseYear, int distanceDriven, int dateRentCost,int passengernum, int cc)
	{
		super(plate, model, releaseYear,distanceDriven,dateRentCost);
		this.PassengerNum = passengernum;
		this.cc = cc;
	}
}
