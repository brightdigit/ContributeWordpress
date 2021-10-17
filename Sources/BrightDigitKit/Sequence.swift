extension Sequence {
  func uniqueByKey<Key: Hashable, Value>() -> [Key: Value] where Element == (Key, Value) {
    return Dictionary(uniqueKeysWithValues: self)
  }

  func groupByKey<Key: Hashable, Value>() -> [Key: [Value]] where Element == (Key, Value) {
    return Dictionary(grouping: self, by: { $0.0 }).mapValues { $0.map(\.1) }
  }
}
