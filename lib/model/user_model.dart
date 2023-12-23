class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;

  Map<int,String>? purchasedCategories;
  UserModel({this.uid, this.email, this.firstName, this.secondName, this.purchasedCategories});

  // receiving data from server
  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],

      //purchasedCategories: List<String>.from(map['purchasedCategories'] ?? []),
    );
  }
  // factory UserModel.fromMap(map) {
  //   return UserModel(
  //     uid: map['uid'],
  //     email: map['email'],
  //     firstName: map['firstName'],
  //     secondName: map['secondName'],
  //     premiumStatus: map['premiumStatus'],
  //
  //   );
  // }

  // sending data to our server
  Map<dynamic, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'purchasedCategories': purchasedCategories,
    };
  }
}