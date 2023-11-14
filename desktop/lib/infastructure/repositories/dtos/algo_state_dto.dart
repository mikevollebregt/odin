class AlgoStateDTO {
  int id, lastLocationIndex, lastMovingIndex, timeNotMoving;
  bool isMoving;

  AlgoStateDTO(
      {required this.id,
      required this.lastLocationIndex,
      required this.lastMovingIndex,
      required this.timeNotMoving,
      required this.isMoving});
}
