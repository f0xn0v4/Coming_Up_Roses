float a=0;
float a_inc;
float rotation=0;
PGraphics pg;
float init_x;
float init_y;
float init_z;
boolean working = true;

void setup(){
  size(600,600, P3D);
  background(0);
  pg = createGraphics(width,height,P3D);
}

void draw(){
  pg.beginDraw();
  if (a==0){
    init_x=(random(2*PI));
    init_y=(random(2*PI));
    init_z=(random(2*PI));
    a_inc=0.01*random(0.7,2);
    println(a_inc);
  }
  if (a<20 & working){
    pg.translate(300,300);
    pg.strokeWeight(3);
    pg.stroke(229,0,54,20);
    pg.rotateX(init_x);
    pg.rotateY(init_y);
    pg.rotateZ(init_z);
    pg.rotateY(cos(a)+0.2*noise(a));
    pg.rotateZ(sin(a)+0.2*noise(a));
    pg.fill(225,240,150,150);
    pg.box(200-a*10);
    pg.endDraw();
    image(pg, 0,0);
    a+=a_inc;
    //println(a);
  }
  else {
    if (working) {
      pg.save("rose_"+str(init_x)+str(init_y)+str(init_z)+".png");
      working = false;
      println("DONE");
      exit();
    }
  }
}
