package classes;
import java.util.*;
public class Car {
	private String platenum;
	private String model;
	private int yearor;
	private double fuelcons;
	private int kilometers;
	private double price;
	private Vector <Characteristics> chars;
	public Car()
	{
		
	}
	public Car(String platenum, String model, int yearor, double fuelcons,int kilometers,double price)
	{
		this.platenum = platenum;
		this.kilometers = kilometers;
		this.price = price;
		this.model = model;
		this.fuelcons = fuelcons;
		this.yearor = yearor;
		chars = new Vector <Characteristics>();
	}
	public void addChar(Characteristics c)
	{
		chars.add(c);
	}
	public Vector<Characteristics> chars()
	{
		return chars;
	}
	public String getPlatenum() {
		return platenum;
	}
	public void setPlatenum(String platenum) {
		this.platenum = platenum;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public int getYearor() {
		return yearor;
	}
	public void setYearor(int yearor) {
		this.yearor = yearor;
	}
	public double getFuelcons() {
		return fuelcons;
	}
	public void setFuelcons(double fuelcons) {
		this.fuelcons = fuelcons;
	}
	public int getKilometers() {
		return kilometers;
	}
	public void setKilometers(int kilometers)
	
	{
		this.kilometers = kilometers;
	}
	public double getPrice() 
	{
		return price;
	}
	public void setPrice(double price) 
	{
		this.price = price;
	}
	@Override 
	public String toString()
	{
		String x ="================" + "\nModel: "+this.model+"\nLicense Plates: "+this.platenum+"\nFuel per 100Km: "+this.fuelcons+"\nYear: " + this.yearor+ "\nMilage: "
	                + this.kilometers+ "\nPrice: "+ this.price+"\nFeatures: "+this.chars();
		return x;
	}
}
