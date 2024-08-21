import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Filter {
  work,
  fun,
  travel,
  food,
  hobby,
  others,
}

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  var _workFilter = false;
  var _foodFilter = false;
  var _funFilter = false;
  var _travelFilter = false;
  var _hobbyFilter = false;
  var _othersFilter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) return;
          Navigator.of(context).pop({
            Filter.work: _workFilter,
            Filter.food: _foodFilter,
            Filter.fun: _funFilter,
            Filter.hobby: _hobbyFilter,
            Filter.travel: _travelFilter,
            Filter.others: _othersFilter,
          });
        },
        child: Column(
          children: [
            SwitchListTile(
              value: _workFilter,
              onChanged: (isChecked) {
                setState(() {
                  _workFilter = isChecked;
                });
              },
              title: Text('Work'),
              subtitle: Text('Category'),
              activeColor: Colors.red,
            ),
            SwitchListTile(
              value: _hobbyFilter,
              onChanged: (isChecked) {
                setState(() {
                  _hobbyFilter = isChecked;
                });
              },
              title: Text('Hobby'),
              subtitle: Text('Category'),
              activeColor: Colors.red,
            ),
            SwitchListTile(
              value: _funFilter,
              onChanged: (isChecked) {
                setState(() {
                  _funFilter = isChecked;
                });
              },
              title: Text('Fun'),
              subtitle: Text('Category'),
              activeColor: Colors.red,
            ),
            SwitchListTile(
              value: _foodFilter,
              onChanged: (isChecked) {
                setState(() {
                  _foodFilter = isChecked;
                });
              },
              title: Text('Food'),
              subtitle: Text('Category'),
              activeColor: Colors.red,
            ),
            SwitchListTile(
              value: _travelFilter,
              onChanged: (isChecked) {
                setState(() {
                  _travelFilter = isChecked;
                });
              },
              title: Text('Travel'),
              subtitle: Text('Category'),
              activeColor: Colors.red,
            ),
            SwitchListTile(
              value: _othersFilter,
              onChanged: (isChecked) {
                setState(() {
                  _othersFilter = isChecked;
                });
              },
              title: Text('Others'),
              subtitle: Text('Category'),
              activeColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
