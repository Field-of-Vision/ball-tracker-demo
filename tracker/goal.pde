public class GoalPage extends Page {
  int time;
  State state;
  double timestamp;
  double checkpoint;
  String action, goal_name, url;
  int pass, home, away, out, possession, goal, tutorial;
  int selectedImage;

  GoalPage() {
    time = millis();
    timestamp = 0;
    selectedImage = -1;
  }
    /**
    * Sets the AWS endpoint for the given goal
    * 
    * @param url: the AWS endpoint
    * @param _goal: the go  al name (format to be determined)
    * @selectedImage : the index of the image to be displayed (TODO: will probs remove this!)
    */
  void setGoal(String url, String _goal, int selectedImage) {
    this.url = url;
    this.goal_name = _goal;
    this.selectedImage = selectedImage;

    switch(url) {
    case DALYMOUNT_PARK:
      this.action = "dalymount_IRL_sendMessage";
      println("goalPage: dalymount_IRL_sendMessage");
      break;
    case MARVEL_STADIUM:
      this.action = "marvel_AUS_sendMessage";
      break;
    case MELBOURNE_CRICKET_GROUND:
      this.action = "mcg_AUS_sendMessage";
      break;
    }
  }

  String toJsonRequest() {
    if (action == null) {
      println("Can't send message to the server before setting the stadium");
    }

    action = "hello";
    mouseX = 0;
    mouseY = 0;
    possession = 1;
    pass = 1;
    goal = 1;
    tutorial = 1;

    // Temporarily commenting out just to see if I can hardcode something
    // return "{\"action\": \"" + action + "\", \"message\": {\"T\":" +
    //   String.format("%.02f", timestamp) + ",\"X\":" +
    //   mouseX/15 + ",\"Y\":" +
    //   mouseY/15 + ",\"P\":" +
    //   possession + ",\"Pa\":" +
    //   pass + ",\"G\":" +
    //   goal + ",\n\"T\":" +
    //   tutorial + "}}";
    return "{\"action\" : \"yolo\", \"message\": {\"x\": \"3\"}}";
  }

  void show() {
    super.show();

    if (visible != this) {
      return;
    }

    background(255);

    // Hide other elements on the main page
    cp5.getController(MainPage.STADIUM_LIST_LABEL).hide();
    cp5.getController(MainPage.GOAL_LIST_LABEL).hide();
    cp5.getController(MainPage.START_LABEL).hide();
    cp5.getController(MainPage.LOGIN_LABEL).hide();
    textSize(20);
    text("Goal page", 10, 30);

    int clock = millis();
    if (clock > time + MILLI_SEC_DELAY) {

      // Iterate timestamp by MILLI_SEC_DELAY = 500; seconds.
      float elapsed = clock - time;
      println("Elapsed time since last request: " + elapsed);

      time = clock;
      timestamp = (float)time / 1000.0 - checkpoint;
      webSendJson(toJsonRequest());
    }
  }

  public void start() {
    webConnect(url);
  }

  public void finish() {
    webDisconnect();
    saveEnd();
  }

  public void reset() {

  }
}
