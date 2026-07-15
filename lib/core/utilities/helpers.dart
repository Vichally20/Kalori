/// Extracts initials from a full name.
///
/// Takes the first letter of each word (up to 2) and returns them uppercased.
/// Returns an empty string if the input is empty or blank.
///
/// Examples:
///   'John Doe'       → 'JD'
///   'Alice'          → 'A'
///   'John Middle Doe' → 'JD'
///   ''               → ''
String nameToInitials(String fullName) {
  final trimmed = fullName.trim();
  if (trimmed.isEmpty) return '';

  final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();

  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  }

  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
