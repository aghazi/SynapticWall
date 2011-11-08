class CircularSlider extends Control {
  float fSize, fMin, fMax;
  float fBegin, fEnd, fSlider;
  boolean fHover, fSelected;
  
  int fState;
  static final int SLIDER = 0;
  static final int BEGIN = 1;
  static final int END = 2;
  
  CircularSlider(float x, float y, float size) {
    super(x,y);
    fSize = size;
    fBegin = fMin = 0;
    fSlider = PI;
    fEnd = fMax = TWO_PI;
    fState = SLIDER;
  }
  CircularSlider(float x, float y, float size, float begin, float end) {
    super(x, y);
    fSize = size;
    fSlider = fBegin = begin;
    fEnd = end;
    fState = SLIDER;
  }
  CircularSlider(float x, float y, float size, float val, float min, float max) {
    this(x, y, size);
    fMin = min;
    fMax = max;
    fSlider = map(val, min, max, fBegin, fEnd);
  }
  
  CircularSlider(float x, float y, float size, float begin, float end,
                 float val, float min, float max) {
    super(x, y);
    fSize = size;
    fState = SLIDER;
    fBegin = begin;
    fEnd = end;
    fMin = min;
    fMax = max;
    fSlider = map(val, min, max, fBegin, fEnd);
  }
  
  float getValue() {
    return map(fSlider, fBegin, fEnd, fMin, fMax);
  }
  
  void setSliderBounds(float begin, float end) {
    fBegin = begin;
    fEnd = end;
    fSlider = constrain(fSlider, 
              fBegin + Constants.SLIDER_HANDLE_WIDTH + Constants.SLIDER_BAR_LENGTH, 
              fEnd - Constants.SLIDER_HANDLE_WIDTH - Constants.SLIDER_BAR_LENGTH);
  }
  void setValueRange(float min, float max) {
    fMin = min;
    fMax = max;
    fSlider = constrain(fSlider, 
              fBegin + Constants.SLIDER_HANDLE_WIDTH + Constants.SLIDER_BAR_LENGTH, 
              fEnd - Constants.SLIDER_HANDLE_WIDTH - Constants.SLIDER_BAR_LENGTH);
  }
  
  void draw() {
    if (!fVisible) return;
    float temp = fSize + Constants.SLIDER_BAR_WIDTH;
    
    fill(Constants.SLIDER_BG_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fEnd);
    fill(Constants.SLIDER_BAR_COLOR);
    
    arc(fLoc.x, fLoc.y, temp, temp, 
        constrain(fSlider - Constants.SLIDER_BAR_LENGTH, fBegin, fEnd), 
        constrain(fSlider + Constants.SLIDER_BAR_LENGTH, fBegin, fEnd));
    fill(Constants.EX_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fBegin + Constants.SLIDER_HANDLE_WIDTH);
    fill(Constants.IN_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fEnd - Constants.SLIDER_HANDLE_WIDTH, fEnd);
    fill(Constants.BG_COLOR);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
  }
  
  boolean isInBounds(float x, float y) {
    boolean inBounds = true;
    float dist = PVector.dist(fLoc, new PVector(x, y));    
    float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
    if (angle >= fEnd - Constants.SLIDER_HANDLE_WIDTH && angle <= fEnd)
      fState = END;
    else if (angle >= fBegin && angle <= fBegin + Constants.SLIDER_HANDLE_WIDTH)
      fState = BEGIN;
    else if (angle < fEnd && angle > fBegin)
      fState = SLIDER;
    else
      inBounds = false;
    return inBounds && dist >= fSize && dist <= fSize + Constants.SLIDER_BAR_WIDTH;
  }
  
  boolean onMouseDown(float x, float y) {
    return fSelected = isInBounds(x, y);
  }
  
  boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
      switch (fState) {
        case SLIDER:
          fSlider = angle;
          break;
        case BEGIN:
          fBegin = Utilities.constrain2(angle, 0.0, PI-Constants.SLIDER_HANDLE_WIDTH);
          break;
        case END:
          fEnd = Utilities.constrain3(angle, PI+Constants.SLIDER_HANDLE_WIDTH, TWO_PI);
          break;
      }
      fSlider = constrain(fSlider, 
                        fBegin + Constants.SLIDER_HANDLE_WIDTH + Constants.SLIDER_BAR_LENGTH, 
                        fEnd - Constants.SLIDER_HANDLE_WIDTH - Constants.SLIDER_BAR_LENGTH);
    }
    return fSelected;
  }
  
  boolean onMouseMoved(float x, float y) {
    return (fHover = isInBounds(x, y));
  }
  
  boolean onMouseUp(float x, float y) {
    return (fSelected = fHover = false);
  }
}