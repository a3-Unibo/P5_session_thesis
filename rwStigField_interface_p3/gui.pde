// GUI stands for Graphic User Interface

void initGUI(ControlP5 c5) {

  c5.setColorBackground(color(0, 0))
    .setColorForeground(color(120))
      .setColorActive(color(250))
        .setColorCaptionLabel(color(0))
          .setColorValueLabel(color(0) );

  Group g1 = c5.addGroup("menu")
    .setPosition(10, 20)
      .setWidth(250)
        //.setBackgroundHeight(120)
        .setColorLabel(color(255))
          .setBackgroundColor(color(180, 80));


  c5.addSlider("sDec")
    .setRange(0.6, 1)
      .setDefaultValue(sDec)
        .setPosition(10, 10)
          .setSize(215, 10)
            .setGroup(g1);

  c5.addToggle("noiseUp")
    .setPosition(10, 30)
      .setSize(50, 10)
        .setGroup(g1);

  c5.addToggle("noiseDisp")
    .setPosition(65, 30)
      .setSize(50, 10)
        .setGroup(g1);

  c5.addToggle("stigDisp")
    .setPosition(120, 30)
      .setSize(50, 10)
        .setGroup(g1);

  c5.addToggle("agDisp")
    .setPosition(175, 30)
      .setSize(50, 10)
        .setGroup(g1);

  c5.addToggle("steer")
    .setPosition(10, 60)
      .setSize(50, 10)
        .setGroup(g1);

  c5.addButton("image")
    .setPosition(10, 90)
      .setSize(50, 20)
        . setColorCaptionLabel(color(255))
          .setGroup(g1);     

  c5.addButton("reset")
    .setPosition(70, 90)
      .setSize(50, 20)
        . setColorCaptionLabel(color(255))
          .setGroup(g1); 

  c5.addToggle("go")
    .setPosition(130, 90)
      .setSize(50, 20)
        . setColorCaptionLabel(color(0))
          .setGroup(g1);         

  c5.setAutoDraw(false); // lets me choose when drawing the interface
}

void image(int theValue) {
  saveImage();
  println("image saved from button", theValue);
}

void reset(int theValue) {
  reset();
}