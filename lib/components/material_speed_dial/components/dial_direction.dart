
enum _Direction { left, right, up, down }

class DialDirection {

  const DialDirection(this.direction);

  final _Direction direction;

  static const left = DialDirection(_Direction.left);

  static const right = DialDirection(_Direction.right);

  static const up = DialDirection(_Direction.up);

  static const down = DialDirection(_Direction.down);

  static bool isVertical(DialDirection direction) => direction == up || direction == down;

  static bool isHorizontal(DialDirection direction) => !isVertical(direction);

  static int getCoefficient(DialDirection direction) {
    if (direction == DialDirection.left || direction == DialDirection.up) {
      return -1;
    } else if (direction == DialDirection.right || direction == DialDirection.down) {
      return 1;
    } else {
      return 0;
    }
  }

  static int getHorizontalCoefficient(DialDirection direction) {
    if (DialDirection.isHorizontal(direction)) {
      if (direction == DialDirection.left) {
        return -1;
      }
      return 1;
    }
    return 0;
  }

  static int getVerticalCoefficient(DialDirection direction) {
    if (DialDirection.isVertical(direction)) {
      if (direction == DialDirection.up) {
        return -1;
      }
      return 1;
    }
    return 0;
  }

  @override
  bool operator == (dynamic other) => direction == other.direction;

  @override
  int get hashCode => direction.hashCode;

}


