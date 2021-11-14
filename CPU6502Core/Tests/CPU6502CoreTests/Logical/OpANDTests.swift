import XCTest
@testable import CPU6502Core

final class OpANDTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testANDImmediate() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x29, 0b00001010])
        self.cpu.PC = 0x0000
        self.cpu.A = 0b11110010
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b00000010)
        XCTAssertEqual(self.cpu.P, 0b00100100)
        
        self.memory.setBytes(start: 0x0080, bytes: [0x29, 0b00001010])
        self.cpu.PC = 0x0000
        self.cpu.A = 0b11110000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00100110)
        XCTAssertEqual(self.cpu.Z, true)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x29, 0xFF])
        self.cpu.PC = 0x0000
        self.cpu.A = 0b11110000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b11110000)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        XCTAssertEqual(self.cpu.N, true)
    }
    
    func testANDZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x25, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x20)
        XCTAssertEqual(self.cpu.P, 0b00100100)
    }
    
    func testANDZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x35, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0xCD])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xAA)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x88)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testANDAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x3D, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xAA)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testANDAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x3D, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xAA)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA8)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA8)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testANDAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x39, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.Y = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xAA)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA8)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xA8)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testANDIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x21, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x02)
        XCTAssertEqual(self.cpu.P, 0b00100100)
    }
    
    func testANDIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x31, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42, 0x43])
        self.memory.setBytes(start: 0xACBD, bytes: [0x44])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.Y = 1
        var actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x02)
        XCTAssertEqual(self.cpu.P, 0b00100100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xF0
        actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00100110)
    }
    
}
