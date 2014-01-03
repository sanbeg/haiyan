import java.util.HashMap;

enum AminoAcid {
    A ('A', 71.037114, 71.0779),
    R ('R', 156.101111, 156.1857),
    N ('N', 114.042927, 114.1026),
    D ('D', 115.026943, 115.0874),
    C ('C', 103.009185, 103.1429),
    E ('E', 129.042593, 129.114),
    Q ('Q', 128.058578, 128.1292),
    G ('G', 57.021464, 57.0513),
    H ('H', 137.058912, 137.1393),
    I ('I', 113.084064, 113.1576),
    L ('L', 113.084064, 113.1576),
    K ('K', 128.094963, 128.1723),
    M ('M', 131.040485, 131.1961),
    F ('F', 147.068414, 147.1739),
    P ('P', 97.052764, 97.1152),
    S ('S', 87.032028, 87.0773),
    T ('T', 101.047679, 101.1039),
    U ('U', 150.95363, 150.0379),
    W ('W', 186.079313, 186.2099),
    Y ('Y', 163.06332, 163.1733),
    V ('V', 99.068414, 99.1311);

    public final char letter;
    public final double mono;
    public final double avg;
    
    AminoAcid (char letter, double mono, double avg) {
	this.letter = letter;
	this.mono = mono;
	this.avg = avg;
    }
    
}


public class Weight 
{
    private final static double H2O_mono = 2.015650 + 15.994915;
    private final static double H2O_avg = 2.0159 + 15.9994;
    
    public static void main (String args[]) 
    {
	
	HashMap<Character,AminoAcid> map = new HashMap<>();
	for (AminoAcid aa : AminoAcid.values()) {
	    map.put(aa.letter,aa);
	}

	char ca[] = args[0].toUpperCase().toCharArray();

	for (int i=0; i<ca.length; ++i) {
	    for (int j=i; j<ca.length; ++j) {
		
		double sum_mono = H2O_mono;
		double sum_avg  = H2O_avg;

		for (int k=i; k<=j; ++k) {
		    char c = ca[k];
		    AminoAcid aa = map.get(c);
		    if (aa == null)
			System.err.println("Skipping unknown character: " + c);
		    else {
			sum_mono += aa.mono;
			sum_avg  += aa.avg;
		    }
		    
		    System.out.print(c);
		    
		}
		//System.out.println("\t" + sum_mono + "\t" + sum_avg);
		System.out.printf("\t%.5f\t%.5f\n", sum_mono, sum_avg);
		
	    }
	    
	}
	
	

    }
}
