package object_classes.vehicles;

public class Truck extends Vehicle {
	private int MaxLoad;
	private double width;
	private double height;
	
	public int getMaxLoad() {
		return MaxLoad;
	}
	public void setMaxLoad(int maxLoad) {
		MaxLoad = maxLoad;
	}
	public double getWidth() {
		return width;
	}
	public void setWidth(double width) {
		this.width = width;
	}
	public double getHeight() {
		return height;
	}
	public void setHeight(double height) {
		this.height = height;
	}
	
	public Truck(String plate, String model, int releaseYear, int milage, int dateRentCost, int load, double w,double h)
	{
		super(plate,model,releaseYear,milage,dateRentCost);
		this.width = w;
		this.height = h;
	}
	
	@Override
	public void print() {
		System.out.println("================TRUCK==============");
		System.out.println("Registration Plates: " + this.getPlate());
		System.out.println("Model: "+ this.getModel());
		System.out.println("Year of Release: " + this.getReleaseYear());
		System.out.println("Milage: " + this.getMilage());
		System.out.println("Maximum Load: " + this.getMaxLoad());
		System.out.println("Dimentions [H]x[W] " + this.getHeight() + "x" + this.getWidth());
		System.out.println("Rent per Day: " + this.getDateRentCost());
	}
}
