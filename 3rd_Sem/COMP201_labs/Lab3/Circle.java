public class Circle extends Shape
{
	private int radius;
	
	public int getRadius()
	{
		return radius;
	}

	public void setRadius(int radius)
	{
		this.radius = radius;
	}

	public Circle(int x, int y, int r)
	{
		super(x,y);
		this.radius = r;
	}
	
	public double calculateArea()
	{
		return Math.PI*radius*radius;
	}

	@Override
	public String drawCommand()
	{
		return "draw circle "+x+" "+y+" "+radius;
	}
}
