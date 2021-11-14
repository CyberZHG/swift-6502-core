enum AddressingMode {
    case accumulator
    case implied
    case immediate
    case zeroPage
    case zeroPageX
    case zeroPageY
    case absolute
    case absoluteX
    case absoluteY
    case indirect
    case indirectIndexed
    case indexedIndirect
    case relative
}


enum Operation {
    case JMP
    case LDA, LDX, LDY
    case NOP
}


let CODE_TO_OPERATION = [
    UInt8(0x4C): (Operation.JMP, AddressingMode.absolute),
    UInt8(0x6C): (Operation.JMP, AddressingMode.indirect),
    
    UInt8(0xA9): (Operation.LDA, AddressingMode.immediate),
    UInt8(0xA5): (Operation.LDA, AddressingMode.zeroPage),
    UInt8(0xB5): (Operation.LDA, AddressingMode.zeroPageX),
    UInt8(0xAD): (Operation.LDA, AddressingMode.absolute),
    UInt8(0xBD): (Operation.LDA, AddressingMode.absoluteX),
    UInt8(0xB9): (Operation.LDA, AddressingMode.absoluteY),
    UInt8(0xA1): (Operation.LDA, AddressingMode.indexedIndirect),
    UInt8(0xB1): (Operation.LDA, AddressingMode.indirectIndexed),
    
    UInt8(0xA2): (Operation.LDX, AddressingMode.immediate),
    UInt8(0xA6): (Operation.LDX, AddressingMode.zeroPage),
    UInt8(0xB6): (Operation.LDX, AddressingMode.zeroPageY),
    UInt8(0xAE): (Operation.LDX, AddressingMode.absolute),
    UInt8(0xBE): (Operation.LDX, AddressingMode.absoluteY),
    
    UInt8(0xA0): (Operation.LDY, AddressingMode.immediate),
    UInt8(0xA4): (Operation.LDY, AddressingMode.zeroPage),
    UInt8(0xB4): (Operation.LDY, AddressingMode.zeroPageX),
    UInt8(0xAC): (Operation.LDY, AddressingMode.absolute),
    UInt8(0xBC): (Operation.LDY, AddressingMode.absoluteX),
    
    UInt8(0xEA): (Operation.NOP, AddressingMode.implied),
]
