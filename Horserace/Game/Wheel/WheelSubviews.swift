import SwiftUI

@available(iOS 14.0, *)
public struct FortuneWheel: View {
    var titles: [String]
    var onSpinEnd: ((Int) -> ())?
    let size: CGSize
    @StateObject var viewModel: FortuneWheelViewModel
    
    public init(titles: [String], size: CGSize, onSpinEnd: ((Int) -> ())?) {
        self.size = size
        self.titles = titles
        _viewModel = StateObject(wrappedValue: FortuneWheelViewModel(titles: titles, onSpinEnd: onSpinEnd))
    }
    
    public var body: some View {
        
        ZStack(alignment: .top) {
            SpinWheelView(data: (0..<titles.count).map { _ in Double(100/titles.count) }, labels: titles, size: size)
                .frame(maxWidth: size.width, maxHeight: size.width)
                .rotationEffect(.degrees(viewModel.degree))
                .gesture(
                    DragGesture().onChanged({ (value) in
                        if value.translation.width < 0 {
                            viewModel.degree = Double(-value.translation.width)
                        }
                    }).onEnded({ (value) in
                        viewModel.spinWheel()
                    })
                )
                .overlay(alignment: .top){
                    SpinWheelPointer().offset(x: 0, y: -8)
                }
                .overlay(alignment: .center) {
                    SpinWheelBolt()
                }
            
            
            
        }
        
    }
}

struct SpinWheelCell: Shape {
    
    let startAngle: Double, endAngle: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        let alpha = CGFloat(startAngle)
        let center = CGPoint(
            x: rect.midX,
            y: rect.midY
        )
        path.move(to: center)
        path.addLine(
            to: CGPoint(
                x: center.x + cos(alpha) * radius,
                y: center.y + sin(alpha) * radius
            )
        )
        path.addArc(
            center: center, radius: radius,
            startAngle: Angle(radians: startAngle),
            endAngle: Angle(radians: endAngle),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}


@available(iOS 13.0, *)
struct SpinWheelPointer: View {
    var body: some View {
        Triangle().frame(width: 50, height: 50)
            .foregroundColor(.red)
            .cornerRadius(24)
            .rotationEffect(.init(degrees: 180))
            .shadow(color: .black.opacity(0.4), radius: 5, x: 0.0, y: 1.0)
    }
}

@available(iOS 13.0, *)
struct SpinWheelBolt: View {
    @EnvironmentObject var game: Game
    var body: some View {
        ZStack {
            Circle().frame(width: 28, height: 28)
                .foregroundColor(game.color)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0.0, y: 1.0)
            Circle().frame(width: 18, height: 18)
                .foregroundColor(game.color)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0.0, y: 1.0)
        }
    }
}

@available(iOS 13.0, *)
struct SpinWheelView: View {
    
    var data: [Double]
    var labels: [String]
    let size: CGSize
    
    private let colors: [Color] = [Colors.blue, Colors.teal, Colors.cyan, Colors.mint, Colors.green, Colors.yellow, Colors.orange, Colors.red, Colors.purple, Colors.indigo]
    private let sliceOffset: Double = -.pi / 2
    
    var body: some View {
        ZStack(alignment: .center) {
            ForEach(data.indices, id: \.self) { index in
                SpinWheelCell(startAngle: startAngle(for: index), endAngle: endAngle(for: index))
                    .fill(colors[index % colors.count])
                Text(labels[index])
                    .foregroundColor(Color.white)
                    .font(.body.weight(.regular))
                    .rotationEffect(Angle(degrees: labelRotation(index: index)))
                    .rotationEffect(Angle(degrees: -90))
                    .offset(viewOffset(for: index, in: size)).zIndex(1)
                
            }
        }
    }
    
    func labelRotation(index: Int) -> Double {
        let singleSliceDegree = 360 / data.count
        let halgSingleSlice = singleSliceDegree / 2
        return Double(halgSingleSlice + (index * singleSliceDegree))
    }
    
    private func startAngle(for index: Int) -> Double {
        switch index {
        case 0: return sliceOffset
        default:
            let ratio: Double = data[..<index].reduce(0.0, +) / data.reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }
    
    private func endAngle(for index: Int) -> Double {
        switch index {
        case data.count - 1: return sliceOffset + 2 * .pi
        default:
            let ratio: Double = data[..<(index + 1)].reduce(0.0, +) / data.reduce(0.0, +)
            return sliceOffset + 2 * .pi * ratio
        }
    }
    
    private func viewOffset(for index: Int, in size: CGSize) -> CGSize {
        let radius = min(size.width, size.height) / 3
        let dataRatio = (2 * data[..<index].reduce(0, +) + data[index]) / (2 * data.reduce(0, +))
        let angle = CGFloat(sliceOffset + 2 * .pi * dataRatio)
        return CGSize(width: radius * cos(angle), height: radius * sin(angle))
    }
}