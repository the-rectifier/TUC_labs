package object_classes.vehicles;
public class Bike extends Passenger {

	private Bike_Type type;
	
	public Bike_Type getType() {
		return type;
	}

	public void setType(Bike_Type type) {
		this.type = type;
	}

	public Bike(String plate, String model, int releaseYear, int milage, int dateRentCost,int passengernum, int cc,Bike_Type type)
	{
		super(plate,model,releaseYear,milage,dateRentCost,passengernum,cc);
		this.type = type;
	}

	@Override
	public void print() {
		System.out.println("================BIKE==============");
		System.out.println("Registration Plates: " + this.getPlate());
		System.out.println("Model: "+ this.getModel());
		System.out.println("Year of Release: " + this.getReleaseYear());
		System.out.println("Milage: " + this.getMilage());
		System.out.println("Engine cc: " + this.getCc());
		System.out.println("Number of Passengers: " + this.getPassengerNum());
		System.out.println("Bike Type: " + this.getType());
	}
}
