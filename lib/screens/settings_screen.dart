import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings
  bool _showTruth = true;
  bool _showDare = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  // Load settings from shared preferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showTruth = prefs.getBool('show_truth') ?? true;
      _showDare = prefs.getBool('show_dare') ?? true;
    });
  }
  
  // Save settings to shared preferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_truth', _showTruth);
    await prefs.setBool('show_dare', _showDare);
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade100,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Settings header
                Text(
                  'Game Options',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Truth option
                _buildSettingSwitch(
                  'Show Truth Questions',
                  'Enable or disable truth questions in the game',
                  _showTruth,
                  (value) {
                    // Don't allow both to be disabled
                    if (!value && !_showDare) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('At least one option must be enabled'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    
                    setState(() {
                      _showTruth = value;
                    });
                  },
                ),
                
                const Divider(),
                
                // Dare option
                _buildSettingSwitch(
                  'Show Dare Challenges',
                  'Enable or disable dare challenges in the game',
                  _showDare,
                  (value) {
                    // Don't allow both to be disabled
                    if (!value && !_showTruth) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('At least one option must be enabled'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    
                    setState(() {
                      _showDare = value;
                    });
                  },
                ),
                
                const Divider(),
                
                const Spacer(),
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Save Settings',
                      style: GoogleFonts.poppins(
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
      ),
    );
  }
  
  Widget _buildSettingSwitch(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}
