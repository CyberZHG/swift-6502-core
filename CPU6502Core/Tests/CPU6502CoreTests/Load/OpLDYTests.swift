import XCTest
@testable import CPU6502Core

final class OpLDYTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testLDYImmediate() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xA0, 0x0A])
        self.cpu.PC = 0x0000
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.Y, 0x0A)
        XCTAssertEqual(self.cpu.P, 0b00100100)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xA0, 0x00])
        self.cpu.PC = 0x0000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.Y, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00100110)
        XCTAssertEqual(self.cpu.Z, true)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xA0, 0xFF])
        self.cpu.PC = 0x0000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.Y, 0xFF)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        XCTAssertEqual(self.cpu.N, true)
    }
    
    func testLDYZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xA4, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xA5])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.Y, 0xA5)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testLDYZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xB4, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0xCD])
        self.cpu.PC = 0x0000
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.Y, 0xAB)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.Y, 0xCD)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xB4, 0xFF])
        self.cpu.PC = 0x0000
        self.cpu.X = 0x11
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.Y, 0xAB)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testLDYAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xAC, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.Y, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
    func testLDYAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xBC, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.Y, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.Y, 0xFC)
        XCTAssertEqual(self.cpu.P, 0b10100100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.Y, 0xFA)
        XCTAssertEqual(self.cpu.P, 0b10100100)
    }
    
}
