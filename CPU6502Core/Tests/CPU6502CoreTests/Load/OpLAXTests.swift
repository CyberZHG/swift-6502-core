import XCTest
@testable import CPU6502Core

final class OpLAXTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testLAXImmediate() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xAB, 0xFE])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xFE)
        XCTAssertEqual(self.cpu.X, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
    func testLAXZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xA7, 0x00])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xA7)
        XCTAssertEqual(self.cpu.X, 0xA7)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
    func testLAXZeroPageY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xB7, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0xCD])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAA
        self.cpu.Y = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xAB)
        XCTAssertEqual(self.cpu.X, 0xAB)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xCD)
        XCTAssertEqual(self.cpu.X, 0xCD)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
    func testLAXAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xAF, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFE)
        XCTAssertEqual(self.cpu.X, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
    func testLAXAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xBF, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFE)
        XCTAssertEqual(self.cpu.X, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFC)
        XCTAssertEqual(self.cpu.X, 0xFC)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x60
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFA)
        XCTAssertEqual(self.cpu.X, 0xFA)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
    func testLAXIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xA3, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x42)
        XCTAssertEqual(self.cpu.X, 0x42)
        XCTAssertEqual(self.cpu.P, 0b00110100)
    }
    
    func testLAXIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xB3, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42, 0x43])
        self.memory.setBytes(start: 0xACBD, bytes: [0x44])
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        var actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x43)
        XCTAssertEqual(self.cpu.X, 0x43)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xF0
        actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x44)
        XCTAssertEqual(self.cpu.X, 0x44)
        XCTAssertEqual(self.cpu.P, 0b00110100)
    }
    
}
