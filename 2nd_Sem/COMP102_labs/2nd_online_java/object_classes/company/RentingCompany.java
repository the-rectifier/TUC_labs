package object_classes.company;

import wrapper_classes.Client_Wrapper;
import wrapper_classes.Renting_wrapper;
import wrapper_classes.Vehicle_wrapper;
import wrapper_classes.EventVenue_Wrapper;

import java.util.Date;

import list.Item;
import list.Node;
import object_classes.customers.*;
import object_classes.vehicles.*;
import object_classes.rentings.*;
import object_classes.venues.*;
import utils.DatePeriod;


public class RentingCompany {
	private String Name;
	private int afm;
	private String Base;
	private static final String pck = "object_classes.venues.";
	private CompanySortedList clientele;
	private CompanySortedList inventory;
	private CompanySortedList rentings;
	private CompanySortedList venues;
	
	public String getName() {
		return Name;
	}
	public void setName(String name) {
		Name = name;
	}
	public int getAfm() {
		return afm;
	}
	public void setAfm(int afm) {
		this.afm = afm;
	}
	public String getBase() {
		return Base;
	}
	public void setBase(String base) {
		Base = base;
	}

	public void print()
	{
		System.out.println(this.Name);
		System.out.println(this.afm);
		System.out.println(this.Base);
	}
	
	@SuppressWarnings("deprecation")
	public RentingCompany() 
	{
		this.Name = "Stolen Cars";
		this.afm = 666;
		this.Base = "Narnia";
		
		clientele = new CompanySortedList();
		inventory = new CompanySortedList();
		rentings = new CompanySortedList();
		venues = new CompanySortedList();
		//init cars and wrap then into Vehicles and insert them to list
		inventory.insert(new Vehicle_wrapper(new Car("XNK5544", "Mercedes C200", 2012, 120000, 50, 5, 1800, 4, Car_Type.BATTERY)));
		inventory.insert(new Vehicle_wrapper(new Car("XNA1204", "Honda Pilot", 2019, 5000, 70, 7, 3000, 5, Car_Type.DIESEL)));
		inventory.insert(new Vehicle_wrapper(new Car("XNM1345", "Mercedes Mini BXS", 2018, 6000, 100, 12, 3000, 4, Car_Type.DIESEL)));
		inventory.insert(new Vehicle_wrapper(new Bike("XNO1706", "Yamaha YZF-R3", 2015, 60500, 45, 2, 600, Bike_Type.TOURING))); 
		inventory.insert(new Vehicle_wrapper(new Bike("XNX9901", "Kawasaki Ninja 300", 2012, 32000, 30, 2, 300, Bike_Type.CRUISER)));
		inventory.insert(new Vehicle_wrapper(new Truck("XNA1207", "Volvo FH16", 2017, 90000, 250, 20000, 3, 4)));
		inventory.insert(new Vehicle_wrapper(new Truck("XNA1208", "Scania XD1", 2018, 80000, 300, 25000, 3, 3))); 
		//same for clients
		clientele.insert(new Client_Wrapper(new Citizen("Nikos Arabatzis", 123456789, 3028210373L, "Chania", "Greece")));
		clientele.insert(new Client_Wrapper(new Citizen("Johanes Stevenson", 987456321, 4621097275L, "Stockholm", "Sweden")));
		clientele.insert(new Client_Wrapper(new Business("Nick Malone", 741258963, 3536975589L, "Dublin", "Ireland", 10)));
		clientele.insert(new Client_Wrapper(new Business("Tim Roberg", 258963147, 3265738648L, "Brussels", "Belgium", 20)));
		//you get the idea
		rentings.insert(new Renting_wrapper(new Renting(100, clientLookup(123456789), vehicleLookup("XNK5544"), new Date("2019/04/03"), new Date("2019/04/22"), 950.0)));
		rentings.insert(new Renting_wrapper(new Renting(101, clientLookup(987456321), vehicleLookup("XNA1204"), new Date("2019/04/05"), new Date("2019/04/08"), 210)));
		rentings.insert(new Renting_wrapper(new Renting(102, clientLookup(741258963), vehicleLookup("XNO1706"), new Date("2019/06/05"), new Date("2019/06/15"), 405)));
		rentings.insert(new Renting_wrapper(new Renting(103, clientLookup(258963147), vehicleLookup("XNX9901"), new Date("2019/06/15"), new Date("2019/06/15"), 240)));
		rentings.insert(new Renting_wrapper(new Renting(104, clientLookup(123456789), vehicleLookup("XNA1207"), new Date("2019/06/05"), new Date("2019/06/14"), 2250)));
		rentings.insert(new Renting_wrapper(new Renting(105, clientLookup(987456321), vehicleLookup("XNA1208"), new Date("2019/06/07"), new Date("2019/06/15"), 2400)));
		rentings.insert(new Renting_wrapper(new Renting(106, clientLookup(741258963), vehicleLookup("XNK5544"), new Date("2019/06/05"), new Date("2019/06/15"), 450)));
		rentings.insert(new Renting_wrapper(new Renting(107, clientLookup(258963147), vehicleLookup("XNM1345"), new Date("2019/08/05"), new Date("2019/08/15"), 800)));		
		//here we go again
		ConferenceHall ch = new ConferenceHall("CNF0110", "Platon Conference Center", 400, 16000.0, 10000.0,5);
		ch.addAm(amenities.WIFI);
		ch.addAm(amenities.AV_EQUIPMENT);
		ch.addAm(amenities.PARKING);
		venues.insert(new EventVenue_Wrapper(ch));	
		ConferenceHall ch1 = new ConferenceHall("CNF0114", "Cronos Conference Hall", 110, 3000.0, 5000.0, 3);
		ch1.addAm(amenities.CATERING);
		ch1.addAm(amenities.AV_EQUIPMENT);
		venues.insert(new EventVenue_Wrapper(ch1));
		ConcertHall ch2 = new ConcertHall("CNC0228","Megaron",700,15000, 30000 , false);
		ch2.addAm(amenities.AV_EQUIPMENT);
		ch2.addAm(amenities.BAR);
		ch2.addAm(amenities.PARKING);
		venues.insert(new EventVenue_Wrapper(ch2));
	}
	
