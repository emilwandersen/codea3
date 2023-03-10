;buildInfoPackage: chisel3, version: 3.3.2, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit SystemTop : 
  module DataMemory : 
    input clock : Clock
    input reset : Reset
    output io : {flip address : UInt<16>, dataRead : UInt<32>, flip writeEnable : UInt<1>, flip dataWrite : UInt<32>, flip testerEnable : UInt<1>, flip testerAddress : UInt<16>, testerDataRead : UInt<32>, flip testerWriteEnable : UInt<1>, flip testerDataWrite : UInt<32>}
    
    cmem memory : UInt<32>[65536] @[DataMemory.scala 18:20]
    when io.testerEnable : @[DataMemory.scala 22:24]
      read mport _T = memory[io.testerAddress], clock @[DataMemory.scala 24:37]
      io.testerDataRead <= _T @[DataMemory.scala 24:23]
      io.dataRead <= UInt<32>("h00") @[DataMemory.scala 26:17]
      when io.testerWriteEnable : @[DataMemory.scala 27:32]
        write mport _T_1 = memory[io.testerAddress], clock
        _T_1 <= io.testerDataWrite
        io.testerDataRead <= io.testerDataWrite @[DataMemory.scala 30:25]
        skip @[DataMemory.scala 27:32]
      skip @[DataMemory.scala 22:24]
    else : @[DataMemory.scala 32:16]
      read mport _T_2 = memory[io.address], clock @[DataMemory.scala 34:31]
      io.dataRead <= _T_2 @[DataMemory.scala 34:17]
      io.testerDataRead <= UInt<32>("h00") @[DataMemory.scala 36:23]
      when io.writeEnable : @[DataMemory.scala 37:26]
        write mport _T_3 = memory[io.address], clock
        _T_3 <= io.dataWrite
        io.dataRead <= io.dataWrite @[DataMemory.scala 40:19]
        skip @[DataMemory.scala 37:26]
      skip @[DataMemory.scala 32:16]
    
  module Accelerator : 
    input clock : Clock
    input reset : Reset
    output io : {flip start : UInt<1>, done : UInt<1>, address : UInt<16>, flip dataRead : UInt<32>, writeEnable : UInt<1>, dataWrite : UInt<32>}
    
    io.done <= UInt<1>("h00") @[Accelerator.scala 21:10]
    io.address <= UInt<16>("h00") @[Accelerator.scala 22:13]
    io.writeEnable <= UInt<1>("h00") @[Accelerator.scala 23:17]
    io.dataWrite <= UInt<1>("h00") @[Accelerator.scala 24:15]
    reg x : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[Accelerator.scala 26:18]
    reg y : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[Accelerator.scala 27:18]
    reg in : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[Accelerator.scala 28:19]
    reg op : UInt<32>, clock with : (reset => (reset, UInt<32>("h0190"))) @[Accelerator.scala 29:19]
    reg value : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 30:21]
    reg left : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 31:21]
    reg right : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 32:21]
    reg up : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 33:19]
    reg down : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 34:21]
    reg stateReg : UInt<4>, clock with : (reset => (reset, UInt<4>("h00"))) @[Accelerator.scala 40:25]
    reg regUp : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 41:22]
    reg regDown : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 42:24]
    reg regLeft : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 43:24]
    reg regRight : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 44:25]
    reg readReg : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[Accelerator.scala 45:24]
    node _T = eq(UInt<4>("h01"), stateReg) @[Conditional.scala 37:30]
    when _T : @[Conditional.scala 40:58]
      io.done <= UInt<1>("h01") @[Accelerator.scala 50:14]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_1 = eq(UInt<4>("h00"), stateReg) @[Conditional.scala 37:30]
      when _T_1 : @[Conditional.scala 39:67]
        x <= UInt<1>("h00") @[Accelerator.scala 54:8]
        y <= UInt<1>("h00") @[Accelerator.scala 55:8]
        in <= UInt<1>("h00") @[Accelerator.scala 56:9]
        op <= UInt<9>("h0190") @[Accelerator.scala 57:9]
        when io.start : @[Accelerator.scala 58:21]
          stateReg <= UInt<4>("h02") @[Accelerator.scala 59:17]
          skip @[Accelerator.scala 58:21]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_2 = eq(UInt<4>("h02"), stateReg) @[Conditional.scala 37:30]
        when _T_2 : @[Conditional.scala 39:67]
          node _T_3 = lt(x, UInt<5>("h014")) @[Accelerator.scala 64:13]
          when _T_3 : @[Accelerator.scala 64:19]
            y <= UInt<1>("h00") @[Accelerator.scala 65:10]
            stateReg <= UInt<4>("h03") @[Accelerator.scala 66:17]
            skip @[Accelerator.scala 64:19]
          else : @[Accelerator.scala 67:18]
            stateReg <= UInt<4>("h01") @[Accelerator.scala 68:17]
            skip @[Accelerator.scala 67:18]
          skip @[Conditional.scala 39:67]
        else : @[Conditional.scala 39:67]
          node _T_4 = eq(UInt<4>("h03"), stateReg) @[Conditional.scala 37:30]
          when _T_4 : @[Conditional.scala 39:67]
            io.writeEnable <= UInt<1>("h00") @[Accelerator.scala 73:21]
            node _T_5 = lt(y, UInt<5>("h014")) @[Accelerator.scala 74:13]
            when _T_5 : @[Accelerator.scala 74:19]
              node _T_6 = eq(x, UInt<1>("h00")) @[Accelerator.scala 76:15]
              node _T_7 = eq(y, UInt<1>("h00")) @[Accelerator.scala 76:23]
              node _T_8 = or(_T_6, _T_7) @[Accelerator.scala 76:21]
              node _T_9 = eq(x, UInt<5>("h013")) @[Accelerator.scala 76:31]
              node _T_10 = or(_T_8, _T_9) @[Accelerator.scala 76:29]
              node _T_11 = eq(y, UInt<5>("h013")) @[Accelerator.scala 76:40]
              node _T_12 = or(_T_10, _T_11) @[Accelerator.scala 76:38]
              when _T_12 : @[Accelerator.scala 76:48]
                stateReg <= UInt<4>("h04") @[Accelerator.scala 77:19]
                skip @[Accelerator.scala 76:48]
              else : @[Accelerator.scala 79:20]
                stateReg <= UInt<4>("h06") @[Accelerator.scala 80:19]
                skip @[Accelerator.scala 79:20]
              skip @[Accelerator.scala 74:19]
            else : @[Accelerator.scala 83:19]
              stateReg <= UInt<4>("h02") @[Accelerator.scala 84:18]
              node _T_13 = add(x, UInt<1>("h01")) @[Accelerator.scala 85:14]
              node _T_14 = tail(_T_13, 1) @[Accelerator.scala 85:14]
              x <= _T_14 @[Accelerator.scala 85:11]
              skip @[Accelerator.scala 83:19]
            skip @[Conditional.scala 39:67]
          else : @[Conditional.scala 39:67]
            node _T_15 = eq(UInt<4>("h04"), stateReg) @[Conditional.scala 37:30]
            when _T_15 : @[Conditional.scala 39:67]
              io.address <= op @[Accelerator.scala 91:17]
              io.writeEnable <= UInt<1>("h01") @[Accelerator.scala 92:21]
              io.dataWrite <= UInt<1>("h00") @[Accelerator.scala 93:19]
              node _T_16 = add(y, UInt<1>("h01")) @[Accelerator.scala 94:11]
              node _T_17 = tail(_T_16, 1) @[Accelerator.scala 94:11]
              y <= _T_17 @[Accelerator.scala 94:8]
              node _T_18 = add(op, UInt<1>("h01")) @[Accelerator.scala 95:13]
              node _T_19 = tail(_T_18, 1) @[Accelerator.scala 95:13]
              op <= _T_19 @[Accelerator.scala 95:9]
              node _T_20 = add(in, UInt<1>("h01")) @[Accelerator.scala 96:13]
              node _T_21 = tail(_T_20, 1) @[Accelerator.scala 96:13]
              in <= _T_21 @[Accelerator.scala 96:9]
              stateReg <= UInt<4>("h03") @[Accelerator.scala 97:15]
              skip @[Conditional.scala 39:67]
            else : @[Conditional.scala 39:67]
              node _T_22 = eq(UInt<4>("h05"), stateReg) @[Conditional.scala 37:30]
              when _T_22 : @[Conditional.scala 39:67]
                io.address <= op @[Accelerator.scala 101:18]
                io.writeEnable <= UInt<1>("h01") @[Accelerator.scala 102:22]
                io.dataWrite <= UInt<8>("h0ff") @[Accelerator.scala 103:20]
                node _T_23 = add(y, UInt<1>("h01")) @[Accelerator.scala 104:12]
                node _T_24 = tail(_T_23, 1) @[Accelerator.scala 104:12]
                y <= _T_24 @[Accelerator.scala 104:9]
                node _T_25 = add(op, UInt<1>("h01")) @[Accelerator.scala 105:14]
                node _T_26 = tail(_T_25, 1) @[Accelerator.scala 105:14]
                op <= _T_26 @[Accelerator.scala 105:10]
                node _T_27 = add(in, UInt<1>("h01")) @[Accelerator.scala 106:13]
                node _T_28 = tail(_T_27, 1) @[Accelerator.scala 106:13]
                in <= _T_28 @[Accelerator.scala 106:9]
                stateReg <= UInt<4>("h03") @[Accelerator.scala 107:16]
                skip @[Conditional.scala 39:67]
              else : @[Conditional.scala 39:67]
                node _T_29 = eq(UInt<4>("h06"), stateReg) @[Conditional.scala 37:30]
                when _T_29 : @[Conditional.scala 39:67]
                  io.address <= in @[Accelerator.scala 111:17]
                  value <= io.dataRead @[Accelerator.scala 112:12]
                  stateReg <= UInt<4>("h07") @[Accelerator.scala 113:15]
                  skip @[Conditional.scala 39:67]
                else : @[Conditional.scala 39:67]
                  node _T_30 = eq(UInt<4>("h07"), stateReg) @[Conditional.scala 37:30]
                  when _T_30 : @[Conditional.scala 39:67]
                    node _T_31 = eq(value, UInt<1>("h00")) @[Accelerator.scala 116:17]
                    when _T_31 : @[Accelerator.scala 116:24]
                      stateReg <= UInt<4>("h04") @[Accelerator.scala 117:17]
                      skip @[Accelerator.scala 116:24]
                    else : @[Accelerator.scala 118:18]
                      node _T_32 = sub(in, UInt<1>("h01")) @[Accelerator.scala 119:23]
                      node _T_33 = tail(_T_32, 1) @[Accelerator.scala 119:23]
                      io.address <= _T_33 @[Accelerator.scala 119:19]
                      left <= io.dataRead @[Accelerator.scala 120:13]
                      stateReg <= UInt<4>("h08") @[Accelerator.scala 121:17]
                      skip @[Accelerator.scala 118:18]
                    skip @[Conditional.scala 39:67]
                  else : @[Conditional.scala 39:67]
                    node _T_34 = eq(UInt<4>("h08"), stateReg) @[Conditional.scala 37:30]
                    when _T_34 : @[Conditional.scala 39:67]
                      node _T_35 = eq(left, UInt<1>("h00")) @[Accelerator.scala 125:16]
                      when _T_35 : @[Accelerator.scala 125:23]
                        stateReg <= UInt<4>("h04") @[Accelerator.scala 126:17]
                        skip @[Accelerator.scala 125:23]
                      else : @[Accelerator.scala 127:18]
                        node _T_36 = add(in, UInt<1>("h01")) @[Accelerator.scala 128:23]
                        node _T_37 = tail(_T_36, 1) @[Accelerator.scala 128:23]
                        io.address <= _T_37 @[Accelerator.scala 128:19]
                        right <= io.dataRead @[Accelerator.scala 129:14]
                        stateReg <= UInt<4>("h09") @[Accelerator.scala 130:17]
                        skip @[Accelerator.scala 127:18]
                      skip @[Conditional.scala 39:67]
                    else : @[Conditional.scala 39:67]
                      node _T_38 = eq(UInt<4>("h09"), stateReg) @[Conditional.scala 37:30]
                      when _T_38 : @[Conditional.scala 39:67]
                        node _T_39 = eq(right, UInt<1>("h00")) @[Accelerator.scala 134:18]
                        when _T_39 : @[Accelerator.scala 134:27]
                          stateReg <= UInt<4>("h04") @[Accelerator.scala 135:18]
                          skip @[Accelerator.scala 134:27]
                        else : @[Accelerator.scala 136:19]
                          node _T_40 = sub(in, UInt<5>("h014")) @[Accelerator.scala 137:26]
                          node _T_41 = tail(_T_40, 1) @[Accelerator.scala 137:26]
                          io.address <= _T_41 @[Accelerator.scala 137:20]
                          up <= io.dataRead @[Accelerator.scala 138:12]
                          stateReg <= UInt<4>("h0a") @[Accelerator.scala 139:18]
                          skip @[Accelerator.scala 136:19]
                        skip @[Conditional.scala 39:67]
                      else : @[Conditional.scala 39:67]
                        node _T_42 = eq(UInt<4>("h0a"), stateReg) @[Conditional.scala 37:30]
                        when _T_42 : @[Conditional.scala 39:67]
                          node _T_43 = eq(up, UInt<1>("h00")) @[Accelerator.scala 144:15]
                          when _T_43 : @[Accelerator.scala 144:24]
                            stateReg <= UInt<4>("h04") @[Accelerator.scala 145:18]
                            skip @[Accelerator.scala 144:24]
                          else : @[Accelerator.scala 146:19]
                            node _T_44 = add(in, UInt<5>("h014")) @[Accelerator.scala 147:26]
                            node _T_45 = tail(_T_44, 1) @[Accelerator.scala 147:26]
                            io.address <= _T_45 @[Accelerator.scala 147:20]
                            down <= io.dataRead @[Accelerator.scala 148:14]
                            stateReg <= UInt<4>("h0b") @[Accelerator.scala 149:17]
                            skip @[Accelerator.scala 146:19]
                          skip @[Conditional.scala 39:67]
                        else : @[Conditional.scala 39:67]
                          node _T_46 = eq(UInt<4>("h0b"), stateReg) @[Conditional.scala 37:30]
                          when _T_46 : @[Conditional.scala 39:67]
                            node _T_47 = eq(down, UInt<1>("h00")) @[Accelerator.scala 153:16]
                            when _T_47 : @[Accelerator.scala 153:23]
                              stateReg <= UInt<4>("h04") @[Accelerator.scala 154:17]
                              skip @[Accelerator.scala 153:23]
                            else : @[Accelerator.scala 155:18]
                              stateReg <= UInt<4>("h05") @[Accelerator.scala 156:17]
                              skip @[Accelerator.scala 155:18]
                            skip @[Conditional.scala 39:67]
    
  module SystemTop : 
    input clock : Clock
    input reset : UInt<1>
    output io : {done : UInt<1>, flip start : UInt<1>, flip testerDataMemEnable : UInt<1>, flip testerDataMemAddress : UInt<16>, testerDataMemDataRead : UInt<32>, flip testerDataMemWriteEnable : UInt<1>, flip testerDataMemDataWrite : UInt<32>}
    
    inst dataMemory of DataMemory @[SystemTop.scala 18:26]
    dataMemory.clock <= clock
    dataMemory.reset <= reset
    inst accelerator of Accelerator @[SystemTop.scala 19:27]
    accelerator.clock <= clock
    accelerator.reset <= reset
    io.done <= accelerator.io.done @[SystemTop.scala 23:11]
    accelerator.io.start <= io.start @[SystemTop.scala 24:24]
    accelerator.io.dataRead <= dataMemory.io.dataRead @[SystemTop.scala 27:27]
    dataMemory.io.address <= accelerator.io.address @[SystemTop.scala 28:25]
    dataMemory.io.dataWrite <= accelerator.io.dataWrite @[SystemTop.scala 29:27]
    dataMemory.io.writeEnable <= accelerator.io.writeEnable @[SystemTop.scala 30:29]
    dataMemory.io.testerAddress <= io.testerDataMemAddress @[SystemTop.scala 33:31]
    io.testerDataMemDataRead <= dataMemory.io.testerDataRead @[SystemTop.scala 34:28]
    dataMemory.io.testerDataWrite <= io.testerDataMemDataWrite @[SystemTop.scala 35:33]
    dataMemory.io.testerEnable <= io.testerDataMemEnable @[SystemTop.scala 36:30]
    dataMemory.io.testerWriteEnable <= io.testerDataMemWriteEnable @[SystemTop.scala 37:35]
    
