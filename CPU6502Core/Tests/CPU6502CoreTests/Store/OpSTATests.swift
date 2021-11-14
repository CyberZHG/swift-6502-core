import XCTest
@testable import CPU6502Core

final class OpSTATests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testSTAZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x85, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xCD
        let actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0xAB], 0xCD)
    }
    
    func testSTAZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x95, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xCD
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0xAB], 0xCD)
        
        self.cpu.PC = 0x0000
        self.cpu.A = 0xCE
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0xAC], 0xCE)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x95, 0xFF])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xCF
        self.cpu.X = 0x11
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0x10], 0xCF)
    }
    
    func testSTAAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x8D, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xEF
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.memory[0xABCD], 0xEF)
    }
    
    func testSTAAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x9D, 0xCD, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xEF
        self.cpu.X = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.memory[0xABCD], 0xEF)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.memory[0xABCE], 0xEF)
    }
    
    func testSTAAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x99, 0xCD, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xEF
        self.cpu.Y = 0
        var actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.memory[0xABCD], 0xEF)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.memory[0xABCE], 0xEF)
    }
    
    func testSTAIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x81, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xEF
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0xABCD], 0xEF)
    }
    
    func testSTAIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x91, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xEF
        self.cpu.Y = 1
        var actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0xABCE], 0xEF)
        
        self.cpu.PC = 0x0000
        self.cpu.Y = 0xF0
        actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0xACBD], 0xEF)
    }
    
}
