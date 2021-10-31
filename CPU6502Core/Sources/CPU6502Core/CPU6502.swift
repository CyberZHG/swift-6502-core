/**
 The class contains all the 6502 states.
 */
class CPU6502 {
    
    /// Program counter. This register points to the address of the next instruction to be executed.
    var PC : UInt16 = 0
    /// Stack pointer. This contains the offset to the stack page (`$0100` - `$01FF`).
    var SP : UInt8 = 0
    /// Processor status. The register stores the state of the processor.
    var P : UInt8 = 0
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
}
