/**
 The class describes the memory space of 6502.
 */
class Memory {
    
    let MAX_SIZE = 0x10000
    
    ///  Memory space
    var memory : [UInt8]
    
    init() {
        memory = [UInt8](repeating: 0, count: MAX_SIZE)
    }
    
}
