class Background
{
  Level l;
  
  Background(Level level) 
  {
    this.l = level;
  }
  
  void drawSky(int i, float perspective)
  {
    for(int j = 0; j < width; j++)
    {
      int index = i * width + j;
      pixels[index] = lerpColor(skyBlues[0], skyBlues[1], perspective);
    }
  }
  
  void drawRoad(int i, float perspective)
  {
    float oscillateGrass = sin(0.6 * frequency * pow((1.2 - perspective), 3) + this.l.carDistance);
    float oscillateSidewalk = sin(3 * frequency * pow((1.2 - perspective), 3) + this.l.carDistance);
    float oscillateDottedLine= sin(0.4 * frequency * pow((1.2 - perspective), 3) + this.l.carDistance);
  
    float middle = 0.5 + cubic(perspective, this.l);
    float roadHalf = 0.05 + perspective * 0.35;
    float sidewalkLen = 0.3;
    float DottedLineLen = 0.1;
  
    int LeftSidewalk = (int)((middle - roadHalf - sidewalkLen * roadHalf) * width);
    int LeftRoad = (int)((middle - roadHalf) * width);
    int LeftDottedLine = (int)((middle - DottedLineLen * roadHalf) * width);
    int RoadMiddle = (int)(middle * width);
    int RightDottedLine = (int)((middle + DottedLineLen * roadHalf) * width);
    int RightRoad = (int)((middle + roadHalf) * width);
    int RightSidewalk = (int)((middle + roadHalf + sidewalkLen * roadHalf) * width);
    int vertialDistance = (int)(this.l.car.pos.y - (i + height / 2));
    for (int j = 0; j < width; j++)
    {
      int row = i + height / 2;
      int index = row * width + j;
      float startDistance = (this.l.carDistance + vertialDistance) % this.l.totalDist - (this.l.totalDist - this.l.route.get(this.l.route.size() - 1).dist);
      if (j < LeftSidewalk || j > RightSidewalk) // Grass
      {
        if (oscillateGrass > 0)
        {
          pixels[index] = lerpColor(lightGreens[0], lightGreens[1], perspective);
        } 
        else
        {
          pixels[index] = lerpColor(darkGreens[0], darkGreens[1], perspective);
        }
      } 
      else if ((j >=  LeftSidewalk && j < LeftRoad) ||
        (j <=  RightSidewalk && j > RightRoad)) //Red-White Sidewalks
      {
        if (oscillateSidewalk > 0)
        {
          pixels[index] = lerpColor(sidewalkReds[0], sidewalkReds[1], perspective);
        } 
        else
        {
          pixels[index] = lerpColor(sidewalkWhites[0], sidewalkWhites[1], perspective);
        }
      } 
      else if(startDistance >= 0 && startDistance <= this.l.route.get(this.l.route.size() - 1).dist)
      {
        float percentV = (this.l.route.get(this.l.route.size() - 1).dist - startDistance) / this.l.route.get(0).dist;
        float percentH = (float)(j - LeftRoad) / (RightRoad - LeftRoad);
        boolean b1 = percentV % finishLineVertical > finishLineVertical / 2;
        boolean b2 = percentH % finishLineHrizontal > finishLineHrizontal / 2;
        if((b1 || b2) && (!b1 || !b2))
        {
          if(j < RoadMiddle)
          {
            pixels[index] = lerpColor(finishLineWhites[0], finishLineWhites[1], 2 * percentH);
          }
          else
          {
            pixels[index] = lerpColor(finishLineWhites[0], finishLineWhites[1], 2 * (1 - percentH));
          }
        }
        else
        {
          if(j < RoadMiddle)
          {
            pixels[index] = lerpColor(finishLineBlacks[0], finishLineBlacks[1], percentH);
          }
          else
          {
            pixels[index] = lerpColor(finishLineBlacks[0], finishLineBlacks[1], 1 - percentH);
          }
        }
        
      }
      else if (j >= LeftDottedLine && j <= RightDottedLine) //White Dotted Line
      {
        if (oscillateDottedLine > 0)
        {
          pixels[index] = lerpColor(middleDottedLines[0], middleDottedLines[1], perspective);
        } 
        else if(j < RoadMiddle)
        {             
          pixels[index] = lerpColor(roadGrays[0], roadGrays[1], 
                        (float)(j - LeftRoad) / (RoadMiddle - LeftRoad));
        }
        else
        {
          pixels[index] = lerpColor(roadGrays[0], roadGrays[1], 
                        1 - (float)(j - RoadMiddle) / (RightRoad - RoadMiddle));
        }
      }
      else if(j < RoadMiddle) //Road Left
      {             
        pixels[index] = lerpColor(roadGrays[0], roadGrays[1], 
                        (float)(j - LeftRoad) / (RoadMiddle - LeftRoad));
      }
      else //Road Right
      {
        pixels[index] = lerpColor(roadGrays[0], roadGrays[1], 
                        1 - (float)(j - RoadMiddle) / (RightRoad - RoadMiddle));
      }
    }
  }
}
