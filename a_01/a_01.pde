// new arrayList instance for particles
ArrayList<Particle> particles = new ArrayList<Particle>();

// system variable
PGraphics imageMask;
PImage original, endImage, pixelatedImage;
int state, prev, padding, buttonPos, selectedX, selectedY, target, clickCount, offset;
float alpha, blur;
boolean first, mouseInteract, clicked;

// adjustable variable
int particleSize, radius, breakTimes;

public void setup() {
  size(500, 500);

  // load PImage/ PGraphic
  original = loadImage("nah.png");
  endImage = loadImage("yay.png");
  original.resize(width, height);
  endImage.resize(width, height);
  imageMask = createGraphics(width, height);

  // system param initialize
  state = 1;
  prev = 0;
  padding = -60;
  alpha = 255;
  blur = 0;
  buttonPos = 278;
  mouseInteract = false;
  first = true;

  // particle param initialize
  particleSize = 4;
  radius = width/10;
  breakTimes = 5;
}

public void draw() {
  // main background
  image(endImage, 0, 0);
  fill(0, alpha);
  rect(0, 0, width, height);
  noFill();

  // load different animations by checking current state
  switch (state) {
    case 1:
      showUI();
      break;

    case 2:
      imageBreaking();
      break;

    case 3:
      pixelReform();
      break;

    case 4:
      toEndImage();
      break;
    }
}

// state: 1 - UI for adjusting params
private void showUI() {
  background(255);

  // title
  textAlign(CENTER);
  textSize(25);
  text("SM2715 Creative Coding", width/2, 230+padding);
  textSize(13.5f);
  text("Assignment 01 - Creative Image Transition", width/2, 255+padding);

  // content
  textSize(15f);
  if (mouseX>190 && mouseX<310 && mouseY>245 && mouseY<265) {
    fill(100, 100);
  }
  rect(width/2-77, 238, 150, 30);
  fill(30);
  text("Play Transition", width/2, 320+padding);

  fill(30);
  textSize(15);
  text("Particle Density", width/2-40, 370+padding);
  rect(278, 306, 70, 0.5f);
  if (mouseX>277 && mouseX<349 && mouseY>302 && mouseY<314 && state==1) {
    if (mousePressed) {
      buttonPos = mouseX;
      particleSize = (int) map(buttonPos, 277, 349, 3, 20);
    }
  }
  
  // update particles after particle size has changed
  particles.clear();
  loadParticles();
  rect(buttonPos, 301.5f, 5, 10);

  textSize(14);
  text("Enable Mouse Interaction   ", width/2-10, 420+padding);
  strokeWeight(1);
  if (mouseInteract) {
    fill(30);
  } else {
    noFill();
  }
  rect(345, 409+padding, 12, 12);

  // credit
  textSize(12f);
  text("created by Wong Kai Fung, 55718613", width/2, 470);
}

// state: 2 - image breaking
private void imageBreaking() {
  // state checking
  if (frameCount - prev > random(50, 100)) {
      // check if mouseInteract is selected
    if (!mouseInteract) {
      if (clickCount>1) {
        clicked = true;
      }

      selectedX = (int) random(0, width);
      selectedY = (int) random(0, height);
      target = (int) random(0, 10);
      clickCount++;
      radius = width/(int) random(4, 7);
      prev = frameCount;
    }
  }

  if (clickCount > 8) {
    for (int i=0; i<particles.size(); i++) {
      particles.get(i).setY((int)random(-400, -10));
    }

    state = 3;
  }

  // particle animation
  for (int i=0; i<particles.size(); i++) {
    Particle particle = particles.get(i);
    int x = particle.getX();
    int y = particle.getY();
    int rngNum = particle.getRng();
    float vx = particle.getVx();
    float vy = particle.getVy();
    float ax = particle.getAx();
    float ay = particle.getAy();
    float dist = dist(x, y, selectedX, selectedY);
    particle.px = particle.getX();
    particle.py = particle.getY();

    // trigger the explode animation
    if (clicked) {
      if (rngNum==target) {
        particle.select();
    }
    if (dist<radius) {
      particle.select();
    }
  }

    // if the canvas clicked more than 3 times
    if (clickCount > breakTimes) {
      particle.select();

      if (frameCount - prev > 200) {
        state = 3;
      }
    }

    // explode all particles
    if (particle.isSelected()) {
      // particle movement
      particle.setVx(vx += ax);
      particle.setVy(vy += ay);
      particle.setX(x + (int)vx);
      particle.setY(y + (int)vy);
    }

    // stop the movement of invisible particles
    if (x<0 || x>width || y<0 || y>height) {
      particle.deselect();
    }

    // set particles
      image(particle.getImage(), x, y);
  }
}

