import SwiftUI
import SpriteKit

struct Law3: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var counter = 0
    @State var biggerCard = false
    @State private var moveRight = false
    @State var instructionNum = 0
    @State var pickLawOfMotionView = PickLawOfMotionView()
    @State var instructions: [String] = [
        "On the last law of motion already? You rock! 🤘",
        "The 3rd law of motion states: \"For every action, there is an equal and opposite reaction.\"🏏",
        "This means that any action will have a reaction equal and oppsite to the action. For e.g. If you throw a ball (which is the action), it will bounce back (which is the reaction) 🎾",
        "Newton's Cradle is an awesome example of this law. Swing either balls on the end to see how it moves the ball on the other side! ← →",
        "A huge round of applause for learning all of the Newton's facinating laws of motions! 👏"
    ]
    @State var rightButtonDisabled = false
    @State var leftButtonDisabled = true
    @State var checkForCompletion = false
    @State var navigationButtonsVisible = true
    init() {
        // Register the first custom font
        if let fontURL = Bundle.main.url(forResource: "RubikDoodleShadow-Regular", withExtension: "ttf"),
           let fontData = try? Data(contentsOf: fontURL) as CFData,
           let provider = CGDataProvider(data: fontData),
           let font = CGFont(provider) {
            
            CTFontManagerRegisterGraphicsFont(font, nil)
            //            print("Custom font 'titleFont' registered successfully.")
        } else {
            print("Failed to register custom font 'titleFont'.")
        }
        
        
        if let anotherFontURL = Bundle.main.url(forResource: "KleeOne-Regular", withExtension: "ttf"),
           let anotherFontData = try? Data(contentsOf: anotherFontURL) as CFData,
           let anotherFontProvider = CGDataProvider(data: anotherFontData),
           let anotherFont = CGFont(anotherFontProvider) {
            
            CTFontManagerRegisterGraphicsFont(anotherFont, nil)
            //            print("Custom font 'anotherFont' registered successfully.")
        } else {
            print("Failed to register custom font 'anotherFont'.")
        }
    }
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            Image("law1bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
                .opacity(0.8)
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                VStack(spacing: 30) {
                    Text("Law 3")
                        .foregroundStyle(.black)
                        .font(.custom("RubikDoodleShadow-Regular", size: 65))
                    
                    SpriteView(scene: GameScene3(size: CGSize(width: 500, height: 350), law3View: self, cradleFrame: CGRect(x: 0, y: 0, width: 500, height: 350)))
                        .frame(width: 500, height: 350)
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.4))
                        .frame(width: 500, height: self.biggerCard ? 220 : 100)
                        .animation(.bouncy, value: biggerCard)
                        .confettiCannon(counter: $counter, num: 100, radius: 500)
                        .overlay {
                            Text(instructions[instructionNum])
                                .foregroundColor(.white)
                                .font(.custom("KleeOne-Regular", size: 23))
                                .padding(.horizontal, 15)
                                .padding(7)
                                .padding(.bottom, biggerCard ? 30 : 10)
                            //                            .padding(.bottom, instructionNum == 3 ? 30 : 0)
                            
                            Button {
                                
                                if instructionNum == 0 {
                                    leftButtonDisabled = true
                                } else {
                                    leftButtonDisabled = false
                                    instructionNum -= 1
                                }
                                
                                if instructionNum == 1 || instructionNum == 2 || instructionNum == 3 {
                                    biggerCard = true
                                } else {
                                    biggerCard = false
                                }
                                
                            } label: {
                                Image(systemName: "arrow.backward.circle")
                                    .font(.custom("KleeOne-Regular", size: 25))
                                    .foregroundStyle(checkForCompletion || leftButtonDisabled ? .yellow.opacity(0.5) : .yellow)
                            }
                            .padding(.leading, 350)
                            .padding(.top, biggerCard ? 140 : 40)
                            .disabled(checkForCompletion)
                            .opacity(navigationButtonsVisible ? 1 : 0)
                            .disabled(!navigationButtonsVisible)
                            .disabled(leftButtonDisabled)
                            
                            Button{
                                if instructionNum == 2 {
                                    checkForCompletion = true
                                }
                                
                                
                                if instructionNum == 3 {
                                    rightButtonDisabled = true
                                }
                                
                                if instructionNum == 4 {
                                    instructionNum = 0
                                } else {
                                    leftButtonDisabled = false
                                    instructionNum += 1
                                }
                                
                                if instructionNum == 1 || instructionNum == 2 || instructionNum == 3 {
                                    biggerCard = true
                                } else {
                                    biggerCard = false
                                }
                            } label: {
                                Image(systemName: "arrow.forward.circle")
                                    .font(.custom("KleeOne-Regular", size: 25))
                                    .foregroundStyle(rightButtonDisabled || checkForCompletion ? .yellow.opacity(0.5) : .yellow)
                            }
                            .onChange(of: instructionNum, { oldValue, newValue in
                                
                                if instructionNum != 3 && newValue == oldValue + 1 {
                                    rightButtonDisabled.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        rightButtonDisabled.toggle()
                                    }
                                }
                            })
                            .disabled(rightButtonDisabled || checkForCompletion)
                            .padding(.leading, 440)
                            .padding(.top, biggerCard ? 140 : 40)
                            .opacity(navigationButtonsVisible ? 1 : 0)
                            .disabled(!navigationButtonsVisible)
                            
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                                pickLawOfMotionView.currentIndex = 1
                            }, label: {
                                Text("Time for Quiz! 🤔")
                                    .font(.custom("KleeOne-Regular", size: 17))
                            })
                            .frame(width: 200)
                            .buttonStyle(.borderedProminent)
                            .opacity(!navigationButtonsVisible ? 1 : 0)
                            .disabled(navigationButtonsVisible)
                            .padding(.top, 100)
                            .padding(.leading, 290)
                            
                        }
                }
                
                
                
            case .phone:
                VStack(spacing: 30) {
                    Text("Law 3")
                        .foregroundStyle(.black)
                        .font(.custom("RubikDoodleShadow-Regular", size: 65))
                    
                    SpriteView(scene: GameScene3(size: CGSize(width: 350, height: 320), law3View: self, cradleFrame: CGRect(x: 0, y: 0, width: 350, height: 320)))
                        .frame(width: 350, height: 320)
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.4))
                        .frame(width: 350, height: self.biggerCard ? 300 : 200)
                        .animation(.bouncy, value: biggerCard)
                        .confettiCannon(counter: $counter, num: 100, radius: 500)
                        .overlay {
                            Text(instructions[instructionNum])
                                .frame(width: 300)
                                .foregroundColor(.white)
                                .font(.custom("KleeOne-Regular", size: 23))
                                .padding(.horizontal, 15)
                                .padding(7)
                                .padding(.bottom, biggerCard ? 30 : 10)
                            //                            .padding(.bottom, instructionNum == 3 ? 30 : 0)
                            
                            Button {
                                
                                if instructionNum == 0 {
                                    leftButtonDisabled = true
                                } else {
                                    leftButtonDisabled = false
                                    instructionNum -= 1
                                }
                                
                                if instructionNum == 1 || instructionNum == 2 || instructionNum == 3 {
                                    biggerCard = true
                                } else {
                                    biggerCard = false
                                }
                                
                            } label: {
                                Image(systemName: "arrow.backward.circle")
                                    .font(.custom("KleeOne-Regular", size: 25))
                                    .foregroundStyle(checkForCompletion || leftButtonDisabled ? .yellow.opacity(0.5) : .yellow)
                            }
                            .padding(.leading, 200)
                            .padding(.top, biggerCard ? 240 : 150)
                            .disabled(checkForCompletion)
                            .opacity(navigationButtonsVisible ? 1 : 0)
                            .disabled(!navigationButtonsVisible)
                            .disabled(leftButtonDisabled)
                            
                            Button{
                                if instructionNum == 2 {
                                    checkForCompletion = true
                                }
                                
                                
                                if instructionNum == 3 {
                                    rightButtonDisabled = true
                                }
                                
                                if instructionNum == 4 {
                                    instructionNum = 0
                                } else {
                                    leftButtonDisabled = false
                                    instructionNum += 1
                                }
                                
                                if instructionNum == 1 || instructionNum == 2 || instructionNum == 3 {
                                    biggerCard = true
                                } else {
                                    biggerCard = false
                                }
                            } label: {
                                Image(systemName: "arrow.forward.circle")
                                    .font(.custom("KleeOne-Regular", size: 25))
                                    .foregroundStyle(rightButtonDisabled || checkForCompletion ? .yellow.opacity(0.5) : .yellow)
                            }
                            .onChange(of: instructionNum, { oldValue, newValue in
                                
                                if instructionNum != 3 && newValue == oldValue + 1 {
                                    rightButtonDisabled.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        rightButtonDisabled.toggle()
                                    }
                                }
                            })
                            .disabled(rightButtonDisabled || checkForCompletion)
                            .padding(.leading, 300)
                            .padding(.top, biggerCard ? 240 : 150)
                            .opacity(navigationButtonsVisible ? 1 : 0)
                            .disabled(!navigationButtonsVisible)
                            
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                                pickLawOfMotionView.currentIndex = 1
                            }, label: {
                                Text("Time for Quiz! 🤔")
                                    .font(.custom("KleeOne-Regular", size: 17))
                            })
                            .frame(width: 200)
                            .buttonStyle(.borderedProminent)
                            .opacity(!navigationButtonsVisible ? 1 : 0)
                            .disabled(navigationButtonsVisible)
                            .padding(.top, 200)
                            .padding(.leading, 100)
                            
                        }
                }
                .padding(.trailing, biggerCard ? 30 : 0)
                
            default:
                VStack {
                    Image(systemName: "xmark.circle")
                    Text("Device Not Supported")
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

#Preview {
    Law3()
}
