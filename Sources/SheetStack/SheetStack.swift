//
//  SheetStack.swift
//  Sheet Stack
//
//  Created by Gabriel Jacoby-Cooper on 9/13/23.
//

import Combine
import SwiftUI

/// A representation of a stack of modal sheets.
@available(macOS 11, iOS 14, *)
@MainActor
public final class SheetStack<SheetType>: ObservableObject where SheetType: Hashable & Identifiable {
	
	struct Handle {
		
		let observedIndex: Int
		
		fileprivate init(observedIndex: Int) {
			self.observedIndex = observedIndex
		}
		
	}
	
	private var stack: [SheetType] = []
	
	let publisher = PassthroughSubject<[SheetType?], Never>()
	
	/// The sheet type that’s currently at the top of this sheet stack.
	public var top: SheetType? {
		get {
			return self.stack.last
		}
		set {
			if let newValue {
				self.push(newValue)
			} else {
				self.pop()
			}
		}
	}
	
	/// The number of sheets that are currently presented.
	public var count: Int {
		get {
			return self.stack.count
		}
	}
	
	/// Creates a sheet stack.
	public init() { }
	
	/// Pushes a new sheet onto the stack.
	/// - Parameter sheetType: The sheet type to push.
	public func push(_ sheetType: SheetType) {
		self.stack.append(sheetType)
		self.publisher.send(self.stack)
		self.objectWillChange.send()
	}
	
	/// Pops the top sheet off of the stack.
	public func pop() {
		if !self.stack.isEmpty {
			self.stack.removeLast()
			self.publisher.send(self.stack)
			self.objectWillChange.send()
		}
	}
	
	func register() -> Handle {
		return Handle(observedIndex: self.stack.count)
	}
	
}
