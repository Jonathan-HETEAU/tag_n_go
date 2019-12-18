class Tag {
  final String name;
  final bool activated;
  final List<bool> days;

  Tag(
      {this.name,
      this.activated = true,
      this.days = const [true, true, true, true, true, true, true]});
}
