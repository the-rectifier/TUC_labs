package object_classes.vehicles;

public abstract class Vehicle {
	private String Plate;
	private String Model;
	private int ReleaseYear;
	private int Milage;
	private int DateRentCost;
	
	public String getPlate() {
		return Plate;
	}
	public void setPlate(String plate) {
		Plate = plate;
	}
	public String getModel() {
		return Model;
	}
	public void setModel(String model) {
		Model = model;
	}
	public int getReleaseYear() {
		return ReleaseYear;
	}
	public void setReleaseYear(int releaseYear) {
		ReleaseYear = releaseYear;
	}
	public int getMilage() {
		return Milage;
	}
	public void setMilage(int milage) {
		Milage = milage;
	}
	public int getDateRentCost() {
		return DateRentCost;
	}
	public void setDateRentCost(int dateRentCost) {
		DateRentCost = dateRentCost;
	}
	
	public Vehicle(String plate, String model, int releaseYear, int milage, int dateRentCost) 
	{
		this.Plate = plate;
		this.Model = model;
		this.ReleaseYear = releaseYear;
		this.Milage = milage;
		this.DateRentCost = dateRentCost;
	}
	
	public abstract void print();
}
