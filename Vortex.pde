//controlled by signal from minim (tau in the textbook)
float tightness=2;

//I tried to do it inside particle class,
//and I don't know why I am getting bugs,
//so I just created a new class for vortex
//to do all the calculation, and add force
//to particle.
class Vortex {

  PVector bottomCenter; 
  PVector topCenter;
  float radius;
  float axisLength;
  PVector axis;
  float freqR=0.1f;
  float freqMax=0.5;

  PVector center;

  Vortex(PVector bc, PVector tc, float r) {
    this.bottomCenter=bc.copy();
    this.topCenter=tc.copy();
    this.radius=r;

    this.axis=PVector.sub(topCenter, bottomCenter);
    axisLength=axis.mag();
    axis.normalize();

    center=PVector.add(bottomCenter, topCenter).div(2);
  }

  //calculate particle's distance to the axis of vortex
  PVector distanceToAxis(PVector p) {
    PVector Xvi=PVector.sub(p, bottomCenter);    
    float li=Xvi.dot(axis);
    PVector ri=PVector.sub(Xvi, PVector.mult(axis, li));
    if (li>axisLength || li<0 || ri.mag()>radius) {
      return new PVector(-1000000, 0);
    } else {
      return ri;
    }
  }

  //calculate angular velocity of the particle
  float angularVelocityAtDistance(float ri) {
    float freqRi=pow(radius/ri, tightness)*freqR;
    freqRi=min(freqMax, freqRi);
    return TWO_PI*freqRi;
  }

  //apply force 
  PVector centripetalForce(PVector particleLoc) {
    // F=m*r*sq(w), formula for centripetal force,where m is mass, w is angular velocity
    PVector ri=distanceToAxis(particleLoc);
    if (ri.x==-1000000) {        //out of the cylinder
      return new PVector(0, 0, 0);
    } else {
      float angularVel=angularVelocityAtDistance(ri.mag());
      //PVector force=axis.cross(ri).normalize().mult(ri.mag()*sq(angularVel)).mult(1);
      PVector force=ri.mult(-ri.mag()*sq(angularVel));
      force.mult(0.001); //return acceleration
      //println(force.mag());
      return force;
    }
  }

  //display the vortex (axis of vortex)
  void display() {
    pushStyle();
    stroke(255);
    strokeWeight(3);
    line(bottomCenter.x, bottomCenter.y, bottomCenter.z, 
      topCenter.x, topCenter.y, topCenter.z);
    //noStroke();
    //fill(#8EC9F7,50);
    //pushMatrix();
    //translate(center.x,center.y,center.z);
    //sphere(radius);
    //popMatrix();
    popStyle();
  }
}