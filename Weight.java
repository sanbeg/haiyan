import java.util.HashMap;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;

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
    
    private static class H2O 
    {
	private final static double mono = 2.015650 + 15.994915;
	private final static double avg = 2.0159 + 15.9994;
    }
    
    private static final HashMap<Character,AminoAcid> map = new HashMap<>();
    static 
    {
	for (AminoAcid aa : AminoAcid.values()) {
	    map.put(aa.letter,aa);
	}
    }
    
    private static final DefaultTableModel model = new DefaultTableModel
        (
         new String[]{"Word","Mono","Average"},
         0
         ){
            @Override public boolean isCellEditable(int row, int col) 
            {
                return false;
            }
        };
    
            

    public static void main (String args[]) 
    {
        createAndShowGui();
        if ( args.length == 1 )
            generateDataFromFile( new File(args[0]) );
        
    }
    
    private static void generateDataFromFile( File file ) 
    {
        
        try {
            FileReader fr = new FileReader(file);
            BufferedReader br = new BufferedReader(fr);
            String line = br.readLine();
            br.close();
            
            model.setRowCount(0);
            generateData( line );
        }
        catch (java.io.IOException e) {
            e.printStackTrace();
        }
    }
    
    private static void generateData ( String phrase ) 
    {
	char ca[] = phrase.toUpperCase().toCharArray();

	for (int i=0; i<ca.length; ++i) {
            StringBuilder word = new StringBuilder();
            double sum_mono = H2O.mono;
            double sum_avg  = H2O.avg;
            
            for (int j=i; j<ca.length; ++j) {
                char c = ca[j];
                AminoAcid aa = map.get(c);
                word.append(c);
                
                if (aa == null)
                    System.err.println("Skipping unknown character: " + c);
                else {
                    sum_mono += aa.mono;
                    sum_avg  += aa.avg;
                }
                
                if ( word.length() > 0) {
                    model.addRow( new String[]{
                            word.toString(), 
                            String.format("%.5f", sum_mono),
                            String.format("%.5f", sum_avg)
                        });
                }
	    }
	}
    }

    private static void createAndShowGui() {
        //Create and set up the window.
        JFrame frame = new JFrame("Amino Acid Weight Thingy");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        
        JMenuBar menu_bar = new JMenuBar();
        final JMenu menu_input = new JMenu("File");
        menu_bar.add( menu_input );
        frame.setJMenuBar(menu_bar);
        
        JMenuItem menu_item = new JMenuItem("Load Sequence");
        menu_input.add(menu_item);
        menu_item.addActionListener
            (
             new ActionListener()
             {
                 public void actionPerformed(ActionEvent e) {
                     JFileChooser fc = new JFileChooser();
                     int rc = fc.showOpenDialog(menu_input);
                     if (rc == fc.APPROVE_OPTION) {
                         generateDataFromFile( fc.getSelectedFile() );
                     }
                     
                 }
             }
             );
        

        JTable table = new JTable( model );
        JScrollPane scrollpane = new JScrollPane(table);
        frame.getContentPane().add(scrollpane);
        

       
        //Display the window.
        frame.pack();
        frame.setVisible(true);
    }
}
