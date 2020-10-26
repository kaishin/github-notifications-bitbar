#!/usr/bin/swift

// # <bitbar.title>GitHub Notifications</bitbar.title>
// # <bitbar.version>v1.0</bitbar.version>
// # <bitbar.author>Reda Lemeden</bitbar.author>
// # <bitbar.author.github>kaishin</bitbar.author.github>
// # <bitbar.desc>Displays all your GitHub notifications in the menubar.</bitbar.desc>
// # <bitbar.image>https://github.com/kaishin/github-notifications-bitbar/raw/master/screenshot.png</bitbar.image>
// # <bitbar.dependencies>swift</bitbar.dependencies>
// # <bitbar.abouturl>https://github.com/kaishin/github-notifications-bitbar</bitbar.abouturl>

import Foundation

// Paste your GitHub API token key here.
// More info on how to generate a new one: https://github.com/blog/1509-personal-api-tokens
let GitHubAPIKey = ""
let showCountBadge = false

// Do not edit below this line unless you know what you are doing.

#if swift(>=4.0)
  struct GitHubNotification: Codable {
    let dateUpdated: Date
    let dateLastRead: Date?
    let unread: Bool
    let reason: String
    let subject: Subject
    let repository: Repository

    enum CodingKeys: String, CodingKey {
      case dateUpdated = "updated_at"
      case dateLastRead = "last_read_at"
      case unread
      case reason
      case subject
      case repository
    }

    enum NotificationType: String, Codable {
      case issue = "Issue"
      case pullRequest = "PullRequest"
      case commit = "Commit"
      case release = "Release"
      case invitation = "RepositoryInvitation"
      case vulnerabilityAlert = "RepositoryVulnerabilityAlert"
    }

    struct Subject: Codable {
      let title: String
      let url: String
      let latestCommentURL: String?
      let type: NotificationType

      enum CodingKeys: String, CodingKey {
        case latestCommentURL = "latest_comment_url"
        case title
        case url
        case type
      }

      var latestCommentIdentifier: String? {
        guard let latestCommentURL = latestCommentURL, type == .issue, let urlComponents = URLComponents(string: latestCommentURL),
          let commentID = urlComponents.path.split(separator: "/").last.map({ String($0) }) else {
            return nil
        }

        return "#issuecomment-" + commentID
      }

      var lastCommentURL: String {
        return url.replacingOccurrences(of: "https://api.github.com/repos/", with: "https://github.com/")
          .replacingOccurrences(of: "pulls", with: "pull")
          + (latestCommentIdentifier ?? "")
      }

      var icon: String {
        switch type {
        case .issue, .vulnerabilityAlert:
          return "iVBORw0KGgoAAAANSUhEUgAAABUAAAAYCAYAAAAVibZIAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAGuSURBVDiNvdVNb01RFAbgp7eE9KZNGJCSa9iUxMcfICHEsONGxITowEjMEGOJgUTiFxhIfYwRNOFHKGY+rjAgNIqQHoO9Tu51c/a5pxre5EzW2u971tp77XfzDzAyJN/GAXSwCZ/wGk/wdbU/24e7+Iai4lvGHextUul6XMUcWviOx1jEB2zBThzERqzgOs7iZ67VhajkM85jPNPJOC7gS6xfCP4faEW7BZ5jKiM2iGm8CN5tA53PReIttlWQ+/dzENvRjdypMtjGuwgeylRUJwpHItcNPccicC9DaCIKDyI/28JMBG/UEJqg5M+QDqaQ9iaHJpV2Ir8IS/iF0TWKjobOUmvIwtWgHKeVddLJT2ESbzKEyw1EJ6VquzAvVXt8TXVyInRu0hup+zWEJnv6MPKzpGEtb8ThvxQ9qncjx8rgab0bUTVadaIdvRt5sj8xIvljIRnEdKaiQezCy+DNqzD9tuSdhTS7FzGREZvApVhX4JE+66sy6Ss4I9nhD8krn+E9tuqZ9AbJpK/hnDT4tdgj+eOy/HNyC7uryMMevjHsxw5sxke8wtMQ/n/4DYAHhwJg3MAfAAAAAElFTkSuQmCC"
        case .commit:
          return "iVBORw0KGgoAAAANSUhEUgAAABUAAAAYCAYAAAAVibZIAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAADrSURBVDiN7dNNSsNQFMXxn0HX4MQlWFyIFLS6AAUnYhEpgmtw7tQPdAsuQJeibRW3oGI6eC/4EhNtOpT84cHlhHOSd+8NHR1NbOAOU3xiglv0Fg08xgfymvOOo7aBu5WQKR7wkmhfGMwbuIJxYjxBFp9lGEU9xzOWqwFLOKtoaxjG+hIHNS++wn6sL4Rel6jrWXE2G27T/82XNZjSm7TREfpxXtFWsRfrAe5rfNtJfYO3Pz7ux6BGyoM69T2oJzWDamInMebCKj3iVXmltuYNLBgKS960/IdtAwt6Qs8mwt81xjXWFw3s+O/MAM4WTupM6nylAAAAAElFTkSuQmCC"
        case .pullRequest:
          return "iVBORw0KGgoAAAANSUhEUgAAABIAAAAYCAYAAAD3Va0xAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAEVSURBVDiN7dQtTkNBFMXxX5uQsIUiCEGioQVXPIoPi2QTmKfYAOAxrIANgICkYKBdQCtRLQIMBkTnpZfSTps6Ek5yMnfmnvzfzXt5w3xaxXEuUE3rCk6Sa2OZNdxhfdbTGhignTxAPUC6+EIxC/SA87C/wP0YJHqA60kTfqAZ9k2843YCJLqPzQh6DBNVcIlWZqLoLpZL0DbeDN9PJ43eSL0IK9LZBnoBth+nKkKj8FMlLJ6fhfwpo8+fUw+7aS31GeqleUEl7CoXmBc0U/+gvwiCHaNfpJ3qxiL5J7+vkVYGNDU/7RqZpon5Kl5wEBqHeM6AYr6CozJfN7w6Osl9bGVAZb4d85XUrGEv1Td4zYAWyc+vbzqeYalxHB9XAAAAAElFTkSuQmCC"
        case .release:
          return "iVBORw0KGgoAAAANSUhEUgAAABUAAAAYCAYAAAAVibZIAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAExSURBVDiNzdS9SgNREIbhJxgsQ1DSq9ehnVfgLQgWEsUm2BhjDBaCnTbiNXgJVtqo2CuowVYQLRR/8K/YsxDDru4mCn4w7O6Zb98zwxkOf6BC13cFUyh3rd9gD+28G0ziGi+4xEVH3OMRC3mAlQDcRSkhX0Qd72hkhc6ECksYx2KIiS5fNQ+4IWoZVvARopXgjcHLabBieBaCMYu28Izt8F8zDdqpA6yH9/0U8A4GsSnqaDXJ1MB5xko7NSvqsJ6UnMaD5Mp7Bo/iSY5xSQEvwUBYvBMN9xpucZgTeiya8w3RIX5RK+w431O91PCalIjBczmBQzjBaZqhKV/FZRzhCmPfGWPwTxVnBmYF5wZ2g6u/BUwD9w2MFU9FTXTKbYz0A4zVwBvOfgsYa1hvd8Q/1CfyO1PHqoMuVAAAAABJRU5ErkJggg=="
        case .invitation:
          return "iVBORw0KGgoAAAANSUhEUgAAABIAAAAYCAYAAAD3Va0xAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAACnSURBVDiN7dQ9CgIxEIbhRxHB82i3Cx5Ly4CL4L30HuIFrLVZi434Q8RNtrHwhTBhEr7Ml4GBLS5oC9cFzShupjp28qmx8KZeQkA7/nSQq5YS2iuz+Lf2meBvrRe/Z200QOCFSYwHnaUSalRiRWFAMcGXrmX93QTXWNoq5qrEvVUid6fSTVmN4TN7k3rhbu2cYy31R3DCHOs+Ijza/8wRyxh3mPURugELYFwleKMYQwAAAABJRU5ErkJggg=="
        }
      }
    }

    var url: String {
      return subject.lastCommentURL
    }

    var firstLine: String {
      return "\(subject.title) | href=\(url) templateImage=\(subject.icon)"
    }
  }

  struct Repository: Codable {
    let url: String
    let name: String

    enum CodingKeys: String, CodingKey {
      case url = "html_url"
      case name = "full_name"
    }
  }

  extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
      return lhs.name == rhs.name
    }
  }

  func printOutput(_ notifications: [GitHubNotification]) {
    let repositoryNames = notifications.reduce([String]()) { names, notification in
      let repoName = notification.repository.name

      if !names.contains(repoName) {
        return names + [repoName]
      } else {
        return names
      }
    }

    let groupedNotification = Dictionary(grouping: notifications, by: { $0.repository.name })

    print(notifications.count > 0 ? newNotificationsIcon(showCountBadge ? notifications.count : nil) : allReadIcon)
    print("---")
    print("\(notifications.count) unread notification\(notifications.count == 1 ? "" : "s") | href=https://github.com/notifications")
    print("View Notifications on GitHub... | href=https://github.com/notifications alternate=true")
    print("Refresh | href=bitbar://refreshPlugin?name=github-notifications.?*.swift")
    print("---")

    for repositoryName in repositoryNames {
      print(repositoryName)

      for notification in groupedNotification[repositoryName]! {
        print(notification.firstLine)
      }
    }

    requestSemaphore.signal()
  }

  func printError(_ error: Error) {
    print("⚠️")
    print("---")
    print("The following error has occured:")
    print(error.localizedDescription)
    requestSemaphore.signal()
  }

