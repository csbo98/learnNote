/* Copy memory to memory until the specified number of bytes
   has been copied.  Overlap is NOT handled correctly.
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

#ifndef MEMCPY
# define MEMCPY memcpy
#endif
/*
      总体来说，memcpy就是：
      1. 先拷贝若干字节，把dstp对齐到8字节
      2. 判断是否可以通过按页拷贝的方式拷贝大量字符串，若可以就按照页拷贝
      3. 将剩下的字节按照对齐的word拷贝
      4. 还有一些剩下的字节按照字节来拷贝
  */

void *
MEMCPY (void *dstpp, const void *srcpp, size_t len)
{
  // 这个地方使用了long int,为了对地址做一些运算，使用long int 比较方便
  unsigned long int dstp = (long int) dstpp;
  unsigned long int srcp = (long int) srcpp;

  /* Copy from the beginning to the end.  */

  /* If there not too few bytes to copy, use word copy.  */
  if (len >= OP_T_THRES)
    {
      /* Copy just a few bytes to make DSTP aligned.  */
      // dstp和srcp只能对齐一个，为什么对齐dstp而不是srcp呢？
      len -= (-dstp) % OPSIZ;  // OPSIZ是sizeof(long int)，长度为8个字节
      BYTE_COPY_FWD (dstp, srcp, (-dstp) % OPSIZ);

      /* Copy whole pages from SRCP to DSTP by virtual address manipulation,
	 as much as possible.  */

      PAGE_COPY_FWD_MAYBE (dstp, srcp, len, len); // 这个宏通过操纵虚拟地址来整页的拷贝，这个地方几乎不可能用到

      /* Copy from SRCP to DSTP taking advantage of the known alignment of
	 DSTP.  Number of bytes remaining is put in the third argument,
	 i.e. in LEN.  This number may vary from machine to machine.  */
    
      WORD_COPY_FWD (dstp, srcp, len, len);

      /* Fall out and copy the tail.  */
    }

  /* There are just a few bytes to copy.  Use byte memory operations.  */
  BYTE_COPY_FWD (dstp, srcp, len);

  return dstpp;
}
libc_hidden_builtin_def (MEMCPY)
