import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

struct Arrow: Shape {
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let triangle = Triangle()
        let rectangle = Rectangle()
        
        path.addPath(triangle.path(in: CGRect(x: 0, y: 0, width: thickness, height: rect.height / 2)))
        path.addPath(rectangle.path(in: CGRect(x: rect.width / 2 - rect.width / 4, y: rect.height / 2, width: thickness / 2, height: rect.height / 3)))
        return path
    }
}

struct ColorCyclingRect : View {
    var layers = 200
    var amount = 0.0
    
    var body: some View {
        ZStack {
            ForEach(0..<layers) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors:
                        [self.color(for: value, brightness: 1), self.color(for: value, brightness: 2)]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)), lineWidth: 5)
            }
        }.drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.layers) + self.amount
        if targetHue > 1 {
            targetHue -= 1
        }
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}


struct ContentView: View {
    @State var thick: CGFloat = 100
    @State var lineThick: CGFloat = 10
    @State private var cycle = 0.0

    var body: some View {
        VStack {
//            Spacer()
            ZStack {
                ColorCyclingRect(amount: self.cycle)
                    .edgesIgnoringSafeArea(.top)
                Arrow(thickness: thick)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: lineThick, lineCap: .round))
                    .frame(width: thick, height: 300)
                    .overlay(Arrow(thickness: thick)).foregroundColor(.black)
            }
//            Spacer()
            
            Text("Arrow width")
            
            Slider(value: $thick, in: 20...300)
                .padding()
            Text("Arrow thickness")
           
            Slider(value: $lineThick, in: 1...30)
                .padding()
            
            Text("Color Changer")
            
            Slider(value: $cycle)
                .padding()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
