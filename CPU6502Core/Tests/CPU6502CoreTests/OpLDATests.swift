import XCTest
@testable import CPU6502Core

final class OpLDATests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testLDAImmediate() throws {
        self.memory.setBytes(start: 0x0080, bytes: [0xA9, 0x0A])
        self.cpu.PC = 0x0080
        var actualCycle = self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0082)
        XCTAssertEqual(self.cpu.A, 0x0A)
        XCTAssertEqual(self.cpu.P, 0b00100000)
        
        self.memory.setBytes(start: 0x0080, bytes: [0xA9, 0x00])
        self.cpu.PC = 0x0080
        actualCycle = self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0082)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00100010)
        XCTAssertEqual(self.cpu.Z, true)
        
        self.memory.setBytes(start: 0x0080, bytes: [0xA9, 0xFF])
        self.cpu.PC = 0x0080
        actualCycle = self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0082)
        XCTAssertEqual(self.cpu.A, 0xFF)
        XCTAssertEqual(self.cpu.P, 0b10100000)
        XCTAssertEqual(self.cpu.N, true)
    }
    
    func testLDAZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xA5, 0x00])
        self.cpu.PC = 0x0000
        let actualCycle = self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xA5)
        XCTAssertEqual(self.cpu.P, 0b10100000)
    }
    
    func testLDAZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xB5, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0xCD])
        self.cpu.PC = 0x0000
        self.cpu.X = 0
        var actualCycle = self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xAB)
        XCTAssertEqual(self.cpu.P, 0b10100000)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xCD)
        XCTAssertEqual(self.cpu.P, 0b10100000)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xB5, 0xFF])
        self.cpu.PC = 0x0000
        self.cpu.X = 0x11
        actualCycle = self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xAB)
        XCTAssertEqual(self.cpu.P, 0b10100000)
    }
    
    func testLDAAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xAD, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE])
        self.cpu.PC = 0x0000
        self.cpu.X = 0
        let actualCycle = self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10100000)
    }
    
    func testLDAAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xBD, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.X = 0
        var actualCycle = self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10100000)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFC)
        XCTAssertEqual(self.cpu.P, 0b10100000)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0x60
        actualCycle = self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFA)
        XCTAssertEqual(self.cpu.P, 0b10100000)
    }
    
    func testLDAAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xB9, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.Y = 0
        var actualCycle = self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10100000)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        actualCycle = self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFC)
        XCTAssertEqual(self.cpu.P, 0b10100000)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0x60
        actualCycle = self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0xFA)
        XCTAssertEqual(self.cpu.P, 0b10100000)
    }
    
}
