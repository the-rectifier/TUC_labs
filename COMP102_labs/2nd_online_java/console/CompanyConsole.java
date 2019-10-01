package console;
import java.util.Date;
import object_classes.company.*;
import object_classes.customers.*;
import object_classes.rentings.*;
import object_classes.vehicles.*;
import utils.*;

public class CompanyConsole {
	
	private RentingCompany company;
	private static StandardInputRead reader;
	private static int useropt;
	private int code = 107;
	
	public RentingCompany getCompany() {
		return company;
	}

	public void setCompany(RentingCompany company) {
		this.company = company;
	}

	public CompanyConsole()
	{
		company = new RentingCompany();
		reader = new StandardInputRead();
		useropt = 0;
	}
	
	public static void main(String[] args) {
		
		CompanyConsole console = new CompanyConsole();
		console.company.print();
		System.out.println("Note: Use english language!");
		while(useropt != 12)
		{
			printmenu();
			String userin = reader.readString("Make a choice: ");
			if(userin == null) 
			{
				continue;
			}
			else
			{
				try
				{
					useropt = Integer.parseInt(userin);
				}
				catch(NumberFormatException ex)
				{
					useropt = 0;
				}
			}
			switch(useropt)
			{
			case 0:
				continue;
			case 1: 
				console.vehicleLookup();
				break;
			case 2:
				console.vehicleRemoval();
				break;
			case 3:
				console.addVehicle();
				break;
			case 4:
				console.printInventory();
				break;
			case 5:
				console.printCateg();
				break;
			case 6:
				console.clientLookup();
				break;
			case 7:
				console.clientRemoval();
				break;
			case 8:
				console.addClient();
				break;
			case 9:
				console.newRenting();
				break;
			case 10:
				console.printRentings();
				break;
			case 11:
				console.avg_cost_sq();
				break;
			case 12:
				System.out.println("paaaaa");
				break;
			}
				
		}
	}
	
	private static void printmenu()
	{
		System.out.println("=============CAR RENTING COMPANY v2.0============");
		System.out.println("1.) Search inventory for a Vehicle");
		System.out.println("2.) Remove a Vehicle from inventory");
		System.out.println("3.) Add a Vehicle into inventory");
		System.out.println("4.) Print Inventory");
		System.out.println("5.) Print all Vehicles in category");
		System.out.println("6.) Client Look-up");
		System.out.println("7.) Remove Client");
		System.out.println("8.) Insert Client");
		System.out.println("9.) New Renting");
		System.out.println("10.) Print Rentings");
		System.out.println("11.) Average Cost per sqared meter ");
		System.out.println("12.) Exit");
		System.out.println("================================================");
		
	}
	
	private void avg_cost_sq()
	{
		String s;
		System.out.println("1.) Conference Hall");
		System.out.println("2.) Concert Hall");
		int i = reader.readPositiveInt("Choose Venue: ");
		if(i == 1)
		{
			 s = "ConferenceHall";
		}
		else
		{
			 s = "ConcertHall";
		}
		int att = reader.readPositiveInt("How many attentands ");
		company.print_avg_cost_sq(s, att);
	}
	private void vehicleLookup()
	{
		String plates_search = reader.readString("Enter plate numbers: ");
		Vehicle v = company.vehicleLookup(plates_search);
		if(v == null)
		{
			System.out.println("No such Vehicle was found in inventory");
		}
		else
		{
			v.print();
		}
	}
	
	private void vehicleRemoval()
	{
		if (company.vehicleRemoval(reader.readString("Remove car w/ plates: ")) < 0)
		{
			System.out.println("No such vehicle in inventory");
		}
		else 
		{
			System.out.println("Vehicle Removed");
		}
	}
	
	private void printInventory() 
	{
		company.printInventory();
	}
	
	private void clientLookup()
	{
		int afm_search = reader.readPositiveInt("Enter Client afm: ");
		Client c = company.clientLookup(afm_search);
		if(c == null)
		{
			System.out.println("No such client was found");
		}
		else 
		{
			c.print();
		}
	}
	
	private void clientRemoval()
	{
		if(company.clientRemoval(reader.readPositiveInt("Remove client w/ afm: ")) < 0)
		{
			System.out.println("No such client in clientele");
		}
		else 
		{
			System.out.println("Client Removed");
		}
	}
	
