public abstract class Drawable extends Constants {
  protected color fColor;
  protected color fHighlightColor;
  protected PVector fLoc;
  protected boolean fVisible;
  protected boolean fMovable;
  protected int fBirthTime;

  public Drawable() {
    this(0, 0, color(255));
  }

  public Drawable(float x, float y) {
    this(x, y, color(255));
  }

  public Drawable(float x, float y, color cc) {
    fLoc = new PVector(x, y);
    fVisible = fMovable = true;
    fColor = cc;
    if (cc == EX_COLOR)
      fHighlightColor = EX_HIGHLIGHT_COLOR;
    else if (cc == IN_COLOR)
      fHighlightColor = IN_HIGHLIGHT_COLOR;
    else
      fHighlightColor = Util.highlight(fColor);
    fBirthTime = millis();
  }

  public void flipColor() {
    if (fColor == EX_COLOR) {
      fColor = IN_COLOR;
      fHighlightColor = IN_HIGHLIGHT_COLOR;
    }
    else if (fColor == IN_COLOR) {
      fColor = EX_COLOR;
      fHighlightColor = EX_HIGHLIGHT_COLOR;
    }
    else if (fColor == EX_HIGHLIGHT_COLOR) {
      fColor = IN_HIGHLIGHT_COLOR;
      fHighlightColor = Util.highlight(fColor);
    }
    else if (fColor == IN_HIGHLIGHT_COLOR) {
      fColor = EX_HIGHLIGHT_COLOR;
      fHighlightColor = Util.highlight(fColor);
    }
    else {
      println("unknow color");
    }
  }

  public abstract int getType();

  public PVector getLoc() {
    return fLoc;
  }

  public void translate(PVector change) {
    if (fMovable)
      fLoc.add(change);
  }

  public void setVisible(boolean visible) {
    fVisible = visible;
  }

  public void setMovable(boolean movable) {
    fMovable = movable;
  }

  public void drawBackground() {};
  public void drawForeground() {};

  public void draw() {
    if (fVisible) {
      drawBackground();
      drawForeground();
    }
  }

  public void update() {
    //Perform functions that produce animations or other forms of change over time
  };

  public void drawAndUpdate() {
    update();
    draw();
  }
}