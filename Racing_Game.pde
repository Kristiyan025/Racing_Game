Level l1;
Level currL;
ArrayList<RouteSegment> r;
PFont f;

void setup()
{
  size(720, 480);
  l1 = new Level(6);
  currL = l1;
  f = createFont("Arial", 32, true);
}

void draw()
{
  background(30);
  
  currL.Play();

}
