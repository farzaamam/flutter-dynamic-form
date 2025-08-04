sealed class Content {
  final String hint;

  const Content({required this.hint});
}

class FileContent extends Content {
  const FileContent({required super.hint});
}

class TextContent extends Content {
  const TextContent({required super.hint});
}

class SelectableContent extends Content {
  final List<SelectableItem> items;

  SelectableContent(this.items, {required super.hint});
}

class SelectableItem {
  final int id;
  final String item;

  SelectableItem({required this.id, required this.item});
}
