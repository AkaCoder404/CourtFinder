enum MessageType {
  text('text'),
  image('image');

  final String type;
  const MessageType(this.type);
}

extension ConvertMessage on String {
  MessageType toMessageTypeEnum() {
    switch (this) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      default:
        return MessageType.text;
    }
  }
}
