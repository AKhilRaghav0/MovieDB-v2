

import SwiftUI

struct PersonView: View {
    @StateObject private var vm = PersonViewModel()
    @EnvironmentObject var router: Router
    let id: Int
    
    
    var body: some View {
        VStack {
            if vm.person != nil {
                PersonDetailView(person: vm.person!)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .task {
            await vm.fetchPerson(for: id)
        }
        .overlay {
            if vm.viewState == .loading {
                ProgressView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.resetAllPath()
                } label: {
                    returnButtonView()
                }
            }
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PersonView(id: 54693)
                .environmentObject(Router())
        }
    }
}

struct PersonDetailView: View {
    @State private var showFullDescription = false
    let person: Person
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                PersonPictureView
                PersonInfoView
                Divider()
                PersonBiographyView
                Divider()
                PersonFilmographyView
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var PersonPictureView: some View {
        ZStack {
            RectangleView()
            AsyncImage(url: person.profileURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    ZStack {
                        Image(systemName: "person")
                            .font(.system(size: 48))
                            .opacity(0.5)
                    }
                } else {
                    ProgressView()
                }
            }
            
        }
        .frame(width: 130, height: 180)
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black.opacity(0.2), lineWidth: 1)
        }
        .shadow(radius: 5)
    }
    
    private var PersonInfoView: some View {
        VStack(alignment: .leading) {
            Text(person.name)
                .font(.title)
                .fontWeight(.semibold)
                .lineLimit(1)
            Text(person.placeOfBirthText)
            Text(person.birthdayText)
            Text(person.knownForDepartmentText)
        }
        .font(.callout)
    }
    
    private var PersonBiographyView: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextDetailTitle(text: "Biography")
            VStack(alignment: .trailing) {
                Text(person.biographyText)
                    .lineLimit(showFullDescription ? nil : 8)
                if person.biographyText.count > 190 {
                        Button {
                            showFullDescription.toggle()
                        } label: {
                            Text(showFullDescription ? "See Less..." : "Read more...")
                                .padding(.vertical, -2)
                        }
                    .tint(.primary)
                }
            }
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var PersonFilmographyView: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextDetailTitle(text: "Filmography")
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 12) {
                    if let movieCast = person.movieCast {
                        ForEach(movieCast) { movie in
                            NavigationLink(value: movie) {
                                PosterCard(content: movie)
                                    .frame(width: 110, height: 200)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