	private void addVehicle()
	{
		useropt = 0;
		String plate,model;
		int relyear,milage,datecost,passengernum,cc,doors,choice,load,height,width;
		Car_Type ct = null;
		Bike_Type bt = null;
		while(useropt>4 || useropt <1)
		{
			System.out.println("==============Insert New Vehicle To Inventory============");
			System.out.println("1.) Car");
			System.out.println("2.) Bike");
			System.out.println("3.) Truck");
			System.out.println("4.) Back");
			useropt = reader.readPositiveInt("Type of Vehicle: ");
		}
		switch(useropt)
		{
		case 1:
			plate = reader.readString("Plate Numbers: ");
			model = reader.readString("Model: ");
			relyear = reader.readPositiveInt("Year of Release: ");
			datecost = reader.readPositiveInt("Cost per Day: ");
			milage = reader.readPositiveInt("Milage so far: ");
			cc = reader.readPositiveInt("Engine cc: ");
			passengernum = reader.readPositiveInt("Max number of passengers: ");
			doors = reader.readPositiveInt("Number of doors: ");
			System.out.println("1.) Diesel");
			System.out.println("2.) Gas");
			System.out.println("3.) Battery");
			choice = reader.readPositiveInt("Enter Fuel type: ");
			if(choice == 1)
			{
				ct = Car_Type.DIESEL;
			}
			else if(choice == 2)
			{
				ct = Car_Type.GAS;
			}
			else if(choice == 3)
			{
				ct = Car_Type.BATTERY;
			}
			Vehicle c = new Car(plate, model, relyear, milage, datecost, passengernum, cc, doors, ct);
			company.addVehicle(c);
			break;
		case 2:
			plate = reader.readString("Plate Numbers: ");
			model = reader.readString("Model: ");
			relyear = reader.readPositiveInt("Year of Release: ");
			datecost = reader.readPositiveInt("Cost per Day: ");
			milage = reader.readPositiveInt("Milage so far: ");
			cc = reader.readPositiveInt("Engine cc: ");
			passengernum = reader.readPositiveInt("Max number of passengers: ");
			while(passengernum > 2)
			{
				System.out.println("Maximum Passenger for Bike is 2!");
				passengernum = reader.readPositiveInt("Max number of passengers: ");
			}
			System.out.println("1.) Touring");
			System.out.println("2.) Cruiser");
			System.out.println("3.) Sport");
			System.out.println("4.) ON-OFF");
			choice = reader.readPositiveInt("Enter Bike type: ");
			if(choice == 1)
			{
				bt = Bike_Type.TOURING;
			}
			else if(choice == 2)
			{
				bt = Bike_Type.CRUISER;
			}
			else if(choice == 3)
			{
				bt = Bike_Type.SPORT;
			}
			else if(choice == 4)
			{
				bt = Bike_Type.ON_OFF;
			}
			Vehicle b = new Bike(plate, model, relyear, milage, datecost, passengernum, cc, bt);
			company.addVehicle(b);
			break;
		case 3:
			plate = reader.readString("Plate Numbers: ");
			model = reader.readString("Model: ");
			relyear = reader.readPositiveInt("Year of Release: ");
			datecost = reader.readPositiveInt("Cost per Day: ");
			milage = reader.readPositiveInt("Milage so far: ");
			load = reader.readPositiveInt("Maximum Load: ");
			height = reader.readPositiveInt("Height: ");
			width = reader.readPositiveInt("Width: ");
			Vehicle t = new Truck(plate, model, relyear, milage, datecost, load, width, height);
			company.addVehicle(t);
			break;
		case 4:
			break;
		}
	}
	
	private void addClient()
	{
		int choice,afm,disc;
		long tel;
		String town,country,name;
		System.out.println("1.) Citizen");
		System.out.println("2.) Business");
		choice = reader.readPositiveInt("Type of customer: ");
		if(choice == 1)
		{
			name = reader.readString("Name of Customer: ");
			afm = reader.readPositiveInt("afm of Customer: ");
			tel = reader.readLong("Customer Phone Number: ");
			town = reader.readString("Town of Residence: ");
			country = reader.readString("Country of Residence: ");
			Client c = new Citizen(name, afm, tel, town, country);
			company.addClient(c);
			
		}
		else if(choice == 2)
		{
			name = reader.readString("Name of Customer: ");
			afm = reader.readPositiveInt("afm of Customer: ");
			tel = reader.readLong("Customer Phone Number: ");
			town = reader.readString("Town of Residence: ");
			country = reader.readString("Country of Residence: ");
			disc = reader.readPositiveInt("Amount of discount: ");
			Client c = new Business(name, afm, tel, town, country, disc);
			company.addClient(c);
		}
	}
	
	private void printCateg()
	{
		company.printCateg(reader.readString("Category of Vehicle: "));
	}
	
