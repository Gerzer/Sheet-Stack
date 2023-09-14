//
//  SheetPresentation.swift
//  Sheet Stack
//
//  Created by Gabriel Jacoby-Cooper on 9/13/23.
//

import SwiftUI

@available(macOS 11, iOS 14, *)
struct SheetPresentation<Provider>: ViewModifier where Provider: SheetPresentationProvider {
	
	let provider: Provider
	
	@State
	private var sheetType: Provider.SheetType?
	
	@State
	private var handle: SheetStack<Provider.SheetType>.Handle!
	
	@ObservedObject
	private var sheetStack: SheetStack<Provider.SheetType>
	
	func body(content: Content) -> some View {
		return content
			.onAppear {
				self.handle = self.sheetStack.register()
			}
			.onReceive(self.sheetStack.publisher) { (sheets) in
				if sheets.indices.contains(self.handle.observedIndex) {
					self.sheetType = sheets[self.handle.observedIndex]
				} else {
					self.sheetType = nil
				}
			}
			.onChange(of: self.sheetType) { (sheetType) in
				if self.sheetStack.count == self.handle.observedIndex {
					if let sheetType = sheetType {
						self.sheetStack.push(sheetType)
					}
				} else if self.sheetStack.count > self.handle.observedIndex {
					guard sheetType == nil else {
						return
					}
					while self.sheetStack.count - self.handle.observedIndex > 1 {
						self.sheetStack.pop()
					}
				}
			}
			.sheet(item: self.$sheetType) {
				if self.sheetStack.count > self.handle.observedIndex {
					self.sheetStack.pop()
				}
			} content: { (sheetType) in
				self.provider.content(sheetType: sheetType)
			}
	}
	
	init(provider: Provider, sheetStack: SheetStack<Provider.SheetType>) {
		self.provider = provider
		self.sheetStack = sheetStack
	}
	
}

@available(macOS 11, iOS 14, *)
extension View {
	
	public func sheetPresentation<SheetType>(
		provider: some SheetPresentationProvider<SheetType>,
		sheetStack: SheetStack<SheetType>
	) -> some View where SheetType: Hashable & Identifiable {
		return self.modifier(SheetPresentation(provider: provider, sheetStack: sheetStack))
	}
	
}
