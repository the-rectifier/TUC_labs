public class Rectangle extends Shape
{
	private int width;
	private int height;
	
	public int getWidth()
	{
		return width;
	}
	public int getHeight()
	{
		return height;
	}
	public void setWidth(int width)
	{
		this.width = width;
	}
	public void setHeight(int height)
	{
		this.height = height;
	}
	
	public Rectangle(int x, int y, int w, int h)
	{
		super(x,y);
		this.width = w;
		this.height = h;
	}
	
	public double calculateArea()
	{
		return this.height*this.width;
	}
	@Override
	public String drawCommand()
	{
		return "draw rectangle "+x+" "+y+" "+width+" "+height;
	}

}
