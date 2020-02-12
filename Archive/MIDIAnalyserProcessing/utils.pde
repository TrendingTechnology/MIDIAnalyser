/*
  Various functions
*/

// draw every piano key
void drawAllKeys() {
  
  for(int i = 0; i < nKeys; i++){
    if(keys[i].isWhiteKey){keys[i].drawKey();}
  }
  for(int i = 0; i < nKeys; i++) {
    if(!keys[i].isWhiteKey){keys[i].drawKey();}
  }
  
}


// check if mouse over circle
boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

// check if mouse over rectangle
boolean overRect(float x, float y, float width, float height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}


// remove repeated notes
static int removeDuplicates(int arr[], int n) { 
  
  if (n==0 || n==1) {
    return n; 
  }
   
  int[] temp = new int[n]; 
    
  // Start traversing elements 
  int j = 0; 
  
  for (int i = 0; i < n - 1; i++) { 
    // If current element is not equal to next element then store that current element 
    if (arr[i] != arr[i+1]) {
        temp[j++] = arr[i]; 
    }
  }
  
  // Store the last element as whether it is unique or repeated, it hasn't stored previously 
  temp[j++] = arr[n-1];    
    
  // Modify original array 
  for (int i=0; i<j; i++) {
    arr[i] = temp[i]; 
  }
  
  // return size of new array
  return j; 
} 