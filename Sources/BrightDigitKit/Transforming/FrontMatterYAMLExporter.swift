import Foundation
import SyndiKit
import Yams

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct FrontMatterYAMLExporter<
  SourceType,
  FrontMatterTranslatorType: FrontMatterTranslator
>: FrontMatterExporter where
  FrontMatterTranslatorType.SourceType == SourceType
{
  init(translator: FrontMatterTranslatorType) {
    self.translator = translator
  }

  let translator: FrontMatterTranslatorType
  let formatter: FrontMatterFormatter = YAMLEncoder()

  public func frontMatterText(from source: SourceType) throws -> String {
    let specs = translator.frontMatter(from: source)
    let frontMatterText = try formatter.format(specs)
    return frontMatterText
  }
}
