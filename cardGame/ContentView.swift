import SwiftUI

struct ShakeAnimation: ViewModifier {
    @Binding var isShaking: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(x: isShaking ? -5 : 0)
            .animation(
                Animation
                    .linear(duration: 0.05) // Shorter duration
                    .repeatCount(isShaking ? 15 : 0,    autoreverses: true)
            )
     }
}

struct ContentView: View {
    @State var playerCarta = "card" + String(Int.random(in: 1...10))
    @State var cpuCarta = "back"
    @State var plPlayer: Int = 0
    @State var plCpu: Int = 0
    @State var animando: Bool = false
    @State var ponto1 = Int.random(in: 2...14)

    var body: some View {
        ZStack {
            Image("background-wood-grain")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 180)
                    .padding(.top, 80)
                Spacer()

                HStack {
                    Image(playerCarta)
                        .padding(40)
                    Spacer()
                    Image(cpuCarta)
                        .padding(40)
                }

                Button(action: {
                    if !animando {
                        animando = true
                        withAnimation {
                            deal()
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                            ponto1 = Int.random(in: 1...10)
                            playerCarta = "card" + String(ponto1)
                        }
                    }
                })
                {
                    Image("button")
                        .foregroundColor(.white)
                        .modifier(ShakeAnimation(isShaking: $animando))

                }
                .disabled(animando)
                
                Button(action: {
                    if !animando {
                        withAnimation {
                            playerCarta = "card" + String(Int.random(in: 1...10))
                            
                            plCpu = 0
                            plPlayer = 0
                        }

                    }
                })
                {
                    Image("button-reset")
                        .foregroundColor(.white)
                }
                .disabled(animando)
                HStack {
                    VStack {
                        Text("Jogador")
                            .font(.headline)
                        Text(String(plPlayer))
                            .font(.largeTitle)
                    }.padding([.leading, .bottom], 70)
                    Spacer()
                    VStack {
                        Text("CPU")
                            .font(.headline)
                        Text(String(plCpu))
                            .font(.largeTitle)
                    }.padding([.bottom, .trailing], 70)
                }.foregroundColor(.white)
            }
        }
    }

    func deal() {
        let ponto2 = Int.random(in: 1...10)
        cpuCarta = "back"

        if ponto1 > ponto2 {
            plPlayer += 1
        } else if ponto2 > ponto1 {
            plCpu += 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                cpuCarta = "card" + String(ponto2)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    cpuCarta = "back"
                }
                animando = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
