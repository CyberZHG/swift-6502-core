enum AddressingMode {
    case ACCUMULATOR
    case IMPLIED
    case IMMEDIATE
    case ZERO_PAGE
    case ZERO_PAGE_X
    case ZERO_PAGE_Y
    case ABSOLUTE
    case ABSOLUTE_X
    case ABSOLUTE_Y
    case INDIRECT
    case INDIRECT_INDEXED
    case INDEXED_INDIRECT
    case RELATIVE
}


enum Operation {
    case JMP
    case LDA, LDX, LDY
}


let CODE_TO_OPERATION = [
    UInt8(0x4C): (Operation.JMP, AddressingMode.ABSOLUTE),
    UInt8(0x6C): (Operation.JMP, AddressingMode.INDIRECT),
    
    UInt8(0xA9): (Operation.LDA, AddressingMode.IMMEDIATE),
    UInt8(0xA5): (Operation.LDA, AddressingMode.ZERO_PAGE),
    UInt8(0xB5): (Operation.LDA, AddressingMode.ZERO_PAGE_X),
    UInt8(0xAD): (Operation.LDA, AddressingMode.ABSOLUTE),
    UInt8(0xBD): (Operation.LDA, AddressingMode.ABSOLUTE_X),
    UInt8(0xB9): (Operation.LDA, AddressingMode.ABSOLUTE_Y),
    UInt8(0xA1): (Operation.LDA, AddressingMode.INDEXED_INDIRECT),
    UInt8(0xB1): (Operation.LDA, AddressingMode.INDIRECT_INDEXED),
    
    UInt8(0xA2): (Operation.LDX, AddressingMode.IMMEDIATE),
    UInt8(0xA6): (Operation.LDX, AddressingMode.ZERO_PAGE),
    UInt8(0xB6): (Operation.LDX, AddressingMode.ZERO_PAGE_Y),
    UInt8(0xAE): (Operation.LDX, AddressingMode.ABSOLUTE),
    UInt8(0xBE): (Operation.LDX, AddressingMode.ABSOLUTE_Y),
    
    UInt8(0xA0): (Operation.LDY, AddressingMode.IMMEDIATE),
    UInt8(0xA4): (Operation.LDY, AddressingMode.ZERO_PAGE),
    UInt8(0xB4): (Operation.LDY, AddressingMode.ZERO_PAGE_X),
    UInt8(0xAC): (Operation.LDY, AddressingMode.ABSOLUTE),
    UInt8(0xBC): (Operation.LDY, AddressingMode.ABSOLUTE_X),
]
