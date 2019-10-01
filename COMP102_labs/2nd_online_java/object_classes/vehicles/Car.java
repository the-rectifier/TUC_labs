package object_classes.vehicles;
public class Car extends Passenger {
	private int Doors;
	private Car_Type type;
	private String usage;

	public int getDoors() {
		return Doors;
	}

	public void setDoors(int doors) {
		Doors = doors;
	}
	
	public Car_Type getType() {
		return type;
	}

	public void setType(Car_Type type) {
		this.type = type;
	}

	public String getUsage() {
		return usage;
	}

	public void setUsage(String usage) {
		this.usage = usage;
	}

	public Car(String plate, String model, int releaseYear, int milage, int dateRentCost,int passengernum, int cc,int doors,Car_Type type)
	{
		super(plate,model,releaseYear,milage,dateRentCost,passengernum,cc);
		this.Doors = doors;
		this.type = type;
		if (passengernum > 7) 
		{
			this.usage = "Public";
		}
		else 
		{
			this.usage = "Private";
		}
	}

	@Override
	public void print() {
		System.out.println("================CAR==============");
		System.out.println("Registration Plates: " + this.getPlate());
		System.out.println("Model: "+ this.getModel());
		System.out.println("Year of Release: " + this.getReleaseYear());
		System.out.println("Milage: " + this.getMilage());
		System.out.println("Engine cc: " + this.getCc());
		System.out.println("Number of doors: " + this.getDoors());
		System.out.println("Number of Passengers: " + this.getPassengerNum());
		System.out.println("Fuel: " + this.getType());
		System.out.println("Car Usage: " + this.getUsage());
		System.out.println("Rent per Day: " + this.getDateRentCost());
	}
}
