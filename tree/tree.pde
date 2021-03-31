PImage img;
ArrayList<Leaf> seeds;
ArrayList<PImage> flowers = new ArrayList<PImage>();
String[] filenames;
ArrayList<Branch> f_branches = new ArrayList<Branch>();


Tree T;
int max_dist = 20;
int min_dist = 12;
int global_len = 10;
float img_scale = 4.286;
int res = 1;
int flower_min = 120;
int flower_max = 400;
float f_y = 0.45;
float f_prob = 2.75;

String flower_prefix = "\\Users\\Shashwath\\Documents\\Processing\\my_sketches\\tree\\data\\rose_data";

void settings(){
  img = loadImage("img.jpg");
  img.resize(int(img.width*img_scale),int(img.height*img_scale));
  size(img.width, img.height);
  filenames = listFileNames(flower_prefix);
  for (String fn: filenames){
    PImage flower = loadImage(flower_prefix + "\\" + fn);
    int scale = int(random(flower_min, flower_max));
    flower.resize(scale, scale);
    flowers.add(flower);
  }
  seeds = gen_seed_img_neg(img, 150, res);
  T = new Tree(seeds, flowers, f_prob, f_y);
  smooth();
}

void draw(){
  background(0);
  T.show();
  T.grow();
  println(T.branches.size());
  saveFrame("frames/#########.png");
}

ArrayList<Leaf> gen_seed_img(PImage img, int thold, int res, int scale){
  ArrayList<Leaf> output = new ArrayList<Leaf>();
  for (int i = 0; i < img.width; i = i + res){
    for (int j = 0; j < img.height; j = j + res){
      color c = img.get(i,j);
      int r = c >> 16 & 0xFF;
      int g = c >> 8 & 0xFF;
      int b = c & 0xFF;
      float val = (r+g+b)/3;
      if (val >= thold){
        output.add(new Leaf(i*scale,j*scale));
      }
    }
  }
  return output;
}

ArrayList<Leaf> gen_seed_img_neg(PImage img, int thold, int res){
  ArrayList<Leaf> output = new ArrayList<Leaf>();
  for (int i = 0; i < img.width; i = i + res){
    for (int j = 0; j < img.height; j = j + res){
      color c = img.get(i,j);
      int r = c >> 16 & 0xFF;
      int g = c >> 8 & 0xFF;
      int b = c & 0xFF;
      float val = (r+g+b)/3;
      if (val <= thold){
        output.add(new Leaf(i,j));
      }
    }
  }
  return output;
}

String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

void flower(String[] img_list, float prob, int x, int y){
  float dice = random(0,1);
  if (dice <= prob){
    int idx = int(random(0,img_list.length-1));
    PImage flower = loadImage(img_list[idx]);
    image(flower, (flower.width/2)-x, (flower.height/2)-y); 
  }
}
