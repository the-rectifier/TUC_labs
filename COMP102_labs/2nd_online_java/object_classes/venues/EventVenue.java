package object_classes.venues;

import java.util.Vector;

public abstract class EventVenue {
	private String code;
	private String venueName;
	private int numOfpersons;
	private double pricePerDay;
	private double spaceM2;
	private Vector<amenities> am;
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getVenueName() {
		return venueName;
	}
	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}
	public int getNumOfpersons() {
		return numOfpersons;
	}
	public void setNumOfpersons(int numOfpersons) {
		this.numOfpersons = numOfpersons;
	}
	public double getPricePerDay() {
		return pricePerDay;
	}
	public void setPricePerDay(double pricePerDay) {
		this.pricePerDay = pricePerDay;
	}
	public double getSpaceM2() {
		return spaceM2;
	}
	public void setSpaceM2(double spaceM2) {
		this.spaceM2 = spaceM2;
	}
	
	public EventVenue(String code, String venname, int people, double price, double area)
	{
		this.code = code;
		this.venueName = venname;
		this.numOfpersons = people;
		this.pricePerDay = price;
		this.spaceM2 = area;
		am = new Vector<amenities>();
	}
	
	public void addAm(amenities am)
	{
		this.am.add(am);
	}

	public Vector<amenities> amenities()
	{
		return this.am;
	}
	public abstract void print();

}
