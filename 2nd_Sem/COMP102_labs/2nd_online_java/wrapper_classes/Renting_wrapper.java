package wrapper_classes;
import list.*;
import object_classes.rentings.*;;

public class Renting_wrapper extends Item {
	
	private Renting renting;
	
	@Override
	public boolean equals(Item k) {
		return key().equals(k.key());
	}

	@Override
	public boolean less(Item k) {
		if (((Integer) key()).compareTo((Integer) k.key()) < 0)
			return true;
		return false;
	}

	@Override
	public Object key() { //key is renting code
		return renting.getCode();
	}

	@Override
	public void print() {
		renting.print();
	}

	@Override
	public Object getData() {
		return this.renting;
	}
	
	public Renting_wrapper(Renting r)
	{
		this.renting = r;
	}

}
