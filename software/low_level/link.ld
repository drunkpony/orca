/*======================================================================*/
/* Proxy kernel linker script                                           */
/*======================================================================*/
/* This is the linker script used when building the proxy kernel. */

/*----------------------------------------------------------------------*/
/* Setup                                                                */
/*----------------------------------------------------------------------*/

/* The OUTPUT_ARCH command specifies the machine architecture where the
   argument is one of the names used in the BFD library. More
   specifically one of the entires in bfd/cpu-mips.c */

OUTPUT_ARCH( "riscv" )
MEMORY
{
 IMEM : ORIGIN = 0x0, LENGTH = 19K 
 DMEM : ORIGIN = 19K, LENGTH = 2K 
 FMEM : ORIGIN = 21K, LENGTH = 3K
}
/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/
ENTRY(_start)

SECTIONS
{

  /* text: test code section */
  . = 0x100;
  .init . :
  {
	  *(.init)
  }>IMEM
  .text :
  {
    *(.text)
  }>IMEM
  /* data segment */
  .data : { *(.data) }>DMEM
  .rodata : { *(.rodata) }>FMEM

  .sdata : {
    _gp = . + 0x800;
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  }>DMEM

  /* bss segment */
  .sbss : {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
  }>DMEM
  .bss : { *(.bss) }>DMEM

  /* thread-local data segment */
  .tdata :
  {
    _tls_data = .;
    *(.tdata)
  }>DMEM
  .tbss :
  {
    *(.tbss)
  }>DMEM



  /* End of uninitalized data segement */
  _end = .;

  _end_of_memory = 24K;
}
