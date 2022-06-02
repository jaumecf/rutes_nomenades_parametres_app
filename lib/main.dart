import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => ColorScreen(),
        '/edit': (context) => EditColorScreen(),
      },
    );
  }
}

class ColorScreen extends StatefulWidget {
  ColorScreen({Key? key}) : super(key: key);

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  Color _color = Color.fromARGB(255, 255, 0, 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutes amb paràmetres'),
      ),
      backgroundColor: _color,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            child: Text('Canviar color'),
            onPressed: () {
              // Fixau-vos que pushNamed, té un pa`rametre opcional
              // que no haviem emprat abans, arguments
              Navigator.of(context)
                  .pushNamed('/edit', arguments: _color)
                  .then((value) {
                if (value != null) {
                  setState(() {
                    _color = value as Color;
                  });
                }
              });
            },
          ),
        ),
      ),
    );
  }
}

class EditColorScreen extends StatefulWidget {
  EditColorScreen({Key? key}) : super(key: key);

  @override
  State<EditColorScreen> createState() => _EditColorScreenState();
}

class _EditColorScreenState extends State<EditColorScreen> {
  late List<TextEditingController> _controllers;
  /*
  // Dintre de initState no es poden emprar inherited Widgets
  // Ho substituirem pel didChangeDependencies
  /*
  FlutterError (dependOnInheritedWidgetOfExactType<_ModalScopeStatus>() or 
  dependOnInheritedElement() was called before _EditColorScreenState.initState() completed.
  When an inherited widget changes, for example if the value of Theme.of() 
  changes, its dependent widgets are rebuilt. If the dependent widget's 
  reference to the inherited widget is in a constructor or an initState() method, 
  then the rebuilt dependent widget will not reflect the changes in the inherited widget.
  Typically references to inherited widgets should occur in widget build() methods. 
  Alternatively, initialization based on inherited widgets can be placed in the 
  didChangeDependencies method, which is called after initState and whenever 
  the dependencies change thereafter.)*/
  @override
  void initState() {
    final Color color = ModalRoute.of(context)!.settings.arguments as Color;
    _controllers = [for (int i = 0; i < 3; i++) TextEditingController()];
    super.initState();
  }
  */

  @override
  void didChangeDependencies() {
    final Color color = ModalRoute.of(context)!.settings.arguments as Color;
    final List<String> colors = [
      color.red.toString(),
      color.green.toString(),
      color.blue.toString()
    ];
    _controllers = [
      for (int i = 0; i < 3; i++)
        TextEditingController(
          text: colors[i],
        )
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // No podem recuperar els arguments aquí ja que no tenc forma d'assignar-ho al controller
    // final Color color = ModalRoute.of(context)!.settings.arguments as Color;
    const List<String> colors = ['red', 'green', 'blue'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutes amb paràmetres'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                for (int i = 0; i < 3; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _controllers[i],
                        decoration: InputDecoration(labelText: colors[i]),
                      ),
                    ),
                  ),
              ],
            ),
            ElevatedButton(
              child: Text('Desa'),
              onPressed: () {
                final int r = int.parse(_controllers[0].text);
                final int g = int.parse(_controllers[1].text);
                final int b = int.parse(_controllers[2].text);
                Navigator.of(context).pop(Color.fromARGB(255, r, g, b));
              },
            ),
          ],
        ),
      ),
    );
  }
}
