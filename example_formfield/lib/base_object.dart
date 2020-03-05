class BaseObject {
  const BaseObject({this.id, this.name});

  final int id;
  final String name;

  bool get isValid => id != null && name != null;

  bool get isNotValid => !isValid;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseObject &&
          runtimeType == other.runtimeType &&
          this.hashCode == other.hashCode;

  @override
  String toString() {
    return '$name';
  }
}
