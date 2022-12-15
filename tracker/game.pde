enum State {
  PAUSED, ONGOING, FINISHED;
}

public class GamePage extends Page {
  int time;
  double timestamp;
  double checkpoint;
  int pass, receive, home, away, out, possession;
  String action, stadium, url;
  int selectedImage;
  State state;

  GamePage() {
    state = State.PAUSED;
    time = millis();
    pass = 0;
    receive = 0;
    home = 0;
    away = 0;
    out = 0;
    possession = POSSESSION_NEUTRAL;
    timestamp = 0;
    checkpoint = 0;
    selectedImage = -1;
  }

  void setStadium(String url, String stadium, int selectedImage) {
    this.url = url;
    this.stadium = stadium;
    this.selectedImage = selectedImage;

    switch(url) {
    case DALYMOUNT_PARK:
      this.action = "irelandSendMessage";
      break;
    case MARVEL_STADIUM:
      this.action = "marvel_AUS_sendMessage";
      break;
    case MELBOURNE_CRICKET_GROUND:
      this.action = "mcg_AUS_sendMessage";
      break;
    }
  }

  String toTautJson() {
    return "{\n\"Timestamp\":" +
      String.format("%.02f", timestamp) + ",\n\"X\":" +
      mouseX/7 + ",\n\"Y\":" +
      mouseY/7 + ",\n\"Possession\":" +
      possession + ",\n\"Pass\":" +
      pass + ",\n\"Receive\":" +
      receive + ",\n\"home goal\":" +
      home + ",\n\"away goal\":" +
      away + ",\n\"Out\":" +
      out + "\n}";
  }

  String toJsonRequest() {
    if (action == null) {
      println("Can't send message to the server before setting the stadium");
    }

    return "{\"action\": \"" + action + "\", \"message\": {\"Timestamp\":" +
      String.format("%.02f", timestamp) + ",\"X\":" +
      mouseX/7 + ",\"Y\":" +
      mouseY/7 + ",\"Possession\":" +
      possession + ",\"Pass\":" +
      pass + ",\"Receive\":" +
      receive + ",\"home goal\":" +
      home + ",\"away goal\":" +
      away + ",\"Out\":" +
      out + "}}";
  }

  @Override
    void show() {
    super.show();

    textSize(20);

    imageMode(CORNER);
    image(images[selectedImage], 0, 0, width, height);
    //imageMode(CENTER);
    //image(ball[selectedImage], mouseX, mouseY);
    //make cursor outline of circle
    strokeWeight(10);
    ellipse(mouseX, mouseY, 50, 50);
    noFill();
    //when possession is 1, the ellipse is red, when possession is 0, the ellipse is blue, when possession is 66, the ellipse is white
    //when mouse is pressed, the ellipse gets bigger for a split second

    if (possession == POSSESSION_HOME) {
      stroke(0, 0, 205);
    } else if (possession == POSSESSION_AWAY) {
      stroke(255, 173, 0);
    } else {
      stroke(255);
    }

    //if pass, goal, or out is pressed, the ellipse gets bigger for a split second
    if (pass == 1)
      ellipse(mouseX, mouseY, 100, 100);
    if (receive == 1)
      ellipse(mouseX, mouseY, 20, 20);
    if (home == 1)
      //goal.gif is added to middle of screen
      image(goal, (width/2)-300 , 300, 700, (height/2));
    





    int leftPad = 10;
    int leftPad1 = 1340;

    //Instructions on screen
    text("Hold Left Click - Possession", leftPad, 30);
    text("Press 'A' - Pass", leftPad, 55);
    text("Press 'D' - Mark", leftPad, 80);
    text("Press '1' - Tackle", leftPad, 105);
    text("Press '2' - Goal", leftPad, 130);
    text("Press '3' - Behind", leftPad, 155);
    text("Press 'Space' - Pause", leftPad, 180);

    // write output as text on screen for testing purposes.
    text("Timestamp: " + String.format("%.02f", timestamp), leftPad1, 30);
    text("X: " + mouseX/15, leftPad1, 55);
    text("Y: " + mouseY/15, leftPad1, 80);
    text("Possession: " + possession, leftPad1, 105);
    text("Pass: " + pass, leftPad1, 130);
    text("Mark: " + receive, leftPad1, 155);
    text("Goal: " + home, leftPad1, 180);
    text("Behind: " + away, leftPad1, 205);
    text("Tackle: " + out, leftPad1, 230);


    if (state == State.PAUSED) {
      imageMode(CENTER);
      image(paused, width/2+17, height/2, 1200, 750);
    }

    //Everything within this if statement occurs every 0.125 seconds and sends the information to the AWS server.
    int clock = millis();
    if (state == State.ONGOING && clock > time + 125) {

      // Iterate timestamp by 0.125 seconds.
      float elapsed = clock - time;
      println("Elapsed time since last request: " + elapsed);

      time = clock;
      timestamp = (float)time / 1000.0 - checkpoint;

      webSendJson(toJsonRequest());
      saveAppend(toTautJson());

      //Ensure that the vibrations only last one frame.
      this.reset();
    }



    //Controller variables.
    onKeyPressed(keyPressed, key);

    //Possession variables
    onMousePressed(mousePressed, mouseButton);
  }

  void onKeyPressed(boolean keyPressed, char key) {
    if (!keyPressed) {
      lastKeyPressed = '\\';
      return;
    }

    char k = Character.toUpperCase(key);
    if (lastKeyPressed == k) {
      return;
    }
    lastKeyPressed = k;

    if (k == 'E') {
      visible = leave;
      return;
    }

    if (k == ' ') {
      if (state == State.PAUSED) {
        state = State.ONGOING;
        return;
      }

      state = State.PAUSED;
      checkpoint = timestamp;
      timestamp = 0;
      return;
    }

    if (state != State.ONGOING) {
      return;
    }

    switch (k) {
    case '1':
      if (out == 0) {
        out = 1;
      }
      break;

    case '2':
      if (home == 0) {
        home = 1;
      }
      break;

    case '3':
      if (away == 0) {
        away = 1;
      }
      break;

    case 'A':
      if (pass == 0) {
        pass = 1;
      }
      break;

    case 'D':
      if (receive == 0) {
        receive = 1;
      }
      break;
    }
  }

  public void start() {
    state = State.PAUSED;
    webConnect(url);
    saveStart(stadium);
  }

  public void finish() {
    state = State.FINISHED;
    webDisconnect();
    saveEnd();
  }

  void onMousePressed(boolean mousePressed, int mouseButton) {
    if (!mousePressed) {
      possession = POSSESSION_NEUTRAL;
      return;
    }

    if (mouseButton == LEFT) {
      possession = 1;
      return;
    }

    if (mouseButton == RIGHT) {
      possession = 0;
    }
  }

  void reset() {
    if (receive == 1) {
      receive = 0;
    }
    if (pass == 1) {
      pass = 0;
    }
    if (home == 1) {
      home = 0;
    }
    if (away == 1) {
      away = 0;
    }
    if (out == 1) {
      out = 0;
    }
  }
}
