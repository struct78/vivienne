class ColourTransition {
  color c1;
  color c2;
  int start;
  int duration;
  boolean started;

  ColourTransition(color c1, color c2) {
    this.c1 = c1;
    this.c2 = c2;
    this.started = false;
  }

  void start(int duration) {
    this.start = millis();
    this.duration = duration;
    this.started = true;
  }

  boolean isStarted() {
    return this.started;
  }

  color getColour() {
    // Restart
    if ((this.start + duration) <= millis()) {
      this.start = millis();

      color t1 = this.c1;
      color t2 = this.c2;
      this.c1 = t2;
      this.c2 = t1;
    }

    return lerpColor( this.c1, this.c2, map(millis(), this.start, this.start + this.duration, 0.0, 1.0 ) );
  }
}
