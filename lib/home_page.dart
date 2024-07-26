import 'dart:async';
import 'package:flutter/material.dart';
import 'For_you_page.dart'; // Ensure this import path is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat', // Global font family
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController(initialPage: 0);
  late Timer _timer;
  int _currentPage = 0;
  double _progressValue = 0.5; // Example progress value
  String _currentGoal = "Complete 5 Workouts";
  int _currentGoalIndex = 0;
  List<Map<String, dynamic>> challenges = [
    {
      'title': 'Complete 100 Push-Ups',
      'description': 'Push yourself to complete 100 push-ups today. You can break it down into smaller sets if needed.',
      'isCompleted': false
    },
    {
      'title': 'Run 5 Kilometers',
      'description': 'Go for a 5 kilometer run. You can take breaks if needed, but try to complete it in one session.',
      'isCompleted': false
    },
    {
      'title': 'Do 50 Sit-Ups',
      'description': 'Complete 50 sit-ups. You can do it in sets if needed.',
      'isCompleted': false
    },
    {
      'title': 'Plank for 5 Minutes',
      'description': 'Hold a plank position for a total of 5 minutes today.',
      'isCompleted': false
    },
  ];

  List<Map<String, dynamic>> completedChallenges = [];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      int nextPage = (_currentPage + 1) % 5; // Adjust this if you change the number of images
      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage = nextPage;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _completeChallenge(int index) {
    setState(() {
      challenges[index]['isCompleted'] = true;
      completedChallenges.add(challenges[index]);
      challenges.removeAt(index);

      // Check if we've completed 5 challenges for the day
      if (completedChallenges.length >= 5) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompletedChallengesPage(challenges: completedChallenges)),
        );
        completedChallenges.clear(); // Clear completed challenges after viewing
      }
    });
  }

  void _updateProgress() {
    setState(() {
      _progressValue += 0.1;
      if (_progressValue > 1.0) {
        _progressValue = 0.0;
      }
    });
  }

  void _resetProgress() {
    setState(() {
      _progressValue = 0.0;
    });
  }

  void _changeGoal() {
    setState(() {
      _currentGoalIndex = (_currentGoalIndex + 1) % 3;
      if (_currentGoalIndex == 0) {
        _currentGoal = "Complete 5 Workouts";
      } else if (_currentGoalIndex == 1) {
        _currentGoal = "Run 20 Kilometers";
      } else {
        _currentGoal = "Burn 3000 Calories";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo1.png',
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'FitFusion',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'BonaNovaSC',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Color(0xFFF4F5F6), // Light gray color for search icon
            ),
            onPressed: () {
              showSearch(context: context, delegate: ExerciseSearchDelegate());
            },
          ),
          IconButton(
            icon: Icon(
              Icons.list,
              color: Color(0xFFF5F7F5), // Light gray color for list icon
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompletedChallengesPage(challenges: completedChallenges)),
              );
            },
          ),
        ],
 // Lime Green for AppBar
      ),
      backgroundColor: Colors.white, // White background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlideshow(),
            SizedBox(height: 20),
            _buildSectionHeader('For you'),
            SizedBox(height: 10),
            _buildExerciseList(),
            SizedBox(height: 20),
            _buildProgressTracker(),// Added progress tracker section
            SizedBox(height: 20),
            _buildChallengeOfTheDay(), // Added challenge of the day section
          ],
        ),
      ),
    );
  }

  Widget _buildSlideshow() {
    return Container(
      height: 300, // Adjust the height as needed
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildWorkoutImage('assets/1.png'),
              _buildWorkoutImage('assets/2.png'),
              _buildWorkoutImage('assets/3.png'),
              _buildWorkoutImage('assets/4.png'),
              _buildWorkoutImage('assets/5.png'),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: _buildPageIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutImage(String imagePath) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: _currentPage == index ? 20 : 10,
          decoration: BoxDecoration(
            color: _currentPage == index ? const Color.fromARGB(255, 9, 9, 9) : Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }

 Widget _buildSectionHeader(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontFamily: 'Montserrat'  // Add this line for italic style
      ),
    ),
  );
}

  Widget _buildExerciseList() {
    return Column(
      children: [
        _buildExerciseTile('My Activities', 'assets/6.png', 0),
        _buildExerciseTile('Social Engagement', 'assets/7.png', 1),
        _buildExerciseTile('Workout Sessions', 'assets/8.png', 2),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildExerciseTile(String title, String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to different pages based on the index
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CardioPage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SplitWorkoutPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FitnessSessionsPage()),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.white, // Light Beige color for box shadow
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildProgressTracker() {
  // Calculate percentage value
  int percentage = (_progressValue * 100).toInt();

  // Get screen dimensions
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Container(
    padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding relative to screen width
    decoration: BoxDecoration(
      color: Color(0xFFB2DFDB),  // Light Teal for background color
      boxShadow: [
        BoxShadow(
          color: Color(0xFFF5F5DC), // Light Beige for box shadow
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Tracker',
          style: TextStyle(
            fontSize: screenWidth * 0.05, // Adjust font size relative to screen width
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333), // Charcoal Gray for text
          ),
        ),
        SizedBox(height: screenHeight * 0.02), // Adjust spacing relative to screen height
        Stack(
          children: [
            LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: Colors.grey[300],
              color: Color(0xFF008080), // Lime Green for progress tracker
              minHeight: screenHeight * 0.02, // Adjust height relative to screen height
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  '$percentage%', // Display percentage inside the progress bar
                  style: TextStyle(
                    fontSize: screenWidth * 0.03, // Adjust font size relative to screen width
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333), // Charcoal Gray for text
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02), // Adjust spacing relative to screen height
        Text(
          'Current Goal: $_currentGoal',
          style: TextStyle(
            fontSize: screenWidth * 0.04, // Adjust font size relative to screen width
            color: Color(0xFF333333), // Charcoal Gray for text
          ),
        ),
        SizedBox(height: screenHeight * 0.00), // Adjust spacing relative to screen height
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Update Progress',
                  child: IconButton(
                    icon: Icon(Icons.update),
                    onPressed: _updateProgress,
                    iconSize: screenWidth * 0.05, // Adjust icon size relative to screen width
                    color: const Color.fromARGB(255, 0, 0, 0), // Lime Green for button icon
                  ),
                ),
                SizedBox(height: screenHeight * 0.0001), // Adjust spacing relative to screen height
                Text(
                  'Update',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03, // Adjust font size relative to screen width
                    color: Color(0xFF333333), // Charcoal Gray for text
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Reset Progress',
                  child: IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: _resetProgress,
                    iconSize: screenWidth * 0.05, // Adjust icon size relative to screen width
                    color: const Color.fromARGB(255, 4, 4, 4), // Lime Green for button icon
                  ),
                ),
                SizedBox(height: screenHeight * 0.00), // Adjust spacing relative to screen height
                Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03, // Adjust font size relative to screen width
                    color: Color.fromARGB(255, 15, 15, 15), // Charcoal Gray for text
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Change Goal',
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: _changeGoal,
                    iconSize: screenWidth * 0.05, // Adjust icon size relative to screen width
                    color: const Color.fromARGB(255, 0, 0, 0), // Lime Green for button icon
                  ),
                ),
                SizedBox(height: screenHeight * 0.00), // Adjust spacing relative to screen height
                Text(
                  'Change',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03, // Adjust font size relative to screen width
                    color: Color(0xFF333333), // Charcoal Gray for text
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}




Widget _buildChallengeOfTheDay() {
    bool allCompleted = challenges.every((challenge) => challenge['isCompleted']);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Challenge of the Day',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ...challenges.map((challenge) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(challenge['description']),
                SizedBox(height: 10),
                if (!challenge['isCompleted'])
                  ElevatedButton(
                    onPressed: () {
                      _completeChallenge(challenges.indexOf(challenge));
                    },
                    child: Text('Complete Challenge'),
                  ),
                if (challenge['isCompleted'])
                  Text(
                    'Completed!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Divider(),
              ],
            );
          }).toList(),
          if (allCompleted)
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'You have completed the challenges for today! Congratulations and stay healthy!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}



class CompletedChallengesPage extends StatelessWidget {
  final List<Map<String, dynamic>> challenges;

  CompletedChallengesPage({required this.challenges});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Challenges'),
      ),
      body: challenges.isEmpty
          ? Center(
              child: Text('No completed challenges yet.'),
            )
          : ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> challenge = challenges[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 3,
                  child: ListTile(
                    title: Text(challenge['title']),
                    subtitle: Text(challenge['description']),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            ),
    );
  }
}



class ExerciseSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, String>> exercises = [
    {
          'name': 'Chest Flyes',
          'image': 'assets/chest/Chest Flyes.jpg',
          'gif': 'assets/gif/chest flys.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Chest Flyes are an excellent exercise for targeting the chest muscles.'
        },
        {
          'name': 'Reverse Flyes',
          'image': 'assets/chest/Cable Crossover.jpg',
          'gif': 'assets/gif/reverse flys.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Reverse Flyes work the posterior deltoids and upper back muscles.'
        },
        {
          'name': 'Chest Press',
          'image': 'assets/chest/Chest Press.jpg',
          'gif': 'assets/gif/chest press.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Chest Press is a fundamental exercise for building chest strength.'
        },
        {
          'name': 'Decline Chest Press',
          'image': 'assets/chest/Decline Chest Press.jpg',
          'gif': 'assets/gif/decline chest press.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Decline Chest Press targets the lower part of the chest muscles.'
        },
        {
          'name': 'Front Raises',
          'image': 'assets/chest/Front Raises.jpg',
          'gif': 'assets/gif/front raise.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Front Raises strengthen the front deltoid muscles.'
        },
        {
          'name': 'Incline Dumbell Press',
          'image': 'assets/chest/Incline Bench Press.jpg',
          'gif': 'assets/gif/incline dumbell.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Incline Dumbell Press targets the upper chest and shoulders.'
        },
        {
          'name': 'Incline Chest Press (Machine)',
          'image': 'assets/chest/Incline Chest Press (Machine).jpg',
          'gif': 'assets/gif/incline machine.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Incline Chest Press (Machine) is great for upper chest development.'
        },
        {
          'name': 'Lateral Raises',
          'image': 'assets/chest/Lateral Raises.jpg',
          'gif': 'assets/gif/lateral.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Lateral Raises enhance shoulder width and strength.'
        },
        {
          'name': 'Shoulder Press',
          'image': 'assets/chest/Shoulder Press.jpg',
          'gif': 'assets/gif/shoulder press.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Shoulder Press is a key exercise for overall shoulder development.'
        },
        {
          'name': 'Face Pulls',
          'image': 'assets/chest/facepull.jpg',
          'gif': 'assets/gif/face.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Face Pulls are effective for the rear deltoids and upper back.'
        },
        {
          'name': 'Reverse Tricep Extension',
          'image': 'assets/chest/reverse tricep extension.jpg',
          'gif': 'assets/gif/reverse.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Reverse Tricep Extension targets the triceps, focusing on the long head.'
        },
        {
          'name': 'Rope Extension',
          'image': 'assets/chest/rope extension.jpg',
          'gif': 'assets/gif/rope.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Rope Extension isolates the triceps and helps improve definition.'
        },
        {
          'name': 'Tricep Dips',
          'image': 'assets/chest/tricepdips.jpg',
          'gif': 'assets/gif/dips.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Tricep Dips work the triceps, chest, and shoulders.'
        },
        {
          'name': 'Single Rope Pushdown',
          'image': 'assets/chest/sigle rope pushdown.jpg',
          'gif': 'assets/gif/single.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Single Rope Pushdown focuses on the triceps, enhancing muscle separation.'
        },
         {
          'name': 'Pull-ups',
          'image': 'assets/pull/pull ups.jpg',
          'gif': 'assets/gif/pullups.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Pull-ups are great for building back and bicep strength.'
        },
        {
          'name': 'Close Grip Pulldown',
          'image': 'assets/pull/close grip pulldown.jpg',
          'gif': 'assets/gif/close.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Close Grip Pulldown targets the lower lats and biceps.'
        },
        {
          'name': 'Lat Pulldown',
          'image': 'assets/pull/lat pulldown.jpg',
          'gif': 'assets/gif/latdown.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Lat Pulldown helps in building a wider back by targeting the upper lats.'
        },
        {
          'name': 'T-Bar Row',
          'image': 'assets/pull/t-bar row.jpg',
          'gif': 'assets/gif/tbar.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'T-Bar Row engages the middle back and helps in developing thickness.'
        },
        {
          'name': 'Single Lat Pulldown',
          'image': 'assets/pull/single lat pulldown.jpg',
          'gif': 'assets/gif/singlelat.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Single Lat Pulldown focuses on the lats and helps in improving symmetry.'
        },
        {
          'name': 'Seated Lat Row',
          'image': 'assets/pull/seated lat row.jpg',
          'gif': 'assets/gif/latlat.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Seated Lat Row targets the middle back, improving overall back strength.'
        },
        {
          'name': 'Seated Back Row',
          'image': 'assets/pull/seated back row.jpg',
          'gif': 'assets/gif/latlat.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Seated Back Row helps in building the lower and middle back muscles.'
        },
        {
          'name': 'Seated Cable Row',
          'image': 'assets/pull/seated cable row.jpg',
          'gif': 'assets/gif/cablecable.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Seated Cable Row is effective for targeting the entire back and biceps.'
        },
        {
          'name': 'Single Bicep Curl',
          'image': 'assets/pull/single bicep curl.jpg',
          'gif': 'assets/gif/single biceps.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Single Bicep Curl isolates each bicep for balanced development.'
        },
        {
          'name': 'Seated Bicep Curl',
          'image': 'assets/pull/seated bicep curl.jpg',
          'gif': 'assets/gif/seatedbicep.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Seated Bicep Curl targets the biceps while minimizing the involvement of other muscles.'
        },
        {
          'name': 'Hammer Curl',
          'image': 'assets/pull/hammer curl.jpg',
          'gif': 'assets/gif/hammer.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Hammer Curl works the biceps and the brachialis muscle for thicker arms.'
        },
        {
          'name': 'Wrist Curl',
          'image': 'assets/pull/wrist curl.jpg',
          'gif': 'assets/gif/wrist curl.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Wrist Curl strengthens the forearms and improves grip strength.'
        },
        {
          'name': 'Reverse Wrist Curl',
          'image': 'assets/pull/reverse wrist curl.jpg',
          'gif': 'assets/gif/reverse ezbar.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Reverse Wrist Curl targets the forearms, focusing on the extensor muscles.'
        },
        {
          'name': 'Shrugs',
          'image': 'assets/pull/shurgs.jpg',
          'gif': 'assets/pull/gif14.gif',
          'reps': '3 sets 8-12 reps',
          'description': 'Shrugs are great for building and strengthening the trapezius muscles.'
        },
          {
    'name': 'Squats',
    'image': 'assets/squats.jpg',
    'gif': 'assets/gif/squat.gif',
    'reps': '3 sets 8-12 reps',
    'description': 'Squats are a foundational exercise for leg strength and power.'
  },
  {
    'name': 'Leg Press',
    'image': 'assets/legpress.jpg',
    'gif': 'assets/gif/legpress.gif',
    'reps': '3 sets 8-12 reps',
    'description': 'Leg Press targets the quads, hamstrings, and glutes.'
  },
  {
    'name': 'Hamstring Curls',
    'image': 'assets/hamstringcurl.jpg',
    'gif': 'assets/gif/hamstring.gif',
    'reps': '3 sets 8-12 reps',
    'description': 'Hamstring Curls isolate and strengthen the hamstring muscles.'
  },
  {
    'name': 'Cable Crunch',
    'image': 'assets/cablecrunch.jpg',
    'gif': 'assets/gif/crunch.gif',
    'reps': '3 sets 10-15 reps',
    'description': 'Cable Crunch is effective for building strong abdominal muscles.'
  },
  {
    'name': 'Hanging Leg Raises',
    'image': 'assets/legraises.jpg',
    'gif': 'assets/gif/hangin.gif',
    'reps': '3 sets 10-15 reps',
    'description': 'Hanging Leg Raises target the lower abs and hip flexors.'
  },
  {
    'name': 'Planks',
    'image': 'assets/planks.jpg',
    'gif': 'assets/gif/planks.gif',
    'reps': '3 sets 30-60 seconds',
    'description': 'Planks are excellent for core stability and endurance.'
  },
  {
    'name': 'Lunges',
    'image': 'assets/lunges.jpg',
    'gif': 'assets/gif/lunges.gif',
    'reps': '3 sets 10-15 reps',
    'description': 'Lunges work the legs and glutes while improving balance.'
  }
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

 @override
Widget buildResults(BuildContext context) {
  List<Map<String, String>> searchResults = exercises
      .where((exercise) =>
          exercise['name']!.toLowerCase().contains(query.toLowerCase()))
      .toList();

  if (searchResults.isEmpty) {
    return Center(child: Text('No results found'));
  } else if (searchResults.length == 1) {
    return _buildExerciseDialog(context, searchResults[0]);
  } else {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        Map<String, String> result = searchResults[index];

        return ListTile(
          title: Text(result['name']!),
          leading: CircleAvatar(
            backgroundImage: AssetImage(result['image']!),
          ),
          onTap: () {
            _showExerciseDialog(context, result);
          },
        );
      },
    );
  }
}

