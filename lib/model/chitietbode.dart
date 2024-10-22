class ChiTietBoDe {
  int chiTietBoDeId; // ID chi tiết bộ đề
  String questionTitle; // Tiêu đề câu hỏi
  int boDeId; // ID bộ đề
  DateTime createAt; // Thời gian tạo
  DateTime updateAt; // Thời gian cập nhật
  int trangThai; // Trạng thái (Hoạt động/Không hoạt động)

  ChiTietBoDe({
    required this.chiTietBoDeId,
    required this.questionTitle,
    required this.boDeId,
    required this.createAt,
    required this.updateAt,
    required this.trangThai,
  });
}
