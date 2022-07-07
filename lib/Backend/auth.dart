import 'dart:async' as prefix0;
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'dart:math';

class AuthService {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  int track;
  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();
  StreamSubscription<DocumentSnapshot> subscription;

  // constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<String> googleSignIn() async {
    try {
      loading.add(true);

      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user = await _auth.signInWithCredential(credential);
      updateUserData(user);
      print("user name: ${user.displayName}");

      loading.add(false);
      return user.uid;
    } catch (error) {
      //return error;
      return null;
    }
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      //TODO: Set app version
      'version': 1,
    }, merge: true);
  }

  Future<void> removeInvite(int docNum, String creator) async {
    final FirebaseUser user = await _auth.currentUser();

    DocumentReference documentReference =
        _db.collection('users').document('${user.uid}');

    StreamSubscription<DocumentSnapshot> subscription1;

    subscription1 = documentReference.snapshots().listen((datasnapshot) {
      //print(datasnapshot.data.toString());

//      documentReference.updateData({'docNum': [1]});
//
//      documentReference.updateData({'creators': ["testlet.app"]});
//
//
      //     documentReference.updateData({'invitations': 1});

      if (datasnapshot.data.containsKey('invitations')) {
        int track1 = datasnapshot.data['invitations'];
        //track1--;
        List c = [];
        List d = [];

        List creatorList = [];
        List docNo = [];

        d = datasnapshot.data['docNo'];
        c = datasnapshot.data['creators'];

        for (int i = 0; i < track1; i++) {
          docNo.add(d[i]);
          creatorList.add(c[i]);
        }
        var x = [creatorList, docNo];
        int ans;
        for (int i = 0; i < track1; i++) {
          if (x[0][i] == creator && x[1][i] == docNum) {
            ans = i;
          }
        }

        docNo.removeAt(ans);
        creatorList.removeAt(ans);
        //print(ans);

        documentReference.updateData({'invitations': track1 - 1});
        documentReference.updateData({'creators': creatorList});
        documentReference.updateData({'docNo': docNo});
      }
      subscription1.cancel();
      //print("c2");
    });

    await Future.delayed(Duration(milliseconds: 1000));

    //if (check == true) return [ans, count, creator, desc, num, status];

    return null;
  }

  Future<List> getInvites() async {
    final FirebaseUser user = await _auth.currentUser();
    List ans = [];
    List count = [];
    List creator = [];
    List desc = [];
    List num = [];
    List status = [];
    bool check = false;

    DocumentReference documentReference =
        _db.collection('users').document('${user.uid}');

    StreamSubscription<DocumentSnapshot> subscription1;

    subscription1 = documentReference.snapshots().listen((datasnapshot) {
      //print(datasnapshot.data.toString());

//      documentReference.updateData({'docNum': [1]});
//
//      documentReference.updateData({'creators': ["testlet.app"]});
//
//
      //     documentReference.updateData({'invitations': 1});

      if (datasnapshot.data.containsKey('invitations')) {
        //print("rbuh");
        int track1 = datasnapshot.data['invitations'];

        if (track1 != 0 && track1 != null) {
          List creatorList = [];
          creatorList = datasnapshot.data['creators'];

          List docNo = [];
          docNo = datasnapshot.data['docNo'];

          var ref = _db.collectionGroup('testlets');

          for (int j = 0; j < track1; j++) {
            var query = ref
                .where('create', isEqualTo: true)
                .where('tno', isEqualTo: docNo[j])
                .where('creator', isEqualTo: creatorList[j])
                .getDocuments();

            query.then((QuerySnapshot docs) {
              if (docs.documents.isNotEmpty) {
                for (int i = 0; i < 1; i++) {
                  ans.add(docs.documents[i]['name'].toString());
                  count.add(docs.documents[i]['noOfCards'].toInt());
                  creator.add(docs.documents[i]['creator'].toString());
                  desc.add(docs.documents[i]['description'].toString());
                  num.add(docs.documents[i]['tno']);
                  status.add(docs.documents[i]['private']);
                  check = true;
                }
              } else {
                //print("Ok boomer");
              }
            });
          }
        }
      } else {
        //print("nothing here");
        check = false;
      }
      subscription1.cancel();
      //print("c2");
    });

    await Future.delayed(Duration(milliseconds: 1000));

    if (check == true) return [ans, count, creator, desc, num, status];

    return null;
  }

  Future<List> searchTestlets(String search) async {
    final FirebaseUser user = await _auth.currentUser();
    List ans = [];
    List count = [];
    List creator = [];
    List desc = [];
    List num = [];
    List status = [];
    bool check = false;
    var ref = _db.collectionGroup('testlets');

    var query = ref
        .where('noOfCards', isGreaterThan: 0)
        .where('private', isEqualTo: false)
        .where('create', isEqualTo: true)
        .getDocuments();

    await query.then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          ans.add(docs.documents[i]['name'].toString());
          count.add(docs.documents[i]['noOfCards'].toInt());
          creator.add(docs.documents[i]['creator'].toString());
          desc.add(docs.documents[i]['description'].toString());
          num.add(docs.documents[i]['tno']);
          status.add(docs.documents[i]['private']);
          check = true;
        }
        //docs.documents.map((doc) => ans.add(doc.data['name']));
        //ans.add("Good Job");
      } else {
        //print("Ok boomer");
        //ans.add("Kill yourslef");
      }
    });

    if (check == true) return [ans, count, creator, desc, num, status];

    return null;
  }

  Future<List> noOfTestletonce() async {
    final FirebaseUser user = await _auth.currentUser();
    List ans = [];
    List count = [];
    List creator = [];
    List desc = [];
    List num = [];
    List status = [];
    bool check = false;

    var ref =
        _db.collection('users').document('${user.uid}').collection('testlets');

    var query = ref.where('noOfCards', isGreaterThan: 0).getDocuments();
    //.getDocuments();

    await query.then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          ans.add(docs.documents[i]['name'].toString());
          count.add(docs.documents[i]['noOfCards'].toInt());
          creator.add(docs.documents[i]['creator'].toString());
          desc.add(docs.documents[i]['description'].toString());
          num.add(docs.documents[i]['tno']);
          status.add(docs.documents[i]['private']);
        }
        //docs.documents.map((doc) => ans.add(doc.data['name']));
        //ans.add("Good Job");
        check = true;
      } else {
        //print("Ok boomer");
        //ans.add("Kill yourslef");
      }
    });
