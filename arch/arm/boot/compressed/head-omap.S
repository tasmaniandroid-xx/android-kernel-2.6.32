/*
 * linux/arch/arm/boot/compressed/head-omap.S
 *
 * OMAP specific tweaks.  This is merged into head.S by the linker.
 *
 */

#include <linux/linkage.h>
#include <asm/mach-types.h>

		.section        ".start", "ax"

/* this code should preserve r7, r8, and r9. */
__OMAP_start:
#if defined(CONFIG_ARM_ERRATA_430973) && defined(CONFIG_ARCH_OMAP3_HS)

		/* enable access to L2 Cache AuxCR */
enable_btb_flush:
		stmfd   sp!, {r0-r12, r14}
		mov     r0, #42
		mov     r12, r0
		mov     r1, #0
		mov     r2, #4
		mov     r6, #0xff
		adr     r3, aux_control_params
		mcr     p15, 0, r0, c7, c5, 4
		mcr     p15, 0, r0, c7, c10, 5
		smc     #1

		mov     r0, #41
		mov     r12, r0
		mov     r1, #0
		mov     r2, #4
		mov     r6, #0xff
		adr     r3, l2_aux_control_params
		mcr     p15, 0, r0, c7, c5, 4
		mcr     p15, 0, r0, c7, c10, 5
		smc     #1
		ldmfd   sp!, {r0-r12, r14}

		b enable_btb_flush_done
aux_control_params:
	.word   0x1, 0xe2
l2_aux_control_params:
	.word	0x1, 0x8000042
enable_btb_flush_done:



#endif

#ifdef CONFIG_MACH_OMAP_PERSEUS2
		/* support for booting without u-boot */
		mov	r7, #(MACH_TYPE_OMAP_PERSEUS2 & ~0xf)
		orr	r7, r7, #(MACH_TYPE_OMAP_PERSEUS2 & 0xf)
#endif
