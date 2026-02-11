connect -url $::env(HW_SERVER_URL)

targets -set -filter {name =~ "xcu*"}
puts {Downloading bitstream}
fpga $::env(BITSTREAM)

targets -set -filter {name =~ "Hart #0*" && jtag_cable_name =~ "Xilinx*"}
stop

targets -set -filter {name =~ "RISC-V*" && jtag_cable_name =~ "Xilinx*"}
puts {Downloading Linux image}
dow -data linux-stable/arch/riscv/boot/Image 0x81000000
puts {Downloading ramdisk}
dow -data debian-riscv64/ramdisk 0x85000000

targets -set -filter {name =~ "Hart #0*" && jtag_cable_name =~ "Xilinx*"}
puts {Downloading boot.elf}
dow -clear workspace/boot.elf
rwr a0 0
rwr a1 0x10080
rwr s0 0x80000000
puts {Starting CPU}
con
