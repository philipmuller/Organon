//
//  CompendiumBrowser.swift
//  Organon
//
//  Created by Philip Müller on 06/02/21.
//

import SwiftUI

struct CompendiumBrowser: View {
    let firstSectionEntries = CompendiumData.generateFirstSection()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                sectionHeader
                    .padding(.horizontal, 30)
                    .padding(.top, 60)
                    .padding(.bottom, 30)
                
                section
                
                sectionHeader
                    .padding(.horizontal, 30)
                    .padding(.top, 60)
                    .padding(.bottom, 30)
                
                section

            }
            
            
        }
    }
    
    var sectionHeader: some View {
        
        VStack(alignment: .leading) {
            Text("Le basi")
                .font(.custom("SabonBold", size: 24))
            
            Divider()
        }
        
    }
    
    var section: some View {
        VStack(alignment: .center, spacing: 30) {
            ForEach(firstSectionEntries) { row in
                HStack(alignment: .center, spacing: 0) {
                    NavigationLink(
                        destination: CompendiumDetail(data: row.firstEntry)
                    ) {
                        VStack {
                            Circle()
                                .fill(Color.init(hue: 1, saturation: 0, brightness: 0.95))
                                .frame(width: 100, height: 100)
                                //.alignmentGuide(row.secondEntry == nil ? .center : .compendiumBubbleVerticalLeft) { d in d[HorizontalAlignment.center] }
                            Text(row.firstEntry.title)
                                .font(.custom("AvenirNext-Medium", size: 17))
                                .foregroundColor(Color("MainText"))
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(1)
                        }
                        .frame(width: 150)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if let secondItem = row.secondEntry {
                        NavigationLink(
                            destination: CompendiumDetail(data: secondItem)
                        ) {
                            VStack {
                                Circle()
                                    .fill(Color.init(hue: 1, saturation: 0, brightness: 0.95))
                                    .frame(width: 100, height: 100)
                                    //.alignmentGuide(.compendiumBubbleVerticalRight) { d in d[HorizontalAlignment.center] }
                                Text(secondItem.title)
                                    .font(.custom("AvenirNext-Medium", size: 17))
                                    .foregroundColor(Color("MainText"))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(1)
                            }
                            .frame(width: 150)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

extension HorizontalAlignment {
    struct CompendiumBubbleVerticalLeft: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.center]
        }
    }

    static let compendiumBubbleVerticalLeft = HorizontalAlignment(CompendiumBubbleVerticalLeft.self)
    
    struct CompendiumBubbleVerticalRight: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.compendiumBubbleVerticalLeft]
        }
    }

    static let compendiumBubbleVerticalRight = HorizontalAlignment(CompendiumBubbleVerticalRight.self)
}

struct CompendiumBrowser_Previews: PreviewProvider {
    static var previews: some View {
        CompendiumBrowser()
    }
}
