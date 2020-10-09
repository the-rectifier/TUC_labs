import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class FileStore {
	private String filename;
	
	public FileStore(String filename) {
		this.filename = filename;
	}
	
	public void loadFromFile(Storable sobj) throws FileNotFoundException,IOException {
		String fileText = new String();
		
		BufferedReader inputStream = new BufferedReader(new FileReader(filename));
		String tempStr = inputStream.readLine();
		
		while(tempStr != null){	
			fileText += tempStr+"\n";				
			//System.out.println(tempStr);
			tempStr = inputStream.readLine();
		}
		inputStream.close();
		//System.out.println(fileText);
		sobj.unMarshal(fileText);
	}
	
	public void saveToFile(Storable sobj) throws IOException {
		FileWriter outStream = new FileWriter(filename);
		outStream.write(sobj.marshal());
		outStream.close();
	}
	
	public void print(Storable sobj) {
		System.out.println("Storable Object String Representation:");
		System.out.println(sobj.marshal());
	}

}
