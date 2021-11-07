let PC_RESET_VAL: UInt16 = 0xFFFC

/**
 The class contains all the 6502 states.
 */
public class CPU6502 {
    
    /// Program counter. This register points to the address of the next instruction to be executed.
    var PC : UInt16 = PC_RESET_VAL
    /// Stack pointer. This contains the offset to the stack page (`$0100` - `$01FF`).
    var SP : UInt8 = 0
    /// Processor status. The register stores the state of the processor.
    var P : UInt8 = 0b00100000
    /// Accumulator. The main register for arithmetic and logical operations.
    var A : UInt8 = 0
    /// X index register. This generally is for addressing.
    var X : UInt8 = 0
    /// Y index register.
    var Y : UInt8 = 0
    
    /// Negative flag. The flag will be set after any arithmetic operations.
    var N: Bool {
        get { return getPBit(7) }
        set(flag) { setPBit(7, flag)}
    }
    /// Overflow flag.
    var V: Bool {
        get { return getPBit(6) }
        set(flag) { setPBit(6, flag)}
    }
    /// Break flag.
    var B: Bool {
        get { return getPBit(4) }
        set(flag) { setPBit(4, flag)}
    }
    /// Decimal mode flag.
    var D: Bool {
        get { return getPBit(3) }
        set(flag) { setPBit(3, flag)}
    }
    /// Interrrupt disable flag.
    var I: Bool {
        get { return getPBit(2) }
        set(flag) { setPBit(2, flag)}
    }
    /// Zero flag.
    var Z: Bool {
        get { return getPBit(1) }
        set(flag) { setPBit(1, flag)}
    }
    /// Carry flag.
    var C: Bool {
        get { return getPBit(0) }
        set(flag) { setPBit(0, flag)}
    }

    /// Get 1 bit from the processor unit.
    private func getPBit(_ index: Int) -> Bool {
        return (P & (1 << index)) > 0
    }
    
    /// Set 1 bit to the processor unit.
    private func setPBit(_ index: Int, _ flag: Bool) {
        if (flag) {
            P |= 1 << index
        } else {
            P &= ~(1 << index)
        }
    }
    
    func reset() {
        PC = PC_RESET_VAL
        SP = 0
        P = 0b00100000
        A = 0
        X = 0
        Y = 0
    }
    
    /**
        Execute codes with a given memory space.
     
        - Parameter memory: The memory space.
        - Parameter maxCycle: Maximum number of cycles that can be executed.
        Note that the actual cycle number may be greater than this value as
        it ensures that all the instructions are complete. Set to -1 to execute until a dead loop.
     
        - Returns: The actual number of cycles.
        */
    func execute(_ memory: Memory,
                 entry: UInt16 = PC_RESET_VAL,
                 maxCycle: Int = -1) -> Int {
        var cycle = 0
        while cycle < maxCycle {
            let code = readByte(memory, address: PC, cycle: &cycle)
            PC += 1
            let opCode = getOpCode(code)
            switch CODE_TO_OPERATION[opCode]! {
            case Operation.LDA:
                execLDA(memory, code: code, cycle: &cycle)
                break
            default:
                break
            }
        }
        return cycle
    }
    
    /// Read a byte from the specific address in memory. It requires 1 cycle.
    internal func readByte(_ memory: Memory, address: UInt16, cycle: inout Int) -> UInt8 {
        cycle += 1
        return memory[Int(address)]
    }
    
    /// Read two bytes from the specific address in memory. It requires 2 cycles.
    internal func readWord(_ memory: Memory, address: UInt16, cycle: inout Int) -> UInt16 {
        cycle += 2
        return UInt16(memory[Int(address)]) + (UInt16(memory[Int(address) + 1]) << 8)
    }
    
    /// Write a byte from the specific address in memory. It requires 1 cycle.
    internal func writeByte(_ memory: Memory, address: UInt16, value: UInt8, cycle: inout Int) {
        cycle += 1
        memory[Int(address)] = value
    }
    
    /// Write two bytes from the specific address in memory. It requires 2 cycles.
    internal func writeWord(_ memory: Memory, address: UInt16, value: UInt16, cycle: inout Int) {
        cycle += 2
        memory[Int(address)] = UInt8(value & 0xFF)
        memory[Int(address) + 1] = UInt8(value >> 8)
    }
    
    /// Get the operator code from a byte. The byte has the form `AAABBBCC`, in which `AAACC` is the operation.
    internal func getOpCode(_ code: UInt8) -> UInt8 {
        return ((code & 0b11100000) >> 3) + (code & 0b11)
    }
    
    /// Get the addressing code from a byte. The byte has the form `AAABBBCC`, in which `BBB` indicates the addressing mode.
    internal func getAddrCode(_ code: UInt8) -> UInt8 {
        return (code & 0b00011100) >> 2
    }
    
    /// Get the address from immediate addressing. The address is the byte that PC points to.
    internal func loadAddrImmedidate(_ memory: Memory, cycle: inout Int) -> UInt8 {
        let addr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        return addr
    }
    
    internal func updateStatusFromA() {
        self.Z = A == 0
        self.N = (A & 0b10000000) > 0
    }
}
