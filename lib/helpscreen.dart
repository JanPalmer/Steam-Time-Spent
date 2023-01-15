import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SteamID64'),
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(600, double.infinity)),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    SizedBox(height: 10),
                    Text(
                      "...and where to find it",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "SteamID64 is a 17-digit ID used to uniquely identify"
                      " your Steam accound. Here are a few ways to help you find it:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "1. Through the Steam WWW site -"
                      " go to 'store.steampowered.com' and log in."
                      " Once you're logged in, click on your username and select"
                      " 'View my profile'. This will take you to your Steam profile"
                      " page. If you look at your current URL address,"
                      " to the right of the 'id' section you should see your"
                      " SteamID64. This is the number you have to insert"
                      " into this app.\n"
                      "It might not work for everyone, though, as some might've set"
                      " a custom URL for their profile, which will be displayed instead"
                      " of the ID. This case is further explained in method 2.",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "2. Using a PC Steam Client - To make your SteamID64 visible"
                      " in your Steam client,"
                      " from the main client window go through:\n"
                      "View (top-left corner) -> Settings -> Interface\n"
                      "In the tick-box section you may find"
                      " 'Display web address bars when available'"
                      " Ensure this option is ticked and choose OK to save your"
                      " settings.\n"
                      "From here you should go to your Steam profile."
                      " Your profile's URL will be between the main client"
                      " toolbar and your profile, in green font, and your SteamID64"
                      " is the 17-digit number on its right side.\n"
                      "IF YOUR URL DOES NOT CONTAIN YOUR ID, and you want to"
                      " delete your custom URL (there are other ways),"
                      " go to 'Edit Profile',"
                      " remove text from the Custom URL section and save."
                      " Now, the URL of your Profile page should contain your"
                      " SteamID64.",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "3. Using online tools - If you do not want to rid"
                      " yourself of your custom URL, copy the URL you've got"
                      " and look for conversion sites online.\n"
                      "Using sites like 'steamid.io' or 'steamid.net', you can"
                      " paste your custom URL and get different versions of your"
                      " account's SteamID. Copy the SteamID64, and paste it"
                      " inside the text field in the main window",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
