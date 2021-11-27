import XCTest
@testable import CPU6502Core

final class OpBCCTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testBCCRelative() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x90, 0x02])
        self.cpu.PC = 0x0000
        self.cpu.C = false
        var actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0004)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x90, 0x69])
        self.cpu.PC = 0x0000
        self.cpu.C = true
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        
        self.memory.setBytes(start: 0x08FD, bytes: [0x90, 0x01])
        self.cpu.PC = 0x08FD
        self.cpu.C = false
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0900)
        
        self.memory.setBytes(start: 0x0800, bytes: [0x90, 0xFD])
        self.cpu.PC = 0x0800
        self.cpu.C = false
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x07FF)
    }
    
}
