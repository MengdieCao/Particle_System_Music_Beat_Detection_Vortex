
class Particle {
  //location, velocity, previous velocity, lifespan
  PVector loc;
  PVector velocity;
  PVector prevVelocity;
  int lifeSpan=400;


  Particle(PVector location, PVector speed) {
    this.loc=new PVector(location.x, location.y, location.z);
    this.velocity=new PVector(speed.x, speed.y, speed.z);
  }

  void update() {
    lifeSpan--;
    //if there is change in velocity by other operation
    if (prevVelocity != null) {
      velocity = prevVelocity.copy();
    }
    velocity.add(gravity);
    velocity.add(vortex.centripetalForce(loc));
    loc.add(velocity);
    checkPlanes(planes);
  }

  void rewind() {
    lifeSpan--;
    //copy velocity
    prevVelocity = velocity.copy();
    velocity = new PVector(0, 0, 0);
    velocity.add(acceleration);
    loc.add(velocity);
    //checkPlanes(planes);
  }
  /*
  void vortex() {
   lifeSpan--;
   PVector xVI = xV.copy().sub(loc);
   float lI = vNorm.copy().dot(xVI);
   if (lI<=l && lI >= 0) {
   PVector rI = xVI.copy().sub(vNorm.copy().mult(lI));
   float rIMag = rI.mag();
   if (rIMag <= radius) {
   float fI = pow(radius/rIMag, 2)*2;
   float omega = 2*PI*fI;
   velocity.add(new PVector(omega*rIMag, gravity.y, gravity.z));
   //System.out.println(velocity);
   loc.add(velocity);
   }
   }
   }*/

  boolean isDead() {
    if (lifeSpan<0) {
      return true;
    }
    return false;
  }
  //check for each plane if the particle is colliding with or not,
  //if collision, then bounce off
  void checkPlanes(Plane[]planes) {
    for (int i=0; i<planes.length; i++) {
      if (detectCollision(planes[i])) {
        bounce(planes[i].normal);
      }
    }
  }

  //collision detection
  boolean detectCollision(Plane plane) {
    if (plane.hitPlane(this)) {
      //println(velocity);
      PVector hittingPoint=plane.hittingPoint(this);
      PVector projCoord=plane.getProjectionCoord(hittingPoint);
      if (plane.insidePolygon(projCoord)) {

        return true;
      }
    }
    return false;
  }

  //float distanceToPlane(Plane plane){
  //   PVector.sub(loc,plane.vertices[0]).dot(plane.normal);
  //}

  //bounce back
  void bounce(PVector normal) {
    loc.sub(velocity);
    PVector vn=PVector.mult(normal, velocity.dot(normal));
    PVector vt=PVector.sub(velocity, vn);

    vn.mult(-cr);
    vt.mult(1-cf);    
    velocity=PVector.add(vn, vt);   
    loc.add(velocity);
  }

  //display particle
  void display() {
    stroke(max(400-lifeSpan, 0), 90, 90);
    strokeWeight(3);
    point(loc.x, loc.y, loc.z);
  }

  //void display() {
  //  pushMatrix();
  //  translate(loc.x, loc.y, loc.z);
  //  image(sprite, 0, 0);
  //  popMatrix();
  //}
}