	public Client clientLookup(int afm)
	{
		Client_Wrapper c = (Client_Wrapper)clientele.search(afm);
		if(c == null)
		{
			return null;
		}
		else 
		{
			return (Client)c.getData();
		}
	}
	
	public Vehicle vehicleLookup(String s)
	{
		Vehicle_wrapper v = (Vehicle_wrapper)inventory.search(s);
		if (v == null)
		{
			return null;
		}
		else
		{
			return (Vehicle)v.getData();
		}
	}
	
	public int vehicleRemoval(String s) 
	{
		Vehicle_wrapper v = (Vehicle_wrapper)inventory.search(s);
		if (v == null)
		{
			return -1;
		}
		else 
		{
			inventory.delete(v);
			return 1;
		}
	}
	
	public void printInventory()
	{
		inventory.print();
	}
	
	public int clientRemoval(int afm)
	{
		Client_Wrapper c = (Client_Wrapper)clientele.search(afm);
		if (c == null)
		{
			return -1;
		}
		else 
		{
			clientele.delete(c);
			return 1;
		}
	}
	
	public void addVehicle(Vehicle v)
	{
		inventory.insert(new Vehicle_wrapper(v));
	}
	
	public void addClient(Client c)
	{
		clientele.insert(new Client_Wrapper(c));
	}
	
	public void printCateg(String s)
	{
		inventory.printAllInHierarchy(s);
	}
	
	public void addRenting(Renting r)
	{
		rentings.insert(new Renting_wrapper(r));
	}
	
	public int isRent(String s, DatePeriod dp)
	{
		for (Node tmp = rentings.getHead(); tmp != null; tmp = tmp.getNext()) 
		{
			
			Renting r = (Renting)tmp.getValue().getData();
			if(r.getVehicle().getPlate().equals(s))
			{
				Date x = r.getDate_rent();
				Date y = r.getDate_return();
				DatePeriod xy = new DatePeriod(x, y);
				if(dp.overlaps(xy))
				{
					System.out.println("Car is Rented from: " + x +" until "+y);
					return 1;
				}
			}
		}
		return 0;
	}
	
	public void printRentPlates(String s)
	{
		for (Node tmp = rentings.getHead(); tmp != null; tmp = tmp.getNext())
		{
			Renting r = (Renting)tmp.getValue().getData();
			if(r.getVehicle().getPlate().equals(s))
			{
				r.print();
			}
		}
	}
	public void printRentTax(int afm)
	{
		for (Node tmp = rentings.getHead(); tmp != null; tmp = tmp.getNext())
		{
			Renting r = (Renting)tmp.getValue().getData();
			if(r.getClient().getAfm() == afm)
			{
				r.print();
			}
		}
	}
	public void printRentDate(DatePeriod dp) 
	{
		for (Node tmp = rentings.getHead(); tmp != null; tmp = tmp.getNext())
		{
			Renting r = (Renting)tmp.getValue().getData();
			DatePeriod xy = new DatePeriod(r.getDate_rent(), r.getDate_return());
			if(xy.overlaps(dp))
			{
				r.print();
			}
		}
	}
	
	public void print_avg_cost_sq(String s, int att)
	{
		//double sumsq = 0;
		//double sumpr = 0;
		double avg = 0;
		int count = 0;
		for (Node tmp = venues.getHead(); tmp != null; tmp = tmp.getNext())
		{
			try
			{
				Item item = tmp.getValue();
				if(Class.forName(pck + s).isInstance(item.getData()))
				{
					EventVenue ev = (EventVenue)item.getData(); //if it is an instance of EventVenue then I can cast it
					if(ev.getNumOfpersons() >= att)
					{
						//System.out.println(ev.getPricePerDay());
						//System.out.println(ev.getSpaceM2());
						avg += (ev.getPricePerDay()/ev.getSpaceM2()); //cost per sqare meter is the sum of square meter of each venue
						//System.out.println(avg);
						count ++;
					}
				}
			}
			catch (ClassNotFoundException ex)
			{
				System.out.println("This class "+s+" does not exist...");
			}
		}
		System.out.println("Avg cost per squared meter: " + avg/count);
	}
}