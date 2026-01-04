class PrinterSlot {
  final String id;
  final String printerId;
  final int index;
  final String? filamentId;

  PrinterSlot({
    required this.id,
    required this.printerId,
    required this.index,
    this.filamentId,
  });

  bool get isEmpty => filamentId == null;
}
