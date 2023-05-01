import processing.data.JSONObject;

public class GoalPage extends Page {
  int time;
  State state;
  double timestamp;
  double checkpoint;
  String action, goal_name, url;
  int pass, home, away, out, possession, goal, tutorial;
  int t, x, y, p, pa, g;
  int selectedGoal;

  int counter, json_array_size;
  String json_filename;
  JSONObject json_file;
  JSONArray json_array;
  JSONObject json_object;

  String temp;

  GoalPage() {
    time = millis();
    timestamp = 0;
    selectedGoal = -1;
    counter = 0;
  }
    /**
    * Sets the AWS endpoint for the given goal
    * 
    * @param url: the AWS endpoint
    * @param _goal: the go  al name (format to be determined)
    * @selectedGoal : the index of the goal to be displayed (TODO: will probs remove this!) (i.e. its position in the list!)
    */
  void setGoal(String url, String _goal, int selectedGoal) {
    this.url = url;
    this.goal_name = _goal;

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

    switch(selectedGoal) {
    case 0:
      this.json_filename = "data/match1.json";
      println("goalPage: match1.json");
      break;
    case 1:
      this.json_filename = "data/match2.json";
      println("goalPage: match2.json");
      break;
    case 2:
      this.json_filename = "data/match3.json";
      println("goalPage: match3.json");
      break;
    }

    // TODO: this isn't neat, but load the json file once we have it here
    println("beginning to load json file");
    json_file = loadJSONObject(json_filename);
    json_array = json_file.getJSONArray("data");
    json_array_size = json_array.size();
  }

  String toJsonRequest() {
    if (action == null) {
      println("Can't send message to the server before setting the stadium");
    }

    if (counter >= json_array_size) {
      // We have finished the goal. 
      // TODO: need to return the homepage by hear. 
      println("We have finished");
      game.finish();
      return "";
    }
    else{

      // If the counter is 1, sleep/ delay for 15 seconds
      if (counter == 1) {
        println("delaying");
        delay(5000);
      }

      json_object = json_array.getJSONObject(counter);

      // Access the data fields
      t = json_object.getInt("T");
      x = json_object.getInt("X");
      y = json_object.getInt("Y");
      p = json_object.getInt("P");
      pa = json_object.getInt("Pa");
      g = json_object.getInt("G");

      println("{\"action\": \"" + "dalymount_IRL_sendMessage" + "\", \"message\": {\"T\":" +
      String.format("%.02f", timestamp) + ",\"X\":" +
      x + ",\"Y\":" +
      y + ",\"P\":" +
      p + ",\"Pa\":" +
      pa + ",\"G\":" +
      g +  "}}");

      counter++;
    }

    // Temporarily commenting out just to see if I can hardcode something 
    // TODO: rename action to lambda_function or similar (its dalymount_IRL_sendMessage for example atm)
  
    // return "{\"action\" : \"dalymount_IRL_sendMessage\", \"message\": {\"x\": \"3\"}}";
    return "{\"action\": \"" + "dalymount_IRL_sendMessage" + "\", \"message\": {\"T\":" +
      String.format("%.02f", timestamp) + ",\"X\":" +
      x + ",\"Y\":" +
      y + ",\"P\":" +
      p + ",\"Pa\":" +
      pa + ",\"G\":" +
      g +  "}}";
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
