/* 
 *  GUI Features
 */
 


//-------------------------------------------------------------------------------------------------------- Colours
 
// macOS system colours (normal, dark) 
// https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/color/
final color systemBlueColor   = color( 10, 132, 255);
final color systemBrownColor  = color(172, 142, 104);
final color systemGrayColor   = color(152, 152, 157);
final color systemGreenColor  = color( 50, 215,  75);
final color systemOrangeColor = color(255, 159,  10);
final color systemPinkColor   = color(255,  55,  95);
final color systemPurpleColor = color(191,  90, 242);
final color systemRedColor    = color(255,  69,  58);
final color systemYellowColor = color(255, 214,  10);

// colors
final color optionsBoxColor           = color(37, 41, 47);
final color toggleBoxColor            = color(28, 33, 35);
final color sideBarColor              = color(51, 55, 56);
final color headerColor               = color(37, 41, 47);
final color windowBackgroundColor     = color(28, 33, 35);
final color windowButtonColor         = color(100, 104, 107);
final color windowButtonIconColor     = color(245, 249, 251);
final color windowSelectedButtonColor = color(193, 198, 200);

//-------------------------------------------------------------------------------------------------------- Dimensions
final int headerHeight = 25;
final int sideBarWidth = 40;
final int boxSpacing = 10;

// chord analysis box
final float analyserBoxHeight = 50;
final float analyserBoxSpacing = 10;
final float analyserWidth = 500;//2 * width / 5 - boxSpacing * 2;
final float analyserHeight = 3 * analyserBoxHeight + 3 * analyserBoxSpacing;
final float analyserX = sideBarWidth + boxSpacing;
final float analyserY = headerHeight + boxSpacing;  

// chord box
final float chordBoxX = analyserX + analyserBoxSpacing;
final float chordBoxY = analyserY + analyserBoxSpacing;
final float chordBoxWidth = analyserWidth - 2 * analyserBoxSpacing;
final float chordBoxHeight = analyserBoxHeight * 2;
    
// options boxes
final float optionsBoxWidth = (analyserWidth - 3 * analyserBoxSpacing) / 2;
final float optionsBoxY = analyserY + 2 * analyserBoxSpacing + 2 * analyserBoxHeight;

//-------------------------------------------------------------------------------------------------------- Global Variables

// button states
boolean useIntervals = false;
boolean useFlats = false;

//-------------------------------------------------------------------------------------------------------- Instantiation

// app icon
PImage appIcon;

// fonts
PFont ultralightFont;
PFont lightFont;
PFont systemFont;
PFont musicalSymbols;
PFont arrowSymbol;

// objects 
ToggleBox notesIntervals;
ToggleBox sharpsFlats;


//-------------------------------------------------------------------------------------------------------- Initialisation

void initGUI() {
  
  // fonts
    ultralightFont = loadFont("Ultralight.vlw");
    lightFont = loadFont("Light.vlw");
    systemFont = createFont("SF-Pro-Display-Light.otf", 10);
    arrowSymbol = createFont("Lucida Sans Regular.ttf",10);
    musicalSymbols = createFont("MSGothic.ttf",10);
  
  // draw header
    drawHeader();
    drawWindowButtons(true);
  
  
  // draw analysis box
    fill(optionsBoxColor);
    rect(analyserX, analyserY, analyserWidth, analyserHeight);
    
    
    float optionsBoxX = analyserX + analyserBoxSpacing;
    sharpsFlats = new ToggleBox("\u266F", "\u266D", optionsBoxX, optionsBoxY, optionsBoxWidth, analyserBoxHeight, 0, 20);
    sharpsFlats.font = musicalSymbols;
    sharpsFlats.drawBox();
  
    optionsBoxX += optionsBoxWidth + analyserBoxSpacing;
    notesIntervals = new ToggleBox("Notes", "Intervals", optionsBoxX, optionsBoxY, optionsBoxWidth, analyserBoxHeight, -8, 10);
    notesIntervals.drawBox();
    
    drawOptions(true);
    drawChordBox("Initialising...");
  
}

//-------------------------------------------------------------------------------------------------------- Header

 
// draw header
void drawHeader() {
  
  // variables
  String headerText = "MIDI Keyboard Visualiser";
  int headerTextSize = 9;
  int headerTextColor = 200;
  
  // sidebar
  fill(sideBarColor);
  noStroke();
  rect(0, 0, sideBarWidth, height);
  
  // header
  fill(headerColor);
  noStroke();
  rect(sideBarWidth, 0, width, headerHeight); 
  
  // header text
  fill(headerTextColor);
  textFont(systemFont);
  textAlign(CENTER, CENTER);
  textSize(headerTextSize);
  text(headerText, (width + sideBarWidth) / 2, headerHeight / 2);
  
}


