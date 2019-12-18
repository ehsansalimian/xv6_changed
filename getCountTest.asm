
_getCountTest:     file format elf32-i386


Disassembly of section .text:

00000000 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	8b 45 08             	mov    0x8(%ebp),%eax
   6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
   9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
   a:	89 c2                	mov    %eax,%edx
   c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10:	83 c1 01             	add    $0x1,%ecx
  13:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  17:	83 c2 01             	add    $0x1,%edx
  1a:	84 db                	test   %bl,%bl
  1c:	88 5a ff             	mov    %bl,-0x1(%edx)
  1f:	75 ef                	jne    10 <strcpy+0x10>
    ;
  return os;
}
  21:	5b                   	pop    %ebx
  22:	5d                   	pop    %ebp
  23:	c3                   	ret    
  24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000030 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	8b 55 08             	mov    0x8(%ebp),%edx
  36:	53                   	push   %ebx
  37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  3a:	0f b6 02             	movzbl (%edx),%eax
  3d:	84 c0                	test   %al,%al
  3f:	74 2d                	je     6e <strcmp+0x3e>
  41:	0f b6 19             	movzbl (%ecx),%ebx
  44:	38 d8                	cmp    %bl,%al
  46:	74 0e                	je     56 <strcmp+0x26>
  48:	eb 2b                	jmp    75 <strcmp+0x45>
  4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  50:	38 c8                	cmp    %cl,%al
  52:	75 15                	jne    69 <strcmp+0x39>
    p++, q++;
  54:	89 d9                	mov    %ebx,%ecx
  56:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  59:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  5c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  5f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
  63:	84 c0                	test   %al,%al
  65:	75 e9                	jne    50 <strcmp+0x20>
  67:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
  69:	29 c8                	sub    %ecx,%eax
}
  6b:	5b                   	pop    %ebx
  6c:	5d                   	pop    %ebp
  6d:	c3                   	ret    
  6e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  71:	31 c0                	xor    %eax,%eax
  73:	eb f4                	jmp    69 <strcmp+0x39>
  75:	0f b6 cb             	movzbl %bl,%ecx
  78:	eb ef                	jmp    69 <strcmp+0x39>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000080 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  86:	80 39 00             	cmpb   $0x0,(%ecx)
  89:	74 12                	je     9d <strlen+0x1d>
  8b:	31 d2                	xor    %edx,%edx
  8d:	8d 76 00             	lea    0x0(%esi),%esi
  90:	83 c2 01             	add    $0x1,%edx
  93:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  97:	89 d0                	mov    %edx,%eax
  99:	75 f5                	jne    90 <strlen+0x10>
    ;
  return n;
}
  9b:	5d                   	pop    %ebp
  9c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
  9d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    
  a1:	eb 0d                	jmp    b0 <memset>
  a3:	90                   	nop
  a4:	90                   	nop
  a5:	90                   	nop
  a6:	90                   	nop
  a7:	90                   	nop
  a8:	90                   	nop
  a9:	90                   	nop
  aa:	90                   	nop
  ab:	90                   	nop
  ac:	90                   	nop
  ad:	90                   	nop
  ae:	90                   	nop
  af:	90                   	nop

000000b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 55 08             	mov    0x8(%ebp),%edx
  b6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  bd:	89 d7                	mov    %edx,%edi
  bf:	fc                   	cld    
  c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c2:	89 d0                	mov    %edx,%eax
  c4:	5f                   	pop    %edi
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	89 f6                	mov    %esi,%esi
  c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000d0 <strchr>:

