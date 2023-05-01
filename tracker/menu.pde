public class MainPage extends Page {
  Button start;
  Button login;
  ListBox list;
  ListBox list1;
  int listBoxHeight = 280;
  int listBoxWidth = 500;
  int spaceBetweenMenus = 50;
  int startingX = (1541 - (2 * listBoxWidth) - spaceBetweenMenus) / 2;


  static final String START_LABEL = "Start";
  static final String LOGIN_LABEL = "Logon";
  static final String LIST_LABEL = "Stadium Selector:";
  static final String GOAL_LABEL = "Goal Selector:";

  //Goal strings
  String[] goals = {
    "Goal 1", 
    "Goal 2", 
    "Goal 3", 
    "Goal 4", 
    "Goal 5", 
    "Goal 6", 
  };

  String[] stadiums = {
    "Etihad Stadium", 
    "Marvel Stadium", 
    "Melbourne Cricket Ground", 
    "Windsor Park", 
    "Wembley Stadium", 
    "Estádio do Dragão"
  };

  MainPage() {
    font = createFont("arial", 25);
    background = loadImage(dataPath(FIG_PATH) + File.separator + "Background.png");

    start = cp5.addButton(START_LABEL)
      .setPosition((1541/2)-100, 670)
      .setSize(100, 50)
      .setColorBackground(color(20, 20, 20))
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setLabel(START_LABEL)
      .setFont(font);

    login = cp5.addButton(LOGIN_LABEL)
      .setPosition(10, 10)
      .setSize(100, 50)
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setLabel("Login")
      .setFont(font);

    list = cp5.addListBox("Stadium Selector:")
      .setPosition(startingX, 380)
      .setSize(listBoxWidth, listBoxHeight)
      .setBarVisible(false)
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setItemHeight(70)
      .setFont(font)
      .addItems(stadiums);

    list1 = cp5.addListBox("Goal Selector:")
      .setPosition(startingX + listBoxWidth + spaceBetweenMenus, 380)
      .setSize(listBoxWidth, listBoxHeight)
      .setBarVisible(false)
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setItemHeight(70)
      .setFont(font)
      .addItems(goals);  

    controllers.add(login);
    controllers.add(start);
    controllers.add(list);
    controllers.add(list1);
  }

  void onClickStart() {
    int selectedStadium1 = (int) cp5.getController(MainPage.LIST_LABEL).getValue();
    int selectedGoal1 = (int) cp5.getController(MainPage.GOAL_LABEL).getValue();

    if (selectedStadium1 >= 0) {
      game.start();
      goal.hide();
      visible = game;
    } else if (selectedGoal1 >= 0) {
      goal.start();
      game.hide();
      visible = goal;
    }
    return;
  }



  void onClickStadiumList(int selectedStadium) {
    String stadiumName = stadiums[selectedStadium];
    switch (selectedStadium) {
    case 0:
      game.setStadium(DALYMOUNT_PARK, stadiumName, selectedStadium);
      break;
    case 1:
      game.setStadium(MARVEL_STADIUM, stadiumName, selectedStadium);
      break;
    case 2:
      game.setStadium(MELBOURNE_CRICKET_GROUND, stadiumName, selectedStadium);
      break;
    default:
      println("Stadium not handled <" + stadiumName + ">");
      return;
    }
  }
  void onClickGoalList(int selectedGoal) {
    println("Goal selected: " + selectedGoal);
    String goalName = goals[selectedGoal];
    switch (selectedGoal) {
    case 0:
      goal.setGoal(DALYMOUNT_PARK, goalName, selectedGoal);
      break;
    case 1:
      goal.setGoal(DALYMOUNT_PARK, goalName, selectedGoal);
      break;
    case 2:
      goal.setGoal(DALYMOUNT_PARK, goalName, selectedGoal);
      break;
    case 3:
      goal.setGoal(DALYMOUNT_PARK, goalName, selectedGoal);
      break;
    case 4:
      goal.setGoal(DALYMOUNT_PARK, goalName, selectedGoal);
      break;
    case 5:
      goal.setGoal(DALYMOUNT_PARK, goalName, selectedGoal);
      break;
    default:
      println("Goal not handled <" + goalName + ">");
      return;
    }
  }
}
