import de.bezier.guido.*;
private MSButton[][] buttons; 
public static final int NUM_COLS = 15; 
public static final int NUM_ROWS = 13; 
public static final int BUTTON_WIDTH = 20;
public static final int BUTTON_HEIGHT = 20;
public static final int NUM_BOMBS = (int)((NUM_ROWS*NUM_COLS)*0.1);
private ArrayList <MSButton> bombs; 
public boolean setBombs = false;
public boolean GO = false;
void setup(){
  size(300, 380);
  textAlign(CENTER, CENTER);
  Interactive.make(this);
  buttons = new MSButton [NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++){
    for (int c = 0; c < NUM_COLS; c++){
      buttons[r][c] = new MSButton(r,c);
    }
  }
  bombs = new ArrayList <MSButton>();
}
public void setBombs(int numBombs, int rRows, int cCols){
  for (int i = 0; i < numBombs; i++){
    int bRows = (int)(Math.random()*NUM_ROWS);
    int tCol = (int)(Math.random()*NUM_COLS);
    if (bombs.contains(buttons[bRows][tCol]) == false && bRows != rRows && tCol != cCols) {
      bombs.add(buttons[bRows][tCol]);
    }
    else { 
      i--;
    }
  }
}
public void keyPressed(){
  if (key == ' '){
    setBombs = false;
    GO = false;
    for (int i = 0; i < NUM_BOMBS; i++)
      if (bombs.size() > 0)
        bombs.remove(0);
    for (int rRows = 0; rRows < NUM_ROWS; rRows++){
      for (int cCols = 0; cCols < NUM_COLS; cCols++){
        buttons[rRows][cCols].setClicked(false);
        buttons[rRows][cCols].setMarked(false);
        buttons[rRows][cCols].setChart("");
      }
    }
  }
  if (key=='i' || key=='I'){
      setBombs = false;
    GO = false;
    for (int i = 0; i < NUM_BOMBS; i++)
      if (bombs.size() > 0)
        bombs.remove(0);
    for (int rRows = 0; rRows < NUM_ROWS; rRows++){
      for (int cCols = 0; cCols < NUM_COLS; cCols++){
        buttons[rRows][cCols].setClicked(false);
        buttons[rRows][cCols].setMarked(false);
        buttons[rRows][cCols].setChart("");
      }
    }
  }
}
public void draw (){
  background( 0 );
  if (isWon()){
    fill(255);
    text("You win!", 164,310,100);
  }
   else if (!isWon()){
     fill (255);
     text("Press the SPACEBAR to reset the level", 155,310,100);
   }
}
public boolean isWon(){
  int countMarked = 0;
  int counted = 0;
  for (int r = 0; r < NUM_ROWS; r++){
    for (int c = 0; c < NUM_COLS; c++){
      if (buttons[r][c].isMarked()) {
        countMarked++;
      } 
      else if (buttons[r][c].isClicked()) {
        counted++;
      }
    }
  }
  int countB = 0;
  for (int i = 0; i < bombs.size(); i++){
    if ((bombs.get(i)).isMarked()) {
      countB++;
    }
  }
  if ((countB == NUM_BOMBS && countMarked + counted == NUM_ROWS*NUM_COLS && countB == countMarked) || NUM_BOMBS == (NUM_ROWS*NUM_COLS)-counted) {
    return true;
  }
  return false;
}
public void displayLosingMessage(){
  for (int i = 0; i < bombs.size(); i++)
  {
    (bombs.get(i)).setClicked(true);
    (bombs.get(i)).setMarked(false);
  }
}

public void displayWinningMessage(){
  for (int j = 0; j < bombs.size(); j++)
    (bombs.get(j)).setMarked(true);
}
public class MSButton {
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String charted;
  public MSButton ( int rRows, int cCols ){
    width = BUTTON_WIDTH;
    height = BUTTON_HEIGHT;
    r = rRows;
    c = cCols; 
    x = c*width;
    y = r*height;
    charted = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
   public void setMarked(boolean nMark){
    marked = nMark;
  }
  public boolean isMarked(){
    return marked;
  }
   public void setClicked(boolean nClick){
    clicked = nClick;
  }
  public boolean isClicked(){
    return clicked;
  }
  public void mousePressed(){
    if (!setBombs){
      setBombs = true;
      setBombs(NUM_BOMBS, r, c);
    }
    if (!isWon() && !GO) { 
      if (mouseButton == RIGHT && charted.equals("")){
        if (bombs.contains(this)) {
          clicked = false;
          marked = !marked;
        } 
        else if (clicked == false) {
          clicked = false;
          marked = !marked;
        }
      } 
      else if (mouseButton == CENTER){
        if (countMarks(r, c) == parseInt(charted) && clicked){
          for (int rRows = -1; rRows < 2; rRows++){
            for (int cCols = -1; cCols < 2; cCols++){
              if (isValid(r+rRows, c+cCols)){
                buttons[r+rRows][c+cCols].mouseSurround();
              }
            }
          }
        }
      } 
      else if (!marked){
        clicked = true;
        if (bombs.contains(this)) {
          GO = true;
          displayLosingMessage();
        }
        else if (countBombs(r, c) > 0) { 
          setChart("" + countBombs(r, c));
        } 
        else {
          for (int rRows = -1; rRows < 2; rRows++){
            for (int cCols = -1; cCols < 2; cCols++){
              if (isValid(r+rRows, c+cCols) && buttons[r+rRows][c+cCols].isClicked() == false){
                buttons[r+rRows][c+cCols].mousePressed();
              }
            }
          }
        }
      }
    }
  }
  public void mouseSurround(){
    if (!marked && !clicked){
      clicked = true;
      if (bombs.contains(this)) { 
        displayLosingMessage();
      } 
      else if (countBombs(r, c) > 0) { 
        setChart("" + countBombs(r, c));
      } 
      else {
        for (int rRows = -1; rRows < 2; rRows++){
          for (int cCols = -1; cCols < 2; cCols++){
            if (isValid(r+rRows, c+cCols) && buttons[r+rRows][c+cCols].isClicked() == false){
              buttons[r+rRows][c+cCols].mouseSurround();
            }
          }
        }
      }
    }
  }
  public void draw(){    
 int r = (int)(Math.random()*255)+240;
 int g = (int)(Math.random()*120);
 int b = (int)(Math.random()*20);
 strokeWeight(2);
    if (marked){
      strokeWeight(1);
      fill(55);
      rect(x, y, width, height);     
    }
    else if (clicked && bombs.contains(this)) 
      fill(255, 0, 0);
        else if (clicked){
          fill(225);
        }
      else{
    fill(100);
      }
    stroke(r,g,b);
    rect(x, y, width, height);
    fill(0);
    text(charted, x+width/2, y+height/2);
  }
  public void setChart(String newLabel){
    charted = newLabel;
  }
  public boolean isValid(int r, int c){
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) { 
      return true;
    }
    return false;
  }
  public int countBombs(int row, int col){
    int numBombs = 0;
    for (int rRows = -1; rRows < 2; rRows++) {
      for (int cCols = -1; cCols < 2; cCols++){
        if (isValid(row+rRows, col+cCols) && bombs.contains(buttons[row+rRows][col+cCols])){
          numBombs++;
        }
      }
    }
    return numBombs;
  }
  public int countMarks(int row, int col){
    int markNum = 0;
    for (int rRows = -1; rRows < 2; rRows++){
      for (int cCols = -1; cCols < 2; cCols++){
        if (isValid(row+rRows, col+cCols) && buttons[row+rRows][col+cCols].isMarked()){
          markNum++;
        }
      }
    }
    return markNum;
  }
} 
