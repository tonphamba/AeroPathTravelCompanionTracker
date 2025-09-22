import SwiftUI

struct CityCard: View {
    let city: City
    let onTap: () -> Void
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(city.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .glow(color: Color.aeroPrimary.opacity(0.3), radius: 2)
                        
                        Text(city.country)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: onFavoriteToggle) {
                        ZStack {
                            Circle()
                                .fill(city.isFavorite ? Color.aeroAccent.opacity(0.2) : Color.clear)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(city.isFavorite ? Color.aeroAccent : .gray)
                                .font(.title3)
                                .glow(color: city.isFavorite ? Color.aeroAccent : .clear, radius: 3)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= city.rating ? "star.fill" : "star")
                            .foregroundColor(Color.ratingColor(for: city.rating))
                            .font(.caption)
                            .glow(color: star <= city.rating ? Color.ratingColor(for: city.rating) : .clear, radius: 2)
                    }
                    
                    Spacer()
                    
                    Text(city.formattedVisitDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.aeroPrimary.opacity(0.1))
                        )
                }
                
                if !city.notes.isEmpty {
                    Text(city.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.aeroLightTertiary.opacity(0.5))
                        )
                }
                
                if !city.photos.isEmpty {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.aeroSuccess.opacity(0.2))
                                .frame(width: 24, height: 24)
                            
                            Image(systemName: "photo")
                                .foregroundColor(Color.aeroSuccess)
                                .font(.caption)
                                .glow(color: Color.aeroSuccess, radius: 2)
                        }
                        
                        Text("\(city.photos.count) photos")
                            .font(.caption)
                            .foregroundColor(Color.aeroSuccess)
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                }
            }
            .padding(20)
            .glassCardStyle()
            .hoverEffect()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CityCard(
        city: City(
            name: "Париж",
            country: "Франция",
            latitude: 48.8566,
            longitude: 2.3522,
            rating: 5,
            notes: "Невероятный город! Эйфелева башня просто потрясающая.",
            isFavorite: true
        ),
        onTap: {},
        onFavoriteToggle: {}
    )
    .padding()
    .preferredColorScheme(.dark)
}

