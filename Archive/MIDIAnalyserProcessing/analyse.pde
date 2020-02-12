/*
  Interval analysis tools
*/


String analyseAll(int[] notes, int[] intervals) {
 
  // strings 
  String possibleChords[] = new String[intervals.length];
  String bassNote = "";// = keys[notes[0]].getNoteName(sharpsFlats.state, false);
  String rootNote = "";
  String chord = "";
  
  try{
    bassNote = keys[notes[0]].getNoteName(sharpsFlats.state, false); 
  }
  catch(Exception e) {
    delay(10000000); //<>//
  }
  
  
  // variables
  int nPossibleChords = intervals.length;
 
  // special cases
  if(nPossibleChords == 0) {possibleChords[0] = "";}
  if(nPossibleChords == 1) {possibleChords[0] = bassNote + " (note)";}
  
  else if(nPossibleChords == 2) {   
    if(intervals[1] == perf5) { // 5 chords
      possibleChords[0] = bassNote + "5";
    }
    else { // any other dyads treated as intervals
      possibleChords[0] = bassNote + keys[notes[1]].getNoteName(sharpsFlats.state, false);
      possibleChords[0] += " (" + intervalNames[intervals[1]] + ")";          
    } 
  } 
  else {
    
    // analyse all possible combinations of intervals
    int nCombinations = nPossibleChords - 1;
    
    // print original intervals
    //for(int z = 0; z < nCombinations + 1; z++){print(intervals[z]);print(" ");} print("\n---\n");
    print("---\n");
    possibleChords[0] = analyse(bassNote, intervals);
    println(possibleChords[0]);
    
    for(int i = 1; i < nCombinations + 1; i++) {
      
      // rearrange intervals into next combinations
      for(int j = 0; j < nCombinations; j++) {
        intervals[j] = intervals[j + 1]; 

      }
      intervals[nCombinations] = 12;// last one should always be 12 (one octave shifted up)
      
      //for(int z = 0; z < nCombinations + 1; z++){print(intervals[z]); print(" ");} print("\n");

      int offset = intervals[0];
      for(int j = 0; j < nCombinations + 1; j++) {
        intervals[j] -= offset;
      }
      
      //for(int z = 0; z < nCombinations + 1; z++){print(intervals[z]); print(" ");} print("\n");
      
      // at the end of this loop, new interval set generated 
      possibleChords[i] = analyse(keys[notes[i]].getNoteName(sharpsFlats.state, false), intervals) + "/" + bassNote;
      println(possibleChords[i]);
          
          
    }     
    
    // most likely chord (shortest string in list of possible chords)
    chord = possibleChords[0];
    for(int i = 1; i < nPossibleChords; i++) {
      if(possibleChords[i].length() <= chord.length()) {
        chord = possibleChords[i];
      }
    }  

  }
  
  // check for root / root

  
  println("***" + chord + "***\n");
  
  
  return chord;
}



String analyse(String chordRoot, int[] intervals) {
  
  // strings
  String chord = "";
  String base = "";
  String ext = "";
  
  // triads and extended chords 
  if(intervals.length > 2) {

    // interval corresponds to position in array, each true or false
    boolean intervalStates[] = new boolean[12];
    Arrays.fill(intervalStates, false);
    
    for(int i = 0; i < intervals.length; i++) {
      intervalStates[intervals[i]] = true;
    }
    
    // figure out fundamental chord info (intervals up to and including P5
    boolean extension = false;
    
    if(intervalStates[perf5]) {
      
      // chords with a perfect fifth
      if(intervalStates[maj3]) {
        intervalStates[maj3] = false;
        if     (intervalStates[min7]) {base = "7";     intervalStates[min7] = false;}  // set the interval states to say they are accounted for
        else if(intervalStates[maj7]) {base = "maj7";  intervalStates[maj7] = false;}
        else if(intervalStates[maj6]) {base = "6";     intervalStates[maj6] = false;   if(intervalStates[maj2]){base = "6/9"; intervalStates[maj2] = false;}}  // special case for 6/9
        else                          {base = "";}
        
      }
      else if(intervalStates[min3]) {
        intervalStates[min3] = false;
        if     (intervalStates[min7]) {base = "m7";      intervalStates[min7] = false;}
        else if(intervalStates[maj6]) {base = "m6";      intervalStates[maj6] = false;}
        else if(intervalStates[maj7]) {base = "m(maj7)"; intervalStates[maj7] = false;}
        else                          {base = "m";}
      
      }
      else if(intervalStates[maj2])  {
        intervalStates[maj2] = false;
        if     (intervalStates[min7]) {base = "7sus2";    intervalStates[min7] = false;}
        else if(intervalStates[maj7]) {base = "maj7sus2"; intervalStates[maj7] = false;}
        else if(intervalStates[maj6]) {base = "6sus2";    intervalStates[maj6] = false;}
        else                          {base = "sus2";}
        
      }
      else if(intervalStates[perf4]) {
        intervalStates[perf4] = false;
        if     (intervalStates[min7]) {base = "7sus4";    intervalStates[min7] = false;}
        else if(intervalStates[maj7]) {base = "maj7sus4"; intervalStates[maj7] = false;}
        else if(intervalStates[maj6]) {base = "6sus4";    intervalStates[maj6] = false;}
        else                          {base = "sus4";}
      }
     
      
    }
    else {
      // chords without perfect fifth
      if(intervalStates[min3] && intervalStates[dim5]) {
        intervalStates[min3] = false;
        intervalStates[dim5] = false;
        if(intervalStates[maj6]) {base = "dim7";  intervalStates[maj6] = false;}
        else                     {base = "dim";}
      
      }
      else if(intervalStates[maj3] && intervalStates[min6]) {
        base = "aug";  
        intervalStates[maj3] = false; 
        intervalStates[min6] = false;
      }
      else {base = "?";}  // no 5 chords here
    }
    
    if(intervalStates[min2])  {if(extension) {ext += ",";} ext += "b9";  extension = true;}  // add comma if already extension
    if(intervalStates[maj2])  {if(extension) {ext += ",";} ext += "9";   extension = true;}
    if(intervalStates[min3])  {if(extension) {ext += ",";} ext += "#9";  extension = true;}
    if(intervalStates[perf4]) {if(extension) {ext += ",";} ext += "11";  extension = true;}
    if(intervalStates[aug4])  {if(extension) {ext += ",";} ext += "#11"; extension = true;}
    if(intervalStates[min6])  {if(extension) {ext += ",";} ext += "b13"; extension = true;}
    if(intervalStates[maj6])  {if(extension) {ext += ",";} ext += "13";  extension = true;}
    
    
    chord = chordRoot + base;
    
    if(extension) {
      if(ext.contains("b9") || ext.contains("#9") || ext.contains("#11") || ext.contains("b13") || ext.length() > 3) {
        chord += "add(" + ext + ")";    // add brackets when extension has accidental or multiple extensions
      }
      else {
        chord += "add" + ext;  
      }
    }
    
    
  }
  


  return chord;
  
}
