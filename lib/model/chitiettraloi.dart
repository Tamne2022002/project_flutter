class ChiTietTraLoi {
  final int id;
  final int gameId;
  final int cauHoiId;
  final int diem;
  final int dapAnId;
  final int thoiGianTraLoi;
  final int trangThai;
  final DateTime? createAt;

  ChiTietTraLoi({
    required this.id,
    required this.gameId,
    required this.cauHoiId,
    required this.diem,
    required this.dapAnId,
    required this.thoiGianTraLoi,
    required this.trangThai,
    required this.createAt,
  });
}