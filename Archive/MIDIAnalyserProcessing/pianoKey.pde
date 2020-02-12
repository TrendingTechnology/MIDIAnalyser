/* 
 *  Piano Key Class 
 */
 
 
 
//-------------------------------------------------------------------------------------------------------- Initialisation

void initKeyboard() {
  
  // create keys
  int nBlackKeysCreated = 0;
  float keyStartX = sideBarWidth;
  float keyStartY = height - whiteKeyHeight;
  
  for(int i = 0; i < nKeys; i++) {
    
    if(isWhiteKey[i]) {
      keys[i] = new pianoKey(i, true, keyStartX + (i - nBlackKeysCreated) * whiteKeyWidth + whiteKeySeparation, keyStartY);  
    }
    else {
      nBlackKeysCreated += 1;
      keys[i] = new pianoKey(i, false, keyStartX + whiteKeySeparation + (i + 1 - nBlackKeysCreated) * whiteKeyWidth - blackKeyWidth / 2, keyStartY);
    }
    
  }
  
  drawAllKeys();
  
  // set initial key states
  for(int i = 0; i < nKeys; i++) {
    keyStates[i] = false;
    lastKeyStates[i] = false;
  }  
  
}
 
 
 
 
 
//-------------------------------------------------------------------------------------------------------- Piano Key Class

public class pianoKey {
  
  // instance variables
  int MIDInumber = 0;
  boolean isWhiteKey = true;
  boolean pressed = false;
  float xPos = 0;
  float yPos = 0;
  
  // constructor
  public pianoKey(int MIDInumber, boolean isWhiteKey, float xPos, float yPos) {
    this.MIDInumber = MIDInumber;   
    this.isWhiteKey = isWhiteKey;
    this.xPos = xPos;
    this.yPos = yPos;
  }
  
  // methods
  public void drawKey() {
    
    // draw rectangle with top left corner at xPos, yPos
    if(this.isWhiteKey) {
      
      if(this.pressed) {fill(pressedKeyColor[0], pressedKeyColor[1], pressedKeyColor[2]);}
      else {fill(whiteKeyColor);}
      
      stroke(0);
      rect(this.xPos, this.yPos, whiteKeyWidth, whiteKeyHeight, keyCornerRadius);
      
    }
    else {
      
      if(this.pressed) {fill(pressedKeyColor[0], pressedKeyColor[1], pressedKeyColor[2]);}
      else {fill(blackKeyColor);        }
      
      rect(this.xPos, this.yPos, blackKeyWidth, blackKeyHeight, keyCornerRadius);    
      
    }
    
  }
  
  // toggle key state
  public void updateState(boolean state) {
    this.pressed = state;   
  }
  
  
  public String getNoteName(boolean useFlats, boolean includeOctave) {
    
    String noteName;
    int noteOctave;
    int semitonesAboveC = this.MIDInumber % 12;
    
    // figure out note octave
    noteOctave = (this.MIDInumber / 12) - 1;
    
    // figure out note letter (eg. Ab, D, C#)
    if(useFlats) {
      noteName = noteNamesFlats[semitonesAboveC];
      if(includeOctave) {
        noteName += Integer.toString(noteOctave); 
      }
    }
    else {
      noteName = noteNamesSharps[semitonesAboveC];
      if(includeOctave) {
        noteName += Integer.toString(noteOctave); 
      }
    }
    
    return noteName;
    
  }
  
}
