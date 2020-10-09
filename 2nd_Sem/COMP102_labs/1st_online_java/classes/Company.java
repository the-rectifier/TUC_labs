package classes;
import java.util.*;
import utils.*;
public class Company {
	private int afm;
	private String name;
	private String base;
	private Vector<Car> cars;
	private Vector<Client> clientele;
	private Vector<Renting> rentings;
	public int getAfm() {
		return afm;
	}
	public void setAfm(int afm) {
		this.afm = afm;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getBase() {
		return base;
	}
	public void setBase(String base) {
		this.base = base;
	}
	public Company()
	{
		
	}
	public Company(String name, int afm, String base)
	{
		this.name = name;
		this.afm = afm;
		this.base = base;
		cars = new Vector<Car>();
		clientele = new Vector<Client>();
		rentings = new Vector<Renting>();
	}
	public void addcar(Car c)
	{
		cars.add(c);
	}
	public void addclient(Client c)
	{
		clientele.add(c);
	}
	public void addrent(Renting r)
	{
		rentings.add(r);
	}
	public Vector<Car> listofcars()
	{
		return cars;	
	}
	public Vector<Client> listofclients()
	{
		return clientele;
	}
	public Vector<Renting> listofrents()
	{
		return rentings;
	}
	public void printinventory()
	{
		for(int i=0;i<this.cars.size();i++)
			System.out.println(this.cars.get(i));
	}
	public Car searchForCar(String plates)
	{
		for (int i=0;i<cars.size();i++)
		{
			if(cars.get(i).getPlatenum().equals(plates))
			{
				return cars.get(i);
			}
		}
		return null;
	} 
	public int isRent(String plates,DatePeriod dateperiod)
	{
		for (int i=0;i<rentings.size();i++)
		{
			if(plates.equals(rentings.get(i).getCar().getPlatenum()))
			{
				Date car_rent_date = rentings.get(i).getRentdate();
				Date car_return_date = rentings.get(i).getReturndate();
				DatePeriod car_period = new DatePeriod(car_rent_date,car_return_date);
				if(car_period.overlaps(dateperiod))
				{
					return 1;
				}
			}
		}
		return 0;
	}
	public Client searchForClient(String client)
	{
		for (int i=0;i<clientele.size();i++)
		{
			if(clientele.get(i).getPermit().equals(client))
			{
				return clientele.get(i);
			}
		}
		return null;
	}
	public void print_rents_plates(String s)
	{
		for(int i=0;i<this.rentings.size();i++)
		{
			if(this.rentings.get(i).getCar().getPlatenum().equals(s))
			{
				System.out.println(this.rentings.get(i));
			}
		}
	}
	public void print_rents_licence(String s)
	{
		for(int i=0;i<this.rentings.size();i++)
		{
			if(this.rentings.get(i).getClient().getPermit().equals(s))
			{
				System.out.println(this.rentings.get(i));
			}
		}
	}
	public void print_rents_date(DatePeriod dp)
	{
		for(int i=0;i<this.rentings.size();i++)
		{
			DatePeriod dp_rent = new DatePeriod(this.rentings.get(i).getRentdate(),this.rentings.get(i).getReturndate());
			if(dp.overlaps(dp_rent))
			{
				System.out.println(this.rentings.get(i));
			}
		}
	}
	public void findAvg()
	{
		double x = 0;
		Car car_x = new Car();
		for(int i=0;i<this.listofcars().size();i++) //for every car in inventory
		{
			int count = 0;
			double sum = 0;
			double avg = 0;
			for(int j=0;j<this.listofrents().size();j++)
			{
				if(this.listofcars().get(i).getPlatenum().equals(this.listofrents().get(j).getCar().getPlatenum()))
				{
					count++;
					Date date1 = this.listofrents().get(j).getRentdate();
					Date date2 = this.listofrents().get(j).getReturndate();
					DatePeriod dp = new DatePeriod(date1,date2);
					double dp_dates = dp.toDays();
					sum = sum + dp_dates;
				}
			}
			if(sum!=0)
			{
				avg = sum/count;
				System.out.println("Car plates: " + this.listofcars().get(i).getPlatenum());
				System.out.println("Avg date rent: " + avg);
			}
			
			if(avg>x)
			{
				x = avg;
				car_x = this.listofcars().get(i);
			}
		}
		System.out.println("Car most rented: \n" + car_x + "\nwith: "+ x +" days");
		//System.out.println("Car rented averagely the most: ");
		//System.out.println(car_x);
		//System.out.println("days: " + x);
	}
}