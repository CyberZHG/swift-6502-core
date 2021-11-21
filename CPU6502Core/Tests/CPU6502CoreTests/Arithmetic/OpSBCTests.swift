import XCTest
@testable import CPU6502Core

final class OpSBCTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testSBCImmediate() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xE9, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x42
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x41)
        XCTAssertEqual(self.cpu.P, 0b00100101)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xE9, 0x69])
        self.cpu.PC = 0x0000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xD8)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xE9, 0xFF])
        self.cpu.PC = 0x0000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xD8)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testSBCImmediateBCD() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xF8, 0xE9, 0x21])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x42
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x20)
        XCTAssertEqual(self.cpu.P, 0b00101101)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xF8, 0xE9, 0x50])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x50
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00101111)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xF8, 0xE9, 0x50])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x49
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x99)
        XCTAssertEqual(self.cpu.P, 0b10101100)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xF8, 0xE9, 0x0F])
        self.cpu.PC = 0x0000
        self.cpu.C = false
        self.cpu.A = 0x01
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x9B)
        XCTAssertEqual(self.cpu.P, 0b10101100)
    }
    
    func testSBCZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xE5, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xC4)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testSBCZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xF5, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0xCD])
        self.cpu.PC = 0x0000
        self.cpu.A = 0x10
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x64)
        XCTAssertEqual(self.cpu.P, 0b00100100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x96)
        XCTAssertEqual(self.cpu.P, 0b11100100)
    }
    
    func testSBCAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xED, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xAB)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testSBCAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xFD, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xAB)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xAE)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xB3)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testSBCAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xF9, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.Y = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xAB)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xAE)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xB3)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testSBCIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xE1, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x67)
        XCTAssertEqual(self.cpu.P, 0b01100101)
    }
    
    func testSBCIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xF1, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42, 0x43])
        self.memory.setBytes(start: 0xACBD, bytes: [0x44])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.Y = 1
        var actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x66)
        XCTAssertEqual(self.cpu.P, 0b01100101)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xF0
        actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x22)
        XCTAssertEqual(self.cpu.P, 0b00100101)
    }
    
}
