package wrapper_classes;
import list.*;
import object_classes.customers.*;

public class Client_Wrapper extends Item{
	
	private Client client;
	
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
	public Object key() { //key is afm
		return client.getAfm();
	}

	@Override
	public void print() {
		client.print();
	}

	@Override
	public Object getData() {
		return this.client;
	}
	public Client_Wrapper(Client c)
	{
		this.client = c;
	}
}