char*
strchr(const char *s, char c)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	53                   	push   %ebx
  d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
  da:	0f b6 18             	movzbl (%eax),%ebx
  dd:	84 db                	test   %bl,%bl
  df:	74 1d                	je     fe <strchr+0x2e>
    if(*s == c)
  e1:	38 d3                	cmp    %dl,%bl
  e3:	89 d1                	mov    %edx,%ecx
  e5:	75 0d                	jne    f4 <strchr+0x24>
  e7:	eb 17                	jmp    100 <strchr+0x30>
  e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  f0:	38 ca                	cmp    %cl,%dl
  f2:	74 0c                	je     100 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
  f4:	83 c0 01             	add    $0x1,%eax
  f7:	0f b6 10             	movzbl (%eax),%edx
  fa:	84 d2                	test   %dl,%dl
  fc:	75 f2                	jne    f0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
  fe:	31 c0                	xor    %eax,%eax
}
 100:	5b                   	pop    %ebx
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    
 103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <gets>:

char*
gets(char *buf, int max)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 115:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 117:	53                   	push   %ebx
 118:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 11b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11e:	eb 31                	jmp    151 <gets+0x41>
    cc = read(0, &c, 1);
 120:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 127:	00 
 128:	89 7c 24 04          	mov    %edi,0x4(%esp)
 12c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 133:	e8 02 01 00 00       	call   23a <read>
    if(cc < 1)
 138:	85 c0                	test   %eax,%eax
 13a:	7e 1d                	jle    159 <gets+0x49>
      break;
    buf[i++] = c;
 13c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 140:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 142:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 145:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 147:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 14b:	74 0c                	je     159 <gets+0x49>
 14d:	3c 0a                	cmp    $0xa,%al
 14f:	74 08                	je     159 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 151:	8d 5e 01             	lea    0x1(%esi),%ebx
 154:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 157:	7c c7                	jl     120 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 160:	83 c4 2c             	add    $0x2c,%esp
 163:	5b                   	pop    %ebx
 164:	5e                   	pop    %esi
 165:	5f                   	pop    %edi
 166:	5d                   	pop    %ebp
 167:	c3                   	ret    
 168:	90                   	nop
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	56                   	push   %esi
 174:	53                   	push   %ebx
 175:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 182:	00 
 183:	89 04 24             	mov    %eax,(%esp)
 186:	e8 d7 00 00 00       	call   262 <open>
  if(fd < 0)
 18b:	85 c0                	test   %eax,%eax
stat(const char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 18f:	78 27                	js     1b8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 191:	8b 45 0c             	mov    0xc(%ebp),%eax
 194:	89 1c 24             	mov    %ebx,(%esp)
 197:	89 44 24 04          	mov    %eax,0x4(%esp)
 19b:	e8 da 00 00 00       	call   27a <fstat>
  close(fd);
 1a0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1a3:	89 c6                	mov    %eax,%esi
  close(fd);
 1a5:	e8 a0 00 00 00       	call   24a <close>
  return r;
 1aa:	89 f0                	mov    %esi,%eax
}
 1ac:	83 c4 10             	add    $0x10,%esp
 1af:	5b                   	pop    %ebx
 1b0:	5e                   	pop    %esi
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	90                   	nop
 1b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 1b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1bd:	eb ed                	jmp    1ac <stat+0x3c>
 1bf:	90                   	nop

000001c0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c7:	0f be 11             	movsbl (%ecx),%edx
 1ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 1cd:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 1cf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 1d4:	77 17                	ja     1ed <atoi+0x2d>
 1d6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1d8:	83 c1 01             	add    $0x1,%ecx
 1db:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1de:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e2:	0f be 11             	movsbl (%ecx),%edx
 1e5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1e8:	80 fb 09             	cmp    $0x9,%bl
 1eb:	76 eb                	jbe    1d8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1ed:	5b                   	pop    %ebx
 1ee:	5d                   	pop    %ebp
 1ef:	c3                   	ret    

000001f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f0:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1f1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	56                   	push   %esi
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	53                   	push   %ebx
 1fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 200:	85 db                	test   %ebx,%ebx
 202:	7e 12                	jle    216 <memmove+0x26>
 204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 208:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 20c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 20f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 212:	39 da                	cmp    %ebx,%edx
 214:	75 f2                	jne    208 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 216:	5b                   	pop    %ebx
 217:	5e                   	pop    %esi
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    

