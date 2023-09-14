//
//  SheetPresentationProvider.swift
//  Sheet Stack
//
//  Created by Gabriel Jacoby-Cooper on 9/13/23.
//

import SwiftUI

/// A type that generates sheet content.
@available(macOS 11, iOS 14, *)
public protocol SheetPresentationProvider<SheetType> {
	
	associatedtype SheetType: Hashable, Identifiable
	
	associatedtype Content: View
	
	/// Generates the content of a sheet.
	/// - Parameter sheetType: The sheet type for which to generate content.
	/// - Returns: The sheet content.
	@ViewBuilder
	func content(sheetType: SheetType) -> Content
	
}
