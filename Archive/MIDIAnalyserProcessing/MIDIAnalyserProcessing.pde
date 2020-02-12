// library imports
import java.util.Arrays; 


//-------------------------------------------------------------------------------------------------------- Globals
int note;
int vel;
boolean setup = true;
boolean mouseClick = false;
boolean lastMouseClick = false;

String chordName = "";

//-------------------------------------------------------------------------------------------------------- Setup
void setup() {
  
  // app icon
  appIcon = loadImage("appIcon.png");
  surface.setIcon(appIcon);
  
  // setup window
  fullScreen();
  frameRate(FPS);
  pixelDensity(displayDensity(1));
  smooth();
  background(windowBackgroundColor);  
  
  // initialisation
  initGUI();
  initKeyboard();
  initMIDI();  
  
  delay(1000);
  
 
}



//-------------------------------------------------------------------------------------------------------- Main Loop
void draw() {
  
  // state updates
  mouseClick = mousePressed;
  
  // GUI updates
  drawOptions(mouseClick);
  drawChordBox(chordName); 
  drawWindowButtons(false);  // just check if red pressed
  
  nKeysPressed = keyCount;
  
  // draw keyboard
  if(nKeysPressed > 0) {
    
    // draw keyboard
    drawAllKeys();          // should only really redraw keys near those being pressed 
    
    // make a list of all midi numbers currently pressed
    int notes[] = new int[nKeysPressed];
    int nNotes = 0;
    
    for(int i = 0; i < nKeys; i++) {
      if(keyStates[i]) {
        notes[nNotes] = keys[i].MIDInumber; 
        nNotes++;
      }
    }    
    
      
    // figure out intervals in chord (assuming lowest note root)
    int intervals[];
    intervals = new int[nNotes];
   
    for(int i = 0; i < nNotes; i++) {
      intervals[i] = (notes[i] - notes[0]) % 12;  // mod 12 to remove compound intervals
    } 
   
    // remove duplicate intervals
    Arrays.sort(intervals);
    int nIntervals = intervals.length;
    nIntervals = removeDuplicates(intervals, nIntervals);
    intervals = Arrays.copyOfRange(intervals, 0, nIntervals);
    
  
    // analyse chord based on list of intervals
    chordName = analyseAll(notes, intervals);;    
      
  }
  else {chordName = "";} 
    
    
  // end states
  lastMouseClick = mouseClick;
 
 
} // end of draw
