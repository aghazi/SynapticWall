public class ObjectCollection {
  private Interactive fSelected;
  private ArrayList<Interactive> fObjs;
  private ArrayList<Interactive> fSelectedObjs;
  private ArrayList<Path> fPaths;
  private int fInitiatorIndex, fSomaIndex, fAxonIndex, fSynapseIndex, fDendriteIndex;

  private PVector fSelectStart, fSelectEnd;

  public ObjectCollection() {
    fSelected = null;
    fObjs = new ArrayList<Interactive>();
    fSelectedObjs = new ArrayList<Interactive>();
    fPaths = new ArrayList<Path>();
    fInitiatorIndex = 0;
    fSomaIndex = 0;
    fAxonIndex = 0;
    fSynapseIndex = 0;
    fDendriteIndex = 0;

    fSelectStart = fSelectEnd = null;
  }

  private void drawSelection() {
    if (fSelectStart != null && fSelectEnd != null) {
      pushStyle();
      stroke(Constants.SELECTION_BORDER_COLOR);
      strokeWeight(Constants.SELECTION_BORDER_WIDTH);
      fill(Constants.SELECTION_COLOR);
      PVector size = PVector.sub(fSelectEnd, fSelectStart);
      rect(fSelectStart.x, fSelectStart.y, size.x, size.y);
      popStyle();
    }
  }

  public void draw() {
    // for (int i = 0; i < fInitiatorIndex; i++)
    //   fObjs.get(i).draw();
    for (Interactive s : fObjs)
      s.draw();
    if (fSelectStart != null && fSelectEnd != null) {
      drawSelection();
    }
  }
  public void drawAndUpdate() {
    for (Interactive s : fObjs)
      s.update();
    draw();
  }

  public boolean select(float x, float y) {
    deselectAll();
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive s = fObjs.get(i);
      if (s.select(x, y)) {
        fSelected = s;
        return true;
      }
    }
    return false;
  }

  public void showControls() {
    for (Interactive s : fSelectedObjs) {
      if (s.getType() == Constants.INITIATOR ||
          s.getType() == Constants.SOMA)
          ((Controllable)s).showControls();
    }
  }

  public void hideControls() {
    for (Interactive s : fSelectedObjs) {
      if (s.getType() == Constants.INITIATOR ||
          s.getType() == Constants.SOMA)
          ((Controllable)s).hideControls();
    }
  }

  public void deselectAll() {
    fSelected = null;
    for (Interactive s : fObjs)
      s.deselect();
  }

  public Interactive getSelected() {
    return fSelected;
  }

  public void add(Interactive s) {
    if (s != null) {
      int index = -1;
      switch(s.getType()) {
        case Constants.DENDRITE:
          index = (index == -1) ? fDendriteIndex : index;
          fDendriteIndex++;
        case Constants.AXON:
          index = (index == -1) ? fAxonIndex : index;
          fAxonIndex++;
        case Constants.SYNAPSE:
          index = (index == -1) ? fSynapseIndex : index;
          fSynapseIndex++;
        case Constants.SOMA:
          index = (index == -1) ? fSomaIndex : index;
          fSomaIndex++;
        case Constants.INITIATOR:
          index = (index == -1) ? fInitiatorIndex : index;
          fInitiatorIndex++;
      }
      fObjs.add(index, s);
      if (s.getType() == Constants.AXON || s.getType() == Constants.DENDRITE)
        fPaths.add((Path)s);
    }
  }

  public void remove(Interactive s) {
    // TODO: check for off by 1 error
    if (s != null) {
      switch(s.getType()) {
        case Constants.SOMA:
          fSomaIndex--;
        case Constants.INITIATOR:
          fInitiatorIndex--;
        case Constants.DENDRITE:
          fDendriteIndex--;
        case Constants.SYNAPSE:
          fSynapseIndex--;
        case Constants.AXON:
          fAxonIndex--;
      }
      fObjs.remove(s);
      // TODO: remove from paths as well
    }
  }

  public void beginSelection(float x, float y) {
    hideControls();
    fSelectedObjs = new ArrayList<Interactive>();
    fSelectStart = new PVector(x, y);
    fSelectEnd = new PVector(x, y);
  }

  public void updateSelection(float x, float y) {
    fSelectEnd.set(x, y, 0);
  }

  public boolean endSelection(float x, float y) {
    fSelectEnd.set(x, y, 0);
    PVector minCoord = new PVector(min(fSelectStart.x, fSelectEnd.x), min(fSelectStart.y, fSelectEnd.y));
    PVector maxCoord = new PVector(max(fSelectStart.x, fSelectEnd.x), max(fSelectStart.y, fSelectEnd.y));
    for (Interactive s : fObjs) {
      switch(s.getType()) {
        case Constants.SOMA:
        case Constants.INITIATOR:
          PVector p = s.getLoc();
          if (p.x >= minCoord.x && p.y >= minCoord.y &&
              p.x <= maxCoord.x && p.y <= maxCoord.y) {
            fSelectedObjs.add(s);
            ((Controllable)s).showControls();
          }
          break;
        case Constants.DENDRITE:
        case Constants.SYNAPSE:
        case Constants.AXON:
          break;
      }
    }
    fSelectStart = fSelectEnd = null;
    return fSelectedObjs.size() != 0;
  }

  public boolean onMouseDown(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--)
      if (fObjs.get(i).onMouseDown(x, y))
        return true;
    return false;
  }
  public boolean onMouseDragged(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--)
      if (fObjs.get(i).onMouseDragged(x, y))
        return true;
    return false;
  }
  public boolean onMouseMoved(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--)
      if (fObjs.get(i).onMouseMoved(x, y))
        return true;
    return false;
  }
  public boolean onMouseUp(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--)
      if (fObjs.get(i).onMouseUp(x, y))
        return true;
    return false;
  }
  public boolean onDblClick(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--)
      if (fObjs.get(i).onDblClick(x, y))
        return true;
    return false;
  }
}