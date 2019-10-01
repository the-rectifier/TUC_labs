package object_classes.rentings;
import java.util.Date;

import object_classes.vehicles.*;
import object_classes.customers.*;

public class Renting {
	private int code;
	private Client client;
	private Vehicle vehicle;
	private Date date_rent;
	private Date date_return;
	private double sum;
	
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public Client getClient() {
		return client;
	}
	public void setClient(Client client) {
		this.client = client;
	}
	public Date getDate_rent() {
		return date_rent;
	}
	public void setDate_rent(Date date_rent) {
		this.date_rent = date_rent;
	}
	public Date getDate_return() {
		return date_return;
	}
	public void setDate_return(Date date_return) {
		this.date_return = date_return;
	}
	public double getSum() {
		return sum;
	}
	public void setSum(double sum) {
		this.sum = sum;
	}
	public Vehicle getVehicle() {
		return vehicle;
	}
	public void setVehicle(Vehicle vehicle) {
		this.vehicle = vehicle;
	}
	
	public void print()
	{
		System.out.println("===================RENTING===================");
		System.out.println("Renting Code: " + this.code);
		this.vehicle.print();
		this.client.print();
		System.out.println("Rented From: " + this.date_rent);
		System.out.println("Until: " + this.date_return);
		System.out.println("Total cost: " + this.sum);
		System.out.println("===================RENTING===================");
	}
	
	public Renting(int code, Client client,Vehicle vehicle,Date rent, Date ret, double sum)
	{
		this.code = code;
		this.client = client;
		this.vehicle = vehicle;
		this.date_rent = rent;
		this.date_return = ret;
		this.sum = sum;
	}
}
