import XCTest
@testable import CPU6502Core

final class OpADCTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testADCImmediate() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x69, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x42
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x42)
        XCTAssertEqual(self.cpu.P, 0b00100100)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x69, 0x69])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x42
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xAB)
        XCTAssertEqual(self.cpu.P, 0b11100100)
        XCTAssertEqual(self.cpu.N, true)
        XCTAssertEqual(self.cpu.V, true)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x69, 0xFF])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x42
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x41)
        XCTAssertEqual(self.cpu.P, 0b00100101)
        XCTAssertEqual(self.cpu.C, true)
    }
    
    func testADCImmediateBCD() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xF8, 0x69, 0x47])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x42
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x89)
        XCTAssertEqual(self.cpu.P, 0b11101100)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xF8, 0x69, 0x50])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x50
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00101111)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xF8, 0x69, 0x0F])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x0F
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x15)
        XCTAssertEqual(self.cpu.P, 0b00101100)
    }
    
    func testADCZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x65, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x0F)
        XCTAssertEqual(self.cpu.P, 0b00100101)
    }
    
    func testADCZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x75, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0xCD])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x10
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xBB)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.A = 0x10
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xDD)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testADCAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x6D, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA8)
        XCTAssertEqual(self.cpu.P, 0b10100101)
    }
    
    func testADCAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x7D, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA8)
        XCTAssertEqual(self.cpu.P, 0b10100101)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA5)
        XCTAssertEqual(self.cpu.P, 0b10100101)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA0)
        XCTAssertEqual(self.cpu.P, 0b10100101)
    }
    
    func testADCAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x79, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.Y = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA8)
        XCTAssertEqual(self.cpu.P, 0b10100101)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA5)
        XCTAssertEqual(self.cpu.P, 0b10100101)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA0)
        XCTAssertEqual(self.cpu.P, 0b10100101)
    }
    
    func testADCIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x61, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xEC)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testADCIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x71, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42, 0x43])
        self.memory.setBytes(start: 0xACBD, bytes: [0x44])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.Y = 1
        var actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xED)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xF0
        actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x31)
        XCTAssertEqual(self.cpu.P, 0b00100101)
    }
    
}