0000021a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 21a:	b8 01 00 00 00       	mov    $0x1,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <exit>:
SYSCALL(exit)
 222:	b8 02 00 00 00       	mov    $0x2,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <wait>:
SYSCALL(wait)
 22a:	b8 03 00 00 00       	mov    $0x3,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <pipe>:
SYSCALL(pipe)
 232:	b8 04 00 00 00       	mov    $0x4,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <read>:
SYSCALL(read)
 23a:	b8 05 00 00 00       	mov    $0x5,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <write>:
SYSCALL(write)
 242:	b8 10 00 00 00       	mov    $0x10,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <close>:
SYSCALL(close)
 24a:	b8 15 00 00 00       	mov    $0x15,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <kill>:
SYSCALL(kill)
 252:	b8 06 00 00 00       	mov    $0x6,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <exec>:
SYSCALL(exec)
 25a:	b8 07 00 00 00       	mov    $0x7,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <open>:
SYSCALL(open)
 262:	b8 0f 00 00 00       	mov    $0xf,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <mknod>:
SYSCALL(mknod)
 26a:	b8 11 00 00 00       	mov    $0x11,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <unlink>:
SYSCALL(unlink)
 272:	b8 12 00 00 00       	mov    $0x12,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <fstat>:
SYSCALL(fstat)
 27a:	b8 08 00 00 00       	mov    $0x8,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <link>:
SYSCALL(link)
 282:	b8 13 00 00 00       	mov    $0x13,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <mkdir>:
SYSCALL(mkdir)
 28a:	b8 14 00 00 00       	mov    $0x14,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <chdir>:
SYSCALL(chdir)
 292:	b8 09 00 00 00       	mov    $0x9,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <dup>:
SYSCALL(dup)
 29a:	b8 0a 00 00 00       	mov    $0xa,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <getpid>:
SYSCALL(getpid)
 2a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <sbrk>:
SYSCALL(sbrk)
 2aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <sleep>:
SYSCALL(sleep)
 2b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <uptime>:
SYSCALL(uptime)
 2ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <getppid>:
SYSCALL(getppid)
 2c2:	b8 16 00 00 00       	mov    $0x16,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <getChildren>:
SYSCALL(getChildren)
 2ca:	b8 17 00 00 00       	mov    $0x17,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <getCount>:
SYSCALL(getCount)
 2d2:	b8 18 00 00 00       	mov    $0x18,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    
 2da:	66 90                	xchg   %ax,%ax
 2dc:	66 90                	xchg   %ax,%ax
 2de:	66 90                	xchg   %ax,%ax

000002e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	56                   	push   %esi
 2e5:	89 c6                	mov    %eax,%esi
 2e7:	53                   	push   %ebx
 2e8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2ee:	85 db                	test   %ebx,%ebx
 2f0:	74 09                	je     2fb <printint+0x1b>
 2f2:	89 d0                	mov    %edx,%eax
 2f4:	c1 e8 1f             	shr    $0x1f,%eax
 2f7:	84 c0                	test   %al,%al
 2f9:	75 75                	jne    370 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2fb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 2fd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 304:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 307:	31 ff                	xor    %edi,%edi
 309:	89 ce                	mov    %ecx,%esi
 30b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 30e:	eb 02                	jmp    312 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 310:	89 cf                	mov    %ecx,%edi
 312:	31 d2                	xor    %edx,%edx
 314:	f7 f6                	div    %esi
 316:	8d 4f 01             	lea    0x1(%edi),%ecx
 319:	0f b6 92 ed 06 00 00 	movzbl 0x6ed(%edx),%edx
  }while((x /= base) != 0);
 320:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 322:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 325:	75 e9                	jne    310 <printint+0x30>
  if(neg)
 327:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 32a:	89 c8                	mov    %ecx,%eax
 32c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 32f:	85 d2                	test   %edx,%edx
 331:	74 08                	je     33b <printint+0x5b>
    buf[i++] = '-';
 333:	8d 4f 02             	lea    0x2(%edi),%ecx
 336:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 33b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 33e:	66 90                	xchg   %ax,%ax
 340:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 345:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 348:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 34f:	00 
 350:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 354:	89 34 24             	mov    %esi,(%esp)
 357:	88 45 d7             	mov    %al,-0x29(%ebp)
 35a:	e8 e3 fe ff ff       	call   242 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 35f:	83 ff ff             	cmp    $0xffffffff,%edi
 362:	75 dc                	jne    340 <printint+0x60>
    putc(fd, buf[i]);
}
 364:	83 c4 4c             	add    $0x4c,%esp
 367:	5b                   	pop    %ebx
 368:	5e                   	pop    %esi
 369:	5f                   	pop    %edi
 36a:	5d                   	pop    %ebp
 36b:	c3                   	ret    
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 370:	89 d0                	mov    %edx,%eax
 372:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 374:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 37b:	eb 87                	jmp    304 <printint+0x24>
 37d:	8d 76 00             	lea    0x0(%esi),%esi