//-------------------------------------------------------------------------------------------------------- Window Buttons
void drawWindowButtons(boolean update) {
  
  // variables
  final int circleButtonSize = 11; 
  final int btnSpacing = 24;
  final int headerWidth = 40;           // must match headerHeight in drawHeader()
  final int btnX = headerWidth / 2;
  final int redY = headerWidth * 3 / 8;
  final int yelY = redY + btnSpacing;
  final int grnY = yelY + btnSpacing;
  
  // check for button press
  if(overCircle(btnX, redY, circleButtonSize)) {
    if(mousePressed){exit();}
  }
  
  // draw close button
  if(update) {
    
    noStroke();
    
    fill(systemRedColor);
    ellipse(btnX, redY, circleButtonSize, circleButtonSize);
    
    // draw empty middle button
    fill(systemGrayColor);
    ellipse(btnX, yelY, circleButtonSize, circleButtonSize);
    
    // draw toggle full screen button
    fill(systemGreenColor);
    ellipse(btnX, grnY, circleButtonSize, circleButtonSize);
  }
}



//-------------------------------------------------------------------------------------------------------- Options

void drawOptions(boolean update) {
  
  if(update) {
    notesIntervals.update(mouseClick, lastMouseClick);
    sharpsFlats.update(mouseClick, lastMouseClick);
  }
  
}

//-------------------------------------------------------------------------------------------------------- Chord Analyser

void drawChordBox(String chord) {
  
  
  int fontSize = 40;
  
  if(chord.length() > 0) {
    fontSize = 40 - chord.length(); 
  }
 
  
  
  fill(toggleBoxColor);
  noStroke();
  rect(chordBoxX, chordBoxY, chordBoxWidth, chordBoxHeight);
  textFont(systemFont);
  textAlign(CENTER, CENTER);
  textSize(fontSize);                        // probably need to vary this depending on chord name length
  fill(255);
  text(chord, chordBoxX + chordBoxWidth / 2, chordBoxY + chordBoxHeight / 2);
  
}







//--------------------------------------------------------------------------------------------------------- Toggleable box class for options

public class ToggleBox {
  
  // instance variables
  boolean state = false;
  boolean active = true;
  boolean clicked = false;
  boolean lastClicked = false;
  
  final int boxColor = color(28, 33, 35);
  final int textActiveColor = systemRedColor;
  final int textInactiveColor = 255;
  
  String textA = "";
  String textB = "";
  String spaces = "     ";
  PFont font = systemFont;
  float textOffset = 0;
  int textSize = 10;
  
  float posX;
  float posY;
  float boxHeight;
  float boxWidth;
  float boxRadius = 10;
  
  // constructor
  public ToggleBox(String textA, String textB, float posX, float posY, float boxWidth, float boxHeight, float textOffset, int textSize) {
    this.textA = textA;
    this.textB = textB;
    this.posX = posX;
    this.posY = posY;
    this.boxWidth = boxWidth;
    this.boxHeight = boxHeight;
    this.textOffset = textOffset;
    this.textSize = textSize;
  }
  
  // draw background
  public void drawBox() {
   
    fill(this.boxColor);
    noStroke();
    rect(this.posX, this.posY, this.boxWidth, this.boxHeight, this.boxRadius);   
    
  }
  
  
  // draw text
  public void drawText() {
      
    // arrow in centre
    fill(this.textInactiveColor);
    textFont(arrowSymbol);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("\u21C6", this.posX + this.boxWidth / 2 + this.textOffset, this.posY + this.boxHeight / 2);  
    
    // text color set depending on state
    int colorA = this.textInactiveColor;
    int colorB = this.textInactiveColor;
    
    if(!this.state) { 
      colorA = this.textActiveColor; 
    }
    else {
      colorB = this.textActiveColor;  
    }
    
    textFont(this.font);
    textSize(this.textSize);
    
    // text for option A
    fill(colorA);
    textAlign(RIGHT, CENTER);
    text(this.textA + this.spaces, this.posX + this.boxWidth / 2 + this.textOffset, this.posY + this.boxHeight / 2 - 1);   
    
    // text for option B
    fill(colorB);
    textAlign(LEFT, CENTER);
    text(this.spaces + this.textB, this.posX + this.boxWidth / 2 + this.textOffset, this.posY + this.boxHeight / 2 - 1);
    
  }
  
  
  // state
  public void update(boolean mouse, boolean lastMouse) { 
    
    if(overRect(this.posX, this.posY, this.boxWidth, this.boxHeight)) {
      
      this.active = true;
      
      if(mouse && !lastMouse) {
        this.state = !this.state;
      }
      
    }   
    else {
      this.active = false;
    }
   
    this.drawBox();
    this.drawText();
    
  }
  
}
