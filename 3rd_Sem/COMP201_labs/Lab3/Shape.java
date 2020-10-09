import util.Drawable;
public abstract class Shape implements java.lang.Comparable<Shape>, Drawable
{
	protected int x;
	protected int y;
	
	public int getX()
	{
		return x;
	}
	public void setX(int x)
	{
		this.x = x;
	}
	public int getY()
	{
		return y;
	}
	public void setY(int y)
	{
		this.y = y;
	}
	
	public Shape(int x,int y)
	{
		this.x = x;
		this.y = y;
	}
	
	public abstract double calculateArea();
	
	@Override
	public int compareTo(Shape arg0)
	{
		if(this.calculateArea()<arg0.calculateArea())
			return -1;
		else if(this.calculateArea()>arg0.calculateArea())
			return 1;
		else 
			return 0;
	}
}	
