class Level
{
  float carDistance = 0;
  float carCurvature = 0;
  int totalDist = 0;
  Car car;
  Background bg;
  ArrayList<RouteSegment> route;
  int currRouteSegment = 0;
  float distanceInSegment = 0;
  boolean[] keys = new boolean[3]; // LEFT, UP, RIGHT
  int neededTimeToStart;
  int laps = 0;
  int maxLaps = 6;
  boolean hasTheLevelBegun = false;
  boolean hasTheLevelFinished = false;
  
  Level(int _maxLaps)
  {
    this.maxLaps = _maxLaps;
    this.route = new ArrayList<RouteSegment>();
    populateRoute(this.route, this);
    this.car = new Car(width / 7, height * 0.17, this);
    this.car.pos = new PVector(width / 2, (int)(height * 0.70));
    this.car.vel = new PVector(0, 0);
    this.car.acc = new PVector(2, 0.05);
    this.car.maxSpeed = new PVector(7, 0.6);
    this.car.RoadFriction = new PVector(12, 0.7);
    this.car.GrassFriction = new PVector(car.RoadFriction. x * 2, car.RoadFriction.y * 2);
    this.car.friction = car.RoadFriction;
    this.bg = new Background(this);
  }
  
  void Play()
  {
    loadPixels();
    if(!hasTheLevelFinished)
    { 
      this.carCurvature += (this.route.get(this.currRouteSegment).curv - this.carCurvature) *
                    this.car.vel.y * curvSmoothnessCoeffitient;
    }
  
    for (int i = 0; i < height / 2; i++)
    {
      float perspective = (float)i / (height / 2);
      
      // Drawing The Sky
      this.bg.drawSky(i, perspective);
      
      // Drawing The Road
      this.bg.drawRoad(i, perspective);
    }
  
    // Drawing The Car
    boolean isOutSideTheRoad = this.car.drawIt();
    updatePixels();
    
    if(!hasTheLevelBegun)
    {
      fill(0, 0, 0, 150);
      rect(0, 0, width, height);
      float startLen = 0.5;
      float startmargin = (1 - startLen) / 2;
      textFont(f, startLen / 2.1 * width);
      fill(255);
      text("Start", startmargin * width, 0.47 * height);
      startLen = 0.6;
      startmargin = (1 - startLen) / 2 + 0.06;
      textFont(f, startLen / 18 * width);
      text("Click the left mouse button to start.", startmargin * width, 0.57 * height);
    }
    else if(hasTheLevelFinished)
    {
      // TO DO : Display Results;
    }
    else
    {
      this.car.friction = isOutSideTheRoad ? this.car.GrassFriction : this.car.RoadFriction;
      this.car.move();
      
      //Printing Data on The Screen
      fill(255);
      textFont(f, 18);
      int elapsedTime =  millis() - neededTimeToStart;
      int elapsedMilliseconds = elapsedTime % 1000;
      int elapsedSecconds = elapsedTime / 1000 % 60;
      int elapsedMinutes = elapsedTime / 1000 / 60;
      text("Elapsed Time: " + 
           nf(elapsedMinutes, 2) + ":" + 
           nf(elapsedSecconds, 2) + ":" + 
           elapsedMilliseconds / 10, 15, 30); 
      text("Traveled Distance: " + nf(this.carDistance, 5, 3), 15, 30 + textRowOffset); 
      text("Laps: " + this.laps + "/" + this.maxLaps, 15, 30 + 2 * textRowOffset);
    }
  }
}
