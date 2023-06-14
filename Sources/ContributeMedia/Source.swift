import Contribute
import Foundation
import SyndiKit

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
public extension Podcast {
  struct Source {
    public init(episodeNo: Int, slug: String, title: String, date: Date, summary: String, content: String, audioURL: URL, imageURL: URL, duration: TimeInterval, podcastID: String, video: Video) {
      self.episodeNo = episodeNo
      self.slug = slug
      self.title = title
      self.date = date
      self.summary = summary
      self.content = content
      self.audioURL = audioURL
      self.imageURL = imageURL
      self.duration = duration
      self.video = video
      self.podcastID = podcastID
    }

    public let episodeNo: Int
    public let slug: String
    public let title: String
    public let date: Date
    public let summary: String
    public let content: String
    public let audioURL: URL
    public let imageURL: URL
    public let duration: TimeInterval
    public let video: Video
    public let podcastID: String
  }
}

public extension Podcast.Source {
  init(podcastID: String, item: RSSItem, video: Video) throws {
    guard let content = item.contentEncoded?.value ?? item.description?.value else {
      throw ImportError.invalidPodcastEpisodeFromRSSItem(item)
    }

    guard let date = item.published else {
      throw ImportError.invalidPodcastEpisodeFromRSSItem(item)
    }

    guard case let .podcast(episode) = item.media else {
      throw ImportError.invalidPodcastEpisodeFromRSSItem(item)
    }

    guard let duration = episode.duration else {
      throw ImportError.missingFieldFromPodcastEpisode(episode, .duration)
    }

    guard let title = episode.title else {
      throw ImportError.missingFieldFromPodcastEpisode(episode, .title)
    }

    guard let episodeNo = episode.episode else {
      throw ImportError.missingFieldFromPodcastEpisode(episode, .episode)
    }

    guard let summary = episode.summary?.firstSummaryParagraph() ?? episode.subtitle ?? video.description.firstParagraphText() else {
      throw ImportError.missingFieldFromPodcastEpisode(episode, .summary)
    }

    guard let imageURL = episode.image?.href else {
      throw ImportError.missingFieldFromPodcastEpisode(episode, .imageHref)
    }

    let slug = title.convertedToSlug()

    self.init(episodeNo: episodeNo, slug: slug, title: title, date: date, summary: summary, content: content, audioURL: imageURL, imageURL: imageURL, duration: duration, podcastID: podcastID, video: video)
  }

  static func episodesBasedOn(rssItems: [RSSItem], withVideos videos: [String: Video], id: @escaping (RSSItem, Video) -> String?) throws -> [Podcast.Source] {
    try rssItems.map { rssItem in
      let title = rssItem.title.trimmingCharacters(in: .whitespacesAndNewlines)
      guard let video = videos[title] else {
        throw ImportError.missingVideoForEpisode(rssItem)
      }
      guard let podcastID = id(rssItem, video) else {
        throw ImportError.invalidPodcastEpisodeFromRSSItem(rssItem)
      }
      return try .init(podcastID: podcastID, item: rssItem, video: video)
    }
  }
}
