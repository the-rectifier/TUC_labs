package list;

public class List {

	protected Node head;

	protected int length;

	public List() {
		head = null;
		length = 0;
	}

	public boolean isEmpty() {
		return head == null;
	}

	public Node insert(Item a) {
		length++;
		head = new Node(a, head);
		return head;
	}

	public int getLength() {
		return length;
	}

	public void clearList() {
		head = null;
		length = 0;
	}

	public void print() {
		int helper = 0;
		for (Node tmp = head; tmp != null; tmp = tmp.getNext()) {
			System.out.print("[" + helper + "] ");
			tmp.print();
			helper++;
		}
		if (helper == 0) {
			System.out.println("Empty List...");
		} else {
			System.out.println("==================================");
		}

	}

	public Node search(Item a) {
		for (Node tmp = head; tmp != null; tmp = tmp.getNext()){
			if (a.equals(tmp.getValue())){
				return tmp;
			}
		}
		return null;
	}

	public Node delete(Item a) {
		Node n1 = head, n2 = head;

		while ((n1 != null) && (!a.equals(n1.getValue()))) {

			n2 = n1;
			n1 = n1.getNext();
		}
		if (n1 != null) {
			length--;
			if (n2 != n1)
				n2.setNext(n1.getNext());
			else
				head = head.getNext();
			n1.setNext(null);
		}
		return head;
	}

	public Item removeFirst() {
		Node tmp = head;

		if (head != null) {
			length--;
			head = head.getNext();
			tmp.setNext(null);
			return tmp.getValue();
		} else
			return null;
	}
	
	public Node getHead()
	{
		if(length == 0)
		{
			return null;
		}
		else
		{
			return head;
		}
	}
}
