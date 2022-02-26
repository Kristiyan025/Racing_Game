class Car
{
  PVector pos;
  PVector vel;
  PVector acc;
  PVector maxSpeed;
  PVector friction;
  PVector RoadFriction, GrassFriction;
  PVector size;
  IntList body, tires;
  Level l;

  Car(float sizeX, float sizeY, Level level)
  {
    this.body = new IntList();
    this.tires = new IntList();
    this.size = new PVector(sizeX, sizeY);
    this.initializePic();
    this.l = level;
  }

  void initializePic()
  {
    for (int i = 0; i < this.size.y; i++)
    {
      float percent = (float)i / this.size.y;
      if (percent >= 1.5 / 8 && percent <= 3.0 / 8)
      {
        this.tires.append((int)((percent + 0.5) * 7.0 / 16 * this.size.x));
      }
      else if (percent >= 5.0 / 8 && percent <= 7.5 / 8)
      {
        this.tires.append((int)((0.8 + 0.05 * (1 - (percent - 5.0 / 8)) / (2.5 / 8)) * 0.5 * this.size.x));
      } 
      else
      {
        this.tires.append(0);
      }

      percent = 1 - percent;
      this.body.append((int)((1.5 / 16 + 4.5 / 16 * (1 - sq(percent))) * this.size.x));
    }
  }

  boolean drawIt()
  {
    boolean isOutSideTheRoad = false;
    float verticalMiddlePosition = (this.pos.y  + this.size.y / 2 - height / 2) / (height / 2);
    float roadTangentSlope = derivatve(verticalMiddlePosition, l) * width;
    
    for (int i = 0; i < this.size.y; i++)
    {
      float percent = (this.pos.y  + i - height / 2) / (height / 2);
      int roadMiddle = width / 2 + (int)(cubic(percent, l) * width);
      int shift = (int)(roadTangentSlope * (percent - verticalMiddlePosition) + this.pos.x - width / 2);
      int carMiddle = (int)(this.pos.x + /*roadMiddle - width / 2*/  + ((float)i / this.size.y) *
        (abs(this.pos.x - roadMiddle) / (width / 2 * 0.35)) * shiftCoeffitient * shift);
        
      // Car's Tires
      for (int j = -this.tires.get(i); j < this.tires.get(i); j++)
      {
        int row = (int)(i + this.pos.y);
        int col = j + carMiddle;
        int index = row * width + col;
        if (red(pixels[index]) < 100 && 
            green(pixels[index]) > 90 && 
            blue(pixels[index]) < 100)
        {
          isOutSideTheRoad = true;
        }
        pixels[index] = carTiresBlack;
      }

      // Car's Body
      for (int j = -this.body.get(i); j < this.body.get(i); j++)
      {
        int row = (int)(i + this.pos.y);
        int col = j + carMiddle;
        int index = row * width + col;
        float verticalPercent = (float)i / this.size.y;
        float horizontalPercent = (j + this.body.get(i)) / (2.0 * this.body.get(i));
        pixels[index] = lerpColor(carColors[1], 
          lerpColor(carColors[0], carColors[1], verticalPercent), 
          horizontalPercent <= 0.5 ? 
          horizontalPercent * 2 : 2 * (1 - horizontalPercent));
      }

      // Car's Decoration Lines
      final int lineBegin = 2;
      final int lineEnd = 6;
      for (int j = -lineEnd - 1; j <= lineEnd; j++)
      {
        if (j < -lineBegin || j >= lineBegin)
        {
          int row = (int)(i + this.pos.y);
          int col = j + carMiddle;
          int index = row * width + col;
          pixels[index] = carTiresBlack;
        }
      }
    }

    return isOutSideTheRoad;
  }

  void CheckForGoingOutOfScreen()
  {
    final float shift = 1.8 * 25;
    if (this.pos.x < this.size.x / 2 +  shift)
    {
      this.pos.x = this.size.x / 2 +  shift + 3;
    }
    if (this.pos.x > width - this.size.x / 2 -  shift)
    {
      this.pos.x = width - this.size.x / 2 - shift - 3;
    }
  }

  void move()
  {
    if (l.keys[1]) // UP Clicked
    {
      this.vel.y += this.acc.y;
      if (this.vel.y > this.maxSpeed.y)
      {
        this.vel.y = this.maxSpeed.y;
      }
      travel(this.vel.y, l);
    }
    if (l.keys[0]) // LEFT Clicked
    {
      this.vel.x -= this.acc.x;
      if (-this.vel.x > this.maxSpeed.x)
      {
        this.vel.x = -this.maxSpeed.x;
      }

      this.pos.x += (this.vel.y > 0 ? 1 : 0.5) * this.vel.x;
      CheckForGoingOutOfScreen();
    }
    if (l.keys[2]) // RIGHT Clicked
    {
      this.vel.x += this.acc.x;
      if (this.vel.x > this.maxSpeed.x)
      {
        this.vel.x = this.maxSpeed.x;
      }

      this.pos.x += (this.vel.y > 0 ? 1 : 0.5) * this.vel.x;
      CheckForGoingOutOfScreen();
    }
    
    // Friction Deceleration
    this.applyFriction();
  }

  void applyFriction()
  {
    this.vel.y -= this.friction.y * this.acc.y;
    int  dir = this.vel.x > 0 ? 1 : -1;
    this.vel.x -= dir * this.friction.x * this.acc.y;
    if (this.vel.y < 0)
    {
      this.vel.y = 0;
    }
    if (this.vel.x * dir < 0) //ifit wasn't the same as before
    {
      this.vel.x = 0;
    }

    travel(this.vel.y, currL);
    this.pos.x += this.vel.x;
    CheckForGoingOutOfScreen();
  }
}
