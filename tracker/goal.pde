public class GoalPage extends Page {
  String action, stadium, url;
  int selectedImage;
  double timestamp;
  int time;
  State state;
  double checkpoint;
  int pass, home, away, out, possession, goal, tutorial;

  GoalPage() {
    selectedImage = -1;
    timestamp = 0;
    time = millis();
  }

  void setGoal(String url, String stadium, int selectedImage) {
    this.url = url;
    this.stadium = stadium;

    switch(url) {
    case DALYMOUNT_PARK:
      this.action = "dalymount_IRL_sendMessage";
      println("dalymount_IRL_sendMessage");
      break;
    }
  }

  String toJsonRequest() {
    if (action == null) {
      println("Can't send message to the server before setting the stadium");
      return null;
    }

    // Load the JSON data from file
    String filename = dataPath(dataPath(FIG_PATH) + File.separator + "goal_info.json");
    JSONObject data = loadJSONObject(filename);

    // Check if the data was loaded correctly
    if (data == null) {
      println("Failed to load JSON data from file: " + filename);
      return null;
    }

    // Print out the JSON object to see if it's being created correctly
    println("JSON object: " + data);


    // Create a new JSON object to hold the updated data
    JSONObject updatedData = new JSONObject();

    // Set the values from the JSON file to the new JSON object
    updatedData.setDouble("T", data.getDouble("T"));
    updatedData.setInt("X", data.getInt("X"));
    updatedData.setInt("Y", data.getInt("Y"));
    updatedData.setInt("P", data.getInt("P"));
    updatedData.setInt("Pa", data.getInt("Pa"));
    updatedData.setInt("G", data.getInt("G"));

    // Print out the updated JSON object to see if the values were updated correctly
    println("Updated JSON object: " + updatedData);

    // Print out the updated JSON object to see if the values were updated correctly
    println("Updated JSON object: " + data);



    // Convert the updated data to a string and return it
    return "{\"action\": \"" + action + "\", \"message\": " + data.toString() + "}";
  }



  void show() {
    super.show();

    if (visible != this) {
      return;
    }

    background(255);

    // Hide other elements on the main page
    cp5.getController(MainPage.STADIUM_LIST_LABEL).hide();
    cp5.getController(MainPage.START_LABEL).hide();
    cp5.getController(MainPage.LOGIN_LABEL).hide();
    textSize(20);
    text("Goal page", 10, 30);

    int clock = millis();
    if (state == State.ONGOING && clock > time + MILLI_SEC_DELAY) {

      // Iterate timestamp by MILLI_SEC_DELAY = 500; seconds.
      float elapsed = clock - time;
      println("Elapsed time since last request: " + elapsed);

      time = clock;
      timestamp = (float)time / 1000.0 - checkpoint;
      println(toJsonRequest());
      webSendJson(toJsonRequest());
    }
    println(toJsonRequest());
  }


  public void start() {
    webConnect(url);
  }

  public void finish() {
    webDisconnect();
  }
}
