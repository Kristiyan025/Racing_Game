class RouteSegment
{
    int dist;
    float curv;
    
    RouteSegment(int d, float c)
    {
        this.dist = d;
        this.curv = c;
    }
}

void populateRoute(ArrayList<RouteSegment> route, Level l)
{
  route.add(new RouteSegment(90, 0));
  route.add(new RouteSegment(90, 1));
  route.add(new RouteSegment(100, -1));
  route.add(new RouteSegment(100, 0));
  route.add(new RouteSegment(130, 1.5));
  route.add(new RouteSegment(150, 0));
  route.add(new RouteSegment(110, -1.6));
  route.add(new RouteSegment(190, 0));
  route.add(new RouteSegment(90, -1.5));
  route.add(new RouteSegment(110, 1.6));  
  route.add(new RouteSegment(70, 0));
  
  end(route, l); // Sums Total Distance
}

void end(ArrayList<RouteSegment> route, Level l)
{
  for(RouteSegment rs : route)
  {
    l.totalDist += rs.dist;
  }
}

void travel(float dist, Level l)
{
  l.carDistance += dist;
  float shiftDistance = horizontalShiftCoeffitient * l.car.vel.y * l.carCurvature * width;
  if (abs(shiftDistance) > shiftMax)
  {
    shiftDistance = (shiftDistance > 0 ? 1 : -1) * shiftMax;
  }
  l.car.pos.x -= shiftDistance;
  
  l.distanceInSegment += dist;
  if(l.distanceInSegment > l.route.get(l.currRouteSegment).dist)
  {
    l.distanceInSegment -= l.route.get(l.currRouteSegment).dist;
    l.currRouteSegment++;
    if(l.currRouteSegment == l.route.size())
    {
      l.currRouteSegment = 0;
      l.laps++;
      if(l.laps > l.maxLaps)
      {
        l.laps--;
        l.hasTheLevelFinished = true;
      }
    }
  }
}

float cubic(float num, Level l)
{
  return 0.5 * l.carCurvature * pow(1 - num, 3);
}

float derivatve(float num, Level l) // The Derivative of the cubic function above
{
  return -1.5 * l.carCurvature * pow(1 - num, 2);
}
