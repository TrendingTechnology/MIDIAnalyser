/* 
 *  MIDI Input Handler
 */
 
 
//-------------------------------------------------------------------------------------------------------- Libraries
import themidibus.*;
import javax.sound.midi.MidiMessage; 

//-------------------------------------------------------------------------------------------------------- Globals
MidiBus myBus; 
int midiDevice = 0;
int nKeysPressed = 0;
int keyCount = 0;
 
 
//-------------------------------------------------------------------------------------------------------- Initialisation

void initMIDI() {
  
  myBus = new MidiBus(this, midiDevice, 1);   
  
}


 
//-------------------------------------------------------------------------------------------------------- MIDI Event Handlers

// note on and note off handlers
void noteOn(Note note) { 
  keyStates[note.pitch()] = true;
  keys[note.pitch()].updateState(true);
  keyCount += 1;
}

void noteOff(Note note) {
  keyStates[note.pitch()] = false;
  keys[note.pitch()].updateState(false);
  keyCount -= 1;
}