/*query.snapshots().listen((data) => data.documents.forEach(
          (doc) => print(doc.data),
        ));
    query.snapshots().listen((data) {
      if (data.documents.length != 0) {
        print("theres something");
      } else {
        print("theres nothing");
      }
    });*/

    //print([ans, count, creator, desc]);
    if (check == true) return [ans, count, creator, desc, num, status];

    if (check == false) return null;
  }

  Future<List> gettestlet(int test) async {
    final FirebaseUser user = await _auth.currentUser();
    var x;
    DocumentReference documentReference = _db
        .collection('users')
        .document('${user.uid}')
        .collection('testlets')
        .document('document$test');

    subscription = documentReference.snapshots().listen((datasnapshot) {
      int loop = datasnapshot.data['noOfCards'];

      List c = [];
      c = datasnapshot.data['questions'];

      x = new List.generate(loop + 1, (_) => new List(2));
      for (int i = 0; i < loop; i++) {
        x[i][0] = datasnapshot.data['cardName${c[i]}'];
        x[i][1] = datasnapshot.data['cardNo${c[i]}'];
      }
      x[loop][0] = datasnapshot.data['create'];
      subscription.cancel();
      //print("c2");
    });
    //print("c1");
    await Future.delayed(Duration(milliseconds: 1000));
    //print("c3");
    return x;
  }

  Future<List> getother(int docNo, String name, String creator,
      String description, int count) async {
    final FirebaseUser user = await _auth.currentUser();
    var x;

    var ref = _db.collectionGroup('testlets');

    var query = ref
        .where('noOfCards', isEqualTo: count)
        .where('description', isEqualTo: description)
        .where('create', isEqualTo: true)
        .where('creator', isEqualTo: creator)
        .where('name', isEqualTo: name)
        .where('tno', isEqualTo: docNo)
        .getDocuments();

    await query.then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < 1; i++) {
          int loop = docs.documents[i]['noOfCards'];

          List c = [];
          c = docs.documents[i]['questions'];

          x = new List.generate(loop, (_) => new List(2));
          for (int i = 0; i < loop; i++) {
            x[i][0] = docs.documents[0]['cardName${c[i]}'];
            x[i][1] = docs.documents[0]['cardNo${c[i]}'];
          }
        }
        //docs.documents.map((doc) => ans.add(doc.data['name']));
        //ans.add("Good Job");
      } else {
        //print("Ok boomer");
        //ans.add("Kill yourslef");
      }
    });
    return x;
  }

  Future<bool> sendInvite(int tno, String email, String creator) async {
    bool ans = false;
    email = email.trim();
    var ref = _db.collection('users');
    var query = ref.where('email', isEqualTo: email).getDocuments();

    await query.then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < 1; i++) {
          String uidno = docs.documents[i]['uid'];

          DocumentReference documentReference =
              _db.collection('users').document('${uidno}');

          StreamSubscription<DocumentSnapshot> subscription1;

          subscription1 = documentReference.snapshots().listen((datasnapshot) {
            if (datasnapshot.data.containsKey('invitations')) {
              int track1 = datasnapshot.data['invitations'];
              //track1--;
              List c = [];
              List d = [];

              List creatorList = [];
              List docNo = [];

              d = datasnapshot.data['docNo'];
              c = datasnapshot.data['creators'];

              for (int i = 0; i < track1; i++) {
                docNo.add(d[i]);
                creatorList.add(c[i]);
              }

              docNo.add(tno);
              creatorList.add(creator);

              documentReference
                  .setData({'invitations': track1 + 1}, merge: true);
              documentReference.setData({'creators': creatorList}, merge: true);
              documentReference.setData({'docNo': docNo}, merge: true);
            } else {
              List creatorList = [];
              List docNo = [];

              docNo.add(tno);
              creatorList.add(creator);

              documentReference.setData({'invitations': 1}, merge: true);
              documentReference.setData({'creators': creatorList}, merge: true);
              documentReference.setData({'docNo': docNo}, merge: true);
            }
            subscription1.cancel();
            //print("c2");
          });
        }

        ans = true;
      } else {
        //print("no invites");
      }
    });

    return ans;
  }

  Future<List> makeACopy(int docNo, String name, String creator,
      String description, int count) async {
    List backCards = [];
    List frontCards = [];

    var ref = _db.collectionGroup('testlets');

    var query = ref
        .where('create', isEqualTo: true)
        .where('creator', isEqualTo: creator)
        .where('tno', isEqualTo: docNo)
        .getDocuments();

    await query.then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < 1; i++) {
          int loop = docs.documents[i]['noOfCards'];

          List c = [];
          c = docs.documents[i]['questions'];

          for (int i = 0; i < loop; i++) {
            frontCards.add(docs.documents[0]['cardName${c[i]}']);
            backCards.add(docs.documents[0]['cardNo${c[i]}']);
          }
        }
      } else {
        //print("Ok boomer");
      }
    });

    await updateTestlet(frontCards, backCards, backCards.length, name,
        description, true, false, creator);

    return null;
  }

  Future<List> deleteTestlet(int test) async {
    final FirebaseUser user = await _auth.currentUser();

    DocumentReference documentReference = _db
        .collection('users')
        .document('${user.uid}')
        .collection('testlets')
        .document('document$test');

    await documentReference.delete();
    StreamSubscription<DocumentSnapshot> subscription1;

    DocumentReference documentReference1 =
        _db.collection('users').document('${user.uid}');

    subscription1 = documentReference1.snapshots().listen((datasnapshot) {
      //print(datasnapshot.data);
      if (datasnapshot.data.containsKey('noOfTestlet')) {
        int track1 = datasnapshot.data['noOfTestlet'];
        track1--;
        documentReference1.setData({'noOfTestlet': (track1)}, merge: true);
      }
      subscription1.cancel();
      return null;
    });
    await Future.delayed(Duration(milliseconds: 1000));
    return null;
  }

  Future<List> getprofile() async {
    final FirebaseUser user = await _auth.currentUser();
    List x = [];
    DocumentReference documentReference =
        _db.collection('users').document('${user.uid}');

    StreamSubscription<DocumentSnapshot> subscription1;
    subscription1 = documentReference.snapshots().listen((datasnapshot) {
      if (datasnapshot.data['photoURL'] != null) {
        x.add(datasnapshot.data['photoURL'].toString());
      } else {
        x.add("null");
      }

      if (datasnapshot.data['email'] != null) {
        x.add(datasnapshot.data['email'].toString());
      } else {
        x.add("null");
      }

      if (datasnapshot.data['noOfTestlet'] != null) {
        x.add(datasnapshot.data['noOfTestlet'].toString());
      } else {
        x.add("null");
      }

      if (datasnapshot.data['displayName'] != null) {
        x.add(datasnapshot.data['displayName'].toString());
      } else {
        x.add("null");
      }

      //print(x);
      subscription1.cancel();
      //print("c2");
    });

    //print("c1");
    await Future.delayed(Duration(milliseconds: 1000));
    //print("c3");
    return x;
  }

  Future<void> changeStatus(int tno, bool t) async {
    final FirebaseUser user = await _auth.currentUser();
    //print("hi");
    DocumentReference ref = _db
        .collection('users')
        .document('${user.uid}')
        .collection('testlets')
        .document('document$tno');

    StreamSubscription<DocumentSnapshot> subscription1;

    subscription1 = ref.snapshots().listen((datasnapshot) {
      ref.setData({'private': t}, merge: true);

      subscription1.cancel();

      return null;
    });

    await Future.delayed(Duration(milliseconds: 1000));
    //print("c3");
    return null;
  }

  Future<void> modifyCard(int no, int tno, String front, String back) async {
    final FirebaseUser user = await _auth.currentUser();
    //print("hi");
    DocumentReference ref = _db
        .collection('users')
        .document('${user.uid}')
        .collection('testlets')
        .document('document$tno');

    StreamSubscription<DocumentSnapshot> subscription1;

    subscription1 = ref.snapshots().listen((datasnapshot) {
      List c = [];
      List d = [];

      c = datasnapshot.data['questions'];

      for (int i = 0; i < c.length; i++) {
        d.add(c[i]);
      }

      int g = d[no];

      ref.updateData({'cardNo$g': back});
      ref.updateData({'cardName$g': front});

      subscription1.cancel();

      return null;
    });

    await Future.delayed(Duration(milliseconds: 1000));
    //print("c3");
    return null;
  }

  Future<void> modifyInfo(int tno, String name, String description) async {
    final FirebaseUser user = await _auth.currentUser();
    //print("hi");
    DocumentReference ref = _db
        .collection('users')
        .document('${user.uid}')
        .collection('testlets')
        .document('document$tno');

    StreamSubscription<DocumentSnapshot> subscription1;

    subscription1 = ref.snapshots().listen((datasnapshot) {
      ref.updateData({'name': name});
      ref.updateData({'description': description});

      subscription1.cancel();

      return null;
    });

    await Future.delayed(Duration(milliseconds: 1000));
    //print("c3");
    return null;
  }

  Future<void> deleteCard(int no, int tno) async {
    final FirebaseUser user = await _auth.currentUser();
    //print("hi");
    DocumentReference ref = _db
        .collection('users')
        .document('${user.uid}')
        .collection('testlets')
        .document('document$tno');

    StreamSubscription<DocumentSnapshot> subscription1;

    subscription1 = ref.snapshots().listen((datasnapshot) {
      List c = [];
      List d = [];
      int noOfcards;

      c = datasnapshot.data['questions'];

      for (int i = 0; i < c.length; i++) {
        d.add(c[i]);
      }

      noOfcards = datasnapshot.data['noOfCards'];

      int g = d[no];
      noOfcards--;

      //print(d);
      d.removeAt(no);
      //print(d);

      ref.updateData({'cardNo$g': FieldValue.delete()});
      ref.updateData({'cardName$g': FieldValue.delete()});
      ref.setData({'noOfCards': noOfcards}, merge: true);
      ref.setData({'questions': d}, merge: true);

      subscription1.cancel();

      return null;
    });

    await Future.delayed(Duration(milliseconds: 1000));
    //print("c3");
    return null;
  }

  Future<void> addcards(List front, List back, int no, int tno) async {
    final FirebaseUser user = await _auth.currentUser();
    //print("hi");
    DocumentReference ref = _db
        .collection('users')
        .document('${user.uid}')
        .collection('testlets')
        .document('document$tno');

    StreamSubscription<DocumentSnapshot> subscription1;

    subscription1 = ref.snapshots().listen((datasnapshot) {
      List c = [];
      List d = [];
      int noOfcards;
      int newNo;

      c = datasnapshot.data['questions'];

      for (int i = 0; i < c.length; i++) {
        d.add(c[i]);
      }
      noOfcards = datasnapshot.data['noOfCards'];

      noOfcards = noOfcards + no;

      //c.sort();
      newNo = c.last;

      for (int i = 0; i < no; i++) {
        ref.setData({'cardName${newNo + 1}': front[i]}, merge: true);

        ref.setData({'cardNo${newNo + 1}': back[i]}, merge: true);
        d.add(newNo + 1);
        newNo++;
      }

      ref.setData({'noOfCards': noOfcards}, merge: true);
      ref.setData({'questions': d}, merge: true);

      subscription1.cancel();

      return null;
    });

    await Future.delayed(Duration(milliseconds: 1000));
    //print("c3");
    return null;
  }

  Future<void> updateTestlet(List front, List back, int no, String name,
      String description, bool private, bool create, String creator) async {
    final FirebaseUser user = await _auth.currentUser();
    //print("hi");
    DocumentReference documentReference =
        _db.collection('users').document('${user.uid}');

    List tests = [];
    var ref1 =
        _db.collection('users').document('${user.uid}').collection('testlets');

    var query = ref1.where('tno', isGreaterThan: 0).getDocuments();
    //.getDocuments();

    await query.then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          tests.add(docs.documents[i]['tno']);
        }
        //docs.documents.map((doc) => ans.add(doc.data['name']));
        //ans.add("Good Job");
        //check = true;
      } else {
        //print("Ok boomer");
        //ans.add("Kill yourslef");
      }
    });
    if (tests.length == 0) {
      track = 0;
    } else {
      track = tests[tests.length - 1];
    }
    track++;

    /*await FirebaseDatabase.instance.reference().child("Communities").once().then((DataSnapshot snapshot) {
      print(_objdatabase.toString());

      _objdatabase = snapshot.value;

    });*/

    StreamSubscription<DocumentSnapshot> subscription1;

    subscription1 = documentReference.snapshots().listen((datasnapshot) {
      //print(datasnapshot.data);
      if (datasnapshot.data.containsKey('noOfTestlet')) {
        int track1 = datasnapshot.data['noOfTestlet'];
        //print(track);
        documentReference.setData({'noOfTestlet': (track1 + 1)}, merge: true);
//        track = datasnapshot.data['noOfTestlet'];
//        //print(track);
//        track++;
      } else {
        //print("sameProblem");
        documentReference.setData({'noOfTestlet': 1}, merge: true);
        //track = 1;
      }

      List x;

      if (creator == null) {
        //creator = datasnapshot.data['displayName'];
        //if (creator == null) {
        String em = user.email.toString();
        x = em.split("@");
        creator = x[0];
        //documentReference.setData({'displayName': creator}, merge: true);
        //}
      }

      DocumentReference ref =
          documentReference.collection('testlets').document('document$track');
      List c = [];
      for (int i = 0; i < no; i++) {
        ref.setData({'cardName${i + 1}': front[i]}, merge: true);

        ref.setData({'cardNo${i + 1}': back[i]}, merge: true);
        c.add(i + 1);
      }

      ref.setData({'noOfCards': no}, merge: true);
      ref.setData({'description': description}, merge: true);
      ref.setData({'name': name}, merge: true);
      ref.setData({'tno': track}, merge: true);
      ref.setData({'creator': creator}, merge: true);
      ref.setData({'questions': c}, merge: true);
      ref.setData({'private': private}, merge: true);
      ref.setData({'create': create}, merge: true);

      subscription1.cancel();

      return null;

      //return null;
      /*if (datasnapshot.exists) {

      } else if (!datasnapshot.exists) {}*/
    });

    await Future.delayed(Duration(milliseconds: 1000));
    //print("c3");
    return null;
    //return null;
  }

  Future<void> signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      //return e.toString();
      return null;
    }
  }

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    updateUserData(user);
    //print(user.uid);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    updateUserData(user);
    return user.uid;
  }

  Future<String> currentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    return user?.uid;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _auth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  Future<bool> getIfCloud() async {

    bool x = false;

    Firestore.instance
        .collection('adminStuff')
        .document('adminRich')
        .get()
        .then((DocumentSnapshot) {

      x = DocumentSnapshot.data['cloudText'];
    });


    await Future.delayed(Duration(milliseconds: 1000));

    return x;

  }
  Future<bool> getMachineCloud() async {

    bool x = false;

    Firestore.instance
        .collection('adminStuff')
        .document('adminRich')
        .get()
        .then((DocumentSnapshot) {

      x = DocumentSnapshot.data['machineCloud'];
    });


    await Future.delayed(Duration(milliseconds: 1000));

    return x;

  }
  Future<bool> isUpToDate() async {
    FirebaseUser user = await _auth.currentUser();
    updateUserData(user);
    int userversion = 1;
    int maxversion = 1;
//    print("Second Checkpoint");

//    var ref =
//    _db.collection('adminStuff');

//    var query = ref
//        .where('admin', isEqualTo: true)
//        .getDocuments();
//
//    print("Third Checkpoint");

//    await query.then((QuerySnapshot docs) {
//      if (docs.documents.isNotEmpty) {
//          maxversion = docs.documents[0]['version'];
//          print("Suprise, max version works");
//      } else {
//        print("Bruh versions not working");
//      }
//    });

    Firestore.instance
        .collection('adminStuff')
        .document('adminRich')
        .get()
        .then((DocumentSnapshot) {
      maxversion = DocumentSnapshot.data['version'];
//          print(DocumentSnapshot.data.toString());
    });
//
//    print("Fourth Checkpoint");

//
//    DocumentReference documentReference2 = _db
//        .collection('adminStuff')
//        .document('adminRich');
//
//    subscription = documentReference2.snapshots().listen((datasnapshot) {
//
//      maxversion = datasnapshot.data['version'];
//
//      subscription.cancel();
//
//    });
//

    await Future.delayed(Duration(milliseconds: 2000));

//    print("Final Checkpoint");
//
    print("userversion is $userversion and max version is $maxversion");

    if (userversion == maxversion) {
      return true;
    } else {
      return false;
    }
  }
}

final AuthService authService = new AuthService();
