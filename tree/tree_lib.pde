class Leaf {
  PVector pos;
  boolean reached = false;
  
  Leaf(){
    this.pos = new PVector(random(width), random(height - 50));
  }
  
  Leaf(int x, int y){
    this.pos = new PVector(x, y);
  }
  
  void show(){
    if (!this.reached){
      strokeWeight(1);
      stroke(255);
      point(this.pos.x, this.pos.y);
    }
  }
}

class Branch{
  Branch parent;
  PVector pos;
  PVector dir;
  PVector o_dir;
  float count = 0;
  float len = global_len;
  float flower_prob = randomGaussian();
  
  Branch(Branch parent, PVector pos, PVector dir){
    this.pos = pos;
    this.parent = parent;
    this.dir = dir;
    this.o_dir = dir;
  }
  
  Branch next(){
    this.dir.normalize();
    this.dir.mult(this.len);
    Branch branch = new Branch(this, PVector.add(this.pos, this.dir), this.dir);
    return branch;
  }
  
  void show(){
    if (this.parent != null){
      //strokeWeight(1);
      stroke(255);
      line(this.parent.pos.x,this.parent.pos.y, this.pos.x, this.pos.y);
    }
  }
  
  void reset(){
    this.dir = this.o_dir.copy();
    this.count = 0;
  }
}

class Tree {
  ArrayList<Leaf> leaves = new ArrayList<Leaf>();
  ArrayList<Branch> branches = new ArrayList<Branch>();
  ArrayList<PImage> flowers;
  float flower_prob;
  float f_y;
  
  Tree(int n){
    
    for (int x = 0; x < n; x++){
      Leaf y = new Leaf();
      this.leaves.add(y);
    }
    
    PVector pos = new PVector(width/2, height);
    PVector dir = new PVector(0, -1);
    Branch root = new Branch(null, pos, dir);
    this.branches.add(root);
    Branch current = root;
    
    boolean found = false;
    while (!found){
      
      for (Leaf l: this.leaves){
        float d = PVector.dist(current.pos, l.pos);
        if (d < max_dist){
          found = true;
        }
      }
  
      if (!found){
        Branch branch = current.next();
        this.branches.add(branch);
        current = branch;
      }
    }
  }
  
  Tree(ArrayList<Leaf> leaves, ArrayList<PImage> flowers, float flower_prob, float f_y){
    
    this.leaves = leaves;
    this.flowers = flowers;
    this.flower_prob = flower_prob;
    this.f_y = f_y;
    
    PVector pos = new PVector(width/2, height);
    PVector dir = new PVector(0, -1);
    Branch root = new Branch(null, pos, dir);
    this.branches.add(root);
    
    Branch current = root;
    
    boolean found = false;
    while (!found){
      
      for (Leaf l: this.leaves){
        float d = PVector.dist(current.pos, l.pos);
        if (d < max_dist){
          found = true;
        }
      }
  
      if (!found){
        Branch branch = current.next();
        this.branches.add(branch);
        current = branch;
      }
    }
  }
  
  void grow(){
    for (Leaf l : this.leaves){
      Branch closest_branch = null;
      float record = sqrt((pow(width,2))+(pow(height,2))) + 1;
      
      for (Branch b : this.branches){
        float d = PVector.dist(l.pos, b.pos);
        if (d < min_dist) {
          l.reached = true;
          break;
        } else if (d > max_dist){
          
        } else if (closest_branch == null | d < record){
          closest_branch = b;
          record = d;
        }
      }
      if (closest_branch != null){
        PVector newDir = PVector.sub(l.pos, closest_branch.pos);
        newDir.normalize();
        closest_branch.dir.add(newDir);
        closest_branch.count++;
      }
    }
    
    for (int idx = this.leaves.size()-1; idx >=0; idx--){
      if (this.leaves.get(idx).reached){
        this.leaves.remove(idx);
      }
    }
    
    for (int idx = this.branches.size()-1; idx >=0; idx--){
      Branch branch = this.branches.get(idx);
      if (branch.count > 0){
        branch.dir.div(branch.count + 1);
        this.branches.add(branch.next());
      }
      branch.reset();
    }
  }

  void show(){
    //for (Leaf l: this.leaves){
    //  l.show();
    //}
    
    for (int idx = 0 ; idx < this.branches.size(); idx ++){
      Branch b = this.branches.get(idx);
      strokeWeight(4*noise(idx*0.03));
      b.show();
    }
    
    //for (int idx = 0 ; idx < this.branches.size(); idx ++){
    //  Branch b = this.branches.get(idx);
    //  if (b.flower_prob >= this.flower_prob & b.pos.y <= height*f_y){
    //    PImage flower = this.flowers.get(int(random(this.flowers.size()-1)));
    //    int x = int(b.pos.x - 0.5*flower.width);
    //    int y = int(b.pos.y - 0.5*flower.height);
    //    image(flower, x, y);
    //  }
    //}
  }
}
