import SwiftUI

extension RouletteGame {
    
    struct BetView: View {
        @EnvironmentObject var game: Game
        let bet: RouletteModel.BetType
        @Binding var placedBet: RouletteModel.BetType
        @Binding var isAnimating: Bool
        
        var body: some View {
            Button(action: {
                placedBet = bet
                isAnimating = true
            }) {
                Text(bet.rawValue)
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(bet == placedBet ? Colors.reverseText : Colors.text)
                    .maxWidth()
                    .frame(height: 50)
                    .background(bet == placedBet ? Colors.mainColor : .clear)
                
            }
        }
    }
    
    struct BetImageView: View {
        @EnvironmentObject var game: Game
        let bet: RouletteModel.BetType
        @Binding var placedBet: RouletteModel.BetType
        @Binding var isAnimating: Bool
        
        var body: some View {
            Button(action: {
                placedBet = bet
                isAnimating = true
            }) {
                Image(systemName: "diamond.fill")
                    .foregroundColor(bet == .red ? .red : .black)
                    .font(.title)
                    .maxWidth()
                    .frame(height: 50)
                    .background(bet == placedBet ? Colors.mainColor : Color.clear)
            }
        }
    }
    
    
    
    var betBoard: some View {
        VStack(spacing: 0){
            HStack(spacing: 0){
                BetView(bet: .firstQ, placedBet: $model.placedBet, isAnimating: $model.isAnimating)
                Divider().background(.ultraThickMaterial)
                BetView(bet: .secondQ, placedBet: $model.placedBet, isAnimating: $model.isAnimating)
                Divider().background(.ultraThickMaterial)
                BetView(bet: .thirdQ, placedBet: $model.placedBet, isAnimating: $model.isAnimating)
            }
            Divider().background(.ultraThickMaterial)
            HStack(spacing: 0){
                Group{
                    BetView(bet: .firstHalf, placedBet: $model.placedBet, isAnimating: $model.isAnimating)
                    Divider().background(.ultraThickMaterial)
                    BetView(bet: .even, placedBet: $model.placedBet, isAnimating: $model.isAnimating)
                    Divider().background(.ultraThickMaterial)
                    BetImageView(bet: .red, placedBet: $model.placedBet, isAnimating: $model.isAnimating)
                }
                Group{
                    Divider().background(.ultraThickMaterial)
                    BetImageView(bet: .black, placedBet: $model.placedBet, isAnimating: $model.isAnimating)
                    Divider().background(.ultraThickMaterial)
                    BetView(bet: .odd, placedBet: $model.placedBet, isAnimating: $model.isAnimating)
                    Divider().background(.ultraThickMaterial)
                    BetView(bet: .secondHalf, placedBet: $model.placedBet, isAnimating: $model.isAnimating)
                }
                
            }
        }
        .frame(height: 100)
        .modifier(MainButtonModifier())
        .opacity(model.status == .notStarted ? 0 : 1)
        .opacity(model.status == .roulette ? 0.5 : 1)
        .animation(.linear(duration: 0.5), value: model.status)
        .disabled(model.isAnimating ? true : false)
        .disabled(model.status == .roulette ? true : false)
        .padding(.bottom)
        
    }
    
    var landingIndicator: some View {
        Image(systemName: "arrowtriangle.down.fill")
            .font(.title3.weight(.light))
            .foregroundColor(game.color)
            .opacity(model.status == .roulette ? 1 : 0)
    }
    
    var rouletteTable: some View {
        GeometryReader { geometry in
            let size = geometry.size
            VStack(spacing: 0){
                Spacer()
                landingIndicator
                Image("RouletteTable")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: model.spinDegrees))
                    .frame(maxWidth: size.height / 1.1, alignment: .top)
                    .animation(Animation.easeOut(duration: 5.0)
                        .repeatCount(1, autoreverses: false), value: model.spinDegrees)
                    .maxWidth()
                    .overlay(alignment: .topTrailing) {
                        if let sector = model.landingSector {
                            Text("\(sector.number)")
                                .font(Fonts.title)
                                .foregroundColor(.white)
                                .frame(width: 45, height: 45)
                                .background(Circle().foregroundColor(sector.color))
                                .opacity(model.isAnimating ? 0 : 1)
                        }
                    }
                    .opacity(model.placedBet == .none ? 0.3 : 1)
                    .animation(.linear(duration: 1), value: model.placedBet)
                    .overlay{
                        Text(model.title)
                            .font(.title3.weight(.regular))
                            .foregroundColor(Colors.text)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .opacity(model.isAnimating ? 0 : 1)
                    }
                Spacer()
            }
        }
        .padding(.horizontal, 24)
    }
    

}