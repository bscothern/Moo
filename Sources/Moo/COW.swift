public protocol Copyable: AnyObject {
    init(copying other: Self)
}

@propertyDelegate
@dynamicMemberLookup
public struct COW<Value: Copyable> {
    private var _value: Value

    #if DEBUG
    var copyCount: Int = 0
    #endif

    public var value: Value {
        mutating get {
            if !isKnownUniquelyReferenced(&_value) {
                _value = Value(copying: _value)
                #if DEBUG
                copyCount += 1
                #endif
            }
            return _value
        }
        mutating set {
            _value = newValue
        }
    }

    public init(initialValue: Value) {
        _value = initialValue
    }

    public subscript<Result>(dynamicMember keyPath: WritableKeyPath<Value, Result>) -> Result {
        mutating get { value[keyPath: keyPath] }
        mutating set { value[keyPath: keyPath] = newValue }
    }
}
