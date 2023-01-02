import chisel3._
import chisel3.util._

import scala.collection.immutable

class Accelerator extends Module {
  val io = IO(new Bundle {
    val start = Input(Bool())
    val done = Output(Bool())

    val address = Output(UInt (16.W))
    val dataRead = Input(UInt (32.W))
    val writeEnable = Output(Bool ())
    val dataWrite = Output(UInt (32.W))

  })

  //Write here your code

  //defalut values
  io.done:=false.B
  io.address:=0.U(16.W)
  io.writeEnable:=false.B
  io.dataWrite:=false.B

  val x = RegInit(0.U(16.W))
  val y = RegInit(0.U(16.W))
  val in = RegInit(0.U(32.W))
  val op = RegInit(400.U(32.W))
  val value =RegInit( 0.U)
  val left = RegInit(0.U)
  val right =RegInit( 0.U)
  val up = RegInit(0.U)
  val down = RegInit(0.U)

  //state enum
  val init::end::xloop::yloop::write0::write255::read0::read1::read2::read3::read4::read5:: Nil = Enum(12)

  //registers
  val stateReg = RegInit(init)
  val regUp = RegInit( 0.U)
  val regDown = RegInit( 0.U)
  val regLeft = RegInit( 0.U)
  val regRight = RegInit( 0.U)
  val readReg = RegInit(0.U)

  switch(stateReg){
    //end
    is(end){
      io.done:=true.B
    }
    //start
    is(init){
      x:=0.U
      y:=0.U
      in:=0.U
      op:=400.U
      when(io.start){
        stateReg:=xloop
      }
    }
    //x loop
    is(xloop){
      when(x<20.U){
        y:=0.U
        stateReg:=yloop
      }.otherwise{
        stateReg:=end
      }
    }
    //yloop
    is(yloop){
      io.writeEnable:=false.B
      when(y<20.U){

        when(x===0.U|y===0.U|x===19.U|y===19.U){
          stateReg:=write0

        }.otherwise{
          stateReg:=read0
        }

      }.otherwise {
        stateReg := xloop
        x :=x+ 1.U
      }
    }

    //write 0 in memory
    is(write0){
      io.address:=op
      io.writeEnable:=true.B
      io.dataWrite:=0.U
      y:=y+1.U
      op:=op+1.U
      in:=in+1.U
      stateReg:=yloop
    }
    //write 255 in memory
    is(write255){
      io.address := op
      io.writeEnable := true.B
      io.dataWrite := 255.U
      y :=y+ 1.U
      op :=op+1.U
      in:=in+1.U
      stateReg := yloop
    }

    is(read0){
      io.address:=in
      value:=io.dataRead
      stateReg:=read1
    }
    is(read1){
      when(value===0.U){
        stateReg:=write0
      }.otherwise{
        io.address:=in-1.U
        left:=io.dataRead
        stateReg:=read2
      }
    }
    is(read2){
      when(left===0.U){
        stateReg:=write0
      }.otherwise{
        io.address:=in+1.U
        right:=io.dataRead
        stateReg:=read3
      }
    }
    is(read3){
      when(right === 0.U) {
        stateReg := write0
      }.otherwise {
        io.address := in -20.U
        up := io.dataRead
        stateReg := read4
      }
    }

    is(read4) {
      when(up === 0.U) {
        stateReg := write0
      }.otherwise {
        io.address := in + 20.U
        down := io.dataRead
        stateReg:=read5
      }
    }
    is(read5){
      when(down===0.U){
        stateReg:=write0
      }.otherwise{
        stateReg:=write255
      }
    }

  }

}
