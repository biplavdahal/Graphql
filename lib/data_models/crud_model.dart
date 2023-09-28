class CommentModel {
  final String? id;
  final String name;
  final String email;
  final String body;

  CommentModel({
    this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      body: map['body'] as String,
    );
  }
}
