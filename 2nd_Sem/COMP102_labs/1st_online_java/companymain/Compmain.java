package companymain;
import classes.*;
import utils.*;

import java.util.*;
public class Compmain {

	@SuppressWarnings("deprecation")
	public static void main(String[] args) {
		int code = 200;
		int useropt = 0;
		int useropt_sub = 0;
		double sum =0;
		StandardInputRead reader = new StandardInputRead(); 
		//new company
		Company company = new Company("Company A", 111111,"Nowhere");
		Car car1 = new Car("XNK5544","Ford Fiesta",2012,6.4,120000,33);
		car1.addChar(Characteristics.AIR_CONDITION);
		car1.addChar(Characteristics.DIESEL);
		Car car2 = new Car("XNA1204","Open Corsa",2015,4.7,80000,45);
		car2.addChar(Characteristics.AIR_CONDITION);
		car2.addChar(Characteristics.DIESEL);
		car2.addChar(Characteristics.LEATHER_SEATS);
		Car car3 = new Car("XNO1706","Nissan Micra",2015,5,60500,45);
		car3.addChar(Characteristics.DIESEL);
		car3.addChar(Characteristics.CABRIOLET);
		car3.addChar(Characteristics.LEATHER_SEATS);
		Car car4 = new Car("XNX9901","Lancia Ypsilon",2012,3.5,32000,30);
		car4.addChar(Characteristics.AIR_CONDITION);
		car4.addChar(Characteristics.DIESEL);
		car4.addChar(Characteristics.AUTOMATIC);
		Car car5 = new Car("XNA1207","Toyota Yaris",2017,2.7,17000,50);
		car5.addChar(Characteristics.AIR_CONDITION);
		car5.addChar(Characteristics.HYBRID);
		car5.addChar(Characteristics.AUTOMATIC);
		Car car6 = new Car("XNA1208","Nissan Qashqai",2017,6.8,80000,60);
		car6.addChar(Characteristics.SEVEN_SEATS);
		car6.addChar(Characteristics.DIESEL);
		car6.addChar(Characteristics.FOUR_WHEEL_DRIVE);
		Car car7 = new Car("XNA1209","Ford Mustang",2015,4.7,80000,45);
		car7.addChar(Characteristics.AIR_CONDITION);
		car7.addChar(Characteristics.AUTOMATIC);
		car7.addChar(Characteristics.LEATHER_SEATS);
		Car car8 = new Car("XNH1210","Opel Corsa",2018,3.6,500,80);
		car8.addChar(Characteristics.AUTOMATIC);
		car8.addChar(Characteristics.AIR_CONDITION);
		car8.addChar(Characteristics.LEATHER_SEATS);
		Car car9 = new Car("HKZ1211","Toyota aygo", 2018,3.2,6000,45);
		car9.addChar(Characteristics.AIR_CONDITION);
		car9.addChar(Characteristics.DIESEL);
		car9.addChar(Characteristics.AUTOMATIC);
		Car car10 = new Car("MHO1212","Audi A3",2015,6.1,33000,58);
		car10.addChar(Characteristics.AIR_CONDITION);
		car10.addChar(Characteristics.AUTOMATIC);
		car10.addChar(Characteristics.LEATHER_SEATS);
		company.addcar(car10);
		company.addcar(car9);
		company.addcar(car8);
		company.addcar(car7);
		company.addcar(car6);
		company.addcar(car5);
		company.addcar(car4);
		company.addcar(car3);
		company.addcar(car2);
		company.addcar(car1);
		//clients
		company.addclient(new Client("Nikos", "Arabatzis", "RPS442", 3, "Greece"));
		company.addclient(new Client("Johanes", "Stevenson", "RFF839", 12, "Sweden"));
		company.addclient(new Client("Katerina", "Mpampinioti", "HK6689", 2, "Greece"));
		company.addclient(new Client("Marilena", "Karopoulou", "PK0967", 5, "Greece"));
		company.addclient(new Client("Nick", "Malone", "JFK8FR", 14, "Ireland"));
		company.addclient(new Client("Tim", "Roberg", "HJK31F", 9, "Belgium"));
		company.addclient(new Client("Mario", "Marcelano", "ITF934", 6, "Italy"));
		company.addclient(new Client("Mantalena", "Paliarini", "ITJ798", 3, "Italy"));
		company.addclient(new Client("Klaus", "Regling", "DEF987", 18, "Germany"));
		company.addclient(new Client("Manousos", "Manousakis", "GR0912", 20, "Greece"));
		//rents
		company.addrent(new Renting(100,company.searchForClient("RPS442"),company.searchForCar("XNX9901"),new Date("2019/04/03"),new Date("2019/04/22"),570));
		company.addrent(new Renting(101,company.searchForClient("RFF839"),company.searchForCar("XNA1207"),new Date("2019/04/05"),new Date("2019/04/08"),150));
		company.addrent(new Renting(102,company.searchForClient("HK6689"),company.searchForCar("XNA1208"),new Date("2019/06/05"),new Date("2019/06/15"),600));
		company.addrent(new Renting(103,company.searchForClient("PK0967"),company.searchForCar("XNA1209"),new Date("2019/06/05"),new Date("2019/06/15"),450));
		company.addrent(new Renting(104,company.searchForClient("JFK8FR"),company.searchForCar("XNH1210"),new Date("2019/06/05"),new Date("2019/06/14"),720));
		company.addrent(new Renting(105,company.searchForClient("HJK31F"),company.searchForCar("HKZ1211"),new Date("2019/06/07"),new Date("2019/06/15"),360));
		company.addrent(new Renting(106,company.searchForClient("ITF934"),company.searchForCar("MHO1212"),new Date("2019/06/05"),new Date("2019/06/15"),464));
		company.addrent(new Renting(107,company.searchForClient("RPS442"),company.searchForCar("XNX9901"),new Date("2019/05/03"),new Date("2019/05/19"),384));
		company.addrent(new Renting(108,company.searchForClient("PK0967"),company.searchForCar("XNA1207"),new Date("2019/07/07"),new Date("2019/07/12"),225));
		company.addrent(new Renting(109,company.searchForClient("PK0967"),company.searchForCar("XNX9901"),new Date("2019/06/07"),new Date("2019/06/15"),192));
		while(useropt != 7)
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
			case 0: continue;
			case 1:
				String Name = reader.readString("Model: ");
				String platenum = reader.readString("License Plates: ");
				int kilometers = reader.readPositiveInt("Milage: ");
				double fuelcons = reader.readPositiveFloat("Fuel consumption/100Km: ");
				int yearor = reader.readPositiveInt("Year: ");
				double price = reader.readPositiveFloat("Price per day: ");
				Car car = new Car(platenum,Name,yearor,fuelcons,kilometers,price);
				company.addcar(car);
				if(reader.readString("Add features?[yes][no]: ").equals("yes"))
				{
					while(useropt_sub!= 9)
					{
						submenu();
						String userin_sub = reader.readString("Make a choice: ");
						if(userin_sub == null) 
						{
							continue;
						}
						else
						{
							try
							{
								useropt_sub = Integer.parseInt(userin_sub);
							}
							catch(NumberFormatException ex)
							{
								useropt_sub = 0;
							}
						}
						switch(useropt_sub)
						{
						case 1:
							car.addChar(Characteristics.AIR_CONDITION);
							break;
						case 2:
							car.addChar(Characteristics.DIESEL);
							break;
						case 3:
							car.addChar(Characteristics.HYBRID);
							break;
						case 4:
							car.addChar(Characteristics.LEATHER_SEATS);
							break;
						case 5:
							car.addChar(Characteristics.AUTOMATIC);
							break;
						case 6:
							car.addChar(Characteristics.FOUR_WHEEL_DRIVE);
							break;
						case 7:
							car.addChar(Characteristics.SEVEN_SEATS);
							break;
						case 8:
							car.addChar(Characteristics.CABRIOLET);
							break;
						case 9:
							break;
						default:
							System.out.println("Wrong Choice");
							continue;
						}
					}
				}
				useropt_sub = 0;
				break;
			case 2: 
				company.printinventory();
				break;
			case 3: 
				String fn = reader.readString("Clients First Name: ");
				String ln = reader.readString("Clients Last Name: ");
				String permit = reader.readString("License Number: ");
				int yop = reader.readPositiveInt("Licenced Year: ");
				String country = reader.readString("Country: ");
				company.addclient(new Client(fn,ln,permit,yop,country));
				break;
			case 4: 
				String client = reader.readString("Enter Client's Licence Number: ");
				Client client_search = company.searchForClient(client);
				if(client_search == null)
				{
					System.out.println("Client not found");
					break;
				}
				String plates = reader.readString("Enter car's licence plates: " );
				Car car_rent = company.searchForCar(plates);
				if(car_rent == null)
				{
					System.out.println("Unlisted car");
					break;
				}
				Date rentDate = reader.readDate("Renting from [YYYY/MM/DD]: ");
				Date returnDate = reader.readDate("Until [YYYY/MM/DD]: ");
				DatePeriod dateperiod = new DatePeriod(rentDate,returnDate);
				if(company.isRent(plates,dateperiod)==1) 
				{
					System.out.println("This car is already rented");
					break;
				}
				int days = dateperiod.toDays();
				if(reader.readString("Make a discount?[yes]/[no] ").equals("yes"))
				{
					int discount = reader.readPositiveInt("Enter % of discount");
					sum =car_rent.getPrice() * days - (car_rent.getPrice() * days * discount / 100);
				}
				else
				{
					sum =car_rent.getPrice() * days;
				}
				code ++;
				company.addrent(new Renting(code,client_search,car_rent,rentDate,returnDate,sum));
				break;
			case 5: 
				menu5();
				int choice = reader.readPositiveInt("Print rentings based on: ");
				if(choice == 1)
				{
					String s = reader.readString("Search for licence plates: ");
					company.print_rents_plates(s);
				}
				else if(choice == 2)
				{
					String s = reader.readString("Search for client with licence number: ");
					company.print_rents_licence(s);
				}
				else if(choice == 3)
				{
					Date search_rent = reader.readDate("Enter starting date [YYYY]/[MM]/[DD]");
					Date search_return = reader.readDate("Enter return date [YYYY]/[MM]/[DD]");
					DatePeriod dp = new DatePeriod(search_rent,search_return);
					company.print_rents_date(dp);
				}
				break;
			case 6:
				company.findAvg();
				break;
			case 7: break;
			default: System.out.println("Wrong Choice");continue;
			}
		}
	}
	
	private static void printmenu()
	{
		System.out.println("=====================MAIN MENU=====================");
		System.out.println("1.) Add vehicle");
		System.out.println("2.) Print all cars in inventory");
		System.out.println("3.) Add a client");
		System.out.println("4.) Rent a car");
		System.out.println("5.) Print current rentings");
		System.out.println("6.) Print average Rental Duration");
		System.out.println("7.) Exit");
		System.out.println("===================================================");
	}
	private static void submenu()
	{
		System.out.println("=====================FEATURES MENU=====================");
		System.out.println("1.) AC");
		System.out.println("2.) Diesel");
		System.out.println("3.) Hybrid");
		System.out.println("4.) Leather seats");
		System.out.println("5.) Automatic");
		System.out.println("6.) 4x4");
		System.out.println("7.) 7-seats");
		System.out.println("8.) Cabriolet");
		System.out.println("9.) Done");
		System.out.println("===================================================");
	}
	private static void menu5()
	{
		System.out.println("1.) Licence Plates");
		System.out.println("2.) Client Licence Number");
		System.out.println("3.) Date Period");
	}
}
