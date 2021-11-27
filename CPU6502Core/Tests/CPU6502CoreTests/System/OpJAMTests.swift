import XCTest
@testable import CPU6502Core

final class OpJAMTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testJAMImplied() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x02, 0x12, 0x22, 0x32, 0x42, 0x52])
        self.memory.setBytes(start: 0x0006, bytes: [0x62, 0x72, 0x92, 0xB2, 0xD2, 0xF2])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 1000)
        XCTAssertLessThan(actualCycle, 4)
    }

}
