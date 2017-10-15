//minim library, I watched the tutorial for
//using minim in processing in youtube 
Minim minim;
AudioPlayer player;
float sig=0;

//elasticity, fritction, and gravity
float cr=1;
float cf=0.3;
PVector gravity;

//array of particles (I know I was not suppose to 
//do this.) However, it does not affect the performance
//that much. And I kept getting weird bugs if I allocate
//memory first, and add to fixed size array.
ArrayList<Particle>particles;
//The array for the polygons
Plane[]planes;
//where particles come out
PVector nozzle;
//acceleration other than gravity
PVector acceleration;


float radius = 80;
float l = 200;
PVector xV ;
PVector vNorm = new PVector(0, -1, 0);
//vortex
Vortex vortex;

void setup() {
  size(1280, 720, P3D);
  //use colorMode to generate different colors
  colorMode(HSB, 360, 100, 100);


  gravity=new PVector(0, 0.01, 0);
  nozzle=new PVector(120, 60, 0);


  particles=new ArrayList<Particle>();

  planes=new Plane[2];

  //planes[0]=new Plane(500, -100, 0, 6, 80, PI/2);
  //planes[1]=new Plane(200, 300, 0, 3, 80, PI/9);  
  planes[0]=new Plane(550, 195, 0, 6, 150, PI/4); //hexagon
  planes[1]=new Plane(705, 640, 0, 3, 150, PI/6); //triangle 

  //Plane(float centerX,float centerY,float centerZ, int qty,float radius,float rotz)

  //vortex with radius 120
  vortex=new Vortex(new PVector(670, 550, 20), new PVector(670, 420, 0), 200);

  //vortex=new Vortex(new PVector(850,160,-30),new PVector(850,160,30),50)
  //nozzle=new PVector(560, 340, 0);
  //vortex=new Vortex(new PVector(width/2, height/2, -30), new PVector(width/2, height/2, 30), 50);

  //initiate minim
  minim=new Minim(this); 
  //and select a song from data folder
  player = minim.loadFile("Adele - I Miss You.mp3", 1024);
  //play on loop
  player.loop();
}



void draw() {


  for (int i=0; i<1024; i+=64) { 
    float proxy; 
    //get the ith sample in the buffer
    //left.get()return value between -1 and 1
    //take absolute value and scale it
    //so we can use this value to configure the
    //vortex effect
    //detect beats
    proxy=abs(player.left.get(i))*35; 
    if (sig<proxy) { 
      sig=proxy;
    } else {
      sig-=sig*sig/5000;
    }

    stroke(255); 
    proxy=sig;
  } 

  //elasticity according to signal
  //cr=map(sig, 8, 35, 0.2, 2);
  //this refers to tightness of vortex
  tightness=map(sig, 0, 35, 4, 0.1);


  background(0);
  text(particles.size(), 20, 20);
  //translate(width/2, height/2);
  //rotateY(map(mouseX, 0, width, 0, TWO_PI));
  //rotate to view from all sides
  rotateY(map(mouseX, 0, width, -HALF_PI, HALF_PI));


  for (Particle one : particles) {
    //if space key is pressed, do rewind
    if (keyPressed && key == 32) {
      one.rewind();
      one.display();
    }/*else if (mousePressed){
     xV = new PVector(mouseX,mouseY,0);
     //one.update();
     one.vortex();
     one.display();
     }*/
    else {
      one.update();    
      one.display();
    }
  }

  for (int i=particles.size()-1; i>=0; i--) {
    if (particles.get(i).isDead()) {
      particles.remove(i);
    }
  }

  for (int i=0; i<15; i++) {
    particles.add(new Particle(nozzle, new PVector(random(2, 3), randomGaussian()*0.1, randomGaussian()*0.1)));
  }
  for (int i=0; i<planes.length; i++) {
    planes[i].display();
  }

  vortex.display();
}

void keyPressed() {
  if (key==32) {
    //System.out.println("space");
    //if space key is pressed, then add negative acceleration
    acceleration = new PVector(0, -0.02, 0);
  }

  if (key=='a') {
    //add new particle
    particles.add(new Particle(nozzle, new PVector(random(2, 3), randomGaussian()*0.1, randomGaussian()*0.1)));
  }
}