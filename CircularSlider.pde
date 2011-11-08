class CircularSlider extends Control {
  float fSize, fMin, fMax;
  float fBegin, fEnd, fSlider;
  boolean fHover, fSelected;
  
  int fState;
  static final int SLIDER = 0;
  
  CircularSlider() {
    super(0,0);
  }
  
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
    fBegin = begin;
    fEnd = end;
    fState = SLIDER;
    fSlider = Constants.SLIDER_BAR_LENGTH + Constants.SLIDER_HANDLE_WIDTH;
  }
  CircularSlider(float x, float y, float size, float val, float min, float max) {
    this(x, y, size);
    fMin = min;
    fMax = max;
    fSlider = map(val, min, max, fBegin, fEnd);
  }
  
  CircularSlider(float x, float y, float size, float begin, float end, float val, float min, float max) {
    super(x, y);
    fSize = size;
    fState = SLIDER;
    fBegin = begin;
    fEnd = end;
    fMin = min;
    fMax = max;
    fSlider = constrain(map(val, min, max, fBegin, fEnd), 
              fBegin + Constants.SLIDER_HANDLE_WIDTH + Constants.SLIDER_BAR_LENGTH, 
              fEnd - Constants.SLIDER_HANDLE_WIDTH - Constants.SLIDER_BAR_LENGTH);
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
  }
  
  void draw() {
    if (!fVisible) return;
    float temp = fSize + Constants.SLIDER_BAR_WIDTH;
    
    fill(Constants.SLIDER_BG_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fEnd);
    
    if (fHover)
      fill(Constants.HIGHLIGHT_COLOR);
    else
      fill(Constants.SLIDER_BAR_COLOR);
      
    arc(fLoc.x, fLoc.y, temp, temp, 
        constrain(fSlider - Constants.SLIDER_BAR_LENGTH, fBegin, fEnd), 
        constrain(fSlider + Constants.SLIDER_BAR_LENGTH, fBegin, fEnd));
    fill(Constants.SLIDER_HANDLE_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fBegin + Constants.SLIDER_HANDLE_WIDTH);
    fill(Constants.SLIDER_HANDLE_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fEnd - Constants.SLIDER_HANDLE_WIDTH, fEnd);
    fill(Constants.BG_COLOR);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
  }
  
  boolean isInBounds(float x, float y) {
    boolean inBounds = false;
    float dist = PVector.dist(fLoc, new PVector(x, y));    
    float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
    if (angle < fEnd && angle > fBegin) {
      fState = SLIDER;
      inBounds = true;
    }
    return inBounds && dist >= fSize && dist <= fSize + Constants.SLIDER_BAR_WIDTH;
  }
  
  void updateSlider(float x, float y) {
    float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
    fSlider = constrain(angle, 
                      fBegin + Constants.SLIDER_HANDLE_WIDTH + Constants.SLIDER_BAR_LENGTH, 
                      fEnd - Constants.SLIDER_HANDLE_WIDTH - Constants.SLIDER_BAR_LENGTH);
  }
  boolean onMouseDown(float x, float y) {
    fSelected = isInBounds(x, y);
    if (fSelected)
      updateSlider(x, y);
    return fSelected;
  }
  
  boolean onMouseDragged(float x, float y) {
    if (fSelected)
      updateSlider(x, y);
    return fSelected;
  }
  
  boolean onMouseMoved(float x, float y) {
    return (fHover = isInBounds(x, y));
  }
  
  boolean onMouseUp(float x, float y) {
    return (fSelected = fHover = false);
  }
}