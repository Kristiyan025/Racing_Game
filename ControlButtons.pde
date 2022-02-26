void mousePressed() {
  if (mouseButton == LEFT) {
    currL.hasTheLevelBegun = true;
    currL.neededTimeToStart = millis();
  } 
}

void keyPressed() { 
  markPressed(keyCode, true);
  
}

void keyReleased() { 
  markPressed(keyCode, false);
}

void markPressed(int k, boolean pressed)
{
  if (k > 36 && k < 40)
  {
    currL.keys[k - 37] = pressed;
  }
}
