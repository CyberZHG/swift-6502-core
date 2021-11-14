let PC_RESET_VAL: UInt16 = 0xFFFC

enum EmulateError: Error {
    case invalidOpCode
    case invalidAddrMode
}


enum EmulateFlag {
    /// The orignal 6502 does not deal with the page boundary correctly when using the indirect addressing.
    case useOriginalIncorrectIndirectJMP
}

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
    
    /// Flags for emulation.
    var flags: Set<EmulateFlag> = []
    
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
    
    func addFlag(_ flag: EmulateFlag) {
        flags.insert(flag)
    }
    
    func removeFlag(_ flag: EmulateFlag) {
        flags.remove(flag)
    }
    
    func removeAllFlag() {
        flags.removeAll()
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
                 maxCycle: Int = -1) throws -> Int {
        var cycle = 0
        while cycle < maxCycle {
            let code = readByte(memory, address: PC, cycle: &cycle)
            PC += 1
            guard let (op, addrMode) = CODE_TO_OPERATION[code] else {
                throw EmulateError.invalidOpCode
            }
            switch op {
            case Operation.JMP:
                try execJMP(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.LDA:
                try execLDA(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.LDX:
                try execLDX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.LDY:
                try execLDY(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.NOP:
                try execNOP(memory, addrMode: addrMode, cycle: &cycle)
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
    
    /// Get the address from zero page.
    internal func loadAddrZeroPage(_ memory: Memory, cycle: inout Int) -> UInt8 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        return readByte(memory, address: UInt16(zeroPageAddr), cycle: &cycle)
    }
    
    /// Get the address from zero page indexed by X. The zero page address should modulo 0x100 after indexing.
    internal func loadAddrZeroPageX(_ memory: Memory, cycle: inout Int) -> UInt8 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        let indexedAddr = (UInt16(zeroPageAddr) + UInt16(X)) % 0x100
        cycle += 1
        return readByte(memory, address: indexedAddr, cycle: &cycle)
    }
    
    /// Get the address from zero page indexed by Y. The zero page address should modulo 0x100 after indexing.
    internal func loadAddrZeroPageY(_ memory: Memory, cycle: inout Int) -> UInt8 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        let indexedAddr = (UInt16(zeroPageAddr) + UInt16(Y)) % 0x100
        cycle += 1
        return readByte(memory, address: indexedAddr, cycle: &cycle)
    }
    
    /// Get the address from a 2-byte absolute address.
    internal func loadAddrAbsolute(_ memory: Memory, cycle: inout Int) -> UInt8 {
        let absAddr = readWord(memory, address: PC, cycle: &cycle)
        PC += 2
        return readByte(memory, address: absAddr, cycle: &cycle)
    }
    
    /// Get the address from a 2-byte absolute address indexed by X. One extra cycle is required when a page boundary is crossed.
    internal func loadAddrAbsoluteX(_ memory: Memory, cycle: inout Int) -> UInt8 {
        let absAddr = readWord(memory, address: PC, cycle: &cycle)
        PC += 2
        let indexedAddr = absAddr + UInt16(X)
        if (absAddr >> 8) != (indexedAddr >> 8) {
            cycle += 1
        }
        return readByte(memory, address: indexedAddr, cycle: &cycle)
    }
    
    /// Get the address from a 2-byte absolute address indexed by Y. One extra cycle is required when a page boundary is crossed.
    internal func loadAddrAbsoluteY(_ memory: Memory, cycle: inout Int) -> UInt8 {
        let absAddr = readWord(memory, address: PC, cycle: &cycle)
        PC += 2
        let indexedAddr = absAddr + UInt16(Y)
        if (absAddr >> 8) != (indexedAddr >> 8) {
            cycle += 1
        }
        return readByte(memory, address: indexedAddr, cycle: &cycle)
    }
    
    /// Get the address based on the indexed indirect addressing.
    internal func loadAddrIndexedIndirect(_ memory: Memory, cycle: inout Int) -> UInt8 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        let indexedAddr = (UInt16(zeroPageAddr) + UInt16(X)) % 0x100
        let indirectAddr = readWord(memory, address: indexedAddr, cycle: &cycle)
        cycle += 1
        return readByte(memory, address: indirectAddr, cycle: &cycle)
    }
    
    /// Get the address based on the indirect indexed addressing.
    internal func loadAddrIndirectIndexed(_ memory: Memory, cycle: inout Int) -> UInt8 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        let indirectAddr = readWord(memory, address: UInt16(zeroPageAddr), cycle: &cycle)
        let indexedAddr = indirectAddr + UInt16(Y)
        if (indirectAddr >> 8) != (indexedAddr >> 8) {
            cycle += 1
        }
        return readByte(memory, address: indexedAddr, cycle: &cycle)
    }
    
    /// Update status based on A. A only affects zero and negative flags.
    internal func updateStatusFromConst(_ val: UInt8) {
        self.Z = val == 0
        self.N = (val & 0b10000000) > 0
    }
}
