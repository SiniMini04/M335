import 'package:mongo_dart/mongo_dart.dart';

class DBConnection {
  final mongoUrl =
      'mongodb+srv://SinanM:TBrVZIEEv84WhC6Q@cluster0.o4chkvx.mongodb.net/M335';

  void insertUser(String UserName, String Location) async {
    var db = await Db.create(mongoUrl);
    await db.open();
    final collection = db.collection('Users');

    await collection
        .insert({'UserName': UserName, 'Location': Location, 'friends': []});

    await db.close();
  }

  void updateLocation(String UserName, String Location) async {
    var db = await Db.create(mongoUrl);
    await db.open();
    final collection = db.collection('Users');

    final query = where.eq('UserName', UserName);

    final update = ModifierBuilder();
    update.set('Location', Location);

    await collection.updateOne(query, update);

    await db.close();
  }
}
