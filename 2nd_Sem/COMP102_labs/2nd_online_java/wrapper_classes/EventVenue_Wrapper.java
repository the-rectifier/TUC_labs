package wrapper_classes;
import list.Item;
import object_classes.venues.*;

public class EventVenue_Wrapper extends Item {
	private EventVenue ev;
	
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
	public Object key()
	{
		return ev.getCode();
	}
	
	@Override
	public void print()
	{
		ev.print();
	}
	
	@Override
	public Object getData()
	{
		return this.ev;
	}
	
	public EventVenue_Wrapper(EventVenue ev)
	{
		this.ev = ev;
	}
}
