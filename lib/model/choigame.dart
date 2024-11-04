class ChoiGame {
  final int id;
  final int boDe_ID;
  final int chuDe_ID;
  final int nguoiDung_ID;
  final String theLoai;
  final int trangThai;
  final DateTime? create_at;
  final int tongDiem;

  ChoiGame({
    required this.id,
    required this.boDe_ID,
    required this.chuDe_ID,
    required this.nguoiDung_ID,    
    required this.theLoai,
    required this.trangThai,
    required this.create_at,
    required this.tongDiem,
  });
}
