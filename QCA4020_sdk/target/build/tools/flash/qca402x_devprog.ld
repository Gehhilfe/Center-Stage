/**********
 * This file was generated by a tool.
 *    Tool name     : MakeLinkerScript.py
 *    Template file : DefaultTemplateLinkerScript.ld
 *    Placement file: app.placement
 *    Placement file: LinkerLibs.txt
 *
 * Do not modify this file directly.
 * Rather, change the template, the placement file or the tool.
 *********/

/* RAM_START  = 0x10000000; */
/* RAM_LENGTH = 0x000B8000; */
/* XIP_START  = 0x10100000; */
/* XIP_LENGTH = 0x00080000; */

MEMORY
{
   DEVPRG_RAM_FOM_MEMORY                          (RX) : ORIGIN = 0x10002000, LENGTH = 0x55000
   RAM_SBL_CODE_MEMORY                            (W)  : ORIGIN = 0x100A0000, LENGTH = 0xE200
   DEVPRG_RAM_FOM_BSP_STACK_ZI_MEMORY             (W)  : ORIGIN = 0x100af800, LENGTH = 0x2840
}

PHDRS
{
   DEVPRG_RAM_FOM_SEGMENT     PT_LOAD;
   RAM_SBL_CODE_SEGMENT       PT_LOAD;
   DEVPRG_RAM_FOM_BSP_STACK_ZI_SEGMENT  PT_LOAD;
}

ENTRY(SBL_Entry)

SECTIONS
{
    RAM_SBL_RO_REGION :
    {
       sbl_gcc*.*(QUARTZ_SBL_ENTRY)
       sbl_gcc*.*(SBL_VECTOR_TABLE)
	   sbl1*.*(.text)
	   sbl1*.*(.text.*)
	   sbl1*.*(.rodata)
	   boot*.*(.text)
	   boot*.*(.text.*)
	   boot*.*(.rodata)
	   sbl1*.*(SBL_VECTOR_TABLE) 
	   *.*(RAM_SBL_RO_SECTION)

    } >RAM_SBL_CODE_MEMORY : RAM_SBL_CODE_SEGMENT
	
    .ARM.exidx : {
		__exidx_start = .;
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
		__exidx_end = .;
    } >DEVPRG_RAM_FOM_MEMORY : DEVPRG_RAM_FOM_SEGMENT
	
    RAM_FOM_DEVPRG_RO_REGION : 
    {
		*(.text)
		*(.text.*)
		*(.ARM.Collect*)
		*(.rodata)
		*(.rodata.*)
		*flash_init_config.o(.text)
		*(.rodata.str1.4)
    } >DEVPRG_RAM_FOM_MEMORY : DEVPRG_RAM_FOM_SEGMENT

    RAM_FOM_BSP_RW_REGION : 
    {
	    *(.data)
	    *(.data.*)
		*(.ARM.attributes)    
		*(RAM_FOM_BSP_RW_SECTION)
    } >DEVPRG_RAM_FOM_MEMORY : DEVPRG_RAM_FOM_SEGMENT
		
    RAM_FOM_BSP_ZI_REGION : 
    {
        _RAM_FOM_APPS_ZI_START = .;
		*(.bss)
		*(.bss.*)
        *(RAM_FOM_BSP_ZI_SECTION)
        _RAM_FOM_APPS_ZI_END = ALIGN(0x100);      
    } >DEVPRG_RAM_FOM_MEMORY : DEVPRG_RAM_FOM_SEGMENT

	SBL_LOG_META_INFO_RW_SECTION :
	{
	    _SBL_LOG_META_INFO_RW_START = .;
		. += 64;
	} >DEVPRG_RAM_FOM_BSP_STACK_ZI_MEMORY : DEVPRG_RAM_FOM_BSP_STACK_ZI_SEGMENT
	
	SBL_LOG_BUF_RW_SECTION :
	{
	    _SBL_LOG_BUF_RW_START = .;
		. += 4096;
	} >DEVPRG_RAM_FOM_BSP_STACK_ZI_MEMORY : DEVPRG_RAM_FOM_BSP_STACK_ZI_SEGMENT
	
	RAM_FOM_BSP_STACK_ZI_REGION :
	{
	   *.*(RAM_FOM_BSP_STACK_ZI_SCETION)
	   . += 4096;
	} >DEVPRG_RAM_FOM_BSP_STACK_ZI_MEMORY : DEVPRG_RAM_FOM_BSP_STACK_ZI_SEGMENT
	
	.heap : {
       __heap_start__ = .;
       end = __heap_start__;
       _end = end;
       __end = end;
       KEEP(*(.heap))
       __heap_end__ = .;
       __HeapLimit = __heap_end__;
    } >DEVPRG_RAM_FOM_MEMORY : DEVPRG_RAM_FOM_SEGMENT
}

Image$$RAM_FOM_APPS_ZI_REGION$$ZI$$Base          = _RAM_FOM_APPS_ZI_START;
Load$$RAM_FOM_APPS_ZI_REGION$$ZI$$Base           = _RAM_FOM_APPS_ZI_START;
Image$$RAM_FOM_APPS_ZI_REGION$$ZI$$Length        = _RAM_FOM_APPS_ZI_END - _RAM_FOM_APPS_ZI_START;
Image$$SBL_LOG_BUF_RW_SECTION$$Base              = _SBL_LOG_BUF_RW_START;
Image$$SBL_LOG_META_INFO_RW_SECTION$$Base        = _SBL_LOG_META_INFO_RW_START;