let allReadIcon = "○| color=#585E5E size=13"

func newNotificationsIcon(_ count: Int? = nil) -> String {
  let countString: String = count == nil ? "" : String(describing: count!)
  return  "● \(countString)| color=#2079F2 size=13"
}


let config = URLSessionConfiguration.default
config.httpAdditionalHeaders = ["Authorization": "token \(GitHubAPIKey)", "Accept": "application/json"]
config.requestCachePolicy = .reloadIgnoringLocalCacheData
config.urlCache = nil
let session = URLSession(configuration: config)

let url: URL

if let bundleIdentifier = Bundle.main.bundleIdentifier,
  bundleIdentifier.hasPrefix("com.apple.dt") {
  url = URL(string: "http://www.mocky.io/v2/5a5141162f00001c208d5373")!
} else {
  url = URL(string: "https://api.github.com/notifications")!
}

var requestSemaphore = DispatchSemaphore(value: 0)

let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
  guard let data = data else {
    let error = NSError(domain: "co.kaishin.bitbar.GitHubNotifications", code: 9000, userInfo: [NSLocalizedDescriptionKey: "No data to parse."])
    printError(error)
    return
  }

  do {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let notifications = try decoder.decode([GitHubNotification].self, from: data)
    printOutput(notifications)
  } catch let error {
    printError(error)
  }
})

if GitHubAPIKey.isEmpty {
  print("⚠️")
  print("---")
  print("The GitHub API key is missing. Please add it in the script file.")
} else {
  task.resume()
}

requestSemaphore.wait()

#else
  print("⚠️")
  print("---")
  print("✕ Swift 4+ is required.")
#endif
