import java.util.LinkedList;
import util.Printer;
import util.PrintException;

public class MyTool
{
	LinkedList<Shape> shapes;
	
	public MyTool()
	{
		shapes = new LinkedList<Shape>();
	}

	public void createShapes()
	{
		shapes.add(new Circle(100,100,50));
		shapes.add(new Circle(100,100,100));
		shapes.add(new Circle(150,150,80));
		shapes.add(new Rectangle(100,100,150,150));
		shapes.add(new Rectangle(100,100,100,100));
		shapes.add(new Rectangle(100,150,200,150));
	}
	
	public void showShapes()
	{
		java.util.Collections.sort(shapes);
		Printer p = new Printer();
		for(Shape shape : shapes)
		{
			System.out.println(shape.calculateArea());
			try 
			{
				p.paintShape(shape);
			} 
			catch (PrintException e) 
			{
				System.out.println("Shape "+ shape + " cannot be printed!");
			}
		}
	}
	
	public static void main(String[] args)
	{
		MyTool tool = new MyTool();
		tool.createShapes();
		tool.showShapes();
	}

}
