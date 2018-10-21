class BaseShape {
  float volume;
  WB_Render3D renderer;
  PApplet applet;

  BaseShape(PApplet applet) {
    this.applet = applet;
    this.renderer = new WB_Render3D( applet );
  }

  void lights() {

  }

  void setup() {
    colorMode(HSB, 360, 100, 100);
  }

  void draw() {

  }

  void keyPressed() {

  }

  void rotate() {
    delta += theta;
  }
}
