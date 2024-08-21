import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/pages/filters_page.dart';

const kInitialFilter = {
  Filter.work: false,
  Filter.food: false,
  Filter.fun: false,
  Filter.hobby: false,
  Filter.travel: false,
  Filter.others: false,
};

class MyDrawler extends StatefulWidget {
  const MyDrawler({super.key});

  @override
  State<MyDrawler> createState() => _MyDrawlerState();
}

class _MyDrawlerState extends State<MyDrawler> {
  Map<Filter, bool> _selectedFilters = kInitialFilter;

  void setFilter() async {
    Navigator.of(context).pop();
    final result = await Navigator.of(context).push<Map<Filter, bool>>(
      MaterialPageRoute(
        builder: (ctx) => const FiltersPage(),
      ),
    );
    setState(() {
      _selectedFilters = result ?? kInitialFilter;
    });
  }

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
                  title: GestureDetector(
                    onTap: setFilter,
                    child: Text(
                      'F I L T E R S',
                      style: GoogleFonts.bebasNeue(
                        color: Colors.black,
                        fontSize: 23,
                      ),
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
