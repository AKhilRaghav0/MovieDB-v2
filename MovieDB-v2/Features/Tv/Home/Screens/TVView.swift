
import SwiftUI

struct TVView: View {
    @StateObject var vm = TVViewModel()
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.tvPath) {
            ScrollView {
                VStack {
                    BackdropCarouselView<Tv>(content: vm.airingToday)
                        .padding(.bottom, 10)
                    PosterCarouselView<Tv>(title: "Top Rated", content: vm.tvTopRated)
                    PosterCarouselView<Tv>(title: "On The Air", content: vm.onTheAir)
                    PosterCarouselView<Tv>(title: "Popular", content: vm.popular)

                }
            }
            .navigationTitle("TV Shows")
            .task {
                if !vm.hasAppeared {
                    await vm.populateTV()
                    vm.hasAppeared = true
                }
            }
            .overlay {
                if vm.isLoading {
                    ProgressView()
                }
            }
            .alert("Application Error", isPresented: $vm.hasError, presenting: vm.error) { _ in
                Button("Retry") {
                    Task {
                        await vm.populateTV()
                    }
                }
            } message: { error in
                Text(error.errorDescription ?? "Try again later")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        Task {
                            await vm.populateTV()
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(value: "SettingsView") {
//                        Image(systemName: "gear")
//                            .foregroundStyle(.orange)
//                    }
//                }
            }
            .navigationDestination(for: Tv.self) { tv in
                TVDetailView(id: tv.id)
            }
            .navigationDestination(for: Movie.self) { movie in
                DetailView(id: movie.id)
            }
            .navigationDestination(for: String.self) { i in
                SettingsView()
            }
            .navigationDestination(for: Cast.self) { cast in
                PersonView(id: cast.id)
            }
        }
    }
}

struct TVView_Previews: PreviewProvider {
    static var previews: some View {
        TVView()
            .environmentObject(Router())
    }
}
