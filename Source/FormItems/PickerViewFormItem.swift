// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

/**
# Inline picker view

### Tap to expand/collapse

Behind the scenes this creates a `UIPickerView`.
*/
public class PickerViewFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	/**
	### Collapsed
	
	When the `behavior` is set to `Collapsed` then
	the picker view starts out being hidden.
	
	The user has to tap the row to expand it.
	This will collapse other inline picker views.
	

	### Expanded
	
	When the `behavior` is set to `Expanded` then
	the picker view starts out being visible.
	
	The user has to tap the row to collapse it.
	Or if another control becomes first respond this will collapse it.
	When the keyboard appears this will collapse it.
	
	
	### ExpandedAlways
	
	When the `behavior` is set to `ExpandedAlways` then
	the picker view is always expanded. It cannot be collapsed.
	It is not affected by `becomeFirstResponder()` nor `resignFirstResponder()`.
	*/
	public enum Behavior {
		case Collapsed
		case Expanded
		case ExpandedAlways
	}
	public var behavior = Behavior.Collapsed
	public func behavior(behavior: Behavior) -> Self {
		self.behavior = behavior
		return self
	}
	
	
	public var pickerTitles = [[String]]()
	
	public var humanReadableValueSeparator: String?
	

	typealias SyncBlock = (value: [Int], animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: [Int], animated: Bool) in
		SwiftyFormLog("sync is not overridden: \(value)")
	}
	
	private func maybeAssignFallbackValue() {
		if innerValue.count == pickerTitles.count {
			return
		}
		// If not initialized then select the first rows
		var selectedRows = [Int]()
		for rows in pickerTitles {
			if rows.isEmpty {
				selectedRows.append(-1)
			} else {
				selectedRows.append(0)
			}
		}
		innerValue = selectedRows
	}
	
	
	internal var innerValue = [Int]()
	public var value: [Int] {
		get {
			maybeAssignFallbackValue()
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	
	public func setValue(value: [Int], animated: Bool) {
		innerValue = value
		syncCellWithValue(value: value, animated: animated)
	}

	public typealias ValueDidChangeBlock = (value: [Int]) -> Void
	public var valueDidChangeBlock: ValueDidChangeBlock = { (value: [Int]) in
		SwiftyFormLog("not overridden")
	}

	public func valueDidChange(value: [Int]) {
		innerValue = value
		valueDidChangeBlock(value: value)
	}
}