@override
Widget buildSuggestions(BuildContext context) {
  List<Map<String, String>> suggestionList = query.isEmpty
      ? exercises
      : exercises
          .where((exercise) =>
              exercise['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();

  return ListView.builder(
    itemCount: suggestionList.length,
    itemBuilder: (context, index) {
      Map<String, String> suggestion = suggestionList[index];

      return ListTile(
        title: Text(suggestion['name']!),
        leading: CircleAvatar(
          backgroundImage: AssetImage(suggestion['image']!),
        ),
        onTap: () {
          _showExerciseDialog(context, suggestion);
        },
      );
    },
  );
}

void _showExerciseDialog(BuildContext context, Map<String, String> exercise) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Center(child: Text(exercise['name']!)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Center(
                child: Image.asset(exercise['gif']!),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Sets and Reps: ${exercise['reps']}',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${exercise['description']}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget _buildExerciseDialog(BuildContext context, Map<String, String> exercise) {
  return AlertDialog(
    backgroundColor: Colors.white,
    title: Center(child: Text(exercise['name']!)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Center(
            child: Image.asset(exercise['gif']!),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Sets and Reps: ${exercise['reps']}',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Description: ${exercise['description']}',
          textAlign: TextAlign.center,
        ),
      ],
    ),
    actions: <Widget>[
      TextButton(
        child: Text('Close'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

}