	private void newRenting() throws ClassNotFoundException
	{
		
		if(reader.readString("Renting to Business y/n ? ").equals("y"))
		{
			Business b = (Business) company.clientLookup(reader.readPositiveInt("Enter Client Tax number: "));
			while(b == null)
			{
				System.out.println("Client does not exist in clientele");
				b = (Business) company.clientLookup(reader.readPositiveInt("Enter Client Tax number: "));
			}
			Vehicle v = company.vehicleLookup(reader.readString("Enter Vehicle's Registration Plates: "));
			while(v == null)
			{
				System.out.println("No such Vehicle exists in inventory");
				v = company.vehicleLookup(reader.readString("Enter Vehicle's Registration Plates: "));
			}
			Date date_rent = reader.readDate("Enter Rent Date [DD/MM/YYYY]: ");
			Date date_return = reader.readDate("Enter Return Date [DD/MM/YYYY]: ");
			DatePeriod dp = new DatePeriod(date_rent, date_return);
			int dp_days = dp.toDays();
			if(company.isRent(v.getPlate(), dp) == 0 )
			{
				int sum = dp_days * v.getDateRentCost();
				sum = sum - (sum * b.getDiscount() / 100);
				code++;
				Renting r = new Renting(code, b, v, date_rent, date_return, sum);
				company.addRenting(r);
				System.out.println("Total Cost: " + r.getSum());
				System.out.println("Rented Successfully");
			}
		}
		else
		{
			Citizen c = (Citizen) company.clientLookup(reader.readPositiveInt("Enter Client Tax number: "));
			while(c == null)
			{
				System.out.println("Client does not exist in clientele");
				c = (Citizen) company.clientLookup(reader.readPositiveInt("Enter Client Tax number: "));
			}
			Vehicle v = company.vehicleLookup(reader.readString("Enter Vehicle's Registration Plates: "));
			while(v == null)
			{
				System.out.println("No such Vehicle exists in inventory");
				v = company.vehicleLookup(reader.readString("Enter Vehicle's Registration Plates: "));
			}
			if(Class.forName("object_classes.vehicles.Car").isInstance(v))
			{
				Car car = (Car)v;
				if(car.getUsage().equals("Public"))
				{
					System.out.println("Civilians may Not rent Public Vehicles");
				}
				else 
				{
					Date date_rent = reader.readDate("Enter Rent Date [DD/MM/YYYY]: ");
					Date date_return = reader.readDate("Enter Return Date [DD/MM/YYYY]: ");
					DatePeriod dp = new DatePeriod(date_rent, date_return);
					int dp_days = dp.toDays();
					if(company.isRent(v.getPlate(), dp) == 0)
					{
						int sum = dp_days * v.getDateRentCost();
						code ++;
						Renting r = new Renting(code, c, v, date_rent, date_return, sum);
						company.addRenting(r);
						System.out.println("Total Cost: " + r.getSum());
						System.out.println("Rented Successfully!");
					}
				}
				
			}
			else 
			{
				Date date_rent = reader.readDate("Enter Rent Date [DD/MM/YYYY]: ");
				Date date_return = reader.readDate("Enter Return Date [DD/MM/YYYY]: ");
				DatePeriod dp = new DatePeriod(date_rent, date_return);
				int dp_days = dp.toDays();
				if(company.isRent(v.getPlate(), dp) == 0)
				{
					int sum = dp_days * v.getDateRentCost();
					code ++;
					Renting r = new Renting(code, c, v, date_rent, date_return, sum);
					company.addRenting(r);
					System.out.println("Total Cost: " + r.getSum());
					System.out.println("Rented Successfully!");
				}
			}
			
		}
	}
	public void printRentings()
	{
		while(useropt>4 || useropt <1)
		{
			System.out.println("==============Print Rentings============");
			System.out.println("1.) Registration Plates: ");
			System.out.println("2.) Client's Tax Numer: ");
			System.out.println("3.) Date");
			System.out.println("4.) Back");
			useropt = reader.readPositiveInt("Type of Vehicle: ");
		}
		switch(useropt)
		{
		case 1:
				String s = reader.readString("Search For Rentings with Registration Plates: ");
				company.printRentPlates(s);
			break;
		case 2:
				int afm = reader.readPositiveInt("Search for Rentings with Client's tax number: ");
				company.printRentTax(afm);
			break;
		case 3:
				Date x = reader.readDate("Enter Starting Date [DD/MM/YYYY]: ");
				Date y = reader.readDate("Enter End Date [DD/MM/YYYY]: ");
				DatePeriod dp = new DatePeriod(x, y);
				company.printRentDate(dp);
			break;
		case 4:
			break;
		}
	}
}