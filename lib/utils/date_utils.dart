String formatDateReadable(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
} // Converts DateTime(2025, 3, 24) to "24/03/2025"
