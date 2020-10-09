package object_classes.venues;

public class ConferenceHall extends EventVenue {
	private int numOfRooms;

	public int getNumOfRooms() {
		return numOfRooms;
	}

	public void setNumOfRooms(int numOfRooms) {
		this.numOfRooms = numOfRooms;
	}
	
	public ConferenceHall(String code, String venname, int people,double price, double area, int nor) {
		super(code, venname, people, price, area);
		this.numOfRooms = nor;
	}
	
	public void print()
	{
		System.out.println("============CONFERENCE HALL==============");
		System.out.println(this.getCode() +"\n"+ this.getVenueName() +"\n"+  this.getNumOfpersons()+"\n"+ this.getPricePerDay() +"\n"+ this.getSpaceM2() +"\n"+ this.amenities() +"\n"+ this.getNumOfRooms());
	}

}
