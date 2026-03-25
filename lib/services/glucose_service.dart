import '../models/glucose_entry.dart';

class GlucoseService {
  static final List<GlucoseEntry> _entries = [];

  static void addEntry(GlucoseEntry entry) {
    _entries.add(entry);
  }

  static List<GlucoseEntry> getEntries() {
    return _entries;
  }

  static void deleteEntry(GlucoseEntry entry) {
    _entries.remove(entry);
  }
}
