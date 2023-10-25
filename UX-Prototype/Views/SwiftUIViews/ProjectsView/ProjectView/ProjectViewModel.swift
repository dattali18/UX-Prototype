import Foundation


class ProjectViewModel: ObservableObject {
    @Published var isFetchingData = false
    @Published var commits: [CommitInfo] = []
    
    var project: Project?
    
    init(project: Project?) {
        self.project = project
    }
    
    func fetchData() {
        isFetchingData = true
        self.fetchData(from: project?.url ?? "")
        
    }

    func fetchData(from link: String) {
        guard let username = extractUsername(from: link), let reponame = extractReponame(from: link) else {
            print("Invalid GitHub link format")
            self.isFetchingData = false
            return
        }
        
        fetchCommits(from: "\(username)/\(reponame)", lastNCommits: 5) { commitData in
            DispatchQueue.main.async {
                self.commits = commitData
                self.isFetchingData = false
            }
        }
        
    }

    func fetchCommits(from repository: String, lastNCommits: Int, completion: @escaping ([CommitInfo]) -> Void) {
        let urlString = "https://api.github.com/repos/\(repository)/commits?per_page=\(lastNCommits)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var commitInfoArray = [CommitInfo]()
                    for json in jsonArray {
                        if let commit = json["commit"] as? [String: Any],
                           let author = commit["author"] as? [String: Any],
                           let name = author["name"] as? String,
                           let message = commit["message"] as? String,
                           let authorDate = author["date"] as? String {
                            
                            let dateFormatter = ISO8601DateFormatter()
                            if let date = dateFormatter.date(from: authorDate) {
                                let formattedDate = self.formatDate(date) // Format the date
                                let commitInfo = CommitInfo(authorName: name, commitMessage: message, commitDate: formattedDate)
                                commitInfoArray.append(commitInfo)
                            }
                        }
                    }
                    completion(commitInfoArray)
                } else {
                    print("Error parsing JSON data")
                    completion([])
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion([])
            }
        }
        
        task.resume()
    }
    
    private func extractUsername(from link: String) -> String? {
        // Split the link by '/'
        let components = link.components(separatedBy: "/")
        
        // GitHub links typically have the username at the third component
        if components.count > 2 {
            return components[3]
        }
        
        return nil
    }

    private func extractReponame(from link: String) -> String? {
        // Split the link by '/'
        let components = link.components(separatedBy: "/")
        
        // GitHub links typically have the reponame at the fourth component
        if components.count > 3 {
            return components[4]
        }
        
        return nil
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }

}

struct CommitInfo: Identifiable{
    let id = UUID()
    let authorName: String
    let commitMessage: String
    let commitDate: String
}
