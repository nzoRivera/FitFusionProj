import 'package:flutter/material.dart';
import 'main.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity, // Ensures the Container takes up the full width
            height: MediaQuery.of(context).size.height, // Ensures the Container takes up the full height of the screen
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/signup.png'), // Replace with your image asset
                fit: BoxFit.contain, // Ensures the image is contained within the Container without cropping
                alignment: Alignment.center, // Centers the image within the Container
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Login to FitFusion',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              } else if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => WorkoutPlanApp()),
                                );
                              }
                            },
                            child: Text('Log_in'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              textStyle: TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Settings'),
                  value: 'settings',
                ),
                PopupMenuItem(
                  child: Text('Help'),
                  value: 'help',
                ),
              ];
            },
            onSelected: (String value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSettingsPage()),
                );
              } else if (value == 'help') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQPage()),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildProfileOption(
              Icons.account_circle,
              'Account Settings',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSettingsPage()),
                );
              },
            ),
            _buildProfileOption(
              Icons.notifications,
              'Notifications',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsSettingsPage()),
                );
              },
            ),
            _buildProfileOption(
              Icons.security,
              'Privacy',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacySettingsPage()),
                );
              },
            ),
            _buildProfileOption(
              Icons.help,
              'Help & Support',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQPage()),
                );
              },
            ),
            _buildProfileOption(
              Icons.logout,
              'Logout',
              () {
                _showLogoutConfirmation(context);
              },
            ),
            _buildProfileOption(
              Icons.bug_report,
              'Report a Bug',
              () {
                _showBugReportDialog(context);
              },
            ),
            _buildProfileOption(
              Icons.info,
              'About',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/luffy.jpg'),
        ),
        SizedBox(height: 10),
        Text(
          'ITBA_3305',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: 5),
        Text(
          'ITBA-3305@example.com',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat',
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showBugReportDialog(BuildContext context) {
    final TextEditingController _bugDescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report a Bug'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Please describe the issue you encountered:'),
              TextField(
                controller: _bugDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe the bug...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement bug reporting logic here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bug reported! Thank you for your feedback.'),
                  ),
                );
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String email = 'johndoe@example.com';
  bool newsletterSubscription = true;
  bool locationTracking = false;
  bool syncEnabled = true;
  String selectedPaymentMethod = 'Visa';
  bool isTwoFactorEnabled = false;

  final List<String> paymentMethods = ['Visa', 'MasterCard', 'PayPal'];
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildClickableOption(
              'Change Email',
              'Your current email address is $email.',
              Icons.email,
              () {
                _showChangeEmailDialog();
              },
            ),
            Divider(),
            _buildClickableOption(
              'Subscribe to Newsletter',
              'Receive updates and news via email.',
              Icons.notifications,
              () {
                setState(() {
                  newsletterSubscription = !newsletterSubscription;
                });
              },
              switchWidget: Switch(
                value: newsletterSubscription,
                onChanged: (bool value) {
                  setState(() {
                    newsletterSubscription = value;
                  });
                },
              ),
            ),
            Divider(),
            _buildClickableOption(
              'Enable Location Tracking',
              'Allow the app to access your location.',
              Icons.location_on,
              () {
                setState(() {
                  locationTracking = !locationTracking;
                });
              },
              switchWidget: Switch(
                value: locationTracking,
                onChanged: (bool value) {
                  setState(() {
                    locationTracking = value;
                  });
                },
              ),
            ),
            Divider(),
            _buildClickableOption(
              'Sync Data Across Devices',
              'Sync your data across all your devices.',
              Icons.sync,
              () {
                setState(() {
                  syncEnabled = !syncEnabled;
                });
              },
              switchWidget: Switch(
                value: syncEnabled,
                onChanged: (bool value) {
                  setState(() {
                    syncEnabled = value;
                  });
                },
              ),
            ),
            Divider(),
            _buildClickableOption(
              'Manage Payment Methods',
              'Add or update your payment methods.',
              Icons.payment,
              () {
                _showPaymentMethodsDialog();
              },
            ),
            Divider(),
            _buildClickableOption(
              'Two-Factor Authentication',
              'Enhance your account security with two-factor authentication.',
              Icons.security,
              () {
                _showTwoFactorAuthDialog();
              },
            ),
            Divider(),
            _buildClickableOption(
              'Export Data',
              'Export your data for backup or analysis.',
              Icons.import_export,
              () {
                _exportUserData();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableOption(String title, String subtitle, IconData icon, Function onTap,
      {Widget? switchWidget}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Montserrat',
        ),
      ),
      trailing: switchWidget ?? Icon(Icons.arrow_forward_ios),
      onTap: () {
        if (switchWidget == null) {
          onTap();
        }
      },
    );
  }

  void _showChangeEmailDialog() {
    final TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Email'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Enter new email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  email = emailController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Email changed to $email'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentMethodsDialog() {
  final Map<String, String> paymentImages = {
    'Visa': 'assets/VISA.jpg',
    'MasterCard': 'assets/MasterCard.jpg',
    'PayPal': 'assets/PayPal.jpg',
  };

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Manage Payment Methods'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedPaymentMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPaymentMethod = newValue!;
                    });
                  },
                  items: paymentMethods.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Image.asset(
                            paymentImages[value] ?? 'assets/cards/default.jpg',
                            width: 30,
                            height: 30,
                          ),
                          SizedBox(width: 10),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                if (selectedPaymentMethod == 'Visa' || selectedPaymentMethod == 'MasterCard') ...[
                  TextField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                    ),
                  ),
                  TextField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                    ),
                  ),
                  TextField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                    ),
                  ),
                ]
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment method set to $selectedPaymentMethod'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}


  void _showTwoFactorAuthDialog() {
    showDialog(
      context: context,
      builder: (context) {
        bool newTwoFactorEnabled = isTwoFactorEnabled;
        return AlertDialog(
          title: Text('Two-Factor Authentication'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: Text('Enable Two-Factor Authentication'),
                    value: newTwoFactorEnabled,
                    onChanged: (value) {
                      setState(() {
                        newTwoFactorEnabled = value;
                      });
                    },
                  ),
                  if (newTwoFactorEnabled)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Two-Factor Authentication adds an extra layer of security to your account. You will need to enter a verification code sent to your registered email or phone number.',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isTwoFactorEnabled = newTwoFactorEnabled;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Two-Factor Authentication ${isTwoFactorEnabled ? 'enabled' : 'disabled'}'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _exportUserData() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Export Data'),
          content: Text(
            'Your data export request has been received. You will receive an email once your data is ready for download.',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data export request submitted successfully.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}


class NotificationsSettingsPage extends StatefulWidget {
  @override
  _NotificationsSettingsPageState createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool emailNotifications = true;
  bool pushNotifications = false;
  bool smsNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text(
                'Receive Email Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
              subtitle: Text(
                'Get notified via email for important updates and notifications.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
              ),
              value: emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  emailNotifications = value;
                });
              },
              secondary: Icon(Icons.notifications),
            ),
            Divider(),
            SwitchListTile(
              title: Text(
                'Receive Push Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
              subtitle: Text(
                'Receive real-time notifications directly on your device.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
              ),
              value: pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  pushNotifications = value;
                });
              },
              secondary: Icon(Icons.notifications_active),
            ),
            Divider(),
            SwitchListTile(
              title: Text(
                'Receive SMS Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
              subtitle: Text(
                'Stay informed with text message notifications.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
              ),
              value: smsNotifications,
              onChanged: (bool value) {
                setState(() {
                  smsNotifications = value;
                });
              },
              secondary: Icon(Icons.sms),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  final List<String> _expandedTiles = [];
  String _selectedVisibility = 'Public';
  bool _isSwitchOn = false;
  List<String> blockedUsers = ['User One', 'User Two', 'User Three'];
  Set<String> selectedUsers = {};

  void _toggleTile(String tile) {
    setState(() {
      if (_expandedTiles.contains(tile)) {
        _expandedTiles.remove(tile);
      } else {
        _expandedTiles.clear();
        _expandedTiles.add(tile);
      }
    });
  }

  void _removeBlockedUser(String username) {
    setState(() {
      blockedUsers.remove(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildExpandableTile(
              'Profile Visibility',
              'Control who can see your profile information.',
              Icons.visibility,
              _expandedTiles.contains('Profile Visibility'),
              () {
                _toggleTile('Profile Visibility');
              },
              _buildProfileVisibilityContent,
            ),
            Divider(),
            _buildExpandableTile(
              'Manage Blocked Users',
              'View and manage users you have blocked.',
              Icons.block,
              _expandedTiles.contains('Manage Blocked Users'),
              () {
                _toggleTile('Manage Blocked Users');
              },
              _buildManageBlockedUsersContent,
            ),
            Divider(),
            _buildExpandableTile(
              'Activity Status',
              'Manage who can see your online activity status.',
              Icons.access_time,
              _expandedTiles.contains('Activity Status'),
              () {
                _toggleTile('Activity Status');
              },
              _buildActivityStatusContent,
            ),
            Divider(),
            _buildExpandableTile(
              'Data Download',
              'Request a copy of your personal data.',
              Icons.download,
              _expandedTiles.contains('Data Download'),
              () {
                _toggleTile('Data Download');
              },
              _buildDataDownloadContent,
            ),
            Divider(),
            _buildExpandableTile(
              'Privacy Policy',
              'Read and understand our privacy policy.',
              Icons.privacy_tip,
              _expandedTiles.contains('Privacy Policy'),
              () {
                _toggleTile('Privacy Policy');
              },
              _buildPrivacyPolicyContent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableTile(
    String title,
    String subtitle,
    IconData icon,
    bool isExpanded,
    VoidCallback onTap,
    Widget Function() contentBuilder,
  ) {
    return ExpansionTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Montserrat',
        ),
      ),
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        if (expanded) {
          onTap();
        }
      },
      children: [contentBuilder()],
    );
  }  

  Widget _buildProfileVisibilityContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          Text(
            'Who can see your profile?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 10),
          Text(
            'You can choose from the following options:',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 10),
          RadioListTile<String>(
            title: Text('Public'),
            subtitle: Text('Everyone can see your profile.'),
            value: 'Public',
            groupValue: _selectedVisibility,
            onChanged: (String? value) {
              setState(() {
                _selectedVisibility = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: Text('Followers Only'),
            subtitle: Text('Only your followers can see your profile.'),
            value: 'Followers Only',
            groupValue: _selectedVisibility,
            onChanged: (String? value) {
              setState(() {
                _selectedVisibility = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: Text('Private'),
            subtitle: Text('Only you can see your profile.'),
            value: 'Private',
            groupValue: _selectedVisibility,
            onChanged: (String? value) {
              setState(() {
                _selectedVisibility = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildManageBlockedUsersContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage your blocked users',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Here is the list of users you have blocked. You can unblock users from this list.',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 10),
          ListView(
            shrinkWrap: true,
            children: blockedUsers.map((username) => _buildBlockedUserTile(username)).toList(),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle the unblock all users if needed
            },
            child: Text('Unblock Selected Users'),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedUserTile(String username) {
    return ListTile(
      leading: Icon(Icons.block, color: Colors.black),
      title: Text(username),
      trailing: ElevatedButton(
        onPressed: () {
          _showConfirmationDialog(
            'Unblock User',
            'Are you sure you want to unblock $username? They will be able to interact with you again.',
            'User $username has been unblocked.',
            () => _removeBlockedUser(username),
          );
        },
        child: Text('Unblock'),
      ),
    );
  }
Widget _buildActivityStatusContent() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Control who can see your activity status.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Your activity status shows whether you are currently online or recently active. You can choose who can see this information.',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(
              _isSwitchOn ? Icons.visibility : Icons.visibility_off,
              color: _isSwitchOn ? Colors.blue : Colors.grey,
            ),
            SizedBox(width: 10),
            Expanded(
              child: SwitchListTile(
                title: Text('Allow followers to see your activity status'),
                value: _isSwitchOn,
                onChanged: (bool value) {
                  setState(() {
                    _isSwitchOn = value;
                  });
                  _showConfirmationDialog(
                    'Activity Status Visibility Change',
                    'Are you sure you want to change the visibility of your activity status? This will update who can see when you are online or recently active.',
                    'Activity status visibility updated.',
                    () {
                      // You can add any additional actions you want to take upon confirmation here
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}



Widget _buildDataDownloadContent() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Request a copy of your data.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Requesting a copy of your data will generate a downloadable file containing all the information we have about you. You will receive an email when your data is ready to be downloaded.',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _showConfirmationDialog(
              'Data Download Request',
              'Are you sure you want to request a copy of your data? You will receive an email once the download is ready.',
              'Data download request submitted successfully.',
              () {
                // You can add any additional actions you want to take upon confirmation here
              },
            );
          },
          child: Text('Request Data Download'),
        ),
      ],
    ),
  );
}


  Widget _buildPrivacyPolicyContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Read our privacy policy.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Our privacy policy explains how we handle your personal data, including how we collect, use, and protect your information. It is important to review this policy to understand your privacy rights and our practices.',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _showPrivacyPolicyDialog();
            },
            child: Text('View Privacy Policy'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Privacy Policy'),
          content: SingleChildScrollView(
            child: Text(
              'Here is our privacy policy. We value your privacy and are committed to protecting your personal data. For more information, please visit our website or contact support.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

   void _showConfirmationDialog(String title, String content, String successMessage, VoidCallback onConfirmed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmed();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(successMessage)),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}



class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildFAQItem(
              'How do I change my email address?',
              'To change your email address, go to Account Settings and tap on "Change Email". Enter your new email and save the changes.',
            ),
            Divider(),
            _buildFAQItem(
              'How can I reset my password?',
              'Currently, you can reset your password by contacting support at support@example.com.',
            ),
            Divider(),
            _buildFAQItem(
              'How do I manage my notifications?',
              'You can manage your notifications by going to the Notifications Settings page and toggling the switches for email, push, and SMS notifications.',
            ),
            Divider(),
            _buildFAQItem(
              'How do I update my profile information?',
              'To update your profile information, go to Account Settings and edit the details under the Profile section.',
            ),
            Divider(),
            _buildFAQItem(
              'What should I do if I encounter a bug?',
              'If you encounter a bug, please report it by submitting a ticket through the "Submit a Ticket" option below.',
            ),
            Divider(),
            ListTile(
              title: Text(
                'Submit a Ticket',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  color: Colors.blue,
                ),
              ),
              subtitle: Text(
                'Can\'t find an answer to your question? Submit a ticket to get help from our support team.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicketPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat',
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }
}

class TicketPage extends StatelessWidget {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a Ticket'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ticket submitted! We will get back to you soon.'),
                  ),
                );
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam fermentum tortor vitae dolor porta, in euismod justo sagittis. Aliquam erat volutpat. Vivamus id turpis et sem aliquet gravida. Nullam nec ultricies enim. Suspendisse a commodo ante. Fusce vel maximus risus. Morbi auctor vitae sem ac egestas. Nulla facilisi.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
