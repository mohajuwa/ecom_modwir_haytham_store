class ServiceNote {
  int? noteId;
  int? subServiceId;

  String? content;

  ServiceNote({
    this.noteId,
    this.subServiceId,
    this.content,
  });

  factory ServiceNote.fromJson(Map<String, dynamic> json) {
    return ServiceNote(
      noteId: json['note_id'] as int? ?? 0,
      subServiceId: json['sub_service_id'] as int? ?? 0,
      content: json['content'] as String? ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['note_id'] = this.noteId;
    data['sub_service_id'] = this.subServiceId;
    data['content'] = this.content;
    return data;
  }
}
