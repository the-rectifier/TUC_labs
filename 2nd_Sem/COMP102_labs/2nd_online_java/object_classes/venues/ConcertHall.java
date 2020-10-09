package object_classes.venues;

public class ConcertHall extends EventVenue {
	private boolean outdoor;

	public boolean isOutdoor() {
		return outdoor;
	}

	public void setOutdoor(boolean outdoor) {
		this.outdoor = outdoor;
	}
	
	public ConcertHall(String code, String venname, int people, double price,double area, boolean out) {
		super(code, venname, people, price, area);
		this.outdoor = out;
	}
	
	public void print()
	{
		System.out.println("============CONCERT HALL==============");
		System.out.println(this.getCode() +"\n"+ this.getVenueName() +"\n"+  this.getNumOfpersons()+"\n"+ this.getPricePerDay() +"\n"+ this.getSpaceM2() +"\n"+ this.amenities() + "\n" + this.outdoor);
	}
}
