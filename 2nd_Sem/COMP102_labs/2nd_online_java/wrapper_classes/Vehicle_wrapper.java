package wrapper_classes;
import list.*;
import object_classes.vehicles.*;
public class Vehicle_wrapper extends Item
{
	private Vehicle vehicle;
	
	public Vehicle_wrapper(Vehicle vehicle) 
	{
		this.vehicle = vehicle;
	}

	@Override
	public boolean equals(Item k) {
		return key().equals(k.key());
	}

	@Override
	public boolean less(Item k) {
		if (((String) key()).compareTo((String) k.key()) < 0)
			return true;
		return false;
	}

	@Override
	public Object key() { //key is plate nums
		return vehicle.getPlate();
	}

	@Override
	public void print() {
		vehicle.print();
	}

	@Override
	public Object getData() {
		return this.vehicle;
	}

}