// state: 3 - use the particles to reform the image
private void pixelReform() {
  // state checking
  if (frameCount - prev > 50) {
    prev = frameCount;
    clickCount++;
  }

  for (int i=0; i<particles.size(); i++) {
    Particle particle = particles.get(i);

    renderEndColor(i);

    particle.px = lerp(particle.px, particle.getEndX(), 0.03f);
    particle.py = lerp(particle.py, particle.getEndY(), 0.03f);

    image(particle.getImage(), particle.px, particle.py);
  }

  // state checking
  if (clickCount > 9 && clickCount < 12) {
    alpha -= 2.5;
  } else if (clickCount > 12){
    pixelatedImage = get();
    state = 4;
  }
}

// state: 4 - transition animation to high res end image
private void toEndImage() {
  // controls the params for animation
  if (offset<width*4) {
    int o=20;
    offset += 2+o;
    blur += 0.1;
  }

  // high res background
  image(endImage, 0, 0);

  // PGraphic animated mask
  imageMask.beginDraw();
  imageMask.background(0);
  imageMask.noFill();
  imageMask.strokeWeight(random(2, 20));
  
  for (int i=0; i<20; i++) {
    int size = (int) random(0, dist(0, 0, width, height));
    alpha = (int) random(0, 255);

    imageMask.stroke(alpha);
    imageMask.ellipse(width/2, height/2, size+offset, size+offset);
  }
  
  stroke(255);
  imageMask.strokeWeight(width);
  imageMask.ellipse(width/2f, height/2f, offset, offset);
  imageMask.endDraw();

  // set PGraphic animation as mask to end image
  pixelatedImage.mask(imageMask);
  pixelatedImage.filter(BLUR, random(1, 4));
  image(pixelatedImage, 0, 0);
  PImage p = get();
  p.filter(BLUR);
  p.mask(imageMask);
}

// shuffle array with random function
private ArrayList<Particle> shuffleArrayList(ArrayList arrayList) {
  ArrayList<Particle> tempArrayList = (ArrayList<Particle>) arrayList.clone();
  ArrayList<Particle> returnArrayList = new ArrayList<Particle>();

  for (int i=0; i<arrayList.size(); i++) {
    int choice = (int) random(0, tempArrayList.size());
    returnArrayList.add(tempArrayList.get(choice));
    
    // prevent out of bounce
    if (!tempArrayList.isEmpty()) {
      tempArrayList.remove(tempArrayList.size()-1);
    }
  }
  return returnArrayList;
}

// initialize content of particles
private void loadParticles() {
  // get param from images and load into particles
  for (int y=0; y<original.height; y+=particleSize) {
    for (int x=0; x<original.width; x+=particleSize) {
      particles.add(new Particle(x, y, original.get(x, y), random(-3, 3), random(-10, 11)));
    }
  }

  // create an arraylist to save the end point of particles
  ArrayList<Particle> endParticles = shuffleArrayList(particles);

  // load end pixel to particles
  for (int i=0; i<endParticles.size(); i++) {
    Particle particle = particles.get(i);
    particle.setEndX(endParticles.get(i).getX());
    particle.setEndY(endParticles.get(i).getY());
    particle.setEndColor(endImage.get(particle.getEndX(), particle.getEndY()));
    particle.setImage(createImage(particleSize, particleSize, 0));
    particle.setRng((int) random(-10, 10));
    renderColor(i);
  }
}

// fill particle original/ end image color
private void renderColor(int i) {
  for (int y=0; y<particles.get(i).getImage().height; y++) {
    for (int x=0; x<particles.get(i).getImage().width; x++) {
      particles.get(i).getImage().set(x, y, particles.get(i).getC());
    }
  }
}

private void renderEndColor(int i) {
  for (int y=0; y<particles.get(i).getImage().height; y++) {
    for (int x=0; x<particles.get(i).getImage().width; x++) {
      particles.get(i).getImage().set(x, y, particles.get(i).getEndColor());
    }
  }
}

@Override
public void mouseReleased() {
  if (mouseX>190 && mouseX<310 && mouseY>245 && mouseY<265 && state==1) {
    state = 2;
  } else if (mouseX>345 && mouseX<357 && mouseY>350 && mouseY<363) {
    if (mouseInteract) {
      mouseInteract = false;
    } else {
      mouseInteract = true;
    }
  }

  if (mouseInteract && state>1) {
    clicked = true;
    selectedX = mouseX;
    selectedY = mouseY;
    target = (int) random(0, 10);
    radius = width/(int) random(4, 7);
    clickCount++;
  }
}
