package object_classes.company;
import list.*;


public class CompanySortedList extends SortedList {
	private final String packg = "object_classes.vehicles.";
	
	public CompanySortedList()
	{
		super();
	}
	
	public Item search(String key)
	{
		Node tmpNode = head;
		while (tmpNode != null)
		{
			if (tmpNode.getValue().key().equals(new String(key)))
			{
				return tmpNode.getValue();
			}
			tmpNode = tmpNode.getNext();
		}
		return null;
	}
	
	public Item search(int key)
	{
		Node tmpNode = head;
		while (tmpNode != null)
		{
			if (tmpNode.getValue().key().equals(new Integer(key)))
			{
				return tmpNode.getValue();
			}
			tmpNode = tmpNode.getNext();
		}
		return null;
	}
	
	
	public void printAllInHierarchy(String s) {
		Node tmp = head;
		try{
			while (tmp!=null){
				Item item = tmp.getValue();				
				if (Class.forName(packg + s).isInstance(item.getData())){
					item.print();
				}
				tmp = tmp.getNext();
			}
		}catch (ClassNotFoundException ex){
			System.out.println("This class "+s+" does not exist...");
		}		
	}
}
