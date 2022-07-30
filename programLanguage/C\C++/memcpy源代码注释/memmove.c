/* Copy memory to memory until the specified number of bytes
   has been copied.  Overlap is handled correctly.
   Copyright (C) 1991-2022 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

#include <string.h>
#include <memcopy.h>

/* All this is so that bcopy.c can #include
   this file after defining some things.  */
#ifndef	a1
#define	a1	dest	/* First arg is DEST.  */
#define	a1const
#define	a2	src	/* Second arg is SRC.  */
#define	a2const	const
#undef memmove
#endif
#if	!defined(RETURN) || !defined(rettype)
#define	RETURN(s)	return (s)	/* Return DEST.  */
#define	rettype		void *
#endif

#ifndef MEMMOVE
#define MEMMOVE memmove
#endif

/*
  memmove解决了内存重叠的情况：它是通过在合适的时候分别选择正向拷贝和反向拷贝两种方式来解决的
  在运行效率上面，memmove和memcpy都是一样快的，二者在具体拷贝上的操作一模一样

  与直接写for循环拷贝相比，memcpy和memmove都考虑到了内存对齐的情况，因此它们的运行效率更高
  还有一个优化是减少了循环的次数，在每一次循环里面都进行多次拷贝；一方面是减少了要执行的指令数目，另一方面是减少了分支预测
  错误的次数
  */

rettype
inhibit_loop_to_libcall
MEMMOVE (a1const void *a1, a2const void *a2, size_t len)
{
  // 这个地方把地址先转换为long int，说明最大的虚拟地址也不可能超过long int的范围，这个应该是考虑到目前的硬件限制
  unsigned long int dstp = (long int) dest;
  unsigned long int srcp = (long int) src;

  /* This test makes the forward copying code be used whenever possible.
     Reduces the working set.  */
  //  这个地方是unsigned的比较，dstp < srcp时会得到一个非常大的正数,这是因为dstp和srcp都是unsigned的，所以《dstp-srcp》这个表达式的结果也是unsigned的
  // 所以就只剩下dstp位于[srcp，srcp+len]之间的情况，这种情况的重叠可以通过反向拷贝来解决
  if (dstp - srcp >= len)	/* *Unsigned* compare!  */
    {
      /* Copy from the beginning to the end.  */

#if MEMCPY_OK_FOR_FWD_MEMMOVE
      dest = memcpy (dest, src, len);
#else
      /* If there not too few bytes to copy, use word copy.  */
      if (len >= OP_T_THRES)
	{
	  /* Copy just a few bytes to make DSTP aligned.  */
	  len -= (-dstp) % OPSIZ;   // 利用了unsigned的计算性质来计算拷贝多少字节让dstp 8字节对齐
	  BYTE_COPY_FWD (dstp, srcp, (-dstp) % OPSIZ);

	  /* Copy whole pages from SRCP to DSTP by virtual address
	     manipulation, as much as possible.  */

	  PAGE_COPY_FWD_MAYBE (dstp, srcp, len, len);

	  /* Copy from SRCP to DSTP taking advantage of the known
	     alignment of DSTP.  Number of bytes remaining is put
	     in the third argument, i.e. in LEN.  This number may
	     vary from machine to machine.  */

	  WORD_COPY_FWD (dstp, srcp, len, len);

	  /* Fall out and copy the tail.  */
	}

      /* There are just a few bytes to copy.  Use byte memory operations.  */
      BYTE_COPY_FWD (dstp, srcp, len);
#endif /* MEMCPY_OK_FOR_FWD_MEMMOVE */
    }
  else
    {
      /* Copy from the end to the beginning.  */
      srcp += len;
      dstp += len;

      /* If there not too few bytes to copy, use word copy.  */
      if (len >= OP_T_THRES)
	{
	  /* Copy just a few bytes to make DSTP aligned.  */
	  len -= dstp % OPSIZ;
	  BYTE_COPY_BWD (dstp, srcp, dstp % OPSIZ);

	  /* Copy from SRCP to DSTP taking advantage of the known
	     alignment of DSTP.  Number of bytes remaining is put
	     in the third argument, i.e. in LEN.  This number may
	     vary from machine to machine.  */

	  WORD_COPY_BWD (dstp, srcp, len, len);

	  /* Fall out and copy the tail.  */
	}

      /* There are just a few bytes to copy.  Use byte memory operations.  */
      BYTE_COPY_BWD (dstp, srcp, len);
    }

  RETURN (dest);
}
#ifndef memmove
libc_hidden_builtin_def (memmove)
#endif
