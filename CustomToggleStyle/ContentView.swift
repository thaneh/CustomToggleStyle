//
//  ContentView.swift
//  CustomToggleStyle
//
//  Created by Thane Heninger on 8/18/20.
//

import SwiftUI

fileprivate let standardWidth = CGFloat(51)
fileprivate let standardHeight = CGFloat(31)
fileprivate let circleDiameter = CGFloat(20)

fileprivate func standardColor(_ configuration: ToggleStyle.Configuration) -> Color {
    configuration.isOn ? .green : .gray
}

fileprivate func StandardToggle<Content1: View, Content2: View>(configuration: ToggleStyle.Configuration,
        @ViewBuilder backing: () -> Content1,
        @ViewBuilder marker: () -> Content2) -> some View {
    HStack {
        configuration.label
        Spacer()
        backing()
            .foregroundColor(standardColor(configuration))
            .frame(width: standardWidth, height: standardHeight, alignment: .center)
            .overlay(
                Circle()
                    .foregroundColor(.white)
                    .padding(3)
                    .overlay(
                        marker()
                    )
                    .offset(x: configuration.isOn ? 11 : -11)
                    .animation(.linear(duration: 0.2))
            )
            .cornerRadius(circleDiameter)
            .onTapGesture { configuration.isOn.toggle() }
    }
}

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        StandardToggle(configuration: configuration, backing: {
            Rectangle()
        }) {
            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                .resizable()
                .scaledToFit()
                .font(Font.title.weight(.black))
                .frame(width: 8, height: 8, alignment: .center)
                .foregroundColor(standardColor(configuration))
        }
    }
}

struct PowerToggleStyle: ToggleStyle {
    var onPath: Path {
        var path = Path()
        let x = standardWidth / 2
        let y = circleDiameter / 2
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x, y: standardHeight - y))
        return path
    }
    
    var offPath: Path {
        let pos = CGRect(x: circleDiameter, y: circleDiameter / 2,
                         width: 10.5, height: 10.5)
        let cornerSize = CGSize(width: circleDiameter * 0.375,
                                height: circleDiameter * 0.375)
        return Path(roundedRect: pos, cornerSize: cornerSize)
    }
    
    func marker(configuration: Configuration) -> Path {
        configuration.isOn ? onPath : offPath
    }
    
    func makeBody(configuration: Configuration) -> some View {
        StandardToggle(configuration: configuration,
                       backing: {
                        Rectangle()
                       }) {
            marker(configuration: configuration)
                .stroke(standardColor(configuration), lineWidth: 2)
        }
    }
}

struct ImageToggleStyle: ToggleStyle {
    let onImageName: String
    let offImageName: String
    
    func makeBody(configuration: Configuration) -> some View {
        StandardToggle(configuration: configuration, backing: {
            Image(configuration.isOn ? onImageName : offImageName)
                .resizable()
                .scaledToFill()
        }) {
            EmptyView()
        }
    }
}

struct ContentView: View {
    @State private var normalToggleOn = false
    @State private var checkmarkToggleOn = false
    @State private var powerToggleOn = false
    @State private var imageToggleOn = false
    
    var body: some View {
        VStack(spacing: 20) {
            Toggle(isOn: $normalToggleOn, label: {
                Text("Normal Style")
            })
            
            Toggle(isOn: $checkmarkToggleOn, label: {
                Text("Checkmark Style")
            })
            .toggleStyle(CheckmarkToggleStyle())
            
            Toggle(isOn: $powerToggleOn, label: {
                Text("Power Style")
            })
            .toggleStyle(PowerToggleStyle())
            
            Toggle(isOn: $imageToggleOn, label: {
                Text("Power Style")
            })
            .toggleStyle(ImageToggleStyle(onImageName: "bright",
                                          offImageName: "dim"))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Toggle(isOn: .constant(true), label: {
                    Text("Normal")
                })
                
                Toggle(isOn: .constant(false), label: {
                    Text("Normal")
                })
            }
            
            HStack(spacing: 20) {
                Toggle(isOn: .constant(true), label: {
                    Text("Checkmark")
                })
                
                Toggle(isOn: .constant(false), label: {
                    Text("Checkmark")
                })
            }
            .toggleStyle(CheckmarkToggleStyle())
            
            HStack(spacing: 20) {
                Toggle(isOn: .constant(true), label: {
                    Text("Power")
                })
                
                Toggle(isOn: .constant(false), label: {
                    Text("Power")
                })
            }
            .toggleStyle(PowerToggleStyle())
            
            HStack(spacing: 20) {
                Toggle(isOn: .constant(true), label: {
                    Text("Image")
                })
                
                Toggle(isOn: .constant(false), label: {
                    Text("Image")
                })
            }
            .toggleStyle(ImageToggleStyle(onImageName: "bright",
                                          offImageName: "dim"))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
