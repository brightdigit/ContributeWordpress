@testable import ContributeWordPress
import XCTest

// TODO: Please finish this.
internal final class AssetImportTests_WordPress: XCTestCase {
  internal func testExtractAssetImports() throws {
    let site: WordPressSite = try .make(
      link: try .make(string: "https://leogdion.name"),
      posts: [
        .productivityAppsPost()
      ]
    )

    let rootPublishSiteURL: URL = .temporaryDirURL
    let assetImports = AssetImport.extractAssetImports(
      from: site,
      using: Settings(
        rootPublishSiteURL: rootPublishSiteURL,
        exportsDirectoryURL: rootPublishSiteURL
          .appendingPathComponent("WordPress/exports")
      )
    )

    for assetImport in assetImports {
      print(assetImport.fromURL)
      print(assetImport.atURL)
    }
  }
}
