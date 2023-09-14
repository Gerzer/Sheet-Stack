//
//  SheetPresentationProvider.swift
//  Sheet Stack
//
//  Created by Gabriel Jacoby-Cooper on 9/13/23.
//

import SwiftUI

@available(macOS 11, iOS 14, *)
public protocol SheetPresentationProvider<SheetType> {
	
	associatedtype SheetType: Hashable, Identifiable
	
	associatedtype Content: View
	
	@ViewBuilder
	func content(sheetType: SheetType) -> Content
	
}
