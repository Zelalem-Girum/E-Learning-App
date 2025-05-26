class StudentModels {
  String fname, mname, lname, username, email, pass;
  double balance;
  StudentModels({
    required this.fname,
    required this.lname,
    required this.mname,
    required this.username,
    required this.email,
    required this.pass,
    required this.balance,
  });
  factory StudentModels.fromJson(Map<String, dynamic> json) => StudentModels(
    fname: json['fname'] ?? '',
    mname: json['mname'] ?? '',
    lname: json['lname'] ?? '',
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    pass: json['pass'] ?? '',
    balance: json['balance'] ?? 0.0,
  );
}
