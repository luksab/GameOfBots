import processing.net.*;//Die alte Netzwerkimplementation

Client c;
String input;
int data[];

int size = 30;//die Größe der Felder
int sizeX = 15;//wie viele Felder gibt es in X-Richtung?
int sizeY = 15;//wie viele Felder gibt es in Y-Richtung?
int[][] IDs = new int[sizeX][sizeY];//Das Spielfeld an sich:
            //Speichert die IDs der Felder ab
long last = 0;
boolean run = false;
int ausgewaehlt = 0;
int speed = 30;
int num;

void setup() 
{
  size(828, 725);
  background(255);
  textSize(15);
  IDs = Helper.fillIDs(IDs);//Fülle das Spielfeld
  IDs[4][2] = 2;
  frameRate(30);
  c = new Client(this, "127.0.0.1", 12345); // Die IP und der Port des Servers
  num = (int)(random(100))+20;//Die ClientID
  c.write("hello "+ num + "\n");
  while (c.available() == 0)
    delay(10);
  input = c.readString();
  input = input.substring(0, input.indexOf("\n")); //Nur bis zu \n
  if ("hello".equals(split(input, ' ')[0])) {//richtige Antwort
    println("hi");
    if ("OK".equals(split(input, ' ')[2]))//Ich kann spielen
      println("Alles OK");
    else
      println("Nur ein Zuschauer :(");
  } else
    print("Fehler");
}

void draw() {
  background(255);
  for (int i=0; i<sizeX; i++) {
    for (int j=0; j<sizeX; j++) {//geht alle Felder durch
      if (IDs[i][j] == 7)//und malt sie in ihrer respektiven
        fill(247, 62, 45);//Farbe an
      else if (IDs[i][j] == 8)
        fill(245, 232, 67);
      else if (IDs[i][j] == 9)
        fill(115, 227, 53);
      else if (IDs[i][j] == 10)
        fill(72, 245, 247);
      else if (IDs[i][j] == 11)
        fill(63, 122, 247);
      else if (IDs[i][j] == 12)
        fill(235, 133, 251);
      else if (IDs[i][j] == -1)
        fill(255);
      else
        fill(220);
      hexagon(i*((size*0.87)*2)+((j%2)*(size*0.87))+(size*0.87), j*(size*1.5)+size, size);
      fill(16, 80, 167);
      text(i+"|"+j, i*((size*0.87)*2)+((j%2)*(size-5))+(size-5)-11, j*(size*1.5)+size+7);
    }
  }


  if (c.available() > 0) {//gibt es eine neue Nachicht?
    input = c.readString();//Lese
    input = input.substring(0, input.indexOf("\n")); //Bis \n
    println(input);
    data = int(split(input, ' ')); //Trenne bei Leerzeichen
    if ("changeTo".equals(split(input, ' ')[0])) {
      IDs[data[2]][data[3]] = data[1];//und setze das geänderte Feld
    }
    //println(data[0]+" "+data[1]+" "+data[2]);
  }
}

void hexagon(float x, float y, float radius) {//Male ein Hexagon
  float angle = 1.0471975512;
  beginShape();
  for (float a = angle/2; a < TWO_PI+angle/2; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void keyPressed() {
  if (key == ' ') {//Wenn Leertaste:
    c.write("ready "+num+"\n");//Schreibe: Ich bin fertig
  }
}

void mouseClicked() {
  int j = (int)(mouseY/(size*1.5));
  int i = (int)(mouseX/(((size*0.87)*2))-(j%2)*0.5);
  if (j > 14 || i > 14)
    run = !run;
  else if (i>=0&&j>=0) {
    //IDs[i][j] = ausgewaehlt;
    c.write("change "+num+" "+i+" "+j+ "\n");//Schreibe:ändere Feld auf meine ID
  }
  println(i+" "+j);
  //mach Mauszeug hier!
}