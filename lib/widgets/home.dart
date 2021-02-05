import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String key = 'VILLES';

  List<String> villes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getStorageVilles();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        drawer: drawer,
        body:  Center(
          child: this.villes.length == 0 ? emptyVill : existVille(context),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          child: Icon(Icons.add, color: Colors.white,),
          onPressed: addVill,
        ),
      )
    );
  }

  Drawer drawer = Drawer(
    child: Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              child: new Text(
                  'Metéo',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('images/photo-5.jpg')
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined, size: 30, color: Colors.pink,),
            title: new Text(
                'Accueil',
              style: new TextStyle(
                color: Colors.pink,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info_outline, size: 30, color: Colors.pink,),
            title: new Text(
              'A propos de nous !',
              style: new TextStyle(
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
      color: Colors.transparent,
    )
  );

  Future<bool> exitApp() async {
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext builder) {
          return AlertDialog(
            title: new Text(
              'Metéo',
              style: new TextStyle(
                color: Colors.pink,
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
            ),
            content: new Text(
              'Voulez-vous quitter l\'application ?',
              style: new TextStyle(
                  color: Colors.pink,
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: ( () => Navigator.of(context).pop(false)),
                  child: new Text(
                    'Annuler',
                    style: new TextStyle(
                      color: Colors.pink,
                    ),
                  )
              ),
              FlatButton(
                  onPressed: ( () => SystemNavigator.pop()),
                  child: new Text(
                    'OK',
                    style: new TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold
                    ),
                  )
              )
            ],
          );
        }
    );
  }

  Future<void> addVill() async {
    return showDialog(
      barrierDismissible: false,
        context: context,
      builder: (BuildContext builder) {
          return AlertDialog(
            title: new Text(
              'Ajouter une ville',
              style: new TextStyle(
                  color: Colors.pink,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            content: new TextField(
              decoration: InputDecoration(
                  hintText: 'Entrez le nom de la ville'
              ),
              onSubmitted: (String ville) {
                setState(() {
                  storageVille(ville);
                  Navigator.pop(context);
                });
              },
            ),
          );
      }
    );
  }
  
  Widget emptyVill = Center(
    child: new Text(
      'Aucune ville trouvé !',
      style: new TextStyle(
          fontSize: 20.0,
          color: Colors.pink,
          fontStyle: FontStyle.italic
      ),
    ),
  );

  Widget existVille(BuildContext context) {
    return ListView.builder(
        itemCount: this.villes.length,
        itemBuilder: (context, i) {
          return InkWell(
            child: Dismissible(
                key: new Key(villes[i]),
                child: Container(
                  height: 60,
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            child: Icon(Icons.cloud_download_sharp, color: Colors.white,),
                            color: Colors.pink,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        '${villes[i]}',
                        style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.pink,
                        ),
                      )
                    ],
                  ),
                ),
              background: new Container(
                color: Colors.red,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.delete_forever, size: 40, color: Colors.white,),
                    Icon(Icons.delete_forever, size: 40, color: Colors.white,)
                  ],
                ),
              ),
              onDismissed: (index) {
                 setState(() {
                   deleteVille(i);
                   _snackbar(context);
                 });
              },
            ),
          );
        }
    );
  }

  void _snackbar(BuildContext context) {
    SnackBar snackBar = new SnackBar(
        content: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever, size: 20, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text(
                        'Ville supprimée avec succès !',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
  
  void getStorageVilles() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> liste = await sharedPreferences.getStringList(key);
    if (liste != null) {
      setState(() {
        this.villes = liste;
      });
    }
  }

  void storageVille(String ville) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    this.villes.add(ville);
    await sharedPreferences.setStringList(key, this.villes);
    getStorageVilles();
  }

  void deleteVille(int index) async {
    SharedPreferences  sharedPreferences = await SharedPreferences.getInstance();
    this.villes.removeAt(index);
    await sharedPreferences.setStringList(key, this.villes);
    getStorageVilles();
  }
}
