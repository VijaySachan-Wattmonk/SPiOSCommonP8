import SwiftUI

@MainActor
class UserListViewModel: ObservableObject,FWLoggerDelegate {
    @Published var users: [User] = []
    @Published var alertMessage: String?
    @Published var isShowingAlert = false
    let networkService = FWNetworkService(provider: URLSessionNetworkProvider())
    

    func fetchUsers() {
        Global.logThreadType(tag: tag)
        let service=networkService
        Task {
            let result = await service.requestWithQuery(
                method: .get,
                url: "https://jsonplaceholder.typicode.com/users",
                responseType: [User].self
            )
//            Global.logThreadType(tag: tag+"77777777")
            switch result {
            case .success(let fetchedUsers):
                self.users = fetchedUsers
            case .failure(let error):
                self.alertMessage = error.errorDescription
                self.isShowingAlert = true
            }
        }
    }
}
