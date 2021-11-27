/**
 The protocol that describes the memory space of 6502.
 */
protocol Memory : AnyObject {
    
    var length: Int {get}
    
    subscript(index: Int) -> UInt8 {get set}
    
    func reset()
}

/**
 A strict-forward memory space for testing.
 */
class PlainMemory : Memory {
    
    let MAX_SIZE = 0x10000
    
    ///  Memory space
    var memory : [UInt8]
    var length: Int {
        get { return MAX_SIZE }
    }
    
    init() {
        memory = [UInt8](repeating: 0, count: MAX_SIZE)
    }
    
    subscript(index: Int) -> UInt8 {
        get { return memory[index] }
        set { memory[index] = newValue }
    }
    
    func reset() {
        for i in 0..<MAX_SIZE {
            memory[i] = 0
        }
    }
    
    func setBytes(start: Int, bytes: [UInt8]) {
        for i in 0..<bytes.count {
            memory[start + i] = bytes[i]
        }
    }
}
