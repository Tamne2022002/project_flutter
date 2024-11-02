class Account {
  String name;
  String email;
  String phone;
  String password;
  int role; 
  int xp;
  int id;

  Account({
    required this.name,
    required this.email,
    required this.phone,
    this.password = "",
    required this.role,  
    required this.xp,
    this.id = 1,
  });
}
