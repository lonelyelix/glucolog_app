import '../models/glucose_entry.dart';

class GlucoseService {
  static List<GlucoseEntry> entries = [];

  static void addEntry(GlucoseEntry entry) {
    entries.add(entry);
  }

  static List<GlucoseEntry> getEntries() {
    return entries;
  }
}