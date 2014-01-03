import java.util.HashMap;


enum AminoAcid {
    A ('A', 71.037114),
    R ('R', 156.101111),
    N ('N', 114.042927),
    D ('D', 115.026943),
    C ('C', 103.009185),
    E ('E', 129.042593),
    Q ('Q', 128.058578),
    G ('G', 57.021464),
    H ('H', 137.058912),
    I ('I', 113.084064),
    L ('L', 113.084064),
    K ('K', 128.094963),
    M ('M', 131.040485),
    F ('F', 147.068414),
    P ('P', 97.052764),
    S ('S', 87.032028),
    T ('T', 101.047679),
    U ('U', 150.95363),
    W ('W', 186.079313),
    Y ('Y', 163.06332),
    V ('V', 99.068414);

    public final char letter;
    public final double mass;
    
    AminoAcid (char letter, double mass) {
	this.letter = letter;
	this.mass = mass;
    }
    
}


public class Weight 
{
    private final static double H2 = 2.015650;
    private final static double O = 15.994915;
    
    public static void main (String args[]) 
    {
	
	HashMap<Character,Double> map = new HashMap<>();
	for (AminoAcid aa : AminoAcid.values()) {
	    map.put(aa.letter,aa.mass);
	}

	char ca[] = args[0].toUpperCase().toCharArray();

	for (int i=0; i<ca.length; ++i) {
	    for (int j=i; j<ca.length; ++j) {
		
		double sum = H2+O;
		for (int k=i; k<=j; ++k) {
		    char c = ca[k];
		    Double d = map.get(c);
		    if (d == null)
			System.err.println("Skipping unknown character: " + c);
		    else
			sum += d;
		    System.out.print(c);
		    
		}
		System.out.print("\t");
		System.out.println(sum);
	    }
	    
	}
	
	

    }
}
