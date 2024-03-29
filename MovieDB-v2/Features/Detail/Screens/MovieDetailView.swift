

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                GeometryReader { geo in
                    ZStack(alignment: .bottomLeading) {
                        MovieDetailImageView
                            .frame(width: geo.size.width, height: GeometryHelper.getHeightForHeaderImage(geo))
                        
                        Rectangle()
                            .foregroundColor(.black.opacity(0.5))
                            .frame(width: geo.size.width, height: 80)
                        
                        MovieDetailTitleView
                    }
                    .offset(x: 0, y: GeometryHelper.getOffsetForHeaderImage(geo))
                }
                .frame(height: UIScreen.main.bounds.height * 0.5)
                
                VStack(alignment: .leading, spacing: 20) {
                    MovieDetailOverviewView
                    MovieDetailDistributionView
                    MovieDetailTrailerView
                    MovieDetailRecommendationsView
                }
                .padding(.horizontal)
                .padding(.bottom, 90)
            }
        }
        .ignoresSafeArea()
    }
    
    private var MovieDetailImageView: some View {
        AsyncImage(url: movie.backdropOriginalURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if phase.error != nil {
                Image(systemName: "film")
                    .font(.system(size: 48))
                    .opacity(0.5)
            } else {
                ProgressView()
            }
        }
    }
    
    private var MovieDetailTitleView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(movie.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text("★ \(movie.voteAverageText)   \(movie.durationText)   \(movie.yearText)")
                .font(.callout)
                .fontWeight(.medium)
            
            Text(movie.genreText)
                .font(.footnote)
        }
        .foregroundColor(.white.opacity(0.7))
        .shadow(radius: 7)
        .padding(.leading)
        .padding(.bottom, 8)
    }
    
    private var MovieDetailOverviewView: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextDetailTitle(text: "Overview")
            Text(movie.overview)
                .font(.callout)
        }
        .padding(.top, 5)
    }
    
    private var MovieDetailDistributionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextDetailTitle(text: "Distribution")
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 10) {
                    if let cast = movie.cast, !cast.isEmpty {
                        ForEach(cast.prefix(9)) { cast in
                            NavigationLink(value: cast) {
                                VStack(alignment: .leading) {
                                    ZStack {
                                        RectangleView()
                                            .shadow(radius: 4)
                                        
                                        AsyncImage(url: cast.profileURL) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .shadow(radius: 4)
                                            } else if phase.error != nil {
                                                Image(systemName: "person")
                                                    .font(.system(size: 25))
                                                    .opacity(0.5)
                                            } else {
                                                ProgressView()
                                            }
                                        }
                                    }
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(20)
                                    
                                    Text(cast.name)
                                        .font(.footnote)
                                    Text(cast.character)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                .frame(width: 80)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
    
    private var MovieDetailRecommendationsView: some View {
        VStack(alignment: .leading, spacing: 15) {
            if movie.recommendationsVideo != nil {
                    TextDetailTitle(text: "Recommendations")
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .top, spacing: 12) {
                            ForEach(movie.recommendationsVideo!) { movie in
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
    
    private var MovieDetailTrailerView: some View {
        VStack(alignment: .leading, spacing: 15) {
            if movie.video != nil {
            TextDetailTitle(text: "Trailer")
                ForEach(movie.video!.prefix(1)) { video in
                    VideoView(key: video.key)
                        .aspectRatio(16/9,contentMode: .fit)
                    
                }
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie.localMovie)
    }
}
