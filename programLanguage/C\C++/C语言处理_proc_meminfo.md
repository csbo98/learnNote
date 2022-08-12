这段代码演示了如何在C语言中处理/proc/meminfo中的信息，并不难，C语言中的字符串处理函数和文件读写也很强大，可以方便的用来处理文件和字符串
```c
static void parse_meminfo(unsigned long meminfo[MI_MAX])
{
	static const char fields[] ALIGN1 =
		"MemTotal\0"
		"MemFree\0"
		"MemShared\0"
		"Shmem\0"
		"Buffers\0"
		"Cached\0"
		"SwapTotal\0"
		"SwapFree\0"
		"Dirty\0"
		"Writeback\0"
		"AnonPages\0"
		"Mapped\0"
		"Slab\0";
	char buf[60]; /* actual lines we expect are ~30 chars or less */
	FILE *f;
	int i;

	memset(meminfo, 0, sizeof(meminfo[0]) * MI_MAX);
	f = xfopen_for_read("meminfo");
	while (fgets(buf, sizeof(buf), f) != NULL) {
		char *c = strchr(buf, ':');
		if (!c)
			continue;
		*c = '\0';
		i = index_in_strings(fields, buf);
		if (i >= 0)
			meminfo[i] = strtoul(c+1, NULL, 10);
	}
	fclose(f);
}
```