00000380 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 384:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 386:	56                   	push   %esi
 387:	53                   	push   %ebx
 388:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 38b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 38e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 391:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 394:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 397:	0f b6 13             	movzbl (%ebx),%edx
 39a:	83 c3 01             	add    $0x1,%ebx
 39d:	84 d2                	test   %dl,%dl
 39f:	75 39                	jne    3da <printf+0x5a>
 3a1:	e9 c2 00 00 00       	jmp    468 <printf+0xe8>
 3a6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3a8:	83 fa 25             	cmp    $0x25,%edx
 3ab:	0f 84 bf 00 00 00    	je     470 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3bb:	00 
 3bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3c3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3c6:	e8 77 fe ff ff       	call   242 <write>
 3cb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3ce:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 3d2:	84 d2                	test   %dl,%dl
 3d4:	0f 84 8e 00 00 00    	je     468 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 3da:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 3dc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 3df:	74 c7                	je     3a8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3e1:	83 ff 25             	cmp    $0x25,%edi
 3e4:	75 e5                	jne    3cb <printf+0x4b>
      if(c == 'd'){
 3e6:	83 fa 64             	cmp    $0x64,%edx
 3e9:	0f 84 31 01 00 00    	je     520 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3ef:	25 f7 00 00 00       	and    $0xf7,%eax
 3f4:	83 f8 70             	cmp    $0x70,%eax
 3f7:	0f 84 83 00 00 00    	je     480 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3fd:	83 fa 73             	cmp    $0x73,%edx
 400:	0f 84 a2 00 00 00    	je     4a8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 406:	83 fa 63             	cmp    $0x63,%edx
 409:	0f 84 35 01 00 00    	je     544 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 40f:	83 fa 25             	cmp    $0x25,%edx
 412:	0f 84 e0 00 00 00    	je     4f8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 418:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 41b:	83 c3 01             	add    $0x1,%ebx
 41e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 425:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 426:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 428:	89 44 24 04          	mov    %eax,0x4(%esp)
 42c:	89 34 24             	mov    %esi,(%esp)
 42f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 432:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 436:	e8 07 fe ff ff       	call   242 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 43b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 43e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 441:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 448:	00 
 449:	89 44 24 04          	mov    %eax,0x4(%esp)
 44d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 450:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 453:	e8 ea fd ff ff       	call   242 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 458:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 45c:	84 d2                	test   %dl,%dl
 45e:	0f 85 76 ff ff ff    	jne    3da <printf+0x5a>
 464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 468:	83 c4 3c             	add    $0x3c,%esp
 46b:	5b                   	pop    %ebx
 46c:	5e                   	pop    %esi
 46d:	5f                   	pop    %edi
 46e:	5d                   	pop    %ebp
 46f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 470:	bf 25 00 00 00       	mov    $0x25,%edi
 475:	e9 51 ff ff ff       	jmp    3cb <printf+0x4b>
 47a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 480:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 483:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 488:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 48a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 491:	8b 10                	mov    (%eax),%edx
 493:	89 f0                	mov    %esi,%eax
 495:	e8 46 fe ff ff       	call   2e0 <printint>
        ap++;
 49a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 49e:	e9 28 ff ff ff       	jmp    3cb <printf+0x4b>
 4a3:	90                   	nop
 4a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 4a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 4ab:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 4af:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 4b1:	b8 e6 06 00 00       	mov    $0x6e6,%eax
 4b6:	85 ff                	test   %edi,%edi
 4b8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 4bb:	0f b6 07             	movzbl (%edi),%eax
 4be:	84 c0                	test   %al,%al
 4c0:	74 2a                	je     4ec <printf+0x16c>
 4c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4c8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4cb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 4ce:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d8:	00 
 4d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4dd:	89 34 24             	mov    %esi,(%esp)
 4e0:	e8 5d fd ff ff       	call   242 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4e5:	0f b6 07             	movzbl (%edi),%eax
 4e8:	84 c0                	test   %al,%al
 4ea:	75 dc                	jne    4c8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ec:	31 ff                	xor    %edi,%edi
 4ee:	e9 d8 fe ff ff       	jmp    3cb <printf+0x4b>
 4f3:	90                   	nop
 4f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4fb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 504:	00 
 505:	89 44 24 04          	mov    %eax,0x4(%esp)
 509:	89 34 24             	mov    %esi,(%esp)
 50c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 510:	e8 2d fd ff ff       	call   242 <write>
 515:	e9 b1 fe ff ff       	jmp    3cb <printf+0x4b>
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 520:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 523:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 528:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 52b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 532:	8b 10                	mov    (%eax),%edx
 534:	89 f0                	mov    %esi,%eax
 536:	e8 a5 fd ff ff       	call   2e0 <printint>
        ap++;
 53b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 53f:	e9 87 fe ff ff       	jmp    3cb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 544:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 547:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 549:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 54b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 552:	00 
 553:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 556:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 559:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 55c:	89 44 24 04          	mov    %eax,0x4(%esp)
 560:	e8 dd fc ff ff       	call   242 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 565:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 569:	e9 5d fe ff ff       	jmp    3cb <printf+0x4b>
 56e:	66 90                	xchg   %ax,%ax

00000570 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 570:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 571:	a1 48 09 00 00       	mov    0x948,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 576:	89 e5                	mov    %esp,%ebp
 578:	57                   	push   %edi
 579:	56                   	push   %esi
 57a:	53                   	push   %ebx
 57b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 580:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 583:	39 d0                	cmp    %edx,%eax
 585:	72 11                	jb     598 <free+0x28>
 587:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 588:	39 c8                	cmp    %ecx,%eax
 58a:	72 04                	jb     590 <free+0x20>
 58c:	39 ca                	cmp    %ecx,%edx
 58e:	72 10                	jb     5a0 <free+0x30>
 590:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 592:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 594:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 596:	73 f0                	jae    588 <free+0x18>
 598:	39 ca                	cmp    %ecx,%edx
 59a:	72 04                	jb     5a0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59c:	39 c8                	cmp    %ecx,%eax
 59e:	72 f0                	jb     590 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 5a6:	39 cf                	cmp    %ecx,%edi
 5a8:	74 1e                	je     5c8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5aa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ad:	8b 48 04             	mov    0x4(%eax),%ecx
 5b0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5b3:	39 f2                	cmp    %esi,%edx
 5b5:	74 28                	je     5df <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5b7:	89 10                	mov    %edx,(%eax)
  freep = p;
 5b9:	a3 48 09 00 00       	mov    %eax,0x948
}
 5be:	5b                   	pop    %ebx
 5bf:	5e                   	pop    %esi
 5c0:	5f                   	pop    %edi
 5c1:	5d                   	pop    %ebp
 5c2:	c3                   	ret    
 5c3:	90                   	nop
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5c8:	03 71 04             	add    0x4(%ecx),%esi
 5cb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5ce:	8b 08                	mov    (%eax),%ecx
 5d0:	8b 09                	mov    (%ecx),%ecx
 5d2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5d5:	8b 48 04             	mov    0x4(%eax),%ecx
 5d8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5db:	39 f2                	cmp    %esi,%edx
 5dd:	75 d8                	jne    5b7 <free+0x47>
    p->s.size += bp->s.size;
 5df:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 5e2:	a3 48 09 00 00       	mov    %eax,0x948
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 5e7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5ea:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5ed:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5ef:	5b                   	pop    %ebx
 5f0:	5e                   	pop    %esi
 5f1:	5f                   	pop    %edi
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret    
 5f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000600 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 609:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 60c:	8b 1d 48 09 00 00    	mov    0x948,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 612:	8d 48 07             	lea    0x7(%eax),%ecx
 615:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 618:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 61a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 61d:	0f 84 9b 00 00 00    	je     6be <malloc+0xbe>
 623:	8b 13                	mov    (%ebx),%edx
 625:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 628:	39 fe                	cmp    %edi,%esi
 62a:	76 64                	jbe    690 <malloc+0x90>
 62c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 633:	bb 00 80 00 00       	mov    $0x8000,%ebx
 638:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 63b:	eb 0e                	jmp    64b <malloc+0x4b>
 63d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 640:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 642:	8b 78 04             	mov    0x4(%eax),%edi
 645:	39 fe                	cmp    %edi,%esi
 647:	76 4f                	jbe    698 <malloc+0x98>
 649:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 64b:	3b 15 48 09 00 00    	cmp    0x948,%edx
 651:	75 ed                	jne    640 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 656:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 65c:	bf 00 10 00 00       	mov    $0x1000,%edi
 661:	0f 43 fe             	cmovae %esi,%edi
 664:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 667:	89 04 24             	mov    %eax,(%esp)
 66a:	e8 3b fc ff ff       	call   2aa <sbrk>
  if(p == (char*)-1)
 66f:	83 f8 ff             	cmp    $0xffffffff,%eax
 672:	74 18                	je     68c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 674:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 677:	83 c0 08             	add    $0x8,%eax
 67a:	89 04 24             	mov    %eax,(%esp)
 67d:	e8 ee fe ff ff       	call   570 <free>
  return freep;
 682:	8b 15 48 09 00 00    	mov    0x948,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 688:	85 d2                	test   %edx,%edx
 68a:	75 b4                	jne    640 <malloc+0x40>
        return 0;
 68c:	31 c0                	xor    %eax,%eax
 68e:	eb 20                	jmp    6b0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 690:	89 d0                	mov    %edx,%eax
 692:	89 da                	mov    %ebx,%edx
 694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 698:	39 fe                	cmp    %edi,%esi
 69a:	74 1c                	je     6b8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 69c:	29 f7                	sub    %esi,%edi
 69e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 6a1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 6a4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 6a7:	89 15 48 09 00 00    	mov    %edx,0x948
      return (void*)(p + 1);
 6ad:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6b0:	83 c4 1c             	add    $0x1c,%esp
 6b3:	5b                   	pop    %ebx
 6b4:	5e                   	pop    %esi
 6b5:	5f                   	pop    %edi
 6b6:	5d                   	pop    %ebp
 6b7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 6b8:	8b 08                	mov    (%eax),%ecx
 6ba:	89 0a                	mov    %ecx,(%edx)
 6bc:	eb e9                	jmp    6a7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6be:	c7 05 48 09 00 00 4c 	movl   $0x94c,0x948
 6c5:	09 00 00 
    base.s.size = 0;
 6c8:	ba 4c 09 00 00       	mov    $0x94c,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6cd:	c7 05 4c 09 00 00 4c 	movl   $0x94c,0x94c
 6d4:	09 00 00 
    base.s.size = 0;
 6d7:	c7 05 50 09 00 00 00 	movl   $0x0,0x950
 6de:	00 00 00 
 6e1:	e9 46 ff ff ff       	jmp    62c <malloc+0x2c>
