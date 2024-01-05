


import SwiftUI

@main
struct TheMovieDB_V2App: App {
    @StateObject var favorite = Favorite()
    @StateObject var router = Router()
    @AppStorage("interfaceTheme") private var interfaceTheme: InterfaceTheme = .auto
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favorite)
                .environmentObject(router)
                .preferredColorScheme(interfaceTheme == .auto ? nil : (interfaceTheme == .dark ? .dark : .light))
        }
    }
}
