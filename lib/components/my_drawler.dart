import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawler extends StatelessWidget {
  const MyDrawler({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  size: 65,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'H O M E',
                      style: GoogleFonts.bebasNeue(
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.settings_applications,
                    color: Colors.black,
                  ),
                  title: Text(
                    'S E T T I N G S',
                    style: GoogleFonts.bebasNeue(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text(
                'Logout',
                style: GoogleFonts.bebasNeue(
                  fontWeight: FontWeight.w400,
                  fontSize: 23,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
