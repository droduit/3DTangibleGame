import java.util.List;

class StateManager {
  private List<State> stateStack = new ArrayList<State>(8);
  
  public State currentState() {
    if (this.stateStack.isEmpty())
      return null;
    else
      return this.stateStack.get( this.stateStack.size() - 1 );
  }
  
  public void push(State newState) {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.onLoseFocus();
    
    this.stateStack.add(newState);
    
    newState.onLoad();
    newState.onFocus();
  }
  
  public void pop() {
    State currentState = this.currentState();
    
    if (currentState != null) {
      currentState.onLoseFocus();
      currentState.onUnload();
    }
    
    this.stateStack.remove( this.stateStack.size() - 1 );
    
    State newState = this.currentState();
    
    if (newState != null)
      newState.onFocus();
  }
  
  public void swap(State state) {
    this.pop();
    this.push(state);
  }
  
  public void update(float dt) {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.onUpdate(dt);
    else
      println("WARNING - Thes is no current state!");
  }
  
  public void draw() {
    int drawIndex = this.stateStack.size() - 1;
    
    while (drawIndex > 0 && this.stateStack.get(drawIndex).isPopup())
      drawIndex = drawIndex - 1;
      
    while (drawIndex < this.stateStack.size()) {
      stateStack.get(drawIndex).onDraw();
      
      drawIndex = drawIndex + 1;
    }
  }
  
  // Keyboard Events
  public void keyPressed() {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.keyPressed();
  }
  
  public void keyReleased() {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.keyReleased();
  }
  
  public void keyTyped() {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.keyTyped();
  }
  
  // Mouse Events
  public void mousePressed() {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.mousePressed();
  }
  
  public void mouseReleased() {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.mouseReleased();
  }
  
  public void mouseClicked() {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.mouseClicked();
  }
  
  public void mouseMoved() {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.mouseMoved();
  }
  
  public void mouseDragged() {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.mouseDragged();
  }
  
  public void mouseWheel(MouseEvent event) {
    State currentState = this.currentState();
    
    if (currentState != null)
      currentState.mouseWheel(event);
  }
}