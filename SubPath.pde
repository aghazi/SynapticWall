class SubPath extends Path {
  SubPath(Path parent, int position) {
    fBeginPosition = position;
    fColor = parent.fColor;
    fEndPosition = 0;
  }
  
  void setEndPosition(int position) {
    fEndPosition = position;
  }
  
  void draw() {
    super.draw();
    drawJunction(this.getStartLoc());
    drawJunction(this.getEndLoc());
  }
}