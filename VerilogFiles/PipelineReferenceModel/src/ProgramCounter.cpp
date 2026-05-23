#include <cstdint>

struct Input {
    bool reset;
    bool Branch;
    bool Equal;
    bool Jump;
    bool PC_Write;
    uint32_t branch_target;
    uint32_t jump_target;
};

struct Output {
    uint32_t pc_current;
    uint32_t pc_plus_4;
};

struct state {
    uint32_t pc_current;
    uint32_t next_pc;
    bool PC_Src;
};

class program_counter {
public:
    program_counter() {
        s_ = state{0, 0, false};
    }
    Output step(const Input& in){
        Output out;
        out.pc_current = s_.pc_current;
        out.pc_plus_4 = s_.pc_current + 4;

        state next = s_;

        if (in.reset) {
            next.pc_current = 0;
            next.next_pc = 0;
            next.PC_Src = false;
        } else {
            next.PC_Src = in.Branch && in.Equal;
            next.pc_current = next.next_pc;
            if (in.Jump){
                next.next_pc = in.jump_target;
            } else if (next.PC_Src) {
                next.next_pc = in.branch_target;
            } else {
                next.next_pc = next.next_pc + 4;
            }
        }
        s_ = next;
        return out;
    }
private:
    state s_;
};