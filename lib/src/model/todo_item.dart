class TodoItemDTO {
  String id;
  String name;
  Status status;
  DateTime createdAt;
  TodoItemDTO(this.id, this.name, this.status, this.createdAt);
  static List<TodoItemDTO> store = [];
}

enum Status { active, completed }

enum Filter { all, active, completed }
