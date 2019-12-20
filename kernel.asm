
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 2d 10 80       	mov    $0x80102df0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 60 6e 10 	movl   $0x80106e60,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010005b:	e8 c0 41 00 00       	call   80104220 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 67 6e 10 	movl   $0x80106e67,0x4(%esp)
8010009b:	80 
8010009c:	e8 4f 40 00 00       	call   801040f0 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 a5 42 00 00       	call   80104390 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000f1:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100161:	e8 9a 42 00 00       	call   80104400 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 bf 3f 00 00       	call   80104130 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 a2 1f 00 00       	call   80102120 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 6e 6e 10 80 	movl   $0x80106e6e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 1b 40 00 00       	call   801041d0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 7f 6e 10 80 	movl   $0x80106e7f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 da 3f 00 00       	call   801041d0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 8e 3f 00 00       	call   80104190 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100209:	e8 82 41 00 00       	call   80104390 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 ab 41 00 00       	jmp    80104400 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 86 6e 10 80 	movl   $0x80106e86,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 09 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 fd 40 00 00       	call   80104390 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 53 34 00 00       	call   80103700 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
801002c3:	e8 e8 39 00 00       	call   80103cb0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002cd:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 40 ff 10 80 	movzbl -0x7fef00c0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 ea 40 00 00       	call   80104400 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 92 13 00 00       	call   801016b0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 cc 40 00 00       	call   80104400 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 e5 23 00 00       	call   80102760 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 8d 6e 10 80 	movl   $0x80106e8d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 ff 77 10 80 	movl   $0x801077ff,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 8c 3e 00 00       	call   80104240 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 a1 6e 10 80 	movl   $0x80106ea1,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 c2 55 00 00       	call   801059d0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 12 55 00 00       	call   801059d0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 06 55 00 00       	call   801059d0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 fa 54 00 00       	call   801059d0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 ef 3f 00 00       	call   801044f0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 32 3f 00 00       	call   80104450 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 a5 6e 10 80 	movl   $0x80106ea5,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 d0 6e 10 80 	movzbl -0x7fef9130(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 89 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 7d 3d 00 00       	call   80104390 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 c5 3d 00 00       	call   80104400 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 08 3d 00 00       	call   80104400 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 b8 6e 10 80       	mov    $0x80106eb8,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 f4 3b 00 00       	call   80104390 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 bf 6e 10 80 	movl   $0x80106ebf,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 c6 3b 00 00       	call   80104390 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801007f7:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 d4 3b 00 00       	call   80104400 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d c0 ff 10 80    	mov    0x8010ffc0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008b2:	e8 99 35 00 00       	call   80103e50 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008c5:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ec:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 14 36 00 00       	jmp    80103f40 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 c8 6e 10 	movl   $0x80106ec8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 b6 38 00 00       	call   80104220 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 8c 09 11 80 f0 	movl   $0x801005f0,0x8011098c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100997:	e8 14 19 00 00       	call   801022b0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 4f 2d 00 00       	call   80103700 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 54 21 00 00       	call   80102b10 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 39 15 00 00       	call   80101f00 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 d7 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 65 0f 00 00       	call   80101960 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 08 0f 00 00       	call   80101910 <iunlockput>
    end_op();
80100a08:	e8 73 21 00 00       	call   80102b80 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 8f 61 00 00       	call   80106bc0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 cd 0e 00 00       	call   80101960 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 59 5f 00 00       	call   80106a30 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 58 5e 00 00       	call   80106970 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 12 60 00 00       	call   80106b40 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 d5 0d 00 00       	call   80101910 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 3b 20 00 00       	call   80102b80 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 bf 5e 00 00       	call   80106a30 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 b7 5f 00 00       	call   80106b40 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100b93:	e8 e8 1f 00 00       	call   80102b80 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 e1 6e 10 80 	movl   $0x80106ee1,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 a3 60 00 00       	call   80106c70 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 6a 3a 00 00       	call   80104670 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 59 3a 00 00       	call   80104670 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 9a 61 00 00       	call   80106dd0 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 27 61 00 00       	call   80106dd0 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 3a 39 00 00       	call   80104630 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 bc 5a 00 00       	call   801067e0 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 14 5e 00 00       	call   80106b40 <freevm>
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 ed 6e 10 	movl   $0x80106eed,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d65:	e8 b6 34 00 00       	call   80104220 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d83:	e8 08 36 00 00       	call   80104390 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 4b 36 00 00       	call   80104400 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100dc7:	e8 34 36 00 00       	call   80104400 <release>
  return 0;
}
80100dcc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100df1:	e8 9a 35 00 00       	call   80104390 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e0a:	e8 f1 35 00 00       	call   80104400 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e17:	c7 04 24 f4 6e 10 80 	movl   $0x80106ef4,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e43:	e8 48 35 00 00       	call   80104390 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6b:	e9 90 35 00 00       	jmp    80104400 <release>
    return;
  }
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e85:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e8f:	e8 6c 35 00 00       	call   80104400 <release>

  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 a8 23 00 00       	call   80103260 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 4b 1c 00 00       	call   80102b10 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 00 09 00 00       	call   801017d0 <iput>
    end_op();
  }
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ed7:	e9 a4 1c 00 00       	jmp    80102b80 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edc:	c7 04 24 fc 6e 10 80 	movl   $0x80106efc,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 a6 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 14 0a 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 69 08 00 00       	call   80101790 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 41 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 d7 09 00 00       	call   80101960 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 f3 07 00 00       	call   80101790 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb5:	e9 26 24 00 00       	jmp    801033e0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fc7:	c7 04 24 06 6f 10 80 	movl   $0x80106f06,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 57 07 00 00       	call   80101790 <iunlock>
      end_op();
80101039:	e8 42 1b 00 00       	call   80102b80 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101063:	e8 a8 1a 00 00       	call   80102b10 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 3d 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 ce 09 00 00       	call   80101a60 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 ec 06 00 00       	call   80101790 <iunlock>
      end_op();
801010a4:	e8 d7 1a 00 00       	call   80102b80 <end_op>

      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 0f 22 00 00       	jmp    801032f0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	c7 04 24 0f 6f 10 80 	movl   $0x80106f0f,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ed:	c7 04 24 15 6f 10 80 	movl   $0x80106f15,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	89 d7                	mov    %edx,%edi
80101106:	56                   	push   %esi
80101107:	53                   	push   %ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101108:	bb 01 00 00 00       	mov    $0x1,%ebx
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010110d:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101110:	c1 ea 0c             	shr    $0xc,%edx
80101113:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101119:	89 04 24             	mov    %eax,(%esp)
8010111c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101120:	e8 ab ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101125:	89 f9                	mov    %edi,%ecx
{
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
80101127:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
8010112d:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
8010112f:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101132:	c1 fa 03             	sar    $0x3,%edx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101135:	d3 e3                	shl    %cl,%ebx
bfree(int dev, uint b)
{
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101137:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
80101139:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010113e:	0f b6 c8             	movzbl %al,%ecx
80101141:	85 d9                	test   %ebx,%ecx
80101143:	74 20                	je     80101165 <bfree+0x65>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101145:	f7 d3                	not    %ebx
80101147:	21 c3                	and    %eax,%ebx
80101149:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
8010114d:	89 34 24             	mov    %esi,(%esp)
80101150:	e8 5b 1b 00 00       	call   80102cb0 <log_write>
  brelse(bp);
80101155:	89 34 24             	mov    %esi,(%esp)
80101158:	e8 83 f0 ff ff       	call   801001e0 <brelse>
}
8010115d:	83 c4 1c             	add    $0x1c,%esp
80101160:	5b                   	pop    %ebx
80101161:	5e                   	pop    %esi
80101162:	5f                   	pop    %edi
80101163:	5d                   	pop    %ebp
80101164:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101165:	c7 04 24 1f 6f 10 80 	movl   $0x80106f1f,(%esp)
8010116c:	e8 ef f1 ff ff       	call   80100360 <panic>
80101171:	eb 0d                	jmp    80101180 <balloc>
80101173:	90                   	nop
80101174:	90                   	nop
80101175:	90                   	nop
80101176:	90                   	nop
80101177:	90                   	nop
80101178:	90                   	nop
80101179:	90                   	nop
8010117a:	90                   	nop
8010117b:	90                   	nop
8010117c:	90                   	nop
8010117d:	90                   	nop
8010117e:	90                   	nop
8010117f:	90                   	nop

80101180 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 2c             	sub    $0x2c,%esp
80101189:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118c:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101191:	85 c0                	test   %eax,%eax
80101193:	0f 84 8c 00 00 00    	je     80101225 <balloc+0xa5>
80101199:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a3:	89 f0                	mov    %esi,%eax
801011a5:	c1 f8 0c             	sar    $0xc,%eax
801011a8:	03 05 f8 09 11 80    	add    0x801109f8,%eax
801011ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801011b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b5:	89 04 24             	mov    %eax,(%esp)
801011b8:	e8 13 ef ff ff       	call   801000d0 <bread>
801011bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011c0:	a1 e0 09 11 80       	mov    0x801109e0,%eax
801011c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011c8:	31 c0                	xor    %eax,%eax
801011ca:	eb 33                	jmp    801011ff <balloc+0x7f>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011d3:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011d5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d7:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	bf 01 00 00 00       	mov    $0x1,%edi
801011e2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011e9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011eb:	0f b6 fb             	movzbl %bl,%edi
801011ee:	85 cf                	test   %ecx,%edi
801011f0:	74 46                	je     80101238 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f2:	83 c0 01             	add    $0x1,%eax
801011f5:	83 c6 01             	add    $0x1,%esi
801011f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fd:	74 05                	je     80101204 <balloc+0x84>
801011ff:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101202:	72 cc                	jb     801011d0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101207:	89 04 24             	mov    %eax,(%esp)
8010120a:	e8 d1 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010120f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	3b 05 e0 09 11 80    	cmp    0x801109e0,%eax
8010121f:	0f 82 7b ff ff ff    	jb     801011a0 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101225:	c7 04 24 32 6f 10 80 	movl   $0x80106f32,(%esp)
8010122c:	e8 2f f1 ff ff       	call   80100360 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101238:	09 d9                	or     %ebx,%ecx
8010123a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010123d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101241:	89 1c 24             	mov    %ebx,(%esp)
80101244:	e8 67 1a 00 00       	call   80102cb0 <log_write>
        brelse(bp);
80101249:	89 1c 24             	mov    %ebx,(%esp)
8010124c:	e8 8f ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101251:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101254:	89 74 24 04          	mov    %esi,0x4(%esp)
80101258:	89 04 24             	mov    %eax,(%esp)
8010125b:	e8 70 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101260:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101267:	00 
80101268:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010126f:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101270:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101272:	8d 40 5c             	lea    0x5c(%eax),%eax
80101275:	89 04 24             	mov    %eax,(%esp)
80101278:	e8 d3 31 00 00       	call   80104450 <memset>
  log_write(bp);
8010127d:	89 1c 24             	mov    %ebx,(%esp)
80101280:	e8 2b 1a 00 00       	call   80102cb0 <log_write>
  brelse(bp);
80101285:	89 1c 24             	mov    %ebx,(%esp)
80101288:	e8 53 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010128d:	83 c4 2c             	add    $0x2c,%esp
80101290:	89 f0                	mov    %esi,%eax
80101292:	5b                   	pop    %ebx
80101293:	5e                   	pop    %esi
80101294:	5f                   	pop    %edi
80101295:	5d                   	pop    %ebp
80101296:	c3                   	ret    
80101297:	89 f6                	mov    %esi,%esi
80101299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	89 c7                	mov    %eax,%edi
801012a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a7:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a9:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012af:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801012b2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801012bc:	e8 cf 30 00 00       	call   80104390 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c4:	eb 14                	jmp    801012da <iget+0x3a>
801012c6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012c8:	85 f6                	test   %esi,%esi
801012ca:	74 3c                	je     80101308 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012cc:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d2:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801012d8:	74 46                	je     80101320 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012da:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	7e e7                	jle    801012c8 <iget+0x28>
801012e1:	39 3b                	cmp    %edi,(%ebx)
801012e3:	75 e3                	jne    801012c8 <iget+0x28>
801012e5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012e8:	75 de                	jne    801012c8 <iget+0x28>
      ip->ref++;
801012ea:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012ed:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012ef:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012f6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012f9:	e8 02 31 00 00       	call   80104400 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012fe:	83 c4 1c             	add    $0x1c,%esp
80101301:	89 f0                	mov    %esi,%eax
80101303:	5b                   	pop    %ebx
80101304:	5e                   	pop    %esi
80101305:	5f                   	pop    %edi
80101306:	5d                   	pop    %ebp
80101307:	c3                   	ret    
80101308:	85 c9                	test   %ecx,%ecx
8010130a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101313:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101319:	75 bf                	jne    801012da <iget+0x3a>
8010131b:	90                   	nop
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101320:	85 f6                	test   %esi,%esi
80101322:	74 29                	je     8010134d <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101324:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101326:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101329:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101330:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101337:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010133e:	e8 bd 30 00 00       	call   80104400 <release>

  return ip;
}
80101343:	83 c4 1c             	add    $0x1c,%esp
80101346:	89 f0                	mov    %esi,%eax
80101348:	5b                   	pop    %ebx
80101349:	5e                   	pop    %esi
8010134a:	5f                   	pop    %edi
8010134b:	5d                   	pop    %ebp
8010134c:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
8010134d:	c7 04 24 48 6f 10 80 	movl   $0x80106f48,(%esp)
80101354:	e8 07 f0 ff ff       	call   80100360 <panic>
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c3                	mov    %eax,%ebx
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 46 5c             	mov    0x5c(%esi),%eax
80101376:	85 c0                	test   %eax,%eax
80101378:	74 66                	je     801013e0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	83 c4 1c             	add    $0x1c,%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101388:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010138b:	83 fe 7f             	cmp    $0x7f,%esi
8010138e:	77 77                	ja     80101407 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101390:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101396:	85 c0                	test   %eax,%eax
80101398:	74 5e                	je     801013f8 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010139a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010139e:	8b 03                	mov    (%ebx),%eax
801013a0:	89 04 24             	mov    %eax,(%esp)
801013a3:	e8 28 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013a8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013ac:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013ae:	8b 32                	mov    (%edx),%esi
801013b0:	85 f6                	test   %esi,%esi
801013b2:	75 19                	jne    801013cd <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
801013b4:	8b 03                	mov    (%ebx),%eax
801013b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013b9:	e8 c2 fd ff ff       	call   80101180 <balloc>
801013be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013c1:	89 02                	mov    %eax,(%edx)
801013c3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013c5:	89 3c 24             	mov    %edi,(%esp)
801013c8:	e8 e3 18 00 00       	call   80102cb0 <log_write>
    }
    brelse(bp);
801013cd:	89 3c 24             	mov    %edi,(%esp)
801013d0:	e8 0b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
801013d5:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d8:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013da:	5b                   	pop    %ebx
801013db:	5e                   	pop    %esi
801013dc:	5f                   	pop    %edi
801013dd:	5d                   	pop    %ebp
801013de:	c3                   	ret    
801013df:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 03                	mov    (%ebx),%eax
801013e2:	e8 99 fd ff ff       	call   80101180 <balloc>
801013e7:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ea:	83 c4 1c             	add    $0x1c,%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 03                	mov    (%ebx),%eax
801013fa:	e8 81 fd ff ff       	call   80101180 <balloc>
801013ff:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101405:	eb 93                	jmp    8010139a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101407:	c7 04 24 58 6f 10 80 	movl   $0x80106f58,(%esp)
8010140e:	e8 4d ef ff ff       	call   80100360 <panic>
80101413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101428:	8b 45 08             	mov    0x8(%ebp),%eax
8010142b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101432:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101433:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101436:	89 04 24             	mov    %eax,(%esp)
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010143e:	89 34 24             	mov    %esi,(%esp)
80101441:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101448:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
80101449:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010144b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010144e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101452:	e8 99 30 00 00       	call   801044f0 <memmove>
  brelse(bp);
80101457:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010145a:	83 c4 10             	add    $0x10,%esp
8010145d:	5b                   	pop    %ebx
8010145e:	5e                   	pop    %esi
8010145f:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101460:	e9 7b ed ff ff       	jmp    801001e0 <brelse>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	c7 44 24 04 6b 6f 10 	movl   $0x80106f6b,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010148b:	e8 90 2d 00 00       	call   80104220 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 72 6f 10 	movl   $0x80106f72,0x4(%esp)
801014a0:	80 
801014a1:	e8 4a 2c 00 00       	call   801040f0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a6:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 5f ff ff ff       	call   80101420 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014c1:	a1 f8 09 11 80       	mov    0x801109f8,%eax
801014c6:	c7 04 24 d8 6f 10 80 	movl   $0x80106fd8,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 f4 09 11 80       	mov    0x801109f4,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 f0 09 11 80       	mov    0x801109f0,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 ec 09 11 80       	mov    0x801109ec,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 e8 09 11 80       	mov    0x801109e8,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 e4 09 11 80       	mov    0x801109e4,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101550:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d e8 09 11 80    	cmp    0x801109e8,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 a2 2e 00 00       	call   80104450 <memset>
      dip->type = type;
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015bb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 ea 16 00 00       	call   80102cb0 <log_write>
      brelse(bp);
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015dc:	e9 bf fc ff ff       	jmp    801012a0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015e1:	c7 04 24 78 6f 10 80 	movl   $0x80106f78,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101626:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 8b 2e 00 00       	call   801044f0 <memmove>
  log_write(bp);
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 43 16 00 00       	call   80102cb0 <log_write>
  brelse(bp);
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101691:	e8 fa 2c 00 00       	call   80104390 <acquire>
  ip->ref++;
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010169a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016a1:	e8 5a 2d 00 00       	call   80104400 <release>
  return ip;
}
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b3 00 00 00    	je     80101776 <ilock+0xc6>
801016c3:	8b 53 08             	mov    0x8(%ebx),%edx
801016c6:	85 d2                	test   %edx,%edx
801016c8:	0f 8e a8 00 00 00    	jle    80101776 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 57 2a 00 00       	call   80104130 <acquiresleep>

  if(ip->valid == 0){
801016d9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016dc:	85 c0                	test   %eax,%eax
801016de:	74 08                	je     801016e8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	5b                   	pop    %ebx
801016e4:	5e                   	pop    %esi
801016e5:	5d                   	pop    %ebp
801016e6:	c3                   	ret    
801016e7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101711:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101714:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 a0 2d 00 00       	call   801044f0 <memmove>
    brelse(bp);
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 76 ff ff ff    	jne    801016e0 <ilock+0x30>
      panic("ilock: no type");
8010176a:	c7 04 24 90 6f 10 80 	movl   $0x80106f90,(%esp)
80101771:	e8 ea eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101776:	c7 04 24 8a 6f 10 80 	movl   $0x80106f8a,(%esp)
8010177d:	e8 de eb ff ff       	call   80100360 <panic>
80101782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101790 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	83 ec 10             	sub    $0x10,%esp
80101798:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010179b:	85 db                	test   %ebx,%ebx
8010179d:	74 24                	je     801017c3 <iunlock+0x33>
8010179f:	8d 73 0c             	lea    0xc(%ebx),%esi
801017a2:	89 34 24             	mov    %esi,(%esp)
801017a5:	e8 26 2a 00 00       	call   801041d0 <holdingsleep>
801017aa:	85 c0                	test   %eax,%eax
801017ac:	74 15                	je     801017c3 <iunlock+0x33>
801017ae:	8b 43 08             	mov    0x8(%ebx),%eax
801017b1:	85 c0                	test   %eax,%eax
801017b3:	7e 0e                	jle    801017c3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017b5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	5b                   	pop    %ebx
801017bc:	5e                   	pop    %esi
801017bd:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017be:	e9 cd 29 00 00       	jmp    80104190 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017c3:	c7 04 24 9f 6f 10 80 	movl   $0x80106f9f,(%esp)
801017ca:	e8 91 eb ff ff       	call   80100360 <panic>
801017cf:	90                   	nop

801017d0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 1c             	sub    $0x1c,%esp
801017d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017dc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017df:	89 3c 24             	mov    %edi,(%esp)
801017e2:	e8 49 29 00 00       	call   80104130 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017e7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017ea:	85 d2                	test   %edx,%edx
801017ec:	74 07                	je     801017f5 <iput+0x25>
801017ee:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017f3:	74 2b                	je     80101820 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017f5:	89 3c 24             	mov    %edi,(%esp)
801017f8:	e8 93 29 00 00       	call   80104190 <releasesleep>

  acquire(&icache.lock);
801017fd:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101804:	e8 87 2b 00 00       	call   80104390 <acquire>
  ip->ref--;
80101809:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010180d:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101814:	83 c4 1c             	add    $0x1c,%esp
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5f                   	pop    %edi
8010181a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010181b:	e9 e0 2b 00 00       	jmp    80104400 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101820:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101827:	e8 64 2b 00 00       	call   80104390 <acquire>
    int r = ip->ref;
8010182c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010182f:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101836:	e8 c5 2b 00 00       	call   80104400 <release>
    if(r == 1){
8010183b:	83 fb 01             	cmp    $0x1,%ebx
8010183e:	75 b5                	jne    801017f5 <iput+0x25>
80101840:	8d 4e 30             	lea    0x30(%esi),%ecx
80101843:	89 f3                	mov    %esi,%ebx
80101845:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x87>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fb                	cmp    %edi,%ebx
80101855:	74 19                	je     80101870 <iput+0xa0>
    if(ip->addrs[i]){
80101857:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010185a:	85 d2                	test   %edx,%edx
8010185c:	74 f2                	je     80101850 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010185e:	8b 06                	mov    (%esi),%eax
80101860:	e8 9b f8 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101865:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010186c:	eb e2                	jmp    80101850 <iput+0x80>
8010186e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 2b                	jne    801018a8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010187d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101884:	89 34 24             	mov    %esi,(%esp)
80101887:	e8 64 fd ff ff       	call   801015f0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010188c:	31 c0                	xor    %eax,%eax
8010188e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101892:	89 34 24             	mov    %esi,(%esp)
80101895:	e8 56 fd ff ff       	call   801015f0 <iupdate>
      ip->valid = 0;
8010189a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018a1:	e9 4f ff ff ff       	jmp    801017f5 <iput+0x25>
801018a6:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018ac:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018ae:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	89 04 24             	mov    %eax,(%esp)
801018b3:	e8 18 e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018b8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018bb:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018c1:	89 cf                	mov    %ecx,%edi
801018c3:	31 c0                	xor    %eax,%eax
801018c5:	eb 0e                	jmp    801018d5 <iput+0x105>
801018c7:	90                   	nop
801018c8:	83 c3 01             	add    $0x1,%ebx
801018cb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018d1:	89 d8                	mov    %ebx,%eax
801018d3:	74 10                	je     801018e5 <iput+0x115>
      if(a[j])
801018d5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018d8:	85 d2                	test   %edx,%edx
801018da:	74 ec                	je     801018c8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018dc:	8b 06                	mov    (%esi),%eax
801018de:	e8 1d f8 ff ff       	call   80101100 <bfree>
801018e3:	eb e3                	jmp    801018c8 <iput+0xf8>
    }
    brelse(bp);
801018e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018eb:	89 04 24             	mov    %eax,(%esp)
801018ee:	e8 ed e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018f3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018f9:	8b 06                	mov    (%esi),%eax
801018fb:	e8 00 f8 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
80101900:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101907:	00 00 00 
8010190a:	e9 6e ff ff ff       	jmp    8010187d <iput+0xad>
8010190f:	90                   	nop

80101910 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 14             	sub    $0x14,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	89 1c 24             	mov    %ebx,(%esp)
8010191d:	e8 6e fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101922:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101925:	83 c4 14             	add    $0x14,%esp
80101928:	5b                   	pop    %ebx
80101929:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010192a:	e9 a1 fe ff ff       	jmp    801017d0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 2c             	sub    $0x2c,%esp
80101969:	8b 45 0c             	mov    0xc(%ebp),%eax
8010196c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010196f:	8b 75 10             	mov    0x10(%ebp),%esi
80101972:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101975:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101978:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010197d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101980:	0f 84 aa 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101986:	8b 47 58             	mov    0x58(%edi),%eax
80101989:	39 f0                	cmp    %esi,%eax
8010198b:	0f 82 c7 00 00 00    	jb     80101a58 <readi+0xf8>
80101991:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101994:	89 da                	mov    %ebx,%edx
80101996:	01 f2                	add    %esi,%edx
80101998:	0f 82 ba 00 00 00    	jb     80101a58 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010199e:	89 c1                	mov    %eax,%ecx
801019a0:	29 f1                	sub    %esi,%ecx
801019a2:	39 d0                	cmp    %edx,%eax
801019a4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a7:	31 c0                	xor    %eax,%eax
801019a9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ae:	74 70                	je     80101a20 <readi+0xc0>
801019b0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019b3:	89 c7                	mov    %eax,%edi
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019bb:	89 f2                	mov    %esi,%edx
801019bd:	c1 ea 09             	shr    $0x9,%edx
801019c0:	89 d8                	mov    %ebx,%eax
801019c2:	e8 99 f9 ff ff       	call   80101360 <bmap>
801019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019cb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019cd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d2:	89 04 24             	mov    %eax,(%esp)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019dd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019df:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019e1:	89 f0                	mov    %esi,%eax
801019e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019ee:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019fe:	01 df                	add    %ebx,%edi
80101a00:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a05:	89 04 24             	mov    %eax,(%esp)
80101a08:	e8 e3 2a 00 00       	call   801044f0 <memmove>
    brelse(bp);
80101a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a10:	89 14 24             	mov    %edx,(%esp)
80101a13:	e8 c8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a18:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a1e:	77 98                	ja     801019b8 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a23:	83 c4 2c             	add    $0x2c,%esp
80101a26:	5b                   	pop    %ebx
80101a27:	5e                   	pop    %esi
80101a28:	5f                   	pop    %edi
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
80101a2b:	90                   	nop
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 1e                	ja     80101a58 <readi+0xf8>
80101a3a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 13                	je     80101a58 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a45:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a48:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a4b:	83 c4 2c             	add    $0x2c,%esp
80101a4e:	5b                   	pop    %ebx
80101a4f:	5e                   	pop    %esi
80101a50:	5f                   	pop    %edi
80101a51:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a52:	ff e0                	jmp    *%eax
80101a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a5d:	eb c4                	jmp    80101a23 <readi+0xc3>
80101a5f:	90                   	nop

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 2c             	sub    $0x2c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a80:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 e3 00 00 00    	jb     80101b78 <writei+0x118>
80101a95:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a98:	89 c8                	mov    %ecx,%eax
80101a9a:	01 f0                	add    %esi,%eax
80101a9c:	0f 82 d6 00 00 00    	jb     80101b78 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa7:	0f 87 cb 00 00 00    	ja     80101b78 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aad:	85 c9                	test   %ecx,%ecx
80101aaf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ab6:	74 77                	je     80101b2f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101abb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101abd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac2:	c1 ea 09             	shr    $0x9,%edx
80101ac5:	89 f8                	mov    %edi,%eax
80101ac7:	e8 94 f8 ff ff       	call   80101360 <bmap>
80101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ad0:	8b 07                	mov    (%edi),%eax
80101ad2:	89 04 24             	mov    %eax,(%esp)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101add:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ae0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae5:	89 f0                	mov    %esi,%eax
80101ae7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aec:	29 c3                	sub    %eax,%ebx
80101aee:	39 cb                	cmp    %ecx,%ebx
80101af0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101af9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101afd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b01:	89 04 24             	mov    %eax,(%esp)
80101b04:	e8 e7 29 00 00       	call   801044f0 <memmove>
    log_write(bp);
80101b09:	89 3c 24             	mov    %edi,(%esp)
80101b0c:	e8 9f 11 00 00       	call   80102cb0 <log_write>
    brelse(bp);
80101b11:	89 3c 24             	mov    %edi,(%esp)
80101b14:	e8 c7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b19:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b1f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b22:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b25:	77 91                	ja     80101ab8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b27:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2d:	72 39                	jb     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b32:	83 c4 2c             	add    $0x2c,%esp
80101b35:	5b                   	pop    %ebx
80101b36:	5e                   	pop    %esi
80101b37:	5f                   	pop    %edi
80101b38:	5d                   	pop    %ebp
80101b39:	c3                   	ret    
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 2e                	ja     80101b78 <writei+0x118>
80101b4a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 23                	je     80101b78 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b6e:	89 04 24             	mov    %eax,(%esp)
80101b71:	e8 7a fa ff ff       	call   801015f0 <iupdate>
80101b76:	eb b7                	jmp    80101b2f <writei+0xcf>
  }
  return n;
}
80101b78:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b80:	5b                   	pop    %ebx
80101b81:	5e                   	pop    %esi
80101b82:	5f                   	pop    %edi
80101b83:	5d                   	pop    %ebp
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b99:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ba0:	00 
80101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	89 04 24             	mov    %eax,(%esp)
80101bab:	e8 c0 29 00 00       	call   80104570 <strncmp>
}
80101bb0:	c9                   	leave  
80101bb1:	c3                   	ret    
80101bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 2c             	sub    $0x2c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 97 00 00 00    	jne    80101c6e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	75 0d                	jne    80101bf0 <dirlookup+0x30>
80101be3:	eb 73                	jmp    80101c58 <dirlookup+0x98>
80101be5:	8d 76 00             	lea    0x0(%esi),%esi
80101be8:	83 c7 10             	add    $0x10,%edi
80101beb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bee:	76 68                	jbe    80101c58 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bf7:	00 
80101bf8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bfc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c00:	89 1c 24             	mov    %ebx,(%esp)
80101c03:	e8 58 fd ff ff       	call   80101960 <readi>
80101c08:	83 f8 10             	cmp    $0x10,%eax
80101c0b:	75 55                	jne    80101c62 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c0d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c12:	74 d4                	je     80101be8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c14:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c1e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c25:	00 
80101c26:	89 04 24             	mov    %eax,(%esp)
80101c29:	e8 42 29 00 00       	call   80104570 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c2e:	85 c0                	test   %eax,%eax
80101c30:	75 b6                	jne    80101be8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c32:	8b 45 10             	mov    0x10(%ebp),%eax
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 05                	je     80101c3e <dirlookup+0x7e>
        *poff = off;
80101c39:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c42:	8b 03                	mov    (%ebx),%eax
80101c44:	e8 57 f6 ff ff       	call   801012a0 <iget>
    }
  }

  return 0;
}
80101c49:	83 c4 2c             	add    $0x2c,%esp
80101c4c:	5b                   	pop    %ebx
80101c4d:	5e                   	pop    %esi
80101c4e:	5f                   	pop    %edi
80101c4f:	5d                   	pop    %ebp
80101c50:	c3                   	ret    
80101c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c58:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c5b:	31 c0                	xor    %eax,%eax
}
80101c5d:	5b                   	pop    %ebx
80101c5e:	5e                   	pop    %esi
80101c5f:	5f                   	pop    %edi
80101c60:	5d                   	pop    %ebp
80101c61:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c62:	c7 04 24 b9 6f 10 80 	movl   $0x80106fb9,(%esp)
80101c69:	e8 f2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c6e:	c7 04 24 a7 6f 10 80 	movl   $0x80106fa7,(%esp)
80101c75:	e8 e6 e6 ff ff       	call   80100360 <panic>
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	89 cf                	mov    %ecx,%edi
80101c86:	56                   	push   %esi
80101c87:	53                   	push   %ebx
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c93:	0f 84 51 01 00 00    	je     80101dea <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c99:	e8 62 1a 00 00       	call   80103700 <myproc>
80101c9e:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ca1:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101ca8:	e8 e3 26 00 00       	call   80104390 <acquire>
  ip->ref++;
80101cad:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb1:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101cb8:	e8 43 27 00 00       	call   80104400 <release>
80101cbd:	eb 04                	jmp    80101cc3 <namex+0x43>
80101cbf:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cc0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cc3:	0f b6 03             	movzbl (%ebx),%eax
80101cc6:	3c 2f                	cmp    $0x2f,%al
80101cc8:	74 f6                	je     80101cc0 <namex+0x40>
    path++;
  if(*path == 0)
80101cca:	84 c0                	test   %al,%al
80101ccc:	0f 84 ed 00 00 00    	je     80101dbf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cd2:	0f b6 03             	movzbl (%ebx),%eax
80101cd5:	89 da                	mov    %ebx,%edx
80101cd7:	84 c0                	test   %al,%al
80101cd9:	0f 84 b1 00 00 00    	je     80101d90 <namex+0x110>
80101cdf:	3c 2f                	cmp    $0x2f,%al
80101ce1:	75 0f                	jne    80101cf2 <namex+0x72>
80101ce3:	e9 a8 00 00 00       	jmp    80101d90 <namex+0x110>
80101ce8:	3c 2f                	cmp    $0x2f,%al
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cf0:	74 0a                	je     80101cfc <namex+0x7c>
    path++;
80101cf2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cf5:	0f b6 02             	movzbl (%edx),%eax
80101cf8:	84 c0                	test   %al,%al
80101cfa:	75 ec                	jne    80101ce8 <namex+0x68>
80101cfc:	89 d1                	mov    %edx,%ecx
80101cfe:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d00:	83 f9 0d             	cmp    $0xd,%ecx
80101d03:	0f 8e 8f 00 00 00    	jle    80101d98 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d0d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d14:	00 
80101d15:	89 3c 24             	mov    %edi,(%esp)
80101d18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d1b:	e8 d0 27 00 00       	call   801044f0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d23:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d25:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d28:	75 0e                	jne    80101d38 <namex+0xb8>
80101d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	89 34 24             	mov    %esi,(%esp)
80101d3b:	e8 70 f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d40:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d45:	0f 85 85 00 00 00    	jne    80101dd0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d4e:	85 d2                	test   %edx,%edx
80101d50:	74 09                	je     80101d5b <namex+0xdb>
80101d52:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d55:	0f 84 a5 00 00 00    	je     80101e00 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d62:	00 
80101d63:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d67:	89 34 24             	mov    %esi,(%esp)
80101d6a:	e8 51 fe ff ff       	call   80101bc0 <dirlookup>
80101d6f:	85 c0                	test   %eax,%eax
80101d71:	74 5d                	je     80101dd0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d73:	89 34 24             	mov    %esi,(%esp)
80101d76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d79:	e8 12 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	89 c6                	mov    %eax,%esi
80101d8b:	e9 33 ff ff ff       	jmp    80101cc3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d90:	31 c9                	xor    %ecx,%ecx
80101d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d9c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101da0:	89 3c 24             	mov    %edi,(%esp)
80101da3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da9:	e8 42 27 00 00       	call   801044f0 <memmove>
    name[len] = 0;
80101dae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101db8:	89 d3                	mov    %edx,%ebx
80101dba:	e9 66 ff ff ff       	jmp    80101d25 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dc2:	85 c0                	test   %eax,%eax
80101dc4:	75 4c                	jne    80101e12 <namex+0x192>
80101dc6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc8:	83 c4 2c             	add    $0x2c,%esp
80101dcb:	5b                   	pop    %ebx
80101dcc:	5e                   	pop    %esi
80101dcd:	5f                   	pop    %edi
80101dce:	5d                   	pop    %ebp
80101dcf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dd0:	89 34 24             	mov    %esi,(%esp)
80101dd3:	e8 b8 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101dd8:	89 34 24             	mov    %esi,(%esp)
80101ddb:	e8 f0 f9 ff ff       	call   801017d0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101de3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de5:	5b                   	pop    %ebx
80101de6:	5e                   	pop    %esi
80101de7:	5f                   	pop    %edi
80101de8:	5d                   	pop    %ebp
80101de9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dea:	ba 01 00 00 00       	mov    $0x1,%edx
80101def:	b8 01 00 00 00       	mov    $0x1,%eax
80101df4:	e8 a7 f4 ff ff       	call   801012a0 <iget>
80101df9:	89 c6                	mov    %eax,%esi
80101dfb:	e9 c3 fe ff ff       	jmp    80101cc3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 88 f9 ff ff       	call   80101790 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e08:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e0b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e0d:	5b                   	pop    %ebx
80101e0e:	5e                   	pop    %esi
80101e0f:	5f                   	pop    %edi
80101e10:	5d                   	pop    %ebp
80101e11:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e12:	89 34 24             	mov    %esi,(%esp)
80101e15:	e8 b6 f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e1a:	31 c0                	xor    %eax,%eax
80101e1c:	eb aa                	jmp    80101dc8 <namex+0x148>
80101e1e:	66 90                	xchg   %ax,%ax

80101e20 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 2c             	sub    $0x2c,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e36:	00 
80101e37:	89 1c 24             	mov    %ebx,(%esp)
80101e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3e:	e8 7d fd ff ff       	call   80101bc0 <dirlookup>
80101e43:	85 c0                	test   %eax,%eax
80101e45:	0f 85 8b 00 00 00    	jne    80101ed6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e4e:	31 ff                	xor    %edi,%edi
80101e50:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e53:	85 c0                	test   %eax,%eax
80101e55:	75 13                	jne    80101e6a <dirlink+0x4a>
80101e57:	eb 35                	jmp    80101e8e <dirlink+0x6e>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e60:	8d 57 10             	lea    0x10(%edi),%edx
80101e63:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e66:	89 d7                	mov    %edx,%edi
80101e68:	76 24                	jbe    80101e8e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e71:	00 
80101e72:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e76:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e7a:	89 1c 24             	mov    %ebx,(%esp)
80101e7d:	e8 de fa ff ff       	call   80101960 <readi>
80101e82:	83 f8 10             	cmp    $0x10,%eax
80101e85:	75 5e                	jne    80101ee5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e87:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8c:	75 d2                	jne    80101e60 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e91:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e98:	00 
80101e99:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e9d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea0:	89 04 24             	mov    %eax,(%esp)
80101ea3:	e8 38 27 00 00       	call   801045e0 <strncpy>
  de.inum = inum;
80101ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101eb2:	00 
80101eb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101eb7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ebb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101ebe:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec2:	e8 99 fb ff ff       	call   80101a60 <writei>
80101ec7:	83 f8 10             	cmp    $0x10,%eax
80101eca:	75 25                	jne    80101ef1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101ecc:	31 c0                	xor    %eax,%eax
}
80101ece:	83 c4 2c             	add    $0x2c,%esp
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ed6:	89 04 24             	mov    %eax,(%esp)
80101ed9:	e8 f2 f8 ff ff       	call   801017d0 <iput>
    return -1;
80101ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee3:	eb e9                	jmp    80101ece <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ee5:	c7 04 24 c8 6f 10 80 	movl   $0x80106fc8,(%esp)
80101eec:	e8 6f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ef1:	c7 04 24 d2 75 10 80 	movl   $0x801075d2,(%esp)
80101ef8:	e8 63 e4 ff ff       	call   80100360 <panic>
80101efd:	8d 76 00             	lea    0x0(%esi),%esi

80101f00 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f00:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f01:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 6d fd ff ff       	call   80101c80 <namex>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f20:	55                   	push   %ebp
  return namex(path, 1, name);
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f26:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f2e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f2f:	e9 4c fd ff ff       	jmp    80101c80 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	56                   	push   %esi
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	53                   	push   %ebx
80101f47:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f4a:	85 c0                	test   %eax,%eax
80101f4c:	0f 84 99 00 00 00    	je     80101feb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f52:	8b 48 08             	mov    0x8(%eax),%ecx
80101f55:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f5b:	0f 87 7e 00 00 00    	ja     80101fdf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f61:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f69:	83 e0 c0             	and    $0xffffffc0,%eax
80101f6c:	3c 40                	cmp    $0x40,%al
80101f6e:	75 f8                	jne    80101f68 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f70:	31 db                	xor    %ebx,%ebx
80101f72:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ee                   	out    %al,(%dx)
80101f7a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f84:	ee                   	out    %al,(%dx)
80101f85:	0f b6 c1             	movzbl %cl,%eax
80101f88:	b2 f3                	mov    $0xf3,%dl
80101f8a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f8b:	89 c8                	mov    %ecx,%eax
80101f8d:	b2 f4                	mov    $0xf4,%dl
80101f8f:	c1 f8 08             	sar    $0x8,%eax
80101f92:	ee                   	out    %al,(%dx)
80101f93:	b2 f5                	mov    $0xf5,%dl
80101f95:	89 d8                	mov    %ebx,%eax
80101f97:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f98:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9c:	b2 f6                	mov    $0xf6,%dl
80101f9e:	83 e0 01             	and    $0x1,%eax
80101fa1:	c1 e0 04             	shl    $0x4,%eax
80101fa4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fa7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fa8:	f6 06 04             	testb  $0x4,(%esi)
80101fab:	75 13                	jne    80101fc0 <idestart+0x80>
80101fad:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
80101fbf:	90                   	nop
80101fc0:	b2 f7                	mov    $0xf7,%dl
80101fc2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fc7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fc8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fcd:	83 c6 5c             	add    $0x5c,%esi
80101fd0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fd5:	fc                   	cld    
80101fd6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fdf:	c7 04 24 34 70 10 80 	movl   $0x80107034,(%esp)
80101fe6:	e8 75 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101feb:	c7 04 24 2b 70 10 80 	movl   $0x8010702b,(%esp)
80101ff2:	e8 69 e3 ff ff       	call   80100360 <panic>
80101ff7:	89 f6                	mov    %esi,%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102006:	c7 44 24 04 46 70 10 	movl   $0x80107046,0x4(%esp)
8010200d:	80 
8010200e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102015:	e8 06 22 00 00       	call   80104220 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010201a:	a1 20 2d 11 80       	mov    0x80112d20,%eax
8010201f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102026:	83 e8 01             	sub    $0x1,%eax
80102029:	89 44 24 04          	mov    %eax,0x4(%esp)
8010202d:	e8 7e 02 00 00       	call   801022b0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102032:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102037:	90                   	nop
80102038:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102039:	83 e0 c0             	and    $0xffffffc0,%eax
8010203c:	3c 40                	cmp    $0x40,%al
8010203e:	75 f8                	jne    80102038 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102040:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102045:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204a:	ee                   	out    %al,(%dx)
8010204b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102050:	b2 f7                	mov    $0xf7,%dl
80102052:	eb 09                	jmp    8010205d <ideinit+0x5d>
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102058:	83 e9 01             	sub    $0x1,%ecx
8010205b:	74 0f                	je     8010206c <ideinit+0x6c>
8010205d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010205e:	84 c0                	test   %al,%al
80102060:	74 f6                	je     80102058 <ideinit+0x58>
      havedisk1 = 1;
80102062:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102069:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010206c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102071:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102076:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102077:	c9                   	leave  
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102090:	e8 fb 22 00 00       	call   80104390 <acquire>

  if((b = idequeue) == 0){
80102095:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010209b:	85 db                	test   %ebx,%ebx
8010209d:	74 30                	je     801020cf <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010209f:	8b 43 58             	mov    0x58(%ebx),%eax
801020a2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a7:	8b 33                	mov    (%ebx),%esi
801020a9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020af:	74 37                	je     801020e8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020b1:	83 e6 fb             	and    $0xfffffffb,%esi
801020b4:	83 ce 02             	or     $0x2,%esi
801020b7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020b9:	89 1c 24             	mov    %ebx,(%esp)
801020bc:	e8 8f 1d 00 00       	call   80103e50 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020c1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020c6:	85 c0                	test   %eax,%eax
801020c8:	74 05                	je     801020cf <ideintr+0x4f>
    idestart(idequeue);
801020ca:	e8 71 fe ff ff       	call   80101f40 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020cf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020d6:	e8 25 23 00 00       	call   80104400 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020db:	83 c4 1c             	add    $0x1c,%esp
801020de:	5b                   	pop    %ebx
801020df:	5e                   	pop    %esi
801020e0:	5f                   	pop    %edi
801020e1:	5d                   	pop    %ebp
801020e2:	c3                   	ret    
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ed:	8d 76 00             	lea    0x0(%esi),%esi
801020f0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c1                	mov    %eax,%ecx
801020f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020f6:	80 f9 40             	cmp    $0x40,%cl
801020f9:	75 f5                	jne    801020f0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fb:	a8 21                	test   $0x21,%al
801020fd:	75 b2                	jne    801020b1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102102:	b9 80 00 00 00       	mov    $0x80,%ecx
80102107:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210c:	fc                   	cld    
8010210d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010210f:	8b 33                	mov    (%ebx),%esi
80102111:	eb 9e                	jmp    801020b1 <ideintr+0x31>
80102113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 14             	sub    $0x14,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	89 04 24             	mov    %eax,(%esp)
80102130:	e8 9b 20 00 00       	call   801041d0 <holdingsleep>
80102135:	85 c0                	test   %eax,%eax
80102137:	0f 84 9e 00 00 00    	je     801021db <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213d:	8b 03                	mov    (%ebx),%eax
8010213f:	83 e0 06             	and    $0x6,%eax
80102142:	83 f8 02             	cmp    $0x2,%eax
80102145:	0f 84 a8 00 00 00    	je     801021f3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214b:	8b 53 04             	mov    0x4(%ebx),%edx
8010214e:	85 d2                	test   %edx,%edx
80102150:	74 0d                	je     8010215f <iderw+0x3f>
80102152:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102157:	85 c0                	test   %eax,%eax
80102159:	0f 84 88 00 00 00    	je     801021e7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010215f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102166:	e8 25 22 00 00       	call   80104390 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102170:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102177:	85 c0                	test   %eax,%eax
80102179:	75 07                	jne    80102182 <iderw+0x62>
8010217b:	eb 4e                	jmp    801021cb <iderw+0xab>
8010217d:	8d 76 00             	lea    0x0(%esi),%esi
80102180:	89 d0                	mov    %edx,%eax
80102182:	8b 50 58             	mov    0x58(%eax),%edx
80102185:	85 d2                	test   %edx,%edx
80102187:	75 f7                	jne    80102180 <iderw+0x60>
80102189:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010218c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010218e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102194:	74 3c                	je     801021d2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102196:	8b 03                	mov    (%ebx),%eax
80102198:	83 e0 06             	and    $0x6,%eax
8010219b:	83 f8 02             	cmp    $0x2,%eax
8010219e:	74 1a                	je     801021ba <iderw+0x9a>
    sleep(b, &idelock);
801021a0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021a7:	80 
801021a8:	89 1c 24             	mov    %ebx,(%esp)
801021ab:	e8 00 1b 00 00       	call   80103cb0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021b0:	8b 13                	mov    (%ebx),%edx
801021b2:	83 e2 06             	and    $0x6,%edx
801021b5:	83 fa 02             	cmp    $0x2,%edx
801021b8:	75 e6                	jne    801021a0 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
801021ba:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021c1:	83 c4 14             	add    $0x14,%esp
801021c4:	5b                   	pop    %ebx
801021c5:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021c6:	e9 35 22 00 00       	jmp    80104400 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021d0:	eb ba                	jmp    8010218c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021d2:	89 d8                	mov    %ebx,%eax
801021d4:	e8 67 fd ff ff       	call   80101f40 <idestart>
801021d9:	eb bb                	jmp    80102196 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021db:	c7 04 24 4a 70 10 80 	movl   $0x8010704a,(%esp)
801021e2:	e8 79 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021e7:	c7 04 24 75 70 10 80 	movl   $0x80107075,(%esp)
801021ee:	e8 6d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021f3:	c7 04 24 60 70 10 80 	movl   $0x80107060,(%esp)
801021fa:	e8 61 e1 ff ff       	call   80100360 <panic>
801021ff:	90                   	nop

80102200 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	56                   	push   %esi
80102204:	53                   	push   %ebx
80102205:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102208:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010220f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102212:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102219:	00 00 00 
  return ioapic->data;
8010221c:	8b 15 54 26 11 80    	mov    0x80112654,%edx
80102222:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102225:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010222b:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102231:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102238:	c1 e8 10             	shr    $0x10,%eax
8010223b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
80102241:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102244:	39 c2                	cmp    %eax,%edx
80102246:	74 12                	je     8010225a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102248:	c7 04 24 94 70 10 80 	movl   $0x80107094,(%esp)
8010224f:	e8 fc e3 ff ff       	call   80100650 <cprintf>
80102254:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
8010225a:	ba 10 00 00 00       	mov    $0x10,%edx
8010225f:	31 c0                	xor    %eax,%eax
80102261:	eb 07                	jmp    8010226a <ioapicinit+0x6a>
80102263:	90                   	nop
80102264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102268:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010226c:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
80102272:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102275:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227b:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010227e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102281:	8d 4a 01             	lea    0x1(%edx),%ecx
80102284:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102287:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102289:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228f:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102291:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102298:	7d ce                	jge    80102268 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	5b                   	pop    %ebx
8010229e:	5e                   	pop    %esi
8010229f:	5d                   	pop    %ebp
801022a0:	c3                   	ret    
801022a1:	eb 0d                	jmp    801022b0 <ioapicenable>
801022a3:	90                   	nop
801022a4:	90                   	nop
801022a5:	90                   	nop
801022a6:	90                   	nop
801022a7:	90                   	nop
801022a8:	90                   	nop
801022a9:	90                   	nop
801022aa:	90                   	nop
801022ab:	90                   	nop
801022ac:	90                   	nop
801022ad:	90                   	nop
801022ae:	90                   	nop
801022af:	90                   	nop

801022b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	8b 55 08             	mov    0x8(%ebp),%edx
801022b6:	53                   	push   %ebx
801022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ba:	8d 5a 20             	lea    0x20(%edx),%ebx
801022bd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c1:	8b 15 54 26 11 80    	mov    0x80112654,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c7:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ca:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022cc:	8b 15 54 26 11 80    	mov    0x80112654,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d2:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d5:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022d8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022da:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801022e0:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022e3:	5b                   	pop    %ebx
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	66 90                	xchg   %ax,%ax
801022e8:	66 90                	xchg   %ax,%ax
801022ea:	66 90                	xchg   %ax,%ax
801022ec:	66 90                	xchg   %ax,%ax
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 14             	sub    $0x14,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 7c                	jne    8010237e <kfree+0x8e>
80102302:	81 fb c8 ba 11 80    	cmp    $0x8011bac8,%ebx
80102308:	72 74                	jb     8010237e <kfree+0x8e>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 67                	ja     8010237e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102317:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010231e:	00 
8010231f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102326:	00 
80102327:	89 1c 24             	mov    %ebx,(%esp)
8010232a:	e8 21 21 00 00       	call   80104450 <memset>

  if(kmem.use_lock)
8010232f:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102335:	85 d2                	test   %edx,%edx
80102337:	75 37                	jne    80102370 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102339:	a1 98 26 11 80       	mov    0x80112698,%eax
8010233e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102340:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102345:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
8010234b:	85 c0                	test   %eax,%eax
8010234d:	75 09                	jne    80102358 <kfree+0x68>
    release(&kmem.lock);
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
80102354:	c3                   	ret    
80102355:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102358:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102364:	e9 97 20 00 00       	jmp    80104400 <release>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102370:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102377:	e8 14 20 00 00       	call   80104390 <acquire>
8010237c:	eb bb                	jmp    80102339 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010237e:	c7 04 24 c6 70 10 80 	movl   $0x801070c6,(%esp)
80102385:	e8 d6 df ff ff       	call   80100360 <panic>
8010238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102390 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	56                   	push   %esi
80102394:	53                   	push   %ebx
80102395:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102398:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010239b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010239e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023aa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023b0:	39 de                	cmp    %ebx,%esi
801023b2:	73 08                	jae    801023bc <freerange+0x2c>
801023b4:	eb 18                	jmp    801023ce <freerange+0x3e>
801023b6:	66 90                	xchg   %ax,%ax
801023b8:	89 da                	mov    %ebx,%edx
801023ba:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023bc:	89 14 24             	mov    %edx,(%esp)
801023bf:	e8 2c ff ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ca:	39 f0                	cmp    %esi,%eax
801023cc:	76 ea                	jbe    801023b8 <freerange+0x28>
    kfree(p);
}
801023ce:	83 c4 10             	add    $0x10,%esp
801023d1:	5b                   	pop    %ebx
801023d2:	5e                   	pop    %esi
801023d3:	5d                   	pop    %ebp
801023d4:	c3                   	ret    
801023d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
801023e5:	83 ec 10             	sub    $0x10,%esp
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023eb:	c7 44 24 04 cc 70 10 	movl   $0x801070cc,0x4(%esp)
801023f2:	80 
801023f3:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801023fa:	e8 21 1e 00 00       	call   80104220 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ff:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102402:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102409:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102412:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102418:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010241e:	39 de                	cmp    %ebx,%esi
80102420:	73 0a                	jae    8010242c <kinit1+0x4c>
80102422:	eb 1a                	jmp    8010243e <kinit1+0x5e>
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102428:	89 da                	mov    %ebx,%edx
8010242a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010242c:	89 14 24             	mov    %edx,(%esp)
8010242f:	e8 bc fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102434:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010243a:	39 c6                	cmp    %eax,%esi
8010243c:	73 ea                	jae    80102428 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102458:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010245b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010245e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102464:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 08                	jae    8010247c <kinit2+0x2c>
80102474:	eb 18                	jmp    8010248e <kinit2+0x3e>
80102476:	66 90                	xchg   %ax,%ax
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 6c fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 c6                	cmp    %eax,%esi
8010248c:	73 ea                	jae    80102478 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010248e:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
80102495:	00 00 00 
}
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    
8010249f:	90                   	nop

801024a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024a7:	a1 94 26 11 80       	mov    0x80112694,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 08                	je     801024c2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 0c                	je     801024d2 <kalloc+0x32>
    release(&kmem.lock);
801024c6:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024cd:	e8 2e 1f 00 00       	call   80104400 <release>
  return (char*)r;
}
801024d2:	83 c4 14             	add    $0x14,%esp
801024d5:	89 d8                	mov    %ebx,%eax
801024d7:	5b                   	pop    %ebx
801024d8:	5d                   	pop    %ebp
801024d9:	c3                   	ret    
801024da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024e0:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024e7:	e8 a4 1e 00 00       	call   80104390 <acquire>
801024ec:	a1 94 26 11 80       	mov    0x80112694,%eax
801024f1:	eb bd                	jmp    801024b0 <kalloc+0x10>
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102500:	ba 64 00 00 00       	mov    $0x64,%edx
80102505:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102506:	a8 01                	test   $0x1,%al
80102508:	0f 84 ba 00 00 00    	je     801025c8 <kbdgetc+0xc8>
8010250e:	b2 60                	mov    $0x60,%dl
80102510:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102511:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102514:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010251a:	0f 84 88 00 00 00    	je     801025a8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102520:	84 c0                	test   %al,%al
80102522:	79 2c                	jns    80102550 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102524:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010252a:	f6 c2 40             	test   $0x40,%dl
8010252d:	75 05                	jne    80102534 <kbdgetc+0x34>
8010252f:	89 c1                	mov    %eax,%ecx
80102531:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102534:	0f b6 81 00 72 10 80 	movzbl -0x7fef8e00(%ecx),%eax
8010253b:	83 c8 40             	or     $0x40,%eax
8010253e:	0f b6 c0             	movzbl %al,%eax
80102541:	f7 d0                	not    %eax
80102543:	21 d0                	and    %edx,%eax
80102545:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010254a:	31 c0                	xor    %eax,%eax
8010254c:	c3                   	ret    
8010254d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	53                   	push   %ebx
80102554:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010255a:	f6 c3 40             	test   $0x40,%bl
8010255d:	74 09                	je     80102568 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102562:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102565:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102568:	0f b6 91 00 72 10 80 	movzbl -0x7fef8e00(%ecx),%edx
  shift ^= togglecode[data];
8010256f:	0f b6 81 00 71 10 80 	movzbl -0x7fef8f00(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102576:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102578:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010257a:	89 d0                	mov    %edx,%eax
8010257c:	83 e0 03             	and    $0x3,%eax
8010257f:	8b 04 85 e0 70 10 80 	mov    -0x7fef8f20(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102586:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010258c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010258f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102593:	74 0b                	je     801025a0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102595:	8d 50 9f             	lea    -0x61(%eax),%edx
80102598:	83 fa 19             	cmp    $0x19,%edx
8010259b:	77 1b                	ja     801025b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010259d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a0:	5b                   	pop    %ebx
801025a1:	5d                   	pop    %ebp
801025a2:	c3                   	ret    
801025a3:	90                   	nop
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025a8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025af:	31 c0                	xor    %eax,%eax
801025b1:	c3                   	ret    
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025bb:	8d 50 20             	lea    0x20(%eax),%edx
801025be:	83 f9 19             	cmp    $0x19,%ecx
801025c1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025c4:	eb da                	jmp    801025a0 <kbdgetc+0xa0>
801025c6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax

801025d0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025d6:	c7 04 24 00 25 10 80 	movl   $0x80102500,(%esp)
801025dd:	e8 ce e1 ff ff       	call   801007b0 <consoleintr>
}
801025e2:	c9                   	leave  
801025e3:	c3                   	ret    
801025e4:	66 90                	xchg   %ax,%ax
801025e6:	66 90                	xchg   %ax,%ax
801025e8:	66 90                	xchg   %ax,%ax
801025ea:	66 90                	xchg   %ax,%ax
801025ec:	66 90                	xchg   %ax,%ax
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
801025f0:	55                   	push   %ebp
801025f1:	89 c1                	mov    %eax,%ecx
801025f3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f5:	ba 70 00 00 00       	mov    $0x70,%edx
801025fa:	53                   	push   %ebx
801025fb:	31 c0                	xor    %eax,%eax
801025fd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025fe:	bb 71 00 00 00       	mov    $0x71,%ebx
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 01                	mov    %eax,(%ecx)
8010260d:	b8 02 00 00 00       	mov    $0x2,%eax
80102612:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
80102616:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 41 04             	mov    %eax,0x4(%ecx)
8010261e:	b8 04 00 00 00       	mov    $0x4,%eax
80102623:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102624:	89 da                	mov    %ebx,%edx
80102626:	ec                   	in     (%dx),%al
80102627:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262a:	b2 70                	mov    $0x70,%dl
8010262c:	89 41 08             	mov    %eax,0x8(%ecx)
8010262f:	b8 07 00 00 00       	mov    $0x7,%eax
80102634:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102635:	89 da                	mov    %ebx,%edx
80102637:	ec                   	in     (%dx),%al
80102638:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263b:	b2 70                	mov    $0x70,%dl
8010263d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102640:	b8 08 00 00 00       	mov    $0x8,%eax
80102645:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102646:	89 da                	mov    %ebx,%edx
80102648:	ec                   	in     (%dx),%al
80102649:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264c:	b2 70                	mov    $0x70,%dl
8010264e:	89 41 10             	mov    %eax,0x10(%ecx)
80102651:	b8 09 00 00 00       	mov    $0x9,%eax
80102656:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102657:	89 da                	mov    %ebx,%edx
80102659:	ec                   	in     (%dx),%al
8010265a:	0f b6 d8             	movzbl %al,%ebx
8010265d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102660:	5b                   	pop    %ebx
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    
80102663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102670:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c0 00 00 00    	je     80102740 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 6f                	ja     80102748 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102728:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010272e:	80 e6 10             	and    $0x10,%dh
80102731:	75 f5                	jne    80102728 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102733:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010273a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102740:	5d                   	pop    %ebp
80102741:	c3                   	ret    
80102742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102748:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010274f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102752:	8b 50 20             	mov    0x20(%eax),%edx
80102755:	eb 82                	jmp    801026d9 <lapicinit+0x69>
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102760:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0c                	je     80102778 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010276c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010276f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102770:	c1 e8 18             	shr    $0x18,%eax
}
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102778:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010277a:	5d                   	pop    %ebp
8010277b:	c3                   	ret    
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102780:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
}
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b1:	ba 70 00 00 00       	mov    $0x70,%edx
801027b6:	89 e5                	mov    %esp,%ebp
801027b8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027bd:	53                   	push   %ebx
801027be:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	b2 71                	mov    $0x71,%dl
801027cc:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027cd:	31 c0                	xor    %eax,%eax
801027cf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027d5:	89 d8                	mov    %ebx,%eax
801027d7:	c1 e8 04             	shr    $0x4,%eax
801027da:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027e5:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e8:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027eb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027fb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102801:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102808:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102817:	89 da                	mov    %ebx,%edx
80102819:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102822:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102825:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102837:	5b                   	pop    %ebx
80102838:	5d                   	pop    %ebp
80102839:	c3                   	ret    
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102840 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	89 e5                	mov    %esp,%ebp
80102848:	b8 0b 00 00 00       	mov    $0xb,%eax
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	b2 71                	mov    $0x71,%dl
80102856:	ec                   	in     (%dx),%al
80102857:	88 45 b7             	mov    %al,-0x49(%ebp)
8010285a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010285d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102861:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102868:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010286d:	89 d8                	mov    %ebx,%eax
8010286f:	e8 7c fd ff ff       	call   801025f0 <fill_rtcdate>
80102874:	b8 0a 00 00 00       	mov    $0xa,%eax
80102879:	89 f2                	mov    %esi,%edx
8010287b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	ba 71 00 00 00       	mov    $0x71,%edx
80102881:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102882:	84 c0                	test   %al,%al
80102884:	78 e7                	js     8010286d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102886:	89 f8                	mov    %edi,%eax
80102888:	e8 63 fd ff ff       	call   801025f0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010288d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102894:	00 
80102895:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102899:	89 1c 24             	mov    %ebx,(%esp)
8010289c:	e8 ff 1b 00 00       	call   801044a0 <memcmp>
801028a1:	85 c0                	test   %eax,%eax
801028a3:	75 c3                	jne    80102868 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028a5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028a9:	75 78                	jne    80102923 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ae:	89 c2                	mov    %eax,%edx
801028b0:	83 e0 0f             	and    $0xf,%eax
801028b3:	c1 ea 04             	shr    $0x4,%edx
801028b6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028bc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028c2:	89 c2                	mov    %eax,%edx
801028c4:	83 e0 0f             	and    $0xf,%eax
801028c7:	c1 ea 04             	shr    $0x4,%edx
801028ca:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028d6:	89 c2                	mov    %eax,%edx
801028d8:	83 e0 0f             	and    $0xf,%eax
801028db:	c1 ea 04             	shr    $0x4,%edx
801028de:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028ea:	89 c2                	mov    %eax,%edx
801028ec:	83 e0 0f             	and    $0xf,%eax
801028ef:	c1 ea 04             	shr    $0x4,%edx
801028f2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028fe:	89 c2                	mov    %eax,%edx
80102900:	83 e0 0f             	and    $0xf,%eax
80102903:	c1 ea 04             	shr    $0x4,%edx
80102906:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102909:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010290f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102912:	89 c2                	mov    %eax,%edx
80102914:	83 e0 0f             	and    $0xf,%eax
80102917:	c1 ea 04             	shr    $0x4,%edx
8010291a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102920:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102923:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102926:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102929:	89 01                	mov    %eax,(%ecx)
8010292b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010292e:	89 41 04             	mov    %eax,0x4(%ecx)
80102931:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102934:	89 41 08             	mov    %eax,0x8(%ecx)
80102937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010293a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010293d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102940:	89 41 10             	mov    %eax,0x10(%ecx)
80102943:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102946:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102949:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102950:	83 c4 4c             	add    $0x4c,%esp
80102953:	5b                   	pop    %ebx
80102954:	5e                   	pop    %esi
80102955:	5f                   	pop    %edi
80102956:	5d                   	pop    %ebp
80102957:	c3                   	ret    
80102958:	66 90                	xchg   %ax,%ax
8010295a:	66 90                	xchg   %ax,%ax
8010295c:	66 90                	xchg   %ax,%ax
8010295e:	66 90                	xchg   %ax,%ax

80102960 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	57                   	push   %edi
80102964:	56                   	push   %esi
80102965:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102966:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102968:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010296b:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102970:	85 c0                	test   %eax,%eax
80102972:	7e 78                	jle    801029ec <install_trans+0x8c>
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102978:	a1 d4 26 11 80       	mov    0x801126d4,%eax
8010297d:	01 d8                	add    %ebx,%eax
8010297f:	83 c0 01             	add    $0x1,%eax
80102982:	89 44 24 04          	mov    %eax,0x4(%esp)
80102986:	a1 e4 26 11 80       	mov    0x801126e4,%eax
8010298b:	89 04 24             	mov    %eax,(%esp)
8010298e:	e8 3d d7 ff ff       	call   801000d0 <bread>
80102993:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102995:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010299c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010299f:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a3:	a1 e4 26 11 80       	mov    0x801126e4,%eax
801029a8:	89 04 24             	mov    %eax,(%esp)
801029ab:	e8 20 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029b0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029b7:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029b8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ba:	8d 47 5c             	lea    0x5c(%edi),%eax
801029bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029c4:	89 04 24             	mov    %eax,(%esp)
801029c7:	e8 24 1b 00 00       	call   801044f0 <memmove>
    bwrite(dbuf);  // write dst to disk
801029cc:	89 34 24             	mov    %esi,(%esp)
801029cf:	e8 cc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029d4:	89 3c 24             	mov    %edi,(%esp)
801029d7:	e8 04 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 fc d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029e4:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
801029ea:	7f 8c                	jg     80102978 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801029ec:	83 c4 1c             	add    $0x1c,%esp
801029ef:	5b                   	pop    %ebx
801029f0:	5e                   	pop    %esi
801029f1:	5f                   	pop    %edi
801029f2:	5d                   	pop    %ebp
801029f3:	c3                   	ret    
801029f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	57                   	push   %edi
80102a04:	56                   	push   %esi
80102a05:	53                   	push   %ebx
80102a06:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a09:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a12:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a17:	89 04 24             	mov    %eax,(%esp)
80102a1a:	e8 b1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a1f:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a25:	31 d2                	xor    %edx,%edx
80102a27:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a29:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a2b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a2e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a31:	7e 17                	jle    80102a4a <write_head+0x4a>
80102a33:	90                   	nop
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a38:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102a3f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a43:	83 c2 01             	add    $0x1,%edx
80102a46:	39 da                	cmp    %ebx,%edx
80102a48:	75 ee                	jne    80102a38 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a4a:	89 3c 24             	mov    %edi,(%esp)
80102a4d:	e8 4e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a52:	89 3c 24             	mov    %edi,(%esp)
80102a55:	e8 86 d7 ff ff       	call   801001e0 <brelse>
}
80102a5a:	83 c4 1c             	add    $0x1c,%esp
80102a5d:	5b                   	pop    %ebx
80102a5e:	5e                   	pop    %esi
80102a5f:	5f                   	pop    %edi
80102a60:	5d                   	pop    %ebp
80102a61:	c3                   	ret    
80102a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
80102a75:	83 ec 30             	sub    $0x30,%esp
80102a78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a7b:	c7 44 24 04 00 73 10 	movl   $0x80107300,0x4(%esp)
80102a82:	80 
80102a83:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102a8a:	e8 91 17 00 00       	call   80104220 <initlock>
  readsb(dev, &sb);
80102a8f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a96:	89 1c 24             	mov    %ebx,(%esp)
80102a99:	e8 82 e9 ff ff       	call   80101420 <readsb>
  log.start = sb.logstart;
80102a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102aa1:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aa4:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102aa7:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aad:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ab1:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ab7:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102abc:	e8 0f d6 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ac1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ac3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ac6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102acb:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102ad1:	7e 17                	jle    80102aea <initlog+0x7a>
80102ad3:	90                   	nop
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ad8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102adc:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ae3:	83 c2 01             	add    $0x1,%edx
80102ae6:	39 da                	cmp    %ebx,%edx
80102ae8:	75 ee                	jne    80102ad8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102aea:	89 04 24             	mov    %eax,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102af2:	e8 69 fe ff ff       	call   80102960 <install_trans>
  log.lh.n = 0;
80102af7:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102afe:	00 00 00 
  write_head(); // clear the log
80102b01:	e8 fa fe ff ff       	call   80102a00 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b06:	83 c4 30             	add    $0x30,%esp
80102b09:	5b                   	pop    %ebx
80102b0a:	5e                   	pop    %esi
80102b0b:	5d                   	pop    %ebp
80102b0c:	c3                   	ret    
80102b0d:	8d 76 00             	lea    0x0(%esi),%esi

80102b10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b16:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b1d:	e8 6e 18 00 00       	call   80104390 <acquire>
80102b22:	eb 18                	jmp    80102b3c <begin_op+0x2c>
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b28:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102b2f:	80 
80102b30:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b37:	e8 74 11 00 00       	call   80103cb0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b3c:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102b41:	85 c0                	test   %eax,%eax
80102b43:	75 e3                	jne    80102b28 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b45:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102b4a:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102b50:	83 c0 01             	add    $0x1,%eax
80102b53:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b56:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b59:	83 fa 1e             	cmp    $0x1e,%edx
80102b5c:	7f ca                	jg     80102b28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b5e:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b65:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102b6a:	e8 91 18 00 00       	call   80104400 <release>
      break;
    }
  }
}
80102b6f:	c9                   	leave  
80102b70:	c3                   	ret    
80102b71:	eb 0d                	jmp    80102b80 <end_op>
80102b73:	90                   	nop
80102b74:	90                   	nop
80102b75:	90                   	nop
80102b76:	90                   	nop
80102b77:	90                   	nop
80102b78:	90                   	nop
80102b79:	90                   	nop
80102b7a:	90                   	nop
80102b7b:	90                   	nop
80102b7c:	90                   	nop
80102b7d:	90                   	nop
80102b7e:	90                   	nop
80102b7f:	90                   	nop

80102b80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	57                   	push   %edi
80102b84:	56                   	push   %esi
80102b85:	53                   	push   %ebx
80102b86:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b89:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b90:	e8 fb 17 00 00       	call   80104390 <acquire>
  log.outstanding -= 1;
80102b95:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102b9a:	8b 15 e0 26 11 80    	mov    0x801126e0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ba0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102ba3:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ba5:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102baa:	0f 85 f3 00 00 00    	jne    80102ca3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bb0:	85 c0                	test   %eax,%eax
80102bb2:	0f 85 cb 00 00 00    	jne    80102c83 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bb8:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bbf:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bc1:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102bc8:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bcb:	e8 30 18 00 00       	call   80104400 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bd0:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102bd5:	85 c0                	test   %eax,%eax
80102bd7:	0f 8e 90 00 00 00    	jle    80102c6d <end_op+0xed>
80102bdd:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102be0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102be5:	01 d8                	add    %ebx,%eax
80102be7:	83 c0 01             	add    $0x1,%eax
80102bea:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bee:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102bf3:	89 04 24             	mov    %eax,(%esp)
80102bf6:	e8 d5 d4 ff ff       	call   801000d0 <bread>
80102bfb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bfd:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c04:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c0b:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c10:	89 04 24             	mov    %eax,(%esp)
80102c13:	e8 b8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c18:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c1f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c20:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c22:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c25:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c29:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2c:	89 04 24             	mov    %eax,(%esp)
80102c2f:	e8 bc 18 00 00       	call   801044f0 <memmove>
    bwrite(to);  // write the log
80102c34:	89 34 24             	mov    %esi,(%esp)
80102c37:	e8 64 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c3c:	89 3c 24             	mov    %edi,(%esp)
80102c3f:	e8 9c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 94 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c4c:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102c52:	7c 8c                	jl     80102be0 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c54:	e8 a7 fd ff ff       	call   80102a00 <write_head>
    install_trans(); // Now install writes to home locations
80102c59:	e8 02 fd ff ff       	call   80102960 <install_trans>
    log.lh.n = 0;
80102c5e:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102c65:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c68:	e8 93 fd ff ff       	call   80102a00 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c6d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c74:	e8 17 17 00 00       	call   80104390 <acquire>
    log.committing = 0;
80102c79:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102c80:	00 00 00 
    wakeup(&log);
80102c83:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c8a:	e8 c1 11 00 00       	call   80103e50 <wakeup>
    release(&log.lock);
80102c8f:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c96:	e8 65 17 00 00       	call   80104400 <release>
  }
}
80102c9b:	83 c4 1c             	add    $0x1c,%esp
80102c9e:	5b                   	pop    %ebx
80102c9f:	5e                   	pop    %esi
80102ca0:	5f                   	pop    %edi
80102ca1:	5d                   	pop    %ebp
80102ca2:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102ca3:	c7 04 24 04 73 10 80 	movl   $0x80107304,(%esp)
80102caa:	e8 b1 d6 ff ff       	call   80100360 <panic>
80102caf:	90                   	nop

80102cb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cb7:	a1 e8 26 11 80       	mov    0x801126e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cbf:	83 f8 1d             	cmp    $0x1d,%eax
80102cc2:	0f 8f 98 00 00 00    	jg     80102d60 <log_write+0xb0>
80102cc8:	8b 0d d8 26 11 80    	mov    0x801126d8,%ecx
80102cce:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cd1:	39 d0                	cmp    %edx,%eax
80102cd3:	0f 8d 87 00 00 00    	jge    80102d60 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cd9:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102cde:	85 c0                	test   %eax,%eax
80102ce0:	0f 8e 86 00 00 00    	jle    80102d6c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ce6:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ced:	e8 9e 16 00 00       	call   80104390 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102cf2:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102cf8:	83 fa 00             	cmp    $0x0,%edx
80102cfb:	7e 54                	jle    80102d51 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102cfd:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d00:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d02:	39 0d ec 26 11 80    	cmp    %ecx,0x801126ec
80102d08:	75 0f                	jne    80102d19 <log_write+0x69>
80102d0a:	eb 3c                	jmp    80102d48 <log_write+0x98>
80102d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d10:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102d17:	74 2f                	je     80102d48 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d19:	83 c0 01             	add    $0x1,%eax
80102d1c:	39 d0                	cmp    %edx,%eax
80102d1e:	75 f0                	jne    80102d10 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d20:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d27:	83 c2 01             	add    $0x1,%edx
80102d2a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102d30:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d33:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102d3a:	83 c4 14             	add    $0x14,%esp
80102d3d:	5b                   	pop    %ebx
80102d3e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d3f:	e9 bc 16 00 00       	jmp    80104400 <release>
80102d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d48:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102d4f:	eb df                	jmp    80102d30 <log_write+0x80>
80102d51:	8b 43 08             	mov    0x8(%ebx),%eax
80102d54:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102d59:	75 d5                	jne    80102d30 <log_write+0x80>
80102d5b:	eb ca                	jmp    80102d27 <log_write+0x77>
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102d60:	c7 04 24 13 73 10 80 	movl   $0x80107313,(%esp)
80102d67:	e8 f4 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102d6c:	c7 04 24 29 73 10 80 	movl   $0x80107329,(%esp)
80102d73:	e8 e8 d5 ff ff       	call   80100360 <panic>
80102d78:	66 90                	xchg   %ax,%ax
80102d7a:	66 90                	xchg   %ax,%ax
80102d7c:	66 90                	xchg   %ax,%ax
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d87:	e8 54 09 00 00       	call   801036e0 <cpuid>
80102d8c:	89 c3                	mov    %eax,%ebx
80102d8e:	e8 4d 09 00 00       	call   801036e0 <cpuid>
80102d93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d97:	c7 04 24 44 73 10 80 	movl   $0x80107344,(%esp)
80102d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102da2:	e8 a9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102da7:	e8 24 29 00 00       	call   801056d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dac:	e8 af 08 00 00       	call   80103660 <mycpu>
80102db1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102db3:	b8 01 00 00 00       	mov    $0x1,%eax
80102db8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dbf:	e8 fc 0b 00 00       	call   801039c0 <scheduler>
80102dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102dd0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102dd6:	e8 e5 39 00 00       	call   801067c0 <switchkvm>
  seginit();
80102ddb:	e8 20 39 00 00       	call   80106700 <seginit>
  lapicinit();
80102de0:	e8 8b f8 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102de5:	e8 96 ff ff ff       	call   80102d80 <mpmain>
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102df4:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102df9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dfc:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102dff:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e06:	80 
80102e07:	c7 04 24 c8 ba 11 80 	movl   $0x8011bac8,(%esp)
80102e0e:	e8 cd f5 ff ff       	call   801023e0 <kinit1>
  kvmalloc();      // kernel page table
80102e13:	e8 38 3e 00 00       	call   80106c50 <kvmalloc>
  mpinit();        // detect other processors
80102e18:	e8 73 01 00 00       	call   80102f90 <mpinit>
80102e1d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e20:	e8 4b f8 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102e25:	e8 d6 38 00 00       	call   80106700 <seginit>
  picinit();       // disable pic
80102e2a:	e8 21 03 00 00       	call   80103150 <picinit>
80102e2f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e30:	e8 cb f3 ff ff       	call   80102200 <ioapicinit>
  consoleinit();   // console hardware
80102e35:	e8 16 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e3a:	e8 e1 2b 00 00       	call   80105a20 <uartinit>
80102e3f:	90                   	nop
  pinit();         // process table
80102e40:	e8 fb 07 00 00       	call   80103640 <pinit>
  tvinit();        // trap vectors
80102e45:	e8 e6 27 00 00       	call   80105630 <tvinit>
  binit();         // buffer cache
80102e4a:	e8 f1 d1 ff ff       	call   80100040 <binit>
80102e4f:	90                   	nop
  fileinit();      // file table
80102e50:	e8 fb de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102e55:	e8 a6 f1 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e5a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e61:	00 
80102e62:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e69:	80 
80102e6a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e71:	e8 7a 16 00 00       	call   801044f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e76:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80102e7d:	00 00 00 
80102e80:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102e85:	39 d8                	cmp    %ebx,%eax
80102e87:	76 6a                	jbe    80102ef3 <main+0x103>
80102e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102e90:	e8 cb 07 00 00       	call   80103660 <mycpu>
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	74 41                	je     80102eda <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e99:	e8 02 f6 ff ff       	call   801024a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102e9e:	c7 05 f8 6f 00 80 d0 	movl   $0x80102dd0,0x80006ff8
80102ea5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ea8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102eaf:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102eb2:	05 00 10 00 00       	add    $0x1000,%eax
80102eb7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102ebc:	0f b6 03             	movzbl (%ebx),%eax
80102ebf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ec6:	00 
80102ec7:	89 04 24             	mov    %eax,(%esp)
80102eca:	e8 e1 f8 ff ff       	call   801027b0 <lapicstartap>
80102ecf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ed0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ed6:	85 c0                	test   %eax,%eax
80102ed8:	74 f6                	je     80102ed0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102eda:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80102ee1:	00 00 00 
80102ee4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eea:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102eef:	39 c3                	cmp    %eax,%ebx
80102ef1:	72 9d                	jb     80102e90 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ef3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102efa:	8e 
80102efb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f02:	e8 49 f5 ff ff       	call   80102450 <kinit2>
  userinit();      // first user process
80102f07:	e8 24 08 00 00       	call   80103730 <userinit>
  mpmain();        // finish this processor's setup
80102f0c:	e8 6f fe ff ff       	call   80102d80 <mpmain>
80102f11:	66 90                	xchg   %ax,%ax
80102f13:	66 90                	xchg   %ax,%ax
80102f15:	66 90                	xchg   %ax,%ax
80102f17:	66 90                	xchg   %ax,%ax
80102f19:	66 90                	xchg   %ax,%ax
80102f1b:	66 90                	xchg   %ax,%ax
80102f1d:	66 90                	xchg   %ax,%ax
80102f1f:	90                   	nop

80102f20 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f24:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f2a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f2b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f2e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f31:	39 de                	cmp    %ebx,%esi
80102f33:	73 3c                	jae    80102f71 <mpsearch1+0x51>
80102f35:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f38:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f3f:	00 
80102f40:	c7 44 24 04 58 73 10 	movl   $0x80107358,0x4(%esp)
80102f47:	80 
80102f48:	89 34 24             	mov    %esi,(%esp)
80102f4b:	e8 50 15 00 00       	call   801044a0 <memcmp>
80102f50:	85 c0                	test   %eax,%eax
80102f52:	75 16                	jne    80102f6a <mpsearch1+0x4a>
80102f54:	31 c9                	xor    %ecx,%ecx
80102f56:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f58:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f5c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f5f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f61:	83 fa 10             	cmp    $0x10,%edx
80102f64:	75 f2                	jne    80102f58 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f66:	84 c9                	test   %cl,%cl
80102f68:	74 10                	je     80102f7a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f6a:	83 c6 10             	add    $0x10,%esi
80102f6d:	39 f3                	cmp    %esi,%ebx
80102f6f:	77 c7                	ja     80102f38 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102f71:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102f74:	31 c0                	xor    %eax,%eax
}
80102f76:	5b                   	pop    %ebx
80102f77:	5e                   	pop    %esi
80102f78:	5d                   	pop    %ebp
80102f79:	c3                   	ret    
80102f7a:	83 c4 10             	add    $0x10,%esp
80102f7d:	89 f0                	mov    %esi,%eax
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5d                   	pop    %ebp
80102f82:	c3                   	ret    
80102f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f90 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
80102f95:	53                   	push   %ebx
80102f96:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f99:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fa0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fa7:	c1 e0 08             	shl    $0x8,%eax
80102faa:	09 d0                	or     %edx,%eax
80102fac:	c1 e0 04             	shl    $0x4,%eax
80102faf:	85 c0                	test   %eax,%eax
80102fb1:	75 1b                	jne    80102fce <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fb3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fc1:	c1 e0 08             	shl    $0x8,%eax
80102fc4:	09 d0                	or     %edx,%eax
80102fc6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fc9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102fce:	ba 00 04 00 00       	mov    $0x400,%edx
80102fd3:	e8 48 ff ff ff       	call   80102f20 <mpsearch1>
80102fd8:	85 c0                	test   %eax,%eax
80102fda:	89 c7                	mov    %eax,%edi
80102fdc:	0f 84 22 01 00 00    	je     80103104 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fe2:	8b 77 04             	mov    0x4(%edi),%esi
80102fe5:	85 f6                	test   %esi,%esi
80102fe7:	0f 84 30 01 00 00    	je     8010311d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fed:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102ff3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102ffa:	00 
80102ffb:	c7 44 24 04 5d 73 10 	movl   $0x8010735d,0x4(%esp)
80103002:	80 
80103003:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103006:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103009:	e8 92 14 00 00       	call   801044a0 <memcmp>
8010300e:	85 c0                	test   %eax,%eax
80103010:	0f 85 07 01 00 00    	jne    8010311d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103016:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010301d:	3c 04                	cmp    $0x4,%al
8010301f:	0f 85 0b 01 00 00    	jne    80103130 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103025:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010302c:	85 c0                	test   %eax,%eax
8010302e:	74 21                	je     80103051 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103030:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103032:	31 d2                	xor    %edx,%edx
80103034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103038:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010303f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103040:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103043:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103045:	39 d0                	cmp    %edx,%eax
80103047:	7f ef                	jg     80103038 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103049:	84 c9                	test   %cl,%cl
8010304b:	0f 85 cc 00 00 00    	jne    8010311d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103054:	85 c0                	test   %eax,%eax
80103056:	0f 84 c1 00 00 00    	je     8010311d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010305c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103062:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103067:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010306c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103073:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103079:	03 55 e4             	add    -0x1c(%ebp),%edx
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103080:	39 c2                	cmp    %eax,%edx
80103082:	76 1b                	jbe    8010309f <mpinit+0x10f>
80103084:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103087:	80 f9 04             	cmp    $0x4,%cl
8010308a:	77 74                	ja     80103100 <mpinit+0x170>
8010308c:	ff 24 8d 9c 73 10 80 	jmp    *-0x7fef8c64(,%ecx,4)
80103093:	90                   	nop
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103098:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010309b:	39 c2                	cmp    %eax,%edx
8010309d:	77 e5                	ja     80103084 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010309f:	85 db                	test   %ebx,%ebx
801030a1:	0f 84 93 00 00 00    	je     8010313a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030a7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030ab:	74 12                	je     801030bf <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ad:	ba 22 00 00 00       	mov    $0x22,%edx
801030b2:	b8 70 00 00 00       	mov    $0x70,%eax
801030b7:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b8:	b2 23                	mov    $0x23,%dl
801030ba:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030bb:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030be:	ee                   	out    %al,(%dx)
  }
}
801030bf:	83 c4 1c             	add    $0x1c,%esp
801030c2:	5b                   	pop    %ebx
801030c3:	5e                   	pop    %esi
801030c4:	5f                   	pop    %edi
801030c5:	5d                   	pop    %ebp
801030c6:	c3                   	ret    
801030c7:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801030c8:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
801030ce:	83 fe 07             	cmp    $0x7,%esi
801030d1:	7f 17                	jg     801030ea <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030d3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030d7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030dd:	83 05 20 2d 11 80 01 	addl   $0x1,0x80112d20
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030e4:	88 8e a0 27 11 80    	mov    %cl,-0x7feed860(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801030ea:	83 c0 14             	add    $0x14,%eax
      continue;
801030ed:	eb 91                	jmp    80103080 <mpinit+0xf0>
801030ef:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801030f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801030f4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801030f7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
801030fd:	eb 81                	jmp    80103080 <mpinit+0xf0>
801030ff:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103100:	31 db                	xor    %ebx,%ebx
80103102:	eb 83                	jmp    80103087 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103104:	ba 00 00 01 00       	mov    $0x10000,%edx
80103109:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010310e:	e8 0d fe ff ff       	call   80102f20 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103113:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103115:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103117:	0f 85 c5 fe ff ff    	jne    80102fe2 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010311d:	c7 04 24 62 73 10 80 	movl   $0x80107362,(%esp)
80103124:	e8 37 d2 ff ff       	call   80100360 <panic>
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103130:	3c 01                	cmp    $0x1,%al
80103132:	0f 84 ed fe ff ff    	je     80103025 <mpinit+0x95>
80103138:	eb e3                	jmp    8010311d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010313a:	c7 04 24 7c 73 10 80 	movl   $0x8010737c,(%esp)
80103141:	e8 1a d2 ff ff       	call   80100360 <panic>
80103146:	66 90                	xchg   %ax,%ax
80103148:	66 90                	xchg   %ax,%ax
8010314a:	66 90                	xchg   %ax,%ax
8010314c:	66 90                	xchg   %ax,%ax
8010314e:	66 90                	xchg   %ax,%ax

80103150 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103150:	55                   	push   %ebp
80103151:	ba 21 00 00 00       	mov    $0x21,%edx
80103156:	89 e5                	mov    %esp,%ebp
80103158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010315d:	ee                   	out    %al,(%dx)
8010315e:	b2 a1                	mov    $0xa1,%dl
80103160:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103161:	5d                   	pop    %ebp
80103162:	c3                   	ret    
80103163:	66 90                	xchg   %ax,%ax
80103165:	66 90                	xchg   %ax,%ax
80103167:	66 90                	xchg   %ax,%ax
80103169:	66 90                	xchg   %ax,%ax
8010316b:	66 90                	xchg   %ax,%ax
8010316d:	66 90                	xchg   %ax,%ax
8010316f:	90                   	nop

80103170 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
80103175:	53                   	push   %ebx
80103176:	83 ec 1c             	sub    $0x1c,%esp
80103179:	8b 75 08             	mov    0x8(%ebp),%esi
8010317c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010317f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103185:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010318b:	e8 e0 db ff ff       	call   80100d70 <filealloc>
80103190:	85 c0                	test   %eax,%eax
80103192:	89 06                	mov    %eax,(%esi)
80103194:	0f 84 a4 00 00 00    	je     8010323e <pipealloc+0xce>
8010319a:	e8 d1 db ff ff       	call   80100d70 <filealloc>
8010319f:	85 c0                	test   %eax,%eax
801031a1:	89 03                	mov    %eax,(%ebx)
801031a3:	0f 84 87 00 00 00    	je     80103230 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031a9:	e8 f2 f2 ff ff       	call   801024a0 <kalloc>
801031ae:	85 c0                	test   %eax,%eax
801031b0:	89 c7                	mov    %eax,%edi
801031b2:	74 7c                	je     80103230 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031b4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031bb:	00 00 00 
  p->writeopen = 1;
801031be:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031c5:	00 00 00 
  p->nwrite = 0;
801031c8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031cf:	00 00 00 
  p->nread = 0;
801031d2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031d9:	00 00 00 
  initlock(&p->lock, "pipe");
801031dc:	89 04 24             	mov    %eax,(%esp)
801031df:	c7 44 24 04 b0 73 10 	movl   $0x801073b0,0x4(%esp)
801031e6:	80 
801031e7:	e8 34 10 00 00       	call   80104220 <initlock>
  (*f0)->type = FD_PIPE;
801031ec:	8b 06                	mov    (%esi),%eax
801031ee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801031f4:	8b 06                	mov    (%esi),%eax
801031f6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801031fa:	8b 06                	mov    (%esi),%eax
801031fc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103200:	8b 06                	mov    (%esi),%eax
80103202:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103205:	8b 03                	mov    (%ebx),%eax
80103207:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010320d:	8b 03                	mov    (%ebx),%eax
8010320f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103213:	8b 03                	mov    (%ebx),%eax
80103215:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103219:	8b 03                	mov    (%ebx),%eax
  return 0;
8010321b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010321d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103220:	83 c4 1c             	add    $0x1c,%esp
80103223:	89 d8                	mov    %ebx,%eax
80103225:	5b                   	pop    %ebx
80103226:	5e                   	pop    %esi
80103227:	5f                   	pop    %edi
80103228:	5d                   	pop    %ebp
80103229:	c3                   	ret    
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103230:	8b 06                	mov    (%esi),%eax
80103232:	85 c0                	test   %eax,%eax
80103234:	74 08                	je     8010323e <pipealloc+0xce>
    fileclose(*f0);
80103236:	89 04 24             	mov    %eax,(%esp)
80103239:	e8 f2 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010323e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103240:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103245:	85 c0                	test   %eax,%eax
80103247:	74 d7                	je     80103220 <pipealloc+0xb0>
    fileclose(*f1);
80103249:	89 04 24             	mov    %eax,(%esp)
8010324c:	e8 df db ff ff       	call   80100e30 <fileclose>
  return -1;
}
80103251:	83 c4 1c             	add    $0x1c,%esp
80103254:	89 d8                	mov    %ebx,%eax
80103256:	5b                   	pop    %ebx
80103257:	5e                   	pop    %esi
80103258:	5f                   	pop    %edi
80103259:	5d                   	pop    %ebp
8010325a:	c3                   	ret    
8010325b:	90                   	nop
8010325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103260 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	56                   	push   %esi
80103264:	53                   	push   %ebx
80103265:	83 ec 10             	sub    $0x10,%esp
80103268:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010326b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010326e:	89 1c 24             	mov    %ebx,(%esp)
80103271:	e8 1a 11 00 00       	call   80104390 <acquire>
  if(writable){
80103276:	85 f6                	test   %esi,%esi
80103278:	74 3e                	je     801032b8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010327a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103280:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103287:	00 00 00 
    wakeup(&p->nread);
8010328a:	89 04 24             	mov    %eax,(%esp)
8010328d:	e8 be 0b 00 00       	call   80103e50 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103292:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103298:	85 d2                	test   %edx,%edx
8010329a:	75 0a                	jne    801032a6 <pipeclose+0x46>
8010329c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 32                	je     801032d8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032a9:	83 c4 10             	add    $0x10,%esp
801032ac:	5b                   	pop    %ebx
801032ad:	5e                   	pop    %esi
801032ae:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032af:	e9 4c 11 00 00       	jmp    80104400 <release>
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801032b8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801032be:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032c5:	00 00 00 
    wakeup(&p->nwrite);
801032c8:	89 04 24             	mov    %eax,(%esp)
801032cb:	e8 80 0b 00 00       	call   80103e50 <wakeup>
801032d0:	eb c0                	jmp    80103292 <pipeclose+0x32>
801032d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801032d8:	89 1c 24             	mov    %ebx,(%esp)
801032db:	e8 20 11 00 00       	call   80104400 <release>
    kfree((char*)p);
801032e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
801032e3:	83 c4 10             	add    $0x10,%esp
801032e6:	5b                   	pop    %ebx
801032e7:	5e                   	pop    %esi
801032e8:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801032e9:	e9 02 f0 ff ff       	jmp    801022f0 <kfree>
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
801032f5:	53                   	push   %ebx
801032f6:	83 ec 1c             	sub    $0x1c,%esp
801032f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032fc:	89 1c 24             	mov    %ebx,(%esp)
801032ff:	e8 8c 10 00 00       	call   80104390 <acquire>
  for(i = 0; i < n; i++){
80103304:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103307:	85 c9                	test   %ecx,%ecx
80103309:	0f 8e b2 00 00 00    	jle    801033c1 <pipewrite+0xd1>
8010330f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103312:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103318:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010331e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103324:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103327:	03 4d 10             	add    0x10(%ebp),%ecx
8010332a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010332d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103333:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103339:	39 c8                	cmp    %ecx,%eax
8010333b:	74 38                	je     80103375 <pipewrite+0x85>
8010333d:	eb 55                	jmp    80103394 <pipewrite+0xa4>
8010333f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103340:	e8 bb 03 00 00       	call   80103700 <myproc>
80103345:	8b 40 24             	mov    0x24(%eax),%eax
80103348:	85 c0                	test   %eax,%eax
8010334a:	75 33                	jne    8010337f <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010334c:	89 3c 24             	mov    %edi,(%esp)
8010334f:	e8 fc 0a 00 00       	call   80103e50 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103354:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103358:	89 34 24             	mov    %esi,(%esp)
8010335b:	e8 50 09 00 00       	call   80103cb0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103360:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103366:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010336c:	05 00 02 00 00       	add    $0x200,%eax
80103371:	39 c2                	cmp    %eax,%edx
80103373:	75 23                	jne    80103398 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103375:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010337b:	85 d2                	test   %edx,%edx
8010337d:	75 c1                	jne    80103340 <pipewrite+0x50>
        release(&p->lock);
8010337f:	89 1c 24             	mov    %ebx,(%esp)
80103382:	e8 79 10 00 00       	call   80104400 <release>
        return -1;
80103387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010338c:	83 c4 1c             	add    $0x1c,%esp
8010338f:	5b                   	pop    %ebx
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103394:	89 c2                	mov    %eax,%edx
80103396:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103398:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010339b:	8d 42 01             	lea    0x1(%edx),%eax
8010339e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033a4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033aa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033ae:	0f b6 09             	movzbl (%ecx),%ecx
801033b1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801033b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033b8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033bb:	0f 85 6c ff ff ff    	jne    8010332d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033c1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033c7:	89 04 24             	mov    %eax,(%esp)
801033ca:	e8 81 0a 00 00       	call   80103e50 <wakeup>
  release(&p->lock);
801033cf:	89 1c 24             	mov    %ebx,(%esp)
801033d2:	e8 29 10 00 00       	call   80104400 <release>
  return n;
801033d7:	8b 45 10             	mov    0x10(%ebp),%eax
801033da:	eb b0                	jmp    8010338c <pipewrite+0x9c>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033e0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
801033e9:	8b 75 08             	mov    0x8(%ebp),%esi
801033ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033ef:	89 34 24             	mov    %esi,(%esp)
801033f2:	e8 99 0f 00 00       	call   80104390 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033f7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033fd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103403:	75 5b                	jne    80103460 <piperead+0x80>
80103405:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010340b:	85 db                	test   %ebx,%ebx
8010340d:	74 51                	je     80103460 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010340f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103415:	eb 25                	jmp    8010343c <piperead+0x5c>
80103417:	90                   	nop
80103418:	89 74 24 04          	mov    %esi,0x4(%esp)
8010341c:	89 1c 24             	mov    %ebx,(%esp)
8010341f:	e8 8c 08 00 00       	call   80103cb0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103424:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010342a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103430:	75 2e                	jne    80103460 <piperead+0x80>
80103432:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103438:	85 d2                	test   %edx,%edx
8010343a:	74 24                	je     80103460 <piperead+0x80>
    if(myproc()->killed){
8010343c:	e8 bf 02 00 00       	call   80103700 <myproc>
80103441:	8b 48 24             	mov    0x24(%eax),%ecx
80103444:	85 c9                	test   %ecx,%ecx
80103446:	74 d0                	je     80103418 <piperead+0x38>
      release(&p->lock);
80103448:	89 34 24             	mov    %esi,(%esp)
8010344b:	e8 b0 0f 00 00       	call   80104400 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103450:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103458:	5b                   	pop    %ebx
80103459:	5e                   	pop    %esi
8010345a:	5f                   	pop    %edi
8010345b:	5d                   	pop    %ebp
8010345c:	c3                   	ret    
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103460:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103463:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103465:	85 d2                	test   %edx,%edx
80103467:	7f 2b                	jg     80103494 <piperead+0xb4>
80103469:	eb 31                	jmp    8010349c <piperead+0xbc>
8010346b:	90                   	nop
8010346c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103470:	8d 48 01             	lea    0x1(%eax),%ecx
80103473:	25 ff 01 00 00       	and    $0x1ff,%eax
80103478:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010347e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103483:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103486:	83 c3 01             	add    $0x1,%ebx
80103489:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010348c:	74 0e                	je     8010349c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010348e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103494:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010349a:	75 d4                	jne    80103470 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010349c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034a2:	89 04 24             	mov    %eax,(%esp)
801034a5:	e8 a6 09 00 00       	call   80103e50 <wakeup>
  release(&p->lock);
801034aa:	89 34 24             	mov    %esi,(%esp)
801034ad:	e8 4e 0f 00 00       	call   80104400 <release>
  return i;
}
801034b2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801034b5:	89 d8                	mov    %ebx,%eax
}
801034b7:	5b                   	pop    %ebx
801034b8:	5e                   	pop    %esi
801034b9:	5f                   	pop    %edi
801034ba:	5d                   	pop    %ebp
801034bb:	c3                   	ret    
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
801034c4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p1=0;
  struct proc *highP=0;
 
  char *sp;

  acquire(&ptable.lock);
801034c7:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801034ce:	e8 bd 0e 00 00       	call   80104390 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d3:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801034d8:	eb 16                	jmp    801034f0 <allocproc+0x30>
801034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034e0:	05 14 02 00 00       	add    $0x214,%eax
801034e5:	3d 74 b2 11 80       	cmp    $0x8011b274,%eax
801034ea:	0f 84 ce 00 00 00    	je     801035be <allocproc+0xfe>
    if(p->state == UNUSED)
801034f0:	8b 50 0c             	mov    0xc(%eax),%edx
801034f3:	85 d2                	test   %edx,%edx
801034f5:	75 e9                	jne    801034e0 <allocproc+0x20>
801034f7:	31 db                	xor    %ebx,%ebx
801034f9:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
801034fe:	eb 0e                	jmp    8010350e <allocproc+0x4e>
  release(&ptable.lock);
  return 0;

found:

for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103500:	81 c2 14 02 00 00    	add    $0x214,%edx
80103506:	81 fa 74 b2 11 80    	cmp    $0x8011b274,%edx
8010350c:	74 35                	je     80103543 <allocproc+0x83>
      
      if(p->state != RUNNABLE)
8010350e:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103512:	75 ec                	jne    80103500 <allocproc+0x40>
80103514:	89 d3                	mov    %edx,%ebx
80103516:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010351b:	eb 0f                	jmp    8010352c <allocproc+0x6c>
8010351d:	8d 76 00             	lea    0x0(%esi),%esi
        continue;


      highP=p;

    for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103520:	05 14 02 00 00       	add    $0x214,%eax
80103525:	3d 74 b2 11 80       	cmp    $0x8011b274,%eax
8010352a:	74 d4                	je     80103500 <allocproc+0x40>
      if(p1->state != RUNNABLE)
8010352c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103530:	75 ee                	jne    80103520 <allocproc+0x60>
80103532:	8b 88 10 02 00 00    	mov    0x210(%eax),%ecx
80103538:	39 8b 10 02 00 00    	cmp    %ecx,0x210(%ebx)
8010353e:	0f 4f d8             	cmovg  %eax,%ebx
80103541:	eb dd                	jmp    80103520 <allocproc+0x60>

    }  
}
  p=highP;
  p->state = EMBRYO;
  p->pid = nextpid++;
80103543:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  if (getPolicy()==2)
80103548:	83 3d b8 a5 10 80 02 	cmpl   $0x2,0x8010a5b8
      }

    }  
}
  p=highP;
  p->state = EMBRYO;
8010354f:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103556:	8d 50 01             	lea    0x1(%eax),%edx
80103559:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010355f:	89 43 10             	mov    %eax,0x10(%ebx)

  if (getPolicy()==2)
80103562:	74 6e                	je     801035d2 <allocproc+0x112>
 


 

  release(&ptable.lock);
80103564:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010356b:	e8 90 0e 00 00       	call   80104400 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103570:	e8 2b ef ff ff       	call   801024a0 <kalloc>
80103575:	85 c0                	test   %eax,%eax
80103577:	89 43 08             	mov    %eax,0x8(%ebx)
8010357a:	74 62                	je     801035de <allocproc+0x11e>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010357c:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103582:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103587:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
8010358a:	c7 40 14 23 56 10 80 	movl   $0x80105623,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103591:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103594:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010359b:	00 
8010359c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801035a3:	00 
801035a4:	89 04 24             	mov    %eax,(%esp)
801035a7:	e8 a4 0e 00 00       	call   80104450 <memset>
  p->context->eip = (uint)forkret;
801035ac:	8b 43 1c             	mov    0x1c(%ebx),%eax
801035af:	c7 40 10 f0 35 10 80 	movl   $0x801035f0,0x10(%eax)

  return p;
801035b6:	89 d8                	mov    %ebx,%eax
}
801035b8:	83 c4 14             	add    $0x14,%esp
801035bb:	5b                   	pop    %ebx
801035bc:	5d                   	pop    %ebp
801035bd:	c3                   	ret    

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801035be:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801035c5:	e8 36 0e 00 00       	call   80104400 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801035ca:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
801035cd:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801035cf:	5b                   	pop    %ebx
801035d0:	5d                   	pop    %ebp
801035d1:	c3                   	ret    
  p->state = EMBRYO;
  p->pid = nextpid++;

  if (getPolicy()==2)
  {
     p->priority=5;
801035d2:	c7 83 0c 02 00 00 05 	movl   $0x5,0x20c(%ebx)
801035d9:	00 00 00 
801035dc:	eb 86                	jmp    80103564 <allocproc+0xa4>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801035de:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035e5:	eb d1                	jmp    801035b8 <allocproc+0xf8>
801035e7:	89 f6                	mov    %esi,%esi
801035e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035f6:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801035fd:	e8 fe 0d 00 00       	call   80104400 <release>

  if (first) {
80103602:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103607:	85 c0                	test   %eax,%eax
80103609:	75 05                	jne    80103610 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010360b:	c9                   	leave  
8010360c:	c3                   	ret    
8010360d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103610:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103617:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010361e:	00 00 00 
    iinit(ROOTDEV);
80103621:	e8 4a de ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103626:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010362d:	e8 3e f4 ff ff       	call   80102a70 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103632:	c9                   	leave  
80103633:	c3                   	ret    
80103634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010363a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103640 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103646:	c7 44 24 04 b5 73 10 	movl   $0x801073b5,0x4(%esp)
8010364d:	80 
8010364e:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103655:	e8 c6 0b 00 00       	call   80104220 <initlock>
}
8010365a:	c9                   	leave  
8010365b:	c3                   	ret    
8010365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103660 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	56                   	push   %esi
80103664:	53                   	push   %ebx
80103665:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103668:	9c                   	pushf  
80103669:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010366a:	f6 c4 02             	test   $0x2,%ah
8010366d:	75 57                	jne    801036c6 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010366f:	e8 ec f0 ff ff       	call   80102760 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103674:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
8010367a:	85 f6                	test   %esi,%esi
8010367c:	7e 3c                	jle    801036ba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010367e:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
80103685:	39 c2                	cmp    %eax,%edx
80103687:	74 2d                	je     801036b6 <mycpu+0x56>
80103689:	b9 50 28 11 80       	mov    $0x80112850,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010368e:	31 d2                	xor    %edx,%edx
80103690:	83 c2 01             	add    $0x1,%edx
80103693:	39 f2                	cmp    %esi,%edx
80103695:	74 23                	je     801036ba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103697:	0f b6 19             	movzbl (%ecx),%ebx
8010369a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801036a0:	39 c3                	cmp    %eax,%ebx
801036a2:	75 ec                	jne    80103690 <mycpu+0x30>
      return &cpus[i];
801036a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	5b                   	pop    %ebx
801036ae:	5e                   	pop    %esi
801036af:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801036b0:	05 a0 27 11 80       	add    $0x801127a0,%eax
  }
  panic("unknown apicid\n");
}
801036b5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036b6:	31 d2                	xor    %edx,%edx
801036b8:	eb ea                	jmp    801036a4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801036ba:	c7 04 24 bc 73 10 80 	movl   $0x801073bc,(%esp)
801036c1:	e8 9a cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801036c6:	c7 04 24 98 74 10 80 	movl   $0x80107498,(%esp)
801036cd:	e8 8e cc ff ff       	call   80100360 <panic>
801036d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036e0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036e6:	e8 75 ff ff ff       	call   80103660 <mycpu>
}
801036eb:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801036ec:	2d a0 27 11 80       	sub    $0x801127a0,%eax
801036f1:	c1 f8 04             	sar    $0x4,%eax
801036f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036fa:	c3                   	ret    
801036fb:	90                   	nop
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103700 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	53                   	push   %ebx
80103704:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103707:	e8 94 0b 00 00       	call   801042a0 <pushcli>
  c = mycpu();
8010370c:	e8 4f ff ff ff       	call   80103660 <mycpu>
  p = c->proc;
80103711:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103717:	e8 c4 0b 00 00       	call   801042e0 <popcli>
  return p;
}
8010371c:	83 c4 04             	add    $0x4,%esp
8010371f:	89 d8                	mov    %ebx,%eax
80103721:	5b                   	pop    %ebx
80103722:	5d                   	pop    %ebp
80103723:	c3                   	ret    
80103724:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010372a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103730 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	53                   	push   %ebx
80103734:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103737:	e8 84 fd ff ff       	call   801034c0 <allocproc>
8010373c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010373e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
80103743:	e8 78 34 00 00       	call   80106bc0 <setupkvm>
80103748:	85 c0                	test   %eax,%eax
8010374a:	89 43 04             	mov    %eax,0x4(%ebx)
8010374d:	0f 84 d4 00 00 00    	je     80103827 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103753:	89 04 24             	mov    %eax,(%esp)
80103756:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010375d:	00 
8010375e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103765:	80 
80103766:	e8 85 31 00 00       	call   801068f0 <inituvm>
  p->sz = PGSIZE;
8010376b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103771:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103778:	00 
80103779:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103780:	00 
80103781:	8b 43 18             	mov    0x18(%ebx),%eax
80103784:	89 04 24             	mov    %eax,(%esp)
80103787:	e8 c4 0c 00 00       	call   80104450 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010378c:	8b 43 18             	mov    0x18(%ebx),%eax
8010378f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103794:	b9 23 00 00 00       	mov    $0x23,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103799:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010379d:	8b 43 18             	mov    0x18(%ebx),%eax
801037a0:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801037a4:	8b 43 18             	mov    0x18(%ebx),%eax
801037a7:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037ab:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801037af:	8b 43 18             	mov    0x18(%ebx),%eax
801037b2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037b6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801037ba:	8b 43 18             	mov    0x18(%ebx),%eax
801037bd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037c4:	8b 43 18             	mov    0x18(%ebx),%eax
801037c7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037ce:	8b 43 18             	mov    0x18(%ebx),%eax
801037d1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801037d8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037db:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037e2:	00 
801037e3:	c7 44 24 04 e5 73 10 	movl   $0x801073e5,0x4(%esp)
801037ea:	80 
801037eb:	89 04 24             	mov    %eax,(%esp)
801037ee:	e8 3d 0e 00 00       	call   80104630 <safestrcpy>
  p->cwd = namei("/");
801037f3:	c7 04 24 ee 73 10 80 	movl   $0x801073ee,(%esp)
801037fa:	e8 01 e7 ff ff       	call   80101f00 <namei>
801037ff:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103802:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103809:	e8 82 0b 00 00       	call   80104390 <acquire>

  p->state = RUNNABLE;
8010380e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103815:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010381c:	e8 df 0b 00 00       	call   80104400 <release>
}
80103821:	83 c4 14             	add    $0x14,%esp
80103824:	5b                   	pop    %ebx
80103825:	5d                   	pop    %ebp
80103826:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103827:	c7 04 24 cc 73 10 80 	movl   $0x801073cc,(%esp)
8010382e:	e8 2d cb ff ff       	call   80100360 <panic>
80103833:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103840 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	56                   	push   %esi
80103844:	53                   	push   %ebx
80103845:	83 ec 10             	sub    $0x10,%esp
80103848:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
8010384b:	e8 b0 fe ff ff       	call   80103700 <myproc>

  sz = curproc->sz;
  if(n > 0){
80103850:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
80103853:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
80103855:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103857:	7e 2f                	jle    80103888 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103859:	01 c6                	add    %eax,%esi
8010385b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010385f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103863:	8b 43 04             	mov    0x4(%ebx),%eax
80103866:	89 04 24             	mov    %eax,(%esp)
80103869:	e8 c2 31 00 00       	call   80106a30 <allocuvm>
8010386e:	85 c0                	test   %eax,%eax
80103870:	74 36                	je     801038a8 <growproc+0x68>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103872:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103874:	89 1c 24             	mov    %ebx,(%esp)
80103877:	e8 64 2f 00 00       	call   801067e0 <switchuvm>
  return 0;
8010387c:	31 c0                	xor    %eax,%eax
}
8010387e:	83 c4 10             	add    $0x10,%esp
80103881:	5b                   	pop    %ebx
80103882:	5e                   	pop    %esi
80103883:	5d                   	pop    %ebp
80103884:	c3                   	ret    
80103885:	8d 76 00             	lea    0x0(%esi),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103888:	74 e8                	je     80103872 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010388a:	01 c6                	add    %eax,%esi
8010388c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103890:	89 44 24 04          	mov    %eax,0x4(%esp)
80103894:	8b 43 04             	mov    0x4(%ebx),%eax
80103897:	89 04 24             	mov    %eax,(%esp)
8010389a:	e8 81 32 00 00       	call   80106b20 <deallocuvm>
8010389f:	85 c0                	test   %eax,%eax
801038a1:	75 cf                	jne    80103872 <growproc+0x32>
801038a3:	90                   	nop
801038a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
801038a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038ad:	eb cf                	jmp    8010387e <growproc+0x3e>
801038af:	90                   	nop

801038b0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	57                   	push   %edi
801038b4:	56                   	push   %esi
801038b5:	53                   	push   %ebx
801038b6:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801038b9:	e8 42 fe ff ff       	call   80103700 <myproc>
801038be:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
801038c0:	e8 fb fb ff ff       	call   801034c0 <allocproc>
801038c5:	85 c0                	test   %eax,%eax
801038c7:	89 c7                	mov    %eax,%edi
801038c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038cc:	0f 84 bc 00 00 00    	je     8010398e <fork+0xde>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038d2:	8b 03                	mov    (%ebx),%eax
801038d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038d8:	8b 43 04             	mov    0x4(%ebx),%eax
801038db:	89 04 24             	mov    %eax,(%esp)
801038de:	e8 bd 33 00 00       	call   80106ca0 <copyuvm>
801038e3:	85 c0                	test   %eax,%eax
801038e5:	89 47 04             	mov    %eax,0x4(%edi)
801038e8:	0f 84 a7 00 00 00    	je     80103995 <fork+0xe5>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801038ee:	8b 03                	mov    (%ebx),%eax
801038f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038f3:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
801038f5:	8b 79 18             	mov    0x18(%ecx),%edi
801038f8:	89 c8                	mov    %ecx,%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
801038fa:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038fd:	8b 73 18             	mov    0x18(%ebx),%esi
80103900:	b9 13 00 00 00       	mov    $0x13,%ecx
80103905:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103907:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103909:	8b 40 18             	mov    0x18(%eax),%eax
8010390c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103913:	90                   	nop
80103914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103918:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010391c:	85 c0                	test   %eax,%eax
8010391e:	74 0f                	je     8010392f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103920:	89 04 24             	mov    %eax,(%esp)
80103923:	e8 b8 d4 ff ff       	call   80100de0 <filedup>
80103928:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010392b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010392f:	83 c6 01             	add    $0x1,%esi
80103932:	83 fe 10             	cmp    $0x10,%esi
80103935:	75 e1                	jne    80103918 <fork+0x68>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103937:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010393a:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010393d:	89 04 24             	mov    %eax,(%esp)
80103940:	e8 3b dd ff ff       	call   80101680 <idup>
80103945:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103948:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010394b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010394e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103952:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103959:	00 
8010395a:	89 04 24             	mov    %eax,(%esp)
8010395d:	e8 ce 0c 00 00       	call   80104630 <safestrcpy>

  pid = np->pid;
80103962:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103965:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010396c:	e8 1f 0a 00 00       	call   80104390 <acquire>

  np->state = RUNNABLE;
80103971:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103978:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010397f:	e8 7c 0a 00 00       	call   80104400 <release>

  return pid;
80103984:	89 d8                	mov    %ebx,%eax
}
80103986:	83 c4 1c             	add    $0x1c,%esp
80103989:	5b                   	pop    %ebx
8010398a:	5e                   	pop    %esi
8010398b:	5f                   	pop    %edi
8010398c:	5d                   	pop    %ebp
8010398d:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
8010398e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103993:	eb f1                	jmp    80103986 <fork+0xd6>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103995:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103998:	8b 47 08             	mov    0x8(%edi),%eax
8010399b:	89 04 24             	mov    %eax,(%esp)
8010399e:	e8 4d e9 ff ff       	call   801022f0 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
801039a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
801039a8:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
801039af:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
801039b6:	eb ce                	jmp    80103986 <fork+0xd6>
801039b8:	90                   	nop
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039c0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	57                   	push   %edi
  struct proc *p=0;
    struct proc *p1=0;
    struct proc *highP=0;
801039c4:	31 ff                	xor    %edi,%edi
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801039c6:	56                   	push   %esi
801039c7:	53                   	push   %ebx
  struct proc *p=0;
801039c8:	31 db                	xor    %ebx,%ebx
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801039ca:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p=0;
    struct proc *p1=0;
    struct proc *highP=0;
  
  struct cpu *c = mycpu();
801039cd:	e8 8e fc ff ff       	call   80103660 <mycpu>
  c->proc = 0;
801039d2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039d9:	00 00 00 
{
  struct proc *p=0;
    struct proc *p1=0;
    struct proc *highP=0;
  
  struct cpu *c = mycpu();
801039dc:	89 c6                	mov    %eax,%esi
801039de:	8d 40 04             	lea    0x4(%eax),%eax
801039e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static inline void
sti(void)
{
  asm volatile("sti");
801039e4:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();
    
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039e5:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801039ec:	e8 9f 09 00 00       	call   80104390 <acquire>
    if (getPolicy()==2)
801039f1:	83 3d b8 a5 10 80 02 	cmpl   $0x2,0x8010a5b8
801039f8:	75 55                	jne    80103a4f <scheduler+0x8f>
801039fa:	89 fb                	mov    %edi,%ebx
801039fc:	b9 74 2d 11 80       	mov    $0x80112d74,%ecx
80103a01:	eb 13                	jmp    80103a16 <scheduler+0x56>
80103a03:	90                   	nop
80103a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a08:	81 c1 14 02 00 00    	add    $0x214,%ecx
80103a0e:	81 f9 74 b2 11 80    	cmp    $0x8011b274,%ecx
80103a14:	74 37                	je     80103a4d <scheduler+0x8d>
      
      if(p->state != RUNNABLE)
80103a16:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
80103a1a:	75 ec                	jne    80103a08 <scheduler+0x48>
80103a1c:	89 cb                	mov    %ecx,%ebx
80103a1e:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103a23:	eb 11                	jmp    80103a36 <scheduler+0x76>
80103a25:	8d 76 00             	lea    0x0(%esi),%esi
        continue;


      highP=p;

        for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103a28:	81 c2 14 02 00 00    	add    $0x214,%edx
80103a2e:	81 fa 74 b2 11 80    	cmp    $0x8011b274,%edx
80103a34:	74 d2                	je     80103a08 <scheduler+0x48>
          if(p1->state != RUNNABLE)
80103a36:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103a3a:	75 ec                	jne    80103a28 <scheduler+0x68>
80103a3c:	8b 82 10 02 00 00    	mov    0x210(%edx),%eax
80103a42:	39 83 10 02 00 00    	cmp    %eax,0x210(%ebx)
80103a48:	0f 4f da             	cmovg  %edx,%ebx
80103a4b:	eb db                	jmp    80103a28 <scheduler+0x68>
80103a4d:	89 df                	mov    %ebx,%edi
  }

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
     p->calculatedPriority+=p->priority;
80103a4f:	8b 93 0c 02 00 00    	mov    0x20c(%ebx),%edx
80103a55:	01 93 10 02 00 00    	add    %edx,0x210(%ebx)

      c->proc = p;
80103a5b:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a61:	89 1c 24             	mov    %ebx,(%esp)
80103a64:	e8 77 2d 00 00       	call   801067e0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a69:	8b 53 1c             	mov    0x1c(%ebx),%edx
80103a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      // before jumping back to us.
     p->calculatedPriority+=p->priority;

      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a6f:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)

      swtch(&(c->scheduler), p->context);
80103a76:	89 54 24 04          	mov    %edx,0x4(%esp)
80103a7a:	89 04 24             	mov    %eax,(%esp)
80103a7d:	e8 09 0c 00 00       	call   8010468b <swtch>
      switchkvm();
80103a82:	e8 39 2d 00 00       	call   801067c0 <switchkvm>
     

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a87:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a8e:	00 00 00 
    }
80103a91:	e9 4e ff ff ff       	jmp    801039e4 <scheduler+0x24>
80103a96:	8d 76 00             	lea    0x0(%esi),%esi
80103a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103aa0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103aa8:	e8 53 fc ff ff       	call   80103700 <myproc>

  if(!holding(&ptable.lock))
80103aad:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103ab4:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103ab6:	e8 95 08 00 00       	call   80104350 <holding>
80103abb:	85 c0                	test   %eax,%eax
80103abd:	74 4f                	je     80103b0e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103abf:	e8 9c fb ff ff       	call   80103660 <mycpu>
80103ac4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103acb:	75 65                	jne    80103b32 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103acd:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ad1:	74 53                	je     80103b26 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ad3:	9c                   	pushf  
80103ad4:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103ad5:	f6 c4 02             	test   $0x2,%ah
80103ad8:	75 40                	jne    80103b1a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103ada:	e8 81 fb ff ff       	call   80103660 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103adf:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103ae2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ae8:	e8 73 fb ff ff       	call   80103660 <mycpu>
80103aed:	8b 40 04             	mov    0x4(%eax),%eax
80103af0:	89 1c 24             	mov    %ebx,(%esp)
80103af3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103af7:	e8 8f 0b 00 00       	call   8010468b <swtch>
  mycpu()->intena = intena;
80103afc:	e8 5f fb ff ff       	call   80103660 <mycpu>
80103b01:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b07:	83 c4 10             	add    $0x10,%esp
80103b0a:	5b                   	pop    %ebx
80103b0b:	5e                   	pop    %esi
80103b0c:	5d                   	pop    %ebp
80103b0d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b0e:	c7 04 24 f0 73 10 80 	movl   $0x801073f0,(%esp)
80103b15:	e8 46 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b1a:	c7 04 24 1c 74 10 80 	movl   $0x8010741c,(%esp)
80103b21:	e8 3a c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b26:	c7 04 24 0e 74 10 80 	movl   $0x8010740e,(%esp)
80103b2d:	e8 2e c8 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b32:	c7 04 24 02 74 10 80 	movl   $0x80107402,(%esp)
80103b39:	e8 22 c8 ff ff       	call   80100360 <panic>
80103b3e:	66 90                	xchg   %ax,%ax

80103b40 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b44:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b46:	53                   	push   %ebx
80103b47:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b4a:	e8 b1 fb ff ff       	call   80103700 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b4f:	3b 05 bc a5 10 80    	cmp    0x8010a5bc,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103b55:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b57:	0f 84 fd 00 00 00    	je     80103c5a <exit+0x11a>
80103b5d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103b60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b64:	85 c0                	test   %eax,%eax
80103b66:	74 10                	je     80103b78 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b68:	89 04 24             	mov    %eax,(%esp)
80103b6b:	e8 c0 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103b70:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b77:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103b78:	83 c6 01             	add    $0x1,%esi
80103b7b:	83 fe 10             	cmp    $0x10,%esi
80103b7e:	75 e0                	jne    80103b60 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103b80:	e8 8b ef ff ff       	call   80102b10 <begin_op>
  iput(curproc->cwd);
80103b85:	8b 43 68             	mov    0x68(%ebx),%eax
80103b88:	89 04 24             	mov    %eax,(%esp)
80103b8b:	e8 40 dc ff ff       	call   801017d0 <iput>
  end_op();
80103b90:	e8 eb ef ff ff       	call   80102b80 <end_op>
  curproc->cwd = 0;
80103b95:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103b9c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103ba3:	e8 e8 07 00 00       	call   80104390 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103ba8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bab:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103bb0:	eb 14                	jmp    80103bc6 <exit+0x86>
80103bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bb8:	81 c2 14 02 00 00    	add    $0x214,%edx
80103bbe:	81 fa 74 b2 11 80    	cmp    $0x8011b274,%edx
80103bc4:	74 20                	je     80103be6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103bc6:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bca:	75 ec                	jne    80103bb8 <exit+0x78>
80103bcc:	3b 42 20             	cmp    0x20(%edx),%eax
80103bcf:	75 e7                	jne    80103bb8 <exit+0x78>
      p->state = RUNNABLE;
80103bd1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bd8:	81 c2 14 02 00 00    	add    $0x214,%edx
80103bde:	81 fa 74 b2 11 80    	cmp    $0x8011b274,%edx
80103be4:	75 e0                	jne    80103bc6 <exit+0x86>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103be6:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80103beb:	b9 74 2d 11 80       	mov    $0x80112d74,%ecx
80103bf0:	eb 14                	jmp    80103c06 <exit+0xc6>
80103bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bf8:	81 c1 14 02 00 00    	add    $0x214,%ecx
80103bfe:	81 f9 74 b2 11 80    	cmp    $0x8011b274,%ecx
80103c04:	74 3c                	je     80103c42 <exit+0x102>
    if(p->parent == curproc){
80103c06:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103c09:	75 ed                	jne    80103bf8 <exit+0xb8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c0b:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c0f:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103c12:	75 e4                	jne    80103bf8 <exit+0xb8>
80103c14:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103c19:	eb 13                	jmp    80103c2e <exit+0xee>
80103c1b:	90                   	nop
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c20:	81 c2 14 02 00 00    	add    $0x214,%edx
80103c26:	81 fa 74 b2 11 80    	cmp    $0x8011b274,%edx
80103c2c:	74 ca                	je     80103bf8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103c2e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c32:	75 ec                	jne    80103c20 <exit+0xe0>
80103c34:	3b 42 20             	cmp    0x20(%edx),%eax
80103c37:	75 e7                	jne    80103c20 <exit+0xe0>
      p->state = RUNNABLE;
80103c39:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c40:	eb de                	jmp    80103c20 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c42:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103c49:	e8 52 fe ff ff       	call   80103aa0 <sched>
  panic("zombie exit");
80103c4e:	c7 04 24 3d 74 10 80 	movl   $0x8010743d,(%esp)
80103c55:	e8 06 c7 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103c5a:	c7 04 24 30 74 10 80 	movl   $0x80107430,(%esp)
80103c61:	e8 fa c6 ff ff       	call   80100360 <panic>
80103c66:	8d 76 00             	lea    0x0(%esi),%esi
80103c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c70 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c76:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c7d:	e8 0e 07 00 00       	call   80104390 <acquire>
  myproc()->state = RUNNABLE;
80103c82:	e8 79 fa ff ff       	call   80103700 <myproc>
80103c87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c8e:	e8 0d fe ff ff       	call   80103aa0 <sched>
  release(&ptable.lock);
80103c93:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c9a:	e8 61 07 00 00       	call   80104400 <release>
}
80103c9f:	c9                   	leave  
80103ca0:	c3                   	ret    
80103ca1:	eb 0d                	jmp    80103cb0 <sleep>
80103ca3:	90                   	nop
80103ca4:	90                   	nop
80103ca5:	90                   	nop
80103ca6:	90                   	nop
80103ca7:	90                   	nop
80103ca8:	90                   	nop
80103ca9:	90                   	nop
80103caa:	90                   	nop
80103cab:	90                   	nop
80103cac:	90                   	nop
80103cad:	90                   	nop
80103cae:	90                   	nop
80103caf:	90                   	nop

80103cb0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	83 ec 1c             	sub    $0x1c,%esp
80103cb9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103cbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103cbf:	e8 3c fa ff ff       	call   80103700 <myproc>
  
  if(p == 0)
80103cc4:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103cc6:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103cc8:	0f 84 7c 00 00 00    	je     80103d4a <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103cce:	85 f6                	test   %esi,%esi
80103cd0:	74 6c                	je     80103d3e <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103cd2:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
80103cd8:	74 46                	je     80103d20 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103cda:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103ce1:	e8 aa 06 00 00       	call   80104390 <acquire>
    release(lk);
80103ce6:	89 34 24             	mov    %esi,(%esp)
80103ce9:	e8 12 07 00 00       	call   80104400 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103cee:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103cf1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103cf8:	e8 a3 fd ff ff       	call   80103aa0 <sched>

  // Tidy up.
  p->chan = 0;
80103cfd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d04:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103d0b:	e8 f0 06 00 00       	call   80104400 <release>
    acquire(lk);
80103d10:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103d13:	83 c4 1c             	add    $0x1c,%esp
80103d16:	5b                   	pop    %ebx
80103d17:	5e                   	pop    %esi
80103d18:	5f                   	pop    %edi
80103d19:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d1a:	e9 71 06 00 00       	jmp    80104390 <acquire>
80103d1f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d20:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103d23:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103d2a:	e8 71 fd ff ff       	call   80103aa0 <sched>

  // Tidy up.
  p->chan = 0;
80103d2f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d36:	83 c4 1c             	add    $0x1c,%esp
80103d39:	5b                   	pop    %ebx
80103d3a:	5e                   	pop    %esi
80103d3b:	5f                   	pop    %edi
80103d3c:	5d                   	pop    %ebp
80103d3d:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d3e:	c7 04 24 4f 74 10 80 	movl   $0x8010744f,(%esp)
80103d45:	e8 16 c6 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103d4a:	c7 04 24 49 74 10 80 	movl   $0x80107449,(%esp)
80103d51:	e8 0a c6 ff ff       	call   80100360 <panic>
80103d56:	8d 76 00             	lea    0x0(%esi),%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d60 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	56                   	push   %esi
80103d64:	53                   	push   %ebx
80103d65:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d68:	e8 93 f9 ff ff       	call   80103700 <myproc>
  
  acquire(&ptable.lock);
80103d6d:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d74:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103d76:	e8 15 06 00 00       	call   80104390 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103d7b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d7d:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80103d82:	eb 12                	jmp    80103d96 <wait+0x36>
80103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d88:	81 c3 14 02 00 00    	add    $0x214,%ebx
80103d8e:	81 fb 74 b2 11 80    	cmp    $0x8011b274,%ebx
80103d94:	74 22                	je     80103db8 <wait+0x58>
      if(p->parent != curproc)
80103d96:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d99:	75 ed                	jne    80103d88 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103d9b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d9f:	74 34                	je     80103dd5 <wait+0x75>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da1:	81 c3 14 02 00 00    	add    $0x214,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103da7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dac:	81 fb 74 b2 11 80    	cmp    $0x8011b274,%ebx
80103db2:	75 e2                	jne    80103d96 <wait+0x36>
80103db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103db8:	85 c0                	test   %eax,%eax
80103dba:	74 6e                	je     80103e2a <wait+0xca>
80103dbc:	8b 46 24             	mov    0x24(%esi),%eax
80103dbf:	85 c0                	test   %eax,%eax
80103dc1:	75 67                	jne    80103e2a <wait+0xca>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103dc3:	c7 44 24 04 40 2d 11 	movl   $0x80112d40,0x4(%esp)
80103dca:	80 
80103dcb:	89 34 24             	mov    %esi,(%esp)
80103dce:	e8 dd fe ff ff       	call   80103cb0 <sleep>
  }
80103dd3:	eb a6                	jmp    80103d7b <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103dd5:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103dd8:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103ddb:	89 04 24             	mov    %eax,(%esp)
80103dde:	e8 0d e5 ff ff       	call   801022f0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103de3:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103de6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ded:	89 04 24             	mov    %eax,(%esp)
80103df0:	e8 4b 2d 00 00       	call   80106b40 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103df5:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103dfc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e03:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e0a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e0e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e15:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e1c:	e8 df 05 00 00       	call   80104400 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e21:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e24:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e26:	5b                   	pop    %ebx
80103e27:	5e                   	pop    %esi
80103e28:	5d                   	pop    %ebp
80103e29:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e2a:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e31:	e8 ca 05 00 00       	call   80104400 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e36:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e3e:	5b                   	pop    %ebx
80103e3f:	5e                   	pop    %esi
80103e40:	5d                   	pop    %ebp
80103e41:	c3                   	ret    
80103e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e50 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 14             	sub    $0x14,%esp
80103e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e5a:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e61:	e8 2a 05 00 00       	call   80104390 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e66:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103e6b:	eb 0f                	jmp    80103e7c <wakeup+0x2c>
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
80103e70:	05 14 02 00 00       	add    $0x214,%eax
80103e75:	3d 74 b2 11 80       	cmp    $0x8011b274,%eax
80103e7a:	74 24                	je     80103ea0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103e7c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e80:	75 ee                	jne    80103e70 <wakeup+0x20>
80103e82:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e85:	75 e9                	jne    80103e70 <wakeup+0x20>
      p->state = RUNNABLE;
80103e87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e8e:	05 14 02 00 00       	add    $0x214,%eax
80103e93:	3d 74 b2 11 80       	cmp    $0x8011b274,%eax
80103e98:	75 e2                	jne    80103e7c <wakeup+0x2c>
80103e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ea0:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
80103ea7:	83 c4 14             	add    $0x14,%esp
80103eaa:	5b                   	pop    %ebx
80103eab:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103eac:	e9 4f 05 00 00       	jmp    80104400 <release>
80103eb1:	eb 0d                	jmp    80103ec0 <kill>
80103eb3:	90                   	nop
80103eb4:	90                   	nop
80103eb5:	90                   	nop
80103eb6:	90                   	nop
80103eb7:	90                   	nop
80103eb8:	90                   	nop
80103eb9:	90                   	nop
80103eba:	90                   	nop
80103ebb:	90                   	nop
80103ebc:	90                   	nop
80103ebd:	90                   	nop
80103ebe:	90                   	nop
80103ebf:	90                   	nop

80103ec0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	53                   	push   %ebx
80103ec4:	83 ec 14             	sub    $0x14,%esp
80103ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103eca:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103ed1:	e8 ba 04 00 00       	call   80104390 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed6:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103edb:	eb 0f                	jmp    80103eec <kill+0x2c>
80103edd:	8d 76 00             	lea    0x0(%esi),%esi
80103ee0:	05 14 02 00 00       	add    $0x214,%eax
80103ee5:	3d 74 b2 11 80       	cmp    $0x8011b274,%eax
80103eea:	74 3c                	je     80103f28 <kill+0x68>
    if(p->pid == pid){
80103eec:	39 58 10             	cmp    %ebx,0x10(%eax)
80103eef:	75 ef                	jne    80103ee0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103ef1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103ef5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103efc:	74 1a                	je     80103f18 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103efe:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103f05:	e8 f6 04 00 00       	call   80104400 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f0a:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103f0d:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f0f:	5b                   	pop    %ebx
80103f10:	5d                   	pop    %ebp
80103f11:	c3                   	ret    
80103f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f18:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f1f:	eb dd                	jmp    80103efe <kill+0x3e>
80103f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f28:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103f2f:	e8 cc 04 00 00       	call   80104400 <release>
  return -1;
}
80103f34:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f3c:	5b                   	pop    %ebx
80103f3d:	5d                   	pop    %ebp
80103f3e:	c3                   	ret    
80103f3f:	90                   	nop

80103f40 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	57                   	push   %edi
80103f44:	56                   	push   %esi
80103f45:	53                   	push   %ebx
80103f46:	bb e0 2d 11 80       	mov    $0x80112de0,%ebx
80103f4b:	83 ec 4c             	sub    $0x4c,%esp
80103f4e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103f51:	eb 23                	jmp    80103f76 <procdump+0x36>
80103f53:	90                   	nop
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f58:	c7 04 24 ff 77 10 80 	movl   $0x801077ff,(%esp)
80103f5f:	e8 ec c6 ff ff       	call   80100650 <cprintf>
80103f64:	81 c3 14 02 00 00    	add    $0x214,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6a:	81 fb e0 b2 11 80    	cmp    $0x8011b2e0,%ebx
80103f70:	0f 84 8a 00 00 00    	je     80104000 <procdump+0xc0>
    if(p->state == UNUSED)
80103f76:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f79:	85 c0                	test   %eax,%eax
80103f7b:	74 e7                	je     80103f64 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f7d:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103f80:	ba 60 74 10 80       	mov    $0x80107460,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f85:	77 11                	ja     80103f98 <procdump+0x58>
80103f87:	8b 14 85 c0 74 10 80 	mov    -0x7fef8b40(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103f8e:	b8 60 74 10 80       	mov    $0x80107460,%eax
80103f93:	85 d2                	test   %edx,%edx
80103f95:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f98:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f9f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103fa3:	c7 04 24 64 74 10 80 	movl   $0x80107464,(%esp)
80103faa:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fae:	e8 9d c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103fb3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103fb7:	75 9f                	jne    80103f58 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103fb9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fc0:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103fc3:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103fc6:	8b 40 0c             	mov    0xc(%eax),%eax
80103fc9:	83 c0 08             	add    $0x8,%eax
80103fcc:	89 04 24             	mov    %eax,(%esp)
80103fcf:	e8 6c 02 00 00       	call   80104240 <getcallerpcs>
80103fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103fd8:	8b 17                	mov    (%edi),%edx
80103fda:	85 d2                	test   %edx,%edx
80103fdc:	0f 84 76 ff ff ff    	je     80103f58 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103fe2:	89 54 24 04          	mov    %edx,0x4(%esp)
80103fe6:	83 c7 04             	add    $0x4,%edi
80103fe9:	c7 04 24 a1 6e 10 80 	movl   $0x80106ea1,(%esp)
80103ff0:	e8 5b c6 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103ff5:	39 f7                	cmp    %esi,%edi
80103ff7:	75 df                	jne    80103fd8 <procdump+0x98>
80103ff9:	e9 5a ff ff ff       	jmp    80103f58 <procdump+0x18>
80103ffe:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104000:	83 c4 4c             	add    $0x4c,%esp
80104003:	5b                   	pop    %ebx
80104004:	5e                   	pop    %esi
80104005:	5f                   	pop    %edi
80104006:	5d                   	pop    %ebp
80104007:	c3                   	ret    
80104008:	90                   	nop
80104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104010 <getppid>:

int getppid(void){
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	83 ec 08             	sub    $0x8,%esp
	return myproc()->parent->pid;
80104016:	e8 e5 f6 ff ff       	call   80103700 <myproc>
8010401b:	8b 40 14             	mov    0x14(%eax),%eax
8010401e:	8b 40 10             	mov    0x10(%eax),%eax
}
80104021:	c9                   	leave  
80104022:	c3                   	ret    
80104023:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104030 <getChildren>:

int 
getChildren(int procId){
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	56                   	push   %esi
  struct proc *p;
  int childrens=0;
80104034:	31 f6                	xor    %esi,%esi
int getppid(void){
	return myproc()->parent->pid;
}

int 
getChildren(int procId){
80104036:	53                   	push   %ebx
80104037:	83 ec 10             	sub    $0x10,%esp
8010403a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int childrens=0;

acquire(&ptable.lock);
8010403d:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104044:	e8 47 03 00 00       	call   80104390 <acquire>

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104049:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
8010404e:	eb 0e                	jmp    8010405e <getChildren+0x2e>
80104050:	81 c2 14 02 00 00    	add    $0x214,%edx
80104056:	81 fa 74 b2 11 80    	cmp    $0x8011b274,%edx
8010405c:	74 21                	je     8010407f <getChildren+0x4f>
      if(p->parent->pid==procId){
8010405e:	8b 4a 14             	mov    0x14(%edx),%ecx
80104061:	39 59 10             	cmp    %ebx,0x10(%ecx)
80104064:	75 ea                	jne    80104050 <getChildren+0x20>
        childrens=(childrens*10)+(p->pid*10);
80104066:	8b 42 10             	mov    0x10(%edx),%eax
  struct proc *p;
  int childrens=0;

acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104069:	81 c2 14 02 00 00    	add    $0x214,%edx
      if(p->parent->pid==procId){
        childrens=(childrens*10)+(p->pid*10);
8010406f:	01 f0                	add    %esi,%eax
  struct proc *p;
  int childrens=0;

acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104071:	81 fa 74 b2 11 80    	cmp    $0x8011b274,%edx
      if(p->parent->pid==procId){
        childrens=(childrens*10)+(p->pid*10);
80104077:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010407a:	8d 34 00             	lea    (%eax,%eax,1),%esi
  struct proc *p;
  int childrens=0;

acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407d:	75 df                	jne    8010405e <getChildren+0x2e>
      if(p->parent->pid==procId){
        childrens=(childrens*10)+(p->pid*10);
      }
    }
      release(&ptable.lock);
8010407f:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104086:	e8 75 03 00 00       	call   80104400 <release>

  return childrens;
}
8010408b:	83 c4 10             	add    $0x10,%esp
8010408e:	89 f0                	mov    %esi,%eax
80104090:	5b                   	pop    %ebx
80104091:	5e                   	pop    %esi
80104092:	5d                   	pop    %ebp
80104093:	c3                   	ret    
80104094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010409a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801040a0 <getCount>:


int 
getCount(int sysNum){
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	83 ec 08             	sub    $0x8,%esp
 
  return myproc()->arraySys[sysNum];
801040a6:	e8 55 f6 ff ff       	call   80103700 <myproc>
801040ab:	8b 55 08             	mov    0x8(%ebp),%edx
801040ae:	8b 44 90 7c          	mov    0x7c(%eax,%edx,4),%eax

}
801040b2:	c9                   	leave  
801040b3:	c3                   	ret    
801040b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801040c0 <setPolicy>:
 
 int 
 setPolicy(int policyNum){
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
	policy=policyNum;
801040c3:	8b 45 08             	mov    0x8(%ebp),%eax
  return 1;
 }
801040c6:	5d                   	pop    %ebp

}
 
 int 
 setPolicy(int policyNum){
	policy=policyNum;
801040c7:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  return 1;
 }
801040cc:	b8 01 00 00 00       	mov    $0x1,%eax
801040d1:	c3                   	ret    
801040d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040e0 <getPolicy>:

int
getPolicy(){
801040e0:	55                   	push   %ebp
	return policy;
}
801040e1:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
	policy=policyNum;
  return 1;
 }

int
getPolicy(){
801040e6:	89 e5                	mov    %esp,%ebp
	return policy;
}
801040e8:	5d                   	pop    %ebp
801040e9:	c3                   	ret    
801040ea:	66 90                	xchg   %ax,%ax
801040ec:	66 90                	xchg   %ax,%ax
801040ee:	66 90                	xchg   %ax,%ax

801040f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 14             	sub    $0x14,%esp
801040f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801040fa:	c7 44 24 04 d8 74 10 	movl   $0x801074d8,0x4(%esp)
80104101:	80 
80104102:	8d 43 04             	lea    0x4(%ebx),%eax
80104105:	89 04 24             	mov    %eax,(%esp)
80104108:	e8 13 01 00 00       	call   80104220 <initlock>
  lk->name = name;
8010410d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104110:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104116:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010411d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104120:	83 c4 14             	add    $0x14,%esp
80104123:	5b                   	pop    %ebx
80104124:	5d                   	pop    %ebp
80104125:	c3                   	ret    
80104126:	8d 76 00             	lea    0x0(%esi),%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104130 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	56                   	push   %esi
80104134:	53                   	push   %ebx
80104135:	83 ec 10             	sub    $0x10,%esp
80104138:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010413b:	8d 73 04             	lea    0x4(%ebx),%esi
8010413e:	89 34 24             	mov    %esi,(%esp)
80104141:	e8 4a 02 00 00       	call   80104390 <acquire>
  while (lk->locked) {
80104146:	8b 13                	mov    (%ebx),%edx
80104148:	85 d2                	test   %edx,%edx
8010414a:	74 16                	je     80104162 <acquiresleep+0x32>
8010414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104150:	89 74 24 04          	mov    %esi,0x4(%esp)
80104154:	89 1c 24             	mov    %ebx,(%esp)
80104157:	e8 54 fb ff ff       	call   80103cb0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010415c:	8b 03                	mov    (%ebx),%eax
8010415e:	85 c0                	test   %eax,%eax
80104160:	75 ee                	jne    80104150 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104162:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104168:	e8 93 f5 ff ff       	call   80103700 <myproc>
8010416d:	8b 40 10             	mov    0x10(%eax),%eax
80104170:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104173:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104176:	83 c4 10             	add    $0x10,%esp
80104179:	5b                   	pop    %ebx
8010417a:	5e                   	pop    %esi
8010417b:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010417c:	e9 7f 02 00 00       	jmp    80104400 <release>
80104181:	eb 0d                	jmp    80104190 <releasesleep>
80104183:	90                   	nop
80104184:	90                   	nop
80104185:	90                   	nop
80104186:	90                   	nop
80104187:	90                   	nop
80104188:	90                   	nop
80104189:	90                   	nop
8010418a:	90                   	nop
8010418b:	90                   	nop
8010418c:	90                   	nop
8010418d:	90                   	nop
8010418e:	90                   	nop
8010418f:	90                   	nop

80104190 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
80104195:	83 ec 10             	sub    $0x10,%esp
80104198:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010419b:	8d 73 04             	lea    0x4(%ebx),%esi
8010419e:	89 34 24             	mov    %esi,(%esp)
801041a1:	e8 ea 01 00 00       	call   80104390 <acquire>
  lk->locked = 0;
801041a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801041ac:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801041b3:	89 1c 24             	mov    %ebx,(%esp)
801041b6:	e8 95 fc ff ff       	call   80103e50 <wakeup>
  release(&lk->lk);
801041bb:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041be:	83 c4 10             	add    $0x10,%esp
801041c1:	5b                   	pop    %ebx
801041c2:	5e                   	pop    %esi
801041c3:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801041c4:	e9 37 02 00 00       	jmp    80104400 <release>
801041c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041d0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
801041d4:	31 ff                	xor    %edi,%edi
  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
801041d6:	56                   	push   %esi
801041d7:	53                   	push   %ebx
801041d8:	83 ec 1c             	sub    $0x1c,%esp
801041db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801041de:	8d 73 04             	lea    0x4(%ebx),%esi
801041e1:	89 34 24             	mov    %esi,(%esp)
801041e4:	e8 a7 01 00 00       	call   80104390 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801041e9:	8b 03                	mov    (%ebx),%eax
801041eb:	85 c0                	test   %eax,%eax
801041ed:	74 13                	je     80104202 <holdingsleep+0x32>
801041ef:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801041f2:	e8 09 f5 ff ff       	call   80103700 <myproc>
801041f7:	3b 58 10             	cmp    0x10(%eax),%ebx
801041fa:	0f 94 c0             	sete   %al
801041fd:	0f b6 c0             	movzbl %al,%eax
80104200:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104202:	89 34 24             	mov    %esi,(%esp)
80104205:	e8 f6 01 00 00       	call   80104400 <release>
  return r;
}
8010420a:	83 c4 1c             	add    $0x1c,%esp
8010420d:	89 f8                	mov    %edi,%eax
8010420f:	5b                   	pop    %ebx
80104210:	5e                   	pop    %esi
80104211:	5f                   	pop    %edi
80104212:	5d                   	pop    %ebp
80104213:	c3                   	ret    
80104214:	66 90                	xchg   %ax,%ax
80104216:	66 90                	xchg   %ax,%ax
80104218:	66 90                	xchg   %ax,%ax
8010421a:	66 90                	xchg   %ax,%ax
8010421c:	66 90                	xchg   %ax,%ax
8010421e:	66 90                	xchg   %ax,%ax

80104220 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104226:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010422f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104232:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104239:	5d                   	pop    %ebp
8010423a:	c3                   	ret    
8010423b:	90                   	nop
8010423c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104240 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104243:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104246:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104249:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010424a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010424d:	31 c0                	xor    %eax,%eax
8010424f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104250:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104256:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010425c:	77 1a                	ja     80104278 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010425e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104261:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104264:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104267:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104269:	83 f8 0a             	cmp    $0xa,%eax
8010426c:	75 e2                	jne    80104250 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010426e:	5b                   	pop    %ebx
8010426f:	5d                   	pop    %ebp
80104270:	c3                   	ret    
80104271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104278:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010427f:	83 c0 01             	add    $0x1,%eax
80104282:	83 f8 0a             	cmp    $0xa,%eax
80104285:	74 e7                	je     8010426e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104287:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010428e:	83 c0 01             	add    $0x1,%eax
80104291:	83 f8 0a             	cmp    $0xa,%eax
80104294:	75 e2                	jne    80104278 <getcallerpcs+0x38>
80104296:	eb d6                	jmp    8010426e <getcallerpcs+0x2e>
80104298:	90                   	nop
80104299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 04             	sub    $0x4,%esp
801042a7:	9c                   	pushf  
801042a8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801042a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801042aa:	e8 b1 f3 ff ff       	call   80103660 <mycpu>
801042af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801042b5:	85 c0                	test   %eax,%eax
801042b7:	75 11                	jne    801042ca <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801042b9:	e8 a2 f3 ff ff       	call   80103660 <mycpu>
801042be:	81 e3 00 02 00 00    	and    $0x200,%ebx
801042c4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801042ca:	e8 91 f3 ff ff       	call   80103660 <mycpu>
801042cf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801042d6:	83 c4 04             	add    $0x4,%esp
801042d9:	5b                   	pop    %ebx
801042da:	5d                   	pop    %ebp
801042db:	c3                   	ret    
801042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042e0 <popcli>:

void
popcli(void)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042e6:	9c                   	pushf  
801042e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042e8:	f6 c4 02             	test   $0x2,%ah
801042eb:	75 49                	jne    80104336 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801042ed:	e8 6e f3 ff ff       	call   80103660 <mycpu>
801042f2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801042f8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801042fb:	85 d2                	test   %edx,%edx
801042fd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104303:	78 25                	js     8010432a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104305:	e8 56 f3 ff ff       	call   80103660 <mycpu>
8010430a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104310:	85 d2                	test   %edx,%edx
80104312:	74 04                	je     80104318 <popcli+0x38>
    sti();
}
80104314:	c9                   	leave  
80104315:	c3                   	ret    
80104316:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104318:	e8 43 f3 ff ff       	call   80103660 <mycpu>
8010431d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104323:	85 c0                	test   %eax,%eax
80104325:	74 ed                	je     80104314 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104327:	fb                   	sti    
    sti();
}
80104328:	c9                   	leave  
80104329:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010432a:	c7 04 24 fa 74 10 80 	movl   $0x801074fa,(%esp)
80104331:	e8 2a c0 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104336:	c7 04 24 e3 74 10 80 	movl   $0x801074e3,(%esp)
8010433d:	e8 1e c0 ff ff       	call   80100360 <panic>
80104342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104350 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
  int r;
  pushcli();
  r = lock->locked && lock->cpu == mycpu();
80104354:	31 f6                	xor    %esi,%esi
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104356:	53                   	push   %ebx
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  pushcli();
8010435a:	e8 41 ff ff ff       	call   801042a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010435f:	8b 03                	mov    (%ebx),%eax
80104361:	85 c0                	test   %eax,%eax
80104363:	74 12                	je     80104377 <holding+0x27>
80104365:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104368:	e8 f3 f2 ff ff       	call   80103660 <mycpu>
8010436d:	39 c3                	cmp    %eax,%ebx
8010436f:	0f 94 c0             	sete   %al
80104372:	0f b6 c0             	movzbl %al,%eax
80104375:	89 c6                	mov    %eax,%esi
  popcli();
80104377:	e8 64 ff ff ff       	call   801042e0 <popcli>
  return r;
}
8010437c:	89 f0                	mov    %esi,%eax
8010437e:	5b                   	pop    %ebx
8010437f:	5e                   	pop    %esi
80104380:	5d                   	pop    %ebp
80104381:	c3                   	ret    
80104382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104390 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104397:	e8 04 ff ff ff       	call   801042a0 <pushcli>
  if(holding(lk))
8010439c:	8b 45 08             	mov    0x8(%ebp),%eax
8010439f:	89 04 24             	mov    %eax,(%esp)
801043a2:	e8 a9 ff ff ff       	call   80104350 <holding>
801043a7:	85 c0                	test   %eax,%eax
801043a9:	75 3c                	jne    801043e7 <acquire+0x57>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801043ab:	b9 01 00 00 00       	mov    $0x1,%ecx
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801043b0:	8b 55 08             	mov    0x8(%ebp),%edx
801043b3:	89 c8                	mov    %ecx,%eax
801043b5:	f0 87 02             	lock xchg %eax,(%edx)
801043b8:	85 c0                	test   %eax,%eax
801043ba:	75 f4                	jne    801043b0 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801043bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801043c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043c4:	e8 97 f2 ff ff       	call   80103660 <mycpu>
801043c9:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801043cc:	8b 45 08             	mov    0x8(%ebp),%eax
801043cf:	83 c0 0c             	add    $0xc,%eax
801043d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801043d6:	8d 45 08             	lea    0x8(%ebp),%eax
801043d9:	89 04 24             	mov    %eax,(%esp)
801043dc:	e8 5f fe ff ff       	call   80104240 <getcallerpcs>
}
801043e1:	83 c4 14             	add    $0x14,%esp
801043e4:	5b                   	pop    %ebx
801043e5:	5d                   	pop    %ebp
801043e6:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801043e7:	c7 04 24 01 75 10 80 	movl   $0x80107501,(%esp)
801043ee:	e8 6d bf ff ff       	call   80100360 <panic>
801043f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104400 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 14             	sub    $0x14,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010440a:	89 1c 24             	mov    %ebx,(%esp)
8010440d:	e8 3e ff ff ff       	call   80104350 <holding>
80104412:	85 c0                	test   %eax,%eax
80104414:	74 23                	je     80104439 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104416:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010441d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104424:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104429:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
8010442f:	83 c4 14             	add    $0x14,%esp
80104432:	5b                   	pop    %ebx
80104433:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104434:	e9 a7 fe ff ff       	jmp    801042e0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104439:	c7 04 24 09 75 10 80 	movl   $0x80107509,(%esp)
80104440:	e8 1b bf ff ff       	call   80100360 <panic>
80104445:	66 90                	xchg   %ax,%ax
80104447:	66 90                	xchg   %ax,%ax
80104449:	66 90                	xchg   %ax,%ax
8010444b:	66 90                	xchg   %ax,%ax
8010444d:	66 90                	xchg   %ax,%ax
8010444f:	90                   	nop

80104450 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	8b 55 08             	mov    0x8(%ebp),%edx
80104456:	57                   	push   %edi
80104457:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010445a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010445b:	f6 c2 03             	test   $0x3,%dl
8010445e:	75 05                	jne    80104465 <memset+0x15>
80104460:	f6 c1 03             	test   $0x3,%cl
80104463:	74 13                	je     80104478 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104465:	89 d7                	mov    %edx,%edi
80104467:	8b 45 0c             	mov    0xc(%ebp),%eax
8010446a:	fc                   	cld    
8010446b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010446d:	5b                   	pop    %ebx
8010446e:	89 d0                	mov    %edx,%eax
80104470:	5f                   	pop    %edi
80104471:	5d                   	pop    %ebp
80104472:	c3                   	ret    
80104473:	90                   	nop
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104478:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010447c:	c1 e9 02             	shr    $0x2,%ecx
8010447f:	89 f8                	mov    %edi,%eax
80104481:	89 fb                	mov    %edi,%ebx
80104483:	c1 e0 18             	shl    $0x18,%eax
80104486:	c1 e3 10             	shl    $0x10,%ebx
80104489:	09 d8                	or     %ebx,%eax
8010448b:	09 f8                	or     %edi,%eax
8010448d:	c1 e7 08             	shl    $0x8,%edi
80104490:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104492:	89 d7                	mov    %edx,%edi
80104494:	fc                   	cld    
80104495:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104497:	5b                   	pop    %ebx
80104498:	89 d0                	mov    %edx,%eax
8010449a:	5f                   	pop    %edi
8010449b:	5d                   	pop    %ebp
8010449c:	c3                   	ret    
8010449d:	8d 76 00             	lea    0x0(%esi),%esi

801044a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	8b 45 10             	mov    0x10(%ebp),%eax
801044a6:	57                   	push   %edi
801044a7:	56                   	push   %esi
801044a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044ab:	53                   	push   %ebx
801044ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044af:	85 c0                	test   %eax,%eax
801044b1:	8d 78 ff             	lea    -0x1(%eax),%edi
801044b4:	74 26                	je     801044dc <memcmp+0x3c>
    if(*s1 != *s2)
801044b6:	0f b6 03             	movzbl (%ebx),%eax
801044b9:	31 d2                	xor    %edx,%edx
801044bb:	0f b6 0e             	movzbl (%esi),%ecx
801044be:	38 c8                	cmp    %cl,%al
801044c0:	74 16                	je     801044d8 <memcmp+0x38>
801044c2:	eb 24                	jmp    801044e8 <memcmp+0x48>
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801044cd:	83 c2 01             	add    $0x1,%edx
801044d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044d4:	38 c8                	cmp    %cl,%al
801044d6:	75 10                	jne    801044e8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044d8:	39 fa                	cmp    %edi,%edx
801044da:	75 ec                	jne    801044c8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801044dc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801044dd:	31 c0                	xor    %eax,%eax
}
801044df:	5e                   	pop    %esi
801044e0:	5f                   	pop    %edi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret    
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e8:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801044e9:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801044eb:	5e                   	pop    %esi
801044ec:	5f                   	pop    %edi
801044ed:	5d                   	pop    %ebp
801044ee:	c3                   	ret    
801044ef:	90                   	nop

801044f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	8b 45 08             	mov    0x8(%ebp),%eax
801044f7:	56                   	push   %esi
801044f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044fb:	53                   	push   %ebx
801044fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801044ff:	39 c6                	cmp    %eax,%esi
80104501:	73 35                	jae    80104538 <memmove+0x48>
80104503:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104506:	39 c8                	cmp    %ecx,%eax
80104508:	73 2e                	jae    80104538 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010450a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010450c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010450f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104512:	74 1b                	je     8010452f <memmove+0x3f>
80104514:	f7 db                	neg    %ebx
80104516:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104519:	01 fb                	add    %edi,%ebx
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104520:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104524:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104527:	83 ea 01             	sub    $0x1,%edx
8010452a:	83 fa ff             	cmp    $0xffffffff,%edx
8010452d:	75 f1                	jne    80104520 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010452f:	5b                   	pop    %ebx
80104530:	5e                   	pop    %esi
80104531:	5f                   	pop    %edi
80104532:	5d                   	pop    %ebp
80104533:	c3                   	ret    
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104538:	31 d2                	xor    %edx,%edx
8010453a:	85 db                	test   %ebx,%ebx
8010453c:	74 f1                	je     8010452f <memmove+0x3f>
8010453e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104540:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104544:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104547:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010454a:	39 da                	cmp    %ebx,%edx
8010454c:	75 f2                	jne    80104540 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010454e:	5b                   	pop    %ebx
8010454f:	5e                   	pop    %esi
80104550:	5f                   	pop    %edi
80104551:	5d                   	pop    %ebp
80104552:	c3                   	ret    
80104553:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104563:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104564:	e9 87 ff ff ff       	jmp    801044f0 <memmove>
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104570 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	8b 75 10             	mov    0x10(%ebp),%esi
80104577:	53                   	push   %ebx
80104578:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010457b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010457e:	85 f6                	test   %esi,%esi
80104580:	74 30                	je     801045b2 <strncmp+0x42>
80104582:	0f b6 01             	movzbl (%ecx),%eax
80104585:	84 c0                	test   %al,%al
80104587:	74 2f                	je     801045b8 <strncmp+0x48>
80104589:	0f b6 13             	movzbl (%ebx),%edx
8010458c:	38 d0                	cmp    %dl,%al
8010458e:	75 46                	jne    801045d6 <strncmp+0x66>
80104590:	8d 51 01             	lea    0x1(%ecx),%edx
80104593:	01 ce                	add    %ecx,%esi
80104595:	eb 14                	jmp    801045ab <strncmp+0x3b>
80104597:	90                   	nop
80104598:	0f b6 02             	movzbl (%edx),%eax
8010459b:	84 c0                	test   %al,%al
8010459d:	74 31                	je     801045d0 <strncmp+0x60>
8010459f:	0f b6 19             	movzbl (%ecx),%ebx
801045a2:	83 c2 01             	add    $0x1,%edx
801045a5:	38 d8                	cmp    %bl,%al
801045a7:	75 17                	jne    801045c0 <strncmp+0x50>
    n--, p++, q++;
801045a9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045ab:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801045ad:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045b0:	75 e6                	jne    80104598 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801045b2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801045b3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801045b5:	5e                   	pop    %esi
801045b6:	5d                   	pop    %ebp
801045b7:	c3                   	ret    
801045b8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045bb:	31 c0                	xor    %eax,%eax
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801045c0:	0f b6 d3             	movzbl %bl,%edx
801045c3:	29 d0                	sub    %edx,%eax
}
801045c5:	5b                   	pop    %ebx
801045c6:	5e                   	pop    %esi
801045c7:	5d                   	pop    %ebp
801045c8:	c3                   	ret    
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801045d4:	eb ea                	jmp    801045c0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045d6:	89 d3                	mov    %edx,%ebx
801045d8:	eb e6                	jmp    801045c0 <strncmp+0x50>
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	8b 45 08             	mov    0x8(%ebp),%eax
801045e6:	56                   	push   %esi
801045e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045ea:	53                   	push   %ebx
801045eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801045ee:	89 c2                	mov    %eax,%edx
801045f0:	eb 19                	jmp    8010460b <strncpy+0x2b>
801045f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045f8:	83 c3 01             	add    $0x1,%ebx
801045fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801045ff:	83 c2 01             	add    $0x1,%edx
80104602:	84 c9                	test   %cl,%cl
80104604:	88 4a ff             	mov    %cl,-0x1(%edx)
80104607:	74 09                	je     80104612 <strncpy+0x32>
80104609:	89 f1                	mov    %esi,%ecx
8010460b:	85 c9                	test   %ecx,%ecx
8010460d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104610:	7f e6                	jg     801045f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104612:	31 c9                	xor    %ecx,%ecx
80104614:	85 f6                	test   %esi,%esi
80104616:	7e 0f                	jle    80104627 <strncpy+0x47>
    *s++ = 0;
80104618:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010461c:	89 f3                	mov    %esi,%ebx
8010461e:	83 c1 01             	add    $0x1,%ecx
80104621:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104623:	85 db                	test   %ebx,%ebx
80104625:	7f f1                	jg     80104618 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104627:	5b                   	pop    %ebx
80104628:	5e                   	pop    %esi
80104629:	5d                   	pop    %ebp
8010462a:	c3                   	ret    
8010462b:	90                   	nop
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104636:	56                   	push   %esi
80104637:	8b 45 08             	mov    0x8(%ebp),%eax
8010463a:	53                   	push   %ebx
8010463b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010463e:	85 c9                	test   %ecx,%ecx
80104640:	7e 26                	jle    80104668 <safestrcpy+0x38>
80104642:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104646:	89 c1                	mov    %eax,%ecx
80104648:	eb 17                	jmp    80104661 <safestrcpy+0x31>
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104650:	83 c2 01             	add    $0x1,%edx
80104653:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104657:	83 c1 01             	add    $0x1,%ecx
8010465a:	84 db                	test   %bl,%bl
8010465c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010465f:	74 04                	je     80104665 <safestrcpy+0x35>
80104661:	39 f2                	cmp    %esi,%edx
80104663:	75 eb                	jne    80104650 <safestrcpy+0x20>
    ;
  *s = 0;
80104665:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104668:	5b                   	pop    %ebx
80104669:	5e                   	pop    %esi
8010466a:	5d                   	pop    %ebp
8010466b:	c3                   	ret    
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104670 <strlen>:

int
strlen(const char *s)
{
80104670:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104671:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104673:	89 e5                	mov    %esp,%ebp
80104675:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104678:	80 3a 00             	cmpb   $0x0,(%edx)
8010467b:	74 0c                	je     80104689 <strlen+0x19>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
80104680:	83 c0 01             	add    $0x1,%eax
80104683:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104687:	75 f7                	jne    80104680 <strlen+0x10>
    ;
  return n;
}
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret    

8010468b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010468b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010468f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104693:	55                   	push   %ebp
  pushl %ebx
80104694:	53                   	push   %ebx
  pushl %esi
80104695:	56                   	push   %esi
  pushl %edi
80104696:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104697:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104699:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010469b:	5f                   	pop    %edi
  popl %esi
8010469c:	5e                   	pop    %esi
  popl %ebx
8010469d:	5b                   	pop    %ebx
  popl %ebp
8010469e:	5d                   	pop    %ebp
  ret
8010469f:	c3                   	ret    

801046a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 04             	sub    $0x4,%esp
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801046aa:	e8 51 f0 ff ff       	call   80103700 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801046af:	8b 00                	mov    (%eax),%eax
801046b1:	39 d8                	cmp    %ebx,%eax
801046b3:	76 1b                	jbe    801046d0 <fetchint+0x30>
801046b5:	8d 53 04             	lea    0x4(%ebx),%edx
801046b8:	39 d0                	cmp    %edx,%eax
801046ba:	72 14                	jb     801046d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801046bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801046bf:	8b 13                	mov    (%ebx),%edx
801046c1:	89 10                	mov    %edx,(%eax)
  return 0;
801046c3:	31 c0                	xor    %eax,%eax
}
801046c5:	83 c4 04             	add    $0x4,%esp
801046c8:	5b                   	pop    %ebx
801046c9:	5d                   	pop    %ebp
801046ca:	c3                   	ret    
801046cb:	90                   	nop
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801046d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d5:	eb ee                	jmp    801046c5 <fetchint+0x25>
801046d7:	89 f6                	mov    %esi,%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	83 ec 04             	sub    $0x4,%esp
801046e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801046ea:	e8 11 f0 ff ff       	call   80103700 <myproc>

  if(addr >= curproc->sz)
801046ef:	39 18                	cmp    %ebx,(%eax)
801046f1:	76 26                	jbe    80104719 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
801046f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801046f6:	89 da                	mov    %ebx,%edx
801046f8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801046fa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801046fc:	39 c3                	cmp    %eax,%ebx
801046fe:	73 19                	jae    80104719 <fetchstr+0x39>
    if(*s == 0)
80104700:	80 3b 00             	cmpb   $0x0,(%ebx)
80104703:	75 0d                	jne    80104712 <fetchstr+0x32>
80104705:	eb 21                	jmp    80104728 <fetchstr+0x48>
80104707:	90                   	nop
80104708:	80 3a 00             	cmpb   $0x0,(%edx)
8010470b:	90                   	nop
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104710:	74 16                	je     80104728 <fetchstr+0x48>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104712:	83 c2 01             	add    $0x1,%edx
80104715:	39 d0                	cmp    %edx,%eax
80104717:	77 ef                	ja     80104708 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104719:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010471c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104721:	5b                   	pop    %ebx
80104722:	5d                   	pop    %ebp
80104723:	c3                   	ret    
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104728:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
8010472b:	89 d0                	mov    %edx,%eax
8010472d:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
8010472f:	5b                   	pop    %ebx
80104730:	5d                   	pop    %ebp
80104731:	c3                   	ret    
80104732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104740 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	8b 75 0c             	mov    0xc(%ebp),%esi
80104747:	53                   	push   %ebx
80104748:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010474b:	e8 b0 ef ff ff       	call   80103700 <myproc>
80104750:	89 75 0c             	mov    %esi,0xc(%ebp)
80104753:	8b 40 18             	mov    0x18(%eax),%eax
80104756:	8b 40 44             	mov    0x44(%eax),%eax
80104759:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010475d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104760:	5b                   	pop    %ebx
80104761:	5e                   	pop    %esi
80104762:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104763:	e9 38 ff ff ff       	jmp    801046a0 <fetchint>
80104768:	90                   	nop
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104770 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	83 ec 20             	sub    $0x20,%esp
80104778:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010477b:	e8 80 ef ff ff       	call   80103700 <myproc>
80104780:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104782:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104785:	89 44 24 04          	mov    %eax,0x4(%esp)
80104789:	8b 45 08             	mov    0x8(%ebp),%eax
8010478c:	89 04 24             	mov    %eax,(%esp)
8010478f:	e8 ac ff ff ff       	call   80104740 <argint>
80104794:	85 c0                	test   %eax,%eax
80104796:	78 28                	js     801047c0 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104798:	85 db                	test   %ebx,%ebx
8010479a:	78 24                	js     801047c0 <argptr+0x50>
8010479c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010479f:	8b 06                	mov    (%esi),%eax
801047a1:	39 c2                	cmp    %eax,%edx
801047a3:	73 1b                	jae    801047c0 <argptr+0x50>
801047a5:	01 d3                	add    %edx,%ebx
801047a7:	39 d8                	cmp    %ebx,%eax
801047a9:	72 15                	jb     801047c0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801047ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ae:	89 10                	mov    %edx,(%eax)
  return 0;
}
801047b0:	83 c4 20             	add    $0x20,%esp
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
801047b3:	31 c0                	xor    %eax,%eax
}
801047b5:	5b                   	pop    %ebx
801047b6:	5e                   	pop    %esi
801047b7:	5d                   	pop    %ebp
801047b8:	c3                   	ret    
801047b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047c0:	83 c4 20             	add    $0x20,%esp
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
801047c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}
801047c8:	5b                   	pop    %ebx
801047c9:	5e                   	pop    %esi
801047ca:	5d                   	pop    %ebp
801047cb:	c3                   	ret    
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801047d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801047dd:	8b 45 08             	mov    0x8(%ebp),%eax
801047e0:	89 04 24             	mov    %eax,(%esp)
801047e3:	e8 58 ff ff ff       	call   80104740 <argint>
801047e8:	85 c0                	test   %eax,%eax
801047ea:	78 14                	js     80104800 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801047ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f6:	89 04 24             	mov    %eax,(%esp)
801047f9:	e8 e2 fe ff ff       	call   801046e0 <fetchstr>
}
801047fe:	c9                   	leave  
801047ff:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104805:	c9                   	leave  
80104806:	c3                   	ret    
80104807:	89 f6                	mov    %esi,%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <syscall>:

};

void
syscall(void)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	53                   	push   %ebx
80104816:	83 ec 1c             	sub    $0x1c,%esp
  int num;
  struct proc *curproc = myproc();
80104819:	e8 e2 ee ff ff       	call   80103700 <myproc>

  num = curproc->tf->eax;
8010481e:	8b 78 18             	mov    0x18(%eax),%edi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104821:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104823:	8b 77 1c             	mov    0x1c(%edi),%esi

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104826:	8d 46 ff             	lea    -0x1(%esi),%eax
80104829:	83 f8 19             	cmp    $0x19,%eax
8010482c:	77 22                	ja     80104850 <syscall+0x40>
8010482e:	8b 04 b5 40 75 10 80 	mov    -0x7fef8ac0(,%esi,4),%eax
80104835:	85 c0                	test   %eax,%eax
80104837:	74 17                	je     80104850 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104839:	ff d0                	call   *%eax
8010483b:	89 47 1c             	mov    %eax,0x1c(%edi)
    curproc->arraySys[num]++;
8010483e:	83 44 b3 7c 01       	addl   $0x1,0x7c(%ebx,%esi,4)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104843:	83 c4 1c             	add    $0x1c,%esp
80104846:	5b                   	pop    %ebx
80104847:	5e                   	pop    %esi
80104848:	5f                   	pop    %edi
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    
8010484b:	90                   	nop
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
    curproc->arraySys[num]++;
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104850:	8d 43 6c             	lea    0x6c(%ebx),%eax

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
    curproc->arraySys[num]++;
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104853:	89 74 24 0c          	mov    %esi,0xc(%esp)
            curproc->pid, curproc->name, num);
80104857:	89 44 24 08          	mov    %eax,0x8(%esp)

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
    curproc->arraySys[num]++;
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010485b:	8b 43 10             	mov    0x10(%ebx),%eax
8010485e:	c7 04 24 11 75 10 80 	movl   $0x80107511,(%esp)
80104865:	89 44 24 04          	mov    %eax,0x4(%esp)
80104869:	e8 e2 bd ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010486e:	8b 43 18             	mov    0x18(%ebx),%eax
80104871:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104878:	83 c4 1c             	add    $0x1c,%esp
8010487b:	5b                   	pop    %ebx
8010487c:	5e                   	pop    %esi
8010487d:	5f                   	pop    %edi
8010487e:	5d                   	pop    %ebp
8010487f:	c3                   	ret    

80104880 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	53                   	push   %ebx
80104884:	89 c3                	mov    %eax,%ebx
80104886:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104889:	e8 72 ee ff ff       	call   80103700 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010488e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104890:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104894:	85 c9                	test   %ecx,%ecx
80104896:	74 18                	je     801048b0 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104898:	83 c2 01             	add    $0x1,%edx
8010489b:	83 fa 10             	cmp    $0x10,%edx
8010489e:	75 f0                	jne    80104890 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801048a0:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801048a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048a8:	5b                   	pop    %ebx
801048a9:	5d                   	pop    %ebp
801048aa:	c3                   	ret    
801048ab:	90                   	nop
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801048b0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
801048b4:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
801048b7:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
801048b9:	5b                   	pop    %ebx
801048ba:	5d                   	pop    %ebp
801048bb:	c3                   	ret    
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	57                   	push   %edi
801048c4:	56                   	push   %esi
801048c5:	53                   	push   %ebx
801048c6:	83 ec 3c             	sub    $0x3c,%esp
801048c9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801048cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048cf:	8d 5d da             	lea    -0x26(%ebp),%ebx
801048d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801048d6:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801048dc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048df:	e8 3c d6 ff ff       	call   80101f20 <nameiparent>
801048e4:	85 c0                	test   %eax,%eax
801048e6:	89 c7                	mov    %eax,%edi
801048e8:	0f 84 da 00 00 00    	je     801049c8 <create+0x108>
    return 0;
  ilock(dp);
801048ee:	89 04 24             	mov    %eax,(%esp)
801048f1:	e8 ba cd ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801048f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801048fd:	00 
801048fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104902:	89 3c 24             	mov    %edi,(%esp)
80104905:	e8 b6 d2 ff ff       	call   80101bc0 <dirlookup>
8010490a:	85 c0                	test   %eax,%eax
8010490c:	89 c6                	mov    %eax,%esi
8010490e:	74 40                	je     80104950 <create+0x90>
    iunlockput(dp);
80104910:	89 3c 24             	mov    %edi,(%esp)
80104913:	e8 f8 cf ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104918:	89 34 24             	mov    %esi,(%esp)
8010491b:	e8 90 cd ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104920:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104925:	75 11                	jne    80104938 <create+0x78>
80104927:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010492c:	89 f0                	mov    %esi,%eax
8010492e:	75 08                	jne    80104938 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104930:	83 c4 3c             	add    $0x3c,%esp
80104933:	5b                   	pop    %ebx
80104934:	5e                   	pop    %esi
80104935:	5f                   	pop    %edi
80104936:	5d                   	pop    %ebp
80104937:	c3                   	ret    
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104938:	89 34 24             	mov    %esi,(%esp)
8010493b:	e8 d0 cf ff ff       	call   80101910 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104940:	83 c4 3c             	add    $0x3c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104943:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104945:	5b                   	pop    %ebx
80104946:	5e                   	pop    %esi
80104947:	5f                   	pop    %edi
80104948:	5d                   	pop    %ebp
80104949:	c3                   	ret    
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104950:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104954:	89 44 24 04          	mov    %eax,0x4(%esp)
80104958:	8b 07                	mov    (%edi),%eax
8010495a:	89 04 24             	mov    %eax,(%esp)
8010495d:	e8 be cb ff ff       	call   80101520 <ialloc>
80104962:	85 c0                	test   %eax,%eax
80104964:	89 c6                	mov    %eax,%esi
80104966:	0f 84 bf 00 00 00    	je     80104a2b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
8010496c:	89 04 24             	mov    %eax,(%esp)
8010496f:	e8 3c cd ff ff       	call   801016b0 <ilock>
  ip->major = major;
80104974:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104978:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010497c:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104980:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104984:	b8 01 00 00 00       	mov    $0x1,%eax
80104989:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010498d:	89 34 24             	mov    %esi,(%esp)
80104990:	e8 5b cc ff ff       	call   801015f0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104995:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010499a:	74 34                	je     801049d0 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010499c:	8b 46 04             	mov    0x4(%esi),%eax
8010499f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801049a3:	89 3c 24             	mov    %edi,(%esp)
801049a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801049aa:	e8 71 d4 ff ff       	call   80101e20 <dirlink>
801049af:	85 c0                	test   %eax,%eax
801049b1:	78 6c                	js     80104a1f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
801049b3:	89 3c 24             	mov    %edi,(%esp)
801049b6:	e8 55 cf ff ff       	call   80101910 <iunlockput>

  return ip;
}
801049bb:	83 c4 3c             	add    $0x3c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801049be:	89 f0                	mov    %esi,%eax
}
801049c0:	5b                   	pop    %ebx
801049c1:	5e                   	pop    %esi
801049c2:	5f                   	pop    %edi
801049c3:	5d                   	pop    %ebp
801049c4:	c3                   	ret    
801049c5:	8d 76 00             	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801049c8:	31 c0                	xor    %eax,%eax
801049ca:	e9 61 ff ff ff       	jmp    80104930 <create+0x70>
801049cf:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801049d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801049d5:	89 3c 24             	mov    %edi,(%esp)
801049d8:	e8 13 cc ff ff       	call   801015f0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801049dd:	8b 46 04             	mov    0x4(%esi),%eax
801049e0:	c7 44 24 04 c8 75 10 	movl   $0x801075c8,0x4(%esp)
801049e7:	80 
801049e8:	89 34 24             	mov    %esi,(%esp)
801049eb:	89 44 24 08          	mov    %eax,0x8(%esp)
801049ef:	e8 2c d4 ff ff       	call   80101e20 <dirlink>
801049f4:	85 c0                	test   %eax,%eax
801049f6:	78 1b                	js     80104a13 <create+0x153>
801049f8:	8b 47 04             	mov    0x4(%edi),%eax
801049fb:	c7 44 24 04 c7 75 10 	movl   $0x801075c7,0x4(%esp)
80104a02:	80 
80104a03:	89 34 24             	mov    %esi,(%esp)
80104a06:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a0a:	e8 11 d4 ff ff       	call   80101e20 <dirlink>
80104a0f:	85 c0                	test   %eax,%eax
80104a11:	79 89                	jns    8010499c <create+0xdc>
      panic("create dots");
80104a13:	c7 04 24 bb 75 10 80 	movl   $0x801075bb,(%esp)
80104a1a:	e8 41 b9 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a1f:	c7 04 24 ca 75 10 80 	movl   $0x801075ca,(%esp)
80104a26:	e8 35 b9 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104a2b:	c7 04 24 ac 75 10 80 	movl   $0x801075ac,(%esp)
80104a32:	e8 29 b9 ff ff       	call   80100360 <panic>
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	89 c6                	mov    %eax,%esi
80104a46:	53                   	push   %ebx
80104a47:	89 d3                	mov    %edx,%ebx
80104a49:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104a4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a53:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a5a:	e8 e1 fc ff ff       	call   80104740 <argint>
80104a5f:	85 c0                	test   %eax,%eax
80104a61:	78 2d                	js     80104a90 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a63:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a67:	77 27                	ja     80104a90 <argfd.constprop.0+0x50>
80104a69:	e8 92 ec ff ff       	call   80103700 <myproc>
80104a6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a71:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104a75:	85 c0                	test   %eax,%eax
80104a77:	74 17                	je     80104a90 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104a79:	85 f6                	test   %esi,%esi
80104a7b:	74 02                	je     80104a7f <argfd.constprop.0+0x3f>
    *pfd = fd;
80104a7d:	89 16                	mov    %edx,(%esi)
  if(pf)
80104a7f:	85 db                	test   %ebx,%ebx
80104a81:	74 1d                	je     80104aa0 <argfd.constprop.0+0x60>
    *pf = f;
80104a83:	89 03                	mov    %eax,(%ebx)
  return 0;
80104a85:	31 c0                	xor    %eax,%eax
}
80104a87:	83 c4 20             	add    $0x20,%esp
80104a8a:	5b                   	pop    %ebx
80104a8b:	5e                   	pop    %esi
80104a8c:	5d                   	pop    %ebp
80104a8d:	c3                   	ret    
80104a8e:	66 90                	xchg   %ax,%ax
80104a90:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104a98:	5b                   	pop    %ebx
80104a99:	5e                   	pop    %esi
80104a9a:	5d                   	pop    %ebp
80104a9b:	c3                   	ret    
80104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104aa0:	31 c0                	xor    %eax,%eax
80104aa2:	eb e3                	jmp    80104a87 <argfd.constprop.0+0x47>
80104aa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ab0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104ab0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ab1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	53                   	push   %ebx
80104ab6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ab9:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104abc:	e8 7f ff ff ff       	call   80104a40 <argfd.constprop.0>
80104ac1:	85 c0                	test   %eax,%eax
80104ac3:	78 23                	js     80104ae8 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac8:	e8 b3 fd ff ff       	call   80104880 <fdalloc>
80104acd:	85 c0                	test   %eax,%eax
80104acf:	89 c3                	mov    %eax,%ebx
80104ad1:	78 15                	js     80104ae8 <sys_dup+0x38>
    return -1;
  filedup(f);
80104ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad6:	89 04 24             	mov    %eax,(%esp)
80104ad9:	e8 02 c3 ff ff       	call   80100de0 <filedup>
  return fd;
80104ade:	89 d8                	mov    %ebx,%eax
}
80104ae0:	83 c4 24             	add    $0x24,%esp
80104ae3:	5b                   	pop    %ebx
80104ae4:	5d                   	pop    %ebp
80104ae5:	c3                   	ret    
80104ae6:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aed:	eb f1                	jmp    80104ae0 <sys_dup+0x30>
80104aef:	90                   	nop

80104af0 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104af0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104af1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104af3:	89 e5                	mov    %esp,%ebp
80104af5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104af8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104afb:	e8 40 ff ff ff       	call   80104a40 <argfd.constprop.0>
80104b00:	85 c0                	test   %eax,%eax
80104b02:	78 54                	js     80104b58 <sys_read+0x68>
80104b04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b0b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b12:	e8 29 fc ff ff       	call   80104740 <argint>
80104b17:	85 c0                	test   %eax,%eax
80104b19:	78 3d                	js     80104b58 <sys_read+0x68>
80104b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b25:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b30:	e8 3b fc ff ff       	call   80104770 <argptr>
80104b35:	85 c0                	test   %eax,%eax
80104b37:	78 1f                	js     80104b58 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b3c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b43:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b4a:	89 04 24             	mov    %eax,(%esp)
80104b4d:	e8 ee c3 ff ff       	call   80100f40 <fileread>
}
80104b52:	c9                   	leave  
80104b53:	c3                   	ret    
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104b5d:	c9                   	leave  
80104b5e:	c3                   	ret    
80104b5f:	90                   	nop

80104b60 <sys_write>:

int
sys_write(void)
{
80104b60:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b61:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b6b:	e8 d0 fe ff ff       	call   80104a40 <argfd.constprop.0>
80104b70:	85 c0                	test   %eax,%eax
80104b72:	78 54                	js     80104bc8 <sys_write+0x68>
80104b74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b82:	e8 b9 fb ff ff       	call   80104740 <argint>
80104b87:	85 c0                	test   %eax,%eax
80104b89:	78 3d                	js     80104bc8 <sys_write+0x68>
80104b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b95:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba0:	e8 cb fb ff ff       	call   80104770 <argptr>
80104ba5:	85 c0                	test   %eax,%eax
80104ba7:	78 1f                	js     80104bc8 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bac:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bba:	89 04 24             	mov    %eax,(%esp)
80104bbd:	e8 1e c4 ff ff       	call   80100fe0 <filewrite>
}
80104bc2:	c9                   	leave  
80104bc3:	c3                   	ret    
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104bcd:	c9                   	leave  
80104bce:	c3                   	ret    
80104bcf:	90                   	nop

80104bd0 <sys_close>:

int
sys_close(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104bd6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104bd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bdc:	e8 5f fe ff ff       	call   80104a40 <argfd.constprop.0>
80104be1:	85 c0                	test   %eax,%eax
80104be3:	78 23                	js     80104c08 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
80104be5:	e8 16 eb ff ff       	call   80103700 <myproc>
80104bea:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bed:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104bf4:	00 
  fileclose(f);
80104bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf8:	89 04 24             	mov    %eax,(%esp)
80104bfb:	e8 30 c2 ff ff       	call   80100e30 <fileclose>
  return 0;
80104c00:	31 c0                	xor    %eax,%eax
}
80104c02:	c9                   	leave  
80104c03:	c3                   	ret    
80104c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104c0d:	c9                   	leave  
80104c0e:	c3                   	ret    
80104c0f:	90                   	nop

80104c10 <sys_fstat>:

int
sys_fstat(void)
{
80104c10:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c11:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c1b:	e8 20 fe ff ff       	call   80104a40 <argfd.constprop.0>
80104c20:	85 c0                	test   %eax,%eax
80104c22:	78 34                	js     80104c58 <sys_fstat+0x48>
80104c24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c27:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104c2e:	00 
80104c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c3a:	e8 31 fb ff ff       	call   80104770 <argptr>
80104c3f:	85 c0                	test   %eax,%eax
80104c41:	78 15                	js     80104c58 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c46:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c4d:	89 04 24             	mov    %eax,(%esp)
80104c50:	e8 9b c2 ff ff       	call   80100ef0 <filestat>
}
80104c55:	c9                   	leave  
80104c56:	c3                   	ret    
80104c57:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104c5d:	c9                   	leave  
80104c5e:	c3                   	ret    
80104c5f:	90                   	nop

80104c60 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	53                   	push   %ebx
80104c66:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c69:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c77:	e8 54 fb ff ff       	call   801047d0 <argstr>
80104c7c:	85 c0                	test   %eax,%eax
80104c7e:	0f 88 e6 00 00 00    	js     80104d6a <sys_link+0x10a>
80104c84:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104c87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c92:	e8 39 fb ff ff       	call   801047d0 <argstr>
80104c97:	85 c0                	test   %eax,%eax
80104c99:	0f 88 cb 00 00 00    	js     80104d6a <sys_link+0x10a>
    return -1;

  begin_op();
80104c9f:	e8 6c de ff ff       	call   80102b10 <begin_op>
  if((ip = namei(old)) == 0){
80104ca4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ca7:	89 04 24             	mov    %eax,(%esp)
80104caa:	e8 51 d2 ff ff       	call   80101f00 <namei>
80104caf:	85 c0                	test   %eax,%eax
80104cb1:	89 c3                	mov    %eax,%ebx
80104cb3:	0f 84 ac 00 00 00    	je     80104d65 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104cb9:	89 04 24             	mov    %eax,(%esp)
80104cbc:	e8 ef c9 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80104cc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cc6:	0f 84 91 00 00 00    	je     80104d5d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104ccc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104cd1:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104cd4:	89 1c 24             	mov    %ebx,(%esp)
80104cd7:	e8 14 c9 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
80104cdc:	89 1c 24             	mov    %ebx,(%esp)
80104cdf:	e8 ac ca ff ff       	call   80101790 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104ce4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104ce7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104ceb:	89 04 24             	mov    %eax,(%esp)
80104cee:	e8 2d d2 ff ff       	call   80101f20 <nameiparent>
80104cf3:	85 c0                	test   %eax,%eax
80104cf5:	89 c6                	mov    %eax,%esi
80104cf7:	74 4f                	je     80104d48 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104cf9:	89 04 24             	mov    %eax,(%esp)
80104cfc:	e8 af c9 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d01:	8b 03                	mov    (%ebx),%eax
80104d03:	39 06                	cmp    %eax,(%esi)
80104d05:	75 39                	jne    80104d40 <sys_link+0xe0>
80104d07:	8b 43 04             	mov    0x4(%ebx),%eax
80104d0a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d0e:	89 34 24             	mov    %esi,(%esp)
80104d11:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d15:	e8 06 d1 ff ff       	call   80101e20 <dirlink>
80104d1a:	85 c0                	test   %eax,%eax
80104d1c:	78 22                	js     80104d40 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104d1e:	89 34 24             	mov    %esi,(%esp)
80104d21:	e8 ea cb ff ff       	call   80101910 <iunlockput>
  iput(ip);
80104d26:	89 1c 24             	mov    %ebx,(%esp)
80104d29:	e8 a2 ca ff ff       	call   801017d0 <iput>

  end_op();
80104d2e:	e8 4d de ff ff       	call   80102b80 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d33:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104d36:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d38:	5b                   	pop    %ebx
80104d39:	5e                   	pop    %esi
80104d3a:	5f                   	pop    %edi
80104d3b:	5d                   	pop    %ebp
80104d3c:	c3                   	ret    
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104d40:	89 34 24             	mov    %esi,(%esp)
80104d43:	e8 c8 cb ff ff       	call   80101910 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104d48:	89 1c 24             	mov    %ebx,(%esp)
80104d4b:	e8 60 c9 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80104d50:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d55:	89 1c 24             	mov    %ebx,(%esp)
80104d58:	e8 93 c8 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104d5d:	89 1c 24             	mov    %ebx,(%esp)
80104d60:	e8 ab cb ff ff       	call   80101910 <iunlockput>
  end_op();
80104d65:	e8 16 de ff ff       	call   80102b80 <end_op>
  return -1;
}
80104d6a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104d6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d72:	5b                   	pop    %ebx
80104d73:	5e                   	pop    %esi
80104d74:	5f                   	pop    %edi
80104d75:	5d                   	pop    %ebp
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
80104d85:	53                   	push   %ebx
80104d86:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d89:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d97:	e8 34 fa ff ff       	call   801047d0 <argstr>
80104d9c:	85 c0                	test   %eax,%eax
80104d9e:	0f 88 76 01 00 00    	js     80104f1a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104da4:	e8 67 dd ff ff       	call   80102b10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104da9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104dac:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104daf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104db3:	89 04 24             	mov    %eax,(%esp)
80104db6:	e8 65 d1 ff ff       	call   80101f20 <nameiparent>
80104dbb:	85 c0                	test   %eax,%eax
80104dbd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104dc0:	0f 84 4f 01 00 00    	je     80104f15 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104dc6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104dc9:	89 34 24             	mov    %esi,(%esp)
80104dcc:	e8 df c8 ff ff       	call   801016b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104dd1:	c7 44 24 04 c8 75 10 	movl   $0x801075c8,0x4(%esp)
80104dd8:	80 
80104dd9:	89 1c 24             	mov    %ebx,(%esp)
80104ddc:	e8 af cd ff ff       	call   80101b90 <namecmp>
80104de1:	85 c0                	test   %eax,%eax
80104de3:	0f 84 21 01 00 00    	je     80104f0a <sys_unlink+0x18a>
80104de9:	c7 44 24 04 c7 75 10 	movl   $0x801075c7,0x4(%esp)
80104df0:	80 
80104df1:	89 1c 24             	mov    %ebx,(%esp)
80104df4:	e8 97 cd ff ff       	call   80101b90 <namecmp>
80104df9:	85 c0                	test   %eax,%eax
80104dfb:	0f 84 09 01 00 00    	je     80104f0a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104e01:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e04:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104e08:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e0c:	89 34 24             	mov    %esi,(%esp)
80104e0f:	e8 ac cd ff ff       	call   80101bc0 <dirlookup>
80104e14:	85 c0                	test   %eax,%eax
80104e16:	89 c3                	mov    %eax,%ebx
80104e18:	0f 84 ec 00 00 00    	je     80104f0a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104e1e:	89 04 24             	mov    %eax,(%esp)
80104e21:	e8 8a c8 ff ff       	call   801016b0 <ilock>

  if(ip->nlink < 1)
80104e26:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104e2b:	0f 8e 24 01 00 00    	jle    80104f55 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104e31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e36:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104e39:	74 7d                	je     80104eb8 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104e3b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104e42:	00 
80104e43:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104e4a:	00 
80104e4b:	89 34 24             	mov    %esi,(%esp)
80104e4e:	e8 fd f5 ff ff       	call   80104450 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e53:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104e56:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e5d:	00 
80104e5e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e62:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e66:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e69:	89 04 24             	mov    %eax,(%esp)
80104e6c:	e8 ef cb ff ff       	call   80101a60 <writei>
80104e71:	83 f8 10             	cmp    $0x10,%eax
80104e74:	0f 85 cf 00 00 00    	jne    80104f49 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104e7a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e7f:	0f 84 a3 00 00 00    	je     80104f28 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104e85:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e88:	89 04 24             	mov    %eax,(%esp)
80104e8b:	e8 80 ca ff ff       	call   80101910 <iunlockput>

  ip->nlink--;
80104e90:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e95:	89 1c 24             	mov    %ebx,(%esp)
80104e98:	e8 53 c7 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104e9d:	89 1c 24             	mov    %ebx,(%esp)
80104ea0:	e8 6b ca ff ff       	call   80101910 <iunlockput>

  end_op();
80104ea5:	e8 d6 dc ff ff       	call   80102b80 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104eaa:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104ead:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104eaf:	5b                   	pop    %ebx
80104eb0:	5e                   	pop    %esi
80104eb1:	5f                   	pop    %edi
80104eb2:	5d                   	pop    %ebp
80104eb3:	c3                   	ret    
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104eb8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104ebc:	0f 86 79 ff ff ff    	jbe    80104e3b <sys_unlink+0xbb>
80104ec2:	bf 20 00 00 00       	mov    $0x20,%edi
80104ec7:	eb 15                	jmp    80104ede <sys_unlink+0x15e>
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed0:	8d 57 10             	lea    0x10(%edi),%edx
80104ed3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104ed6:	0f 83 5f ff ff ff    	jae    80104e3b <sys_unlink+0xbb>
80104edc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ede:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104ee5:	00 
80104ee6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104eea:	89 74 24 04          	mov    %esi,0x4(%esp)
80104eee:	89 1c 24             	mov    %ebx,(%esp)
80104ef1:	e8 6a ca ff ff       	call   80101960 <readi>
80104ef6:	83 f8 10             	cmp    $0x10,%eax
80104ef9:	75 42                	jne    80104f3d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104efb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f00:	74 ce                	je     80104ed0 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104f02:	89 1c 24             	mov    %ebx,(%esp)
80104f05:	e8 06 ca ff ff       	call   80101910 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104f0a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f0d:	89 04 24             	mov    %eax,(%esp)
80104f10:	e8 fb c9 ff ff       	call   80101910 <iunlockput>
  end_op();
80104f15:	e8 66 dc ff ff       	call   80102b80 <end_op>
  return -1;
}
80104f1a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f22:	5b                   	pop    %ebx
80104f23:	5e                   	pop    %esi
80104f24:	5f                   	pop    %edi
80104f25:	5d                   	pop    %ebp
80104f26:	c3                   	ret    
80104f27:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104f28:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f2b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104f30:	89 04 24             	mov    %eax,(%esp)
80104f33:	e8 b8 c6 ff ff       	call   801015f0 <iupdate>
80104f38:	e9 48 ff ff ff       	jmp    80104e85 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104f3d:	c7 04 24 ec 75 10 80 	movl   $0x801075ec,(%esp)
80104f44:	e8 17 b4 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104f49:	c7 04 24 fe 75 10 80 	movl   $0x801075fe,(%esp)
80104f50:	e8 0b b4 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104f55:	c7 04 24 da 75 10 80 	movl   $0x801075da,(%esp)
80104f5c:	e8 ff b3 ff ff       	call   80100360 <panic>
80104f61:	eb 0d                	jmp    80104f70 <sys_open>
80104f63:	90                   	nop
80104f64:	90                   	nop
80104f65:	90                   	nop
80104f66:	90                   	nop
80104f67:	90                   	nop
80104f68:	90                   	nop
80104f69:	90                   	nop
80104f6a:	90                   	nop
80104f6b:	90                   	nop
80104f6c:	90                   	nop
80104f6d:	90                   	nop
80104f6e:	90                   	nop
80104f6f:	90                   	nop

80104f70 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	56                   	push   %esi
80104f75:	53                   	push   %ebx
80104f76:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f79:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f87:	e8 44 f8 ff ff       	call   801047d0 <argstr>
80104f8c:	85 c0                	test   %eax,%eax
80104f8e:	0f 88 d1 00 00 00    	js     80105065 <sys_open+0xf5>
80104f94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fa2:	e8 99 f7 ff ff       	call   80104740 <argint>
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	0f 88 b6 00 00 00    	js     80105065 <sys_open+0xf5>
    return -1;

  begin_op();
80104faf:	e8 5c db ff ff       	call   80102b10 <begin_op>

  if(omode & O_CREATE){
80104fb4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104fb8:	0f 85 82 00 00 00    	jne    80105040 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104fbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fc1:	89 04 24             	mov    %eax,(%esp)
80104fc4:	e8 37 cf ff ff       	call   80101f00 <namei>
80104fc9:	85 c0                	test   %eax,%eax
80104fcb:	89 c6                	mov    %eax,%esi
80104fcd:	0f 84 8d 00 00 00    	je     80105060 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104fd3:	89 04 24             	mov    %eax,(%esp)
80104fd6:	e8 d5 c6 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104fdb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104fe0:	0f 84 92 00 00 00    	je     80105078 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104fe6:	e8 85 bd ff ff       	call   80100d70 <filealloc>
80104feb:	85 c0                	test   %eax,%eax
80104fed:	89 c3                	mov    %eax,%ebx
80104fef:	0f 84 93 00 00 00    	je     80105088 <sys_open+0x118>
80104ff5:	e8 86 f8 ff ff       	call   80104880 <fdalloc>
80104ffa:	85 c0                	test   %eax,%eax
80104ffc:	89 c7                	mov    %eax,%edi
80104ffe:	0f 88 94 00 00 00    	js     80105098 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105004:	89 34 24             	mov    %esi,(%esp)
80105007:	e8 84 c7 ff ff       	call   80101790 <iunlock>
  end_op();
8010500c:	e8 6f db ff ff       	call   80102b80 <end_op>

  f->type = FD_INODE;
80105011:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105017:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010501a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010501d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80105024:	89 c2                	mov    %eax,%edx
80105026:	83 e2 01             	and    $0x1,%edx
80105029:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010502c:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010502e:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80105031:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105033:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80105037:	83 c4 2c             	add    $0x2c,%esp
8010503a:	5b                   	pop    %ebx
8010503b:	5e                   	pop    %esi
8010503c:	5f                   	pop    %edi
8010503d:	5d                   	pop    %ebp
8010503e:	c3                   	ret    
8010503f:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105040:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105043:	31 c9                	xor    %ecx,%ecx
80105045:	ba 02 00 00 00       	mov    $0x2,%edx
8010504a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105051:	e8 6a f8 ff ff       	call   801048c0 <create>
    if(ip == 0){
80105056:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105058:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010505a:	75 8a                	jne    80104fe6 <sys_open+0x76>
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
80105060:	e8 1b db ff ff       	call   80102b80 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105065:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010506d:	5b                   	pop    %ebx
8010506e:	5e                   	pop    %esi
8010506f:	5f                   	pop    %edi
80105070:	5d                   	pop    %ebp
80105071:	c3                   	ret    
80105072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010507b:	85 c0                	test   %eax,%eax
8010507d:	0f 84 63 ff ff ff    	je     80104fe6 <sys_open+0x76>
80105083:	90                   	nop
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
80105088:	89 34 24             	mov    %esi,(%esp)
8010508b:	e8 80 c8 ff ff       	call   80101910 <iunlockput>
80105090:	eb ce                	jmp    80105060 <sys_open+0xf0>
80105092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105098:	89 1c 24             	mov    %ebx,(%esp)
8010509b:	e8 90 bd ff ff       	call   80100e30 <fileclose>
801050a0:	eb e6                	jmp    80105088 <sys_open+0x118>
801050a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801050b6:	e8 55 da ff ff       	call   80102b10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801050bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050be:	89 44 24 04          	mov    %eax,0x4(%esp)
801050c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050c9:	e8 02 f7 ff ff       	call   801047d0 <argstr>
801050ce:	85 c0                	test   %eax,%eax
801050d0:	78 2e                	js     80105100 <sys_mkdir+0x50>
801050d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050d5:	31 c9                	xor    %ecx,%ecx
801050d7:	ba 01 00 00 00       	mov    $0x1,%edx
801050dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050e3:	e8 d8 f7 ff ff       	call   801048c0 <create>
801050e8:	85 c0                	test   %eax,%eax
801050ea:	74 14                	je     80105100 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801050ec:	89 04 24             	mov    %eax,(%esp)
801050ef:	e8 1c c8 ff ff       	call   80101910 <iunlockput>
  end_op();
801050f4:	e8 87 da ff ff       	call   80102b80 <end_op>
  return 0;
801050f9:	31 c0                	xor    %eax,%eax
}
801050fb:	c9                   	leave  
801050fc:	c3                   	ret    
801050fd:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105100:	e8 7b da ff ff       	call   80102b80 <end_op>
    return -1;
80105105:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010510a:	c9                   	leave  
8010510b:	c3                   	ret    
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105110 <sys_mknod>:

int
sys_mknod(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105116:	e8 f5 d9 ff ff       	call   80102b10 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010511b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010511e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105122:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105129:	e8 a2 f6 ff ff       	call   801047d0 <argstr>
8010512e:	85 c0                	test   %eax,%eax
80105130:	78 5e                	js     80105190 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105132:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105135:	89 44 24 04          	mov    %eax,0x4(%esp)
80105139:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105140:	e8 fb f5 ff ff       	call   80104740 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105145:	85 c0                	test   %eax,%eax
80105147:	78 47                	js     80105190 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105149:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010514c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105150:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105157:	e8 e4 f5 ff ff       	call   80104740 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010515c:	85 c0                	test   %eax,%eax
8010515e:	78 30                	js     80105190 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105160:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105164:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105169:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010516d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105170:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105173:	e8 48 f7 ff ff       	call   801048c0 <create>
80105178:	85 c0                	test   %eax,%eax
8010517a:	74 14                	je     80105190 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010517c:	89 04 24             	mov    %eax,(%esp)
8010517f:	e8 8c c7 ff ff       	call   80101910 <iunlockput>
  end_op();
80105184:	e8 f7 d9 ff ff       	call   80102b80 <end_op>
  return 0;
80105189:	31 c0                	xor    %eax,%eax
}
8010518b:	c9                   	leave  
8010518c:	c3                   	ret    
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105190:	e8 eb d9 ff ff       	call   80102b80 <end_op>
    return -1;
80105195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010519a:	c9                   	leave  
8010519b:	c3                   	ret    
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051a0 <sys_chdir>:

int
sys_chdir(void)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
801051a5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801051a8:	e8 53 e5 ff ff       	call   80103700 <myproc>
801051ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801051af:	e8 5c d9 ff ff       	call   80102b10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801051b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801051bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051c2:	e8 09 f6 ff ff       	call   801047d0 <argstr>
801051c7:	85 c0                	test   %eax,%eax
801051c9:	78 4a                	js     80105215 <sys_chdir+0x75>
801051cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ce:	89 04 24             	mov    %eax,(%esp)
801051d1:	e8 2a cd ff ff       	call   80101f00 <namei>
801051d6:	85 c0                	test   %eax,%eax
801051d8:	89 c3                	mov    %eax,%ebx
801051da:	74 39                	je     80105215 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
801051dc:	89 04 24             	mov    %eax,(%esp)
801051df:	e8 cc c4 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
801051e4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801051e9:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
801051ec:	75 22                	jne    80105210 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801051ee:	e8 9d c5 ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
801051f3:	8b 46 68             	mov    0x68(%esi),%eax
801051f6:	89 04 24             	mov    %eax,(%esp)
801051f9:	e8 d2 c5 ff ff       	call   801017d0 <iput>
  end_op();
801051fe:	e8 7d d9 ff ff       	call   80102b80 <end_op>
  curproc->cwd = ip;
  return 0;
80105203:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
80105205:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
}
80105208:	83 c4 20             	add    $0x20,%esp
8010520b:	5b                   	pop    %ebx
8010520c:	5e                   	pop    %esi
8010520d:	5d                   	pop    %ebp
8010520e:	c3                   	ret    
8010520f:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105210:	e8 fb c6 ff ff       	call   80101910 <iunlockput>
    end_op();
80105215:	e8 66 d9 ff ff       	call   80102b80 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
8010521a:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
8010521d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
80105222:	5b                   	pop    %ebx
80105223:	5e                   	pop    %esi
80105224:	5d                   	pop    %ebp
80105225:	c3                   	ret    
80105226:	8d 76 00             	lea    0x0(%esi),%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105230 <sys_exec>:

int
sys_exec(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	56                   	push   %esi
80105235:	53                   	push   %ebx
80105236:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010523c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105242:	89 44 24 04          	mov    %eax,0x4(%esp)
80105246:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010524d:	e8 7e f5 ff ff       	call   801047d0 <argstr>
80105252:	85 c0                	test   %eax,%eax
80105254:	0f 88 84 00 00 00    	js     801052de <sys_exec+0xae>
8010525a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105260:	89 44 24 04          	mov    %eax,0x4(%esp)
80105264:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010526b:	e8 d0 f4 ff ff       	call   80104740 <argint>
80105270:	85 c0                	test   %eax,%eax
80105272:	78 6a                	js     801052de <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105274:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010527a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010527c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105283:	00 
80105284:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010528a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105291:	00 
80105292:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105298:	89 04 24             	mov    %eax,(%esp)
8010529b:	e8 b0 f1 ff ff       	call   80104450 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801052a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801052a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801052aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801052ad:	89 04 24             	mov    %eax,(%esp)
801052b0:	e8 eb f3 ff ff       	call   801046a0 <fetchint>
801052b5:	85 c0                	test   %eax,%eax
801052b7:	78 25                	js     801052de <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801052b9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801052bf:	85 c0                	test   %eax,%eax
801052c1:	74 2d                	je     801052f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801052c3:	89 74 24 04          	mov    %esi,0x4(%esp)
801052c7:	89 04 24             	mov    %eax,(%esp)
801052ca:	e8 11 f4 ff ff       	call   801046e0 <fetchstr>
801052cf:	85 c0                	test   %eax,%eax
801052d1:	78 0b                	js     801052de <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801052d3:	83 c3 01             	add    $0x1,%ebx
801052d6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801052d9:	83 fb 20             	cmp    $0x20,%ebx
801052dc:	75 c2                	jne    801052a0 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801052de:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801052e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801052e9:	5b                   	pop    %ebx
801052ea:	5e                   	pop    %esi
801052eb:	5f                   	pop    %edi
801052ec:	5d                   	pop    %ebp
801052ed:	c3                   	ret    
801052ee:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801052f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801052f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801052fa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105300:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105307:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010530b:	89 04 24             	mov    %eax,(%esp)
8010530e:	e8 8d b6 ff ff       	call   801009a0 <exec>
}
80105313:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105319:	5b                   	pop    %ebx
8010531a:	5e                   	pop    %esi
8010531b:	5f                   	pop    %edi
8010531c:	5d                   	pop    %ebp
8010531d:	c3                   	ret    
8010531e:	66 90                	xchg   %ax,%ax

80105320 <sys_pipe>:

int
sys_pipe(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	53                   	push   %ebx
80105324:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105327:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010532a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105331:	00 
80105332:	89 44 24 04          	mov    %eax,0x4(%esp)
80105336:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010533d:	e8 2e f4 ff ff       	call   80104770 <argptr>
80105342:	85 c0                	test   %eax,%eax
80105344:	78 6d                	js     801053b3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105346:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105349:	89 44 24 04          	mov    %eax,0x4(%esp)
8010534d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105350:	89 04 24             	mov    %eax,(%esp)
80105353:	e8 18 de ff ff       	call   80103170 <pipealloc>
80105358:	85 c0                	test   %eax,%eax
8010535a:	78 57                	js     801053b3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010535c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010535f:	e8 1c f5 ff ff       	call   80104880 <fdalloc>
80105364:	85 c0                	test   %eax,%eax
80105366:	89 c3                	mov    %eax,%ebx
80105368:	78 33                	js     8010539d <sys_pipe+0x7d>
8010536a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010536d:	e8 0e f5 ff ff       	call   80104880 <fdalloc>
80105372:	85 c0                	test   %eax,%eax
80105374:	78 1a                	js     80105390 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105376:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105379:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010537b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010537e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105381:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105384:	31 c0                	xor    %eax,%eax
}
80105386:	5b                   	pop    %ebx
80105387:	5d                   	pop    %ebp
80105388:	c3                   	ret    
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105390:	e8 6b e3 ff ff       	call   80103700 <myproc>
80105395:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010539c:	00 
    fileclose(rf);
8010539d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053a0:	89 04 24             	mov    %eax,(%esp)
801053a3:	e8 88 ba ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
801053a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ab:	89 04 24             	mov    %eax,(%esp)
801053ae:	e8 7d ba ff ff       	call   80100e30 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801053b3:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801053b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801053bb:	5b                   	pop    %ebx
801053bc:	5d                   	pop    %ebp
801053bd:	c3                   	ret    
801053be:	66 90                	xchg   %ax,%ax

801053c0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801053c3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801053c4:	e9 e7 e4 ff ff       	jmp    801038b0 <fork>
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053d0 <sys_exit>:
}

int
sys_exit(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801053d6:	e8 65 e7 ff ff       	call   80103b40 <exit>
  return 0;  // not reached
}
801053db:	31 c0                	xor    %eax,%eax
801053dd:	c9                   	leave  
801053de:	c3                   	ret    
801053df:	90                   	nop

801053e0 <sys_wait>:

int
sys_wait(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801053e3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801053e4:	e9 77 e9 ff ff       	jmp    80103d60 <wait>
801053e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_kill>:
}

int
sys_kill(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801053f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801053fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105404:	e8 37 f3 ff ff       	call   80104740 <argint>
80105409:	85 c0                	test   %eax,%eax
8010540b:	78 13                	js     80105420 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010540d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105410:	89 04 24             	mov    %eax,(%esp)
80105413:	e8 a8 ea ff ff       	call   80103ec0 <kill>
}
80105418:	c9                   	leave  
80105419:	c3                   	ret    
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105425:	c9                   	leave  
80105426:	c3                   	ret    
80105427:	89 f6                	mov    %esi,%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105430 <sys_getpid>:

int
sys_getpid(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105436:	e8 c5 e2 ff ff       	call   80103700 <myproc>
8010543b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010543e:	c9                   	leave  
8010543f:	c3                   	ret    

80105440 <sys_sbrk>:

int
sys_sbrk(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	53                   	push   %ebx
80105444:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105447:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010544e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105455:	e8 e6 f2 ff ff       	call   80104740 <argint>
8010545a:	85 c0                	test   %eax,%eax
8010545c:	78 22                	js     80105480 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010545e:	e8 9d e2 ff ff       	call   80103700 <myproc>
  if(growproc(n) < 0)
80105463:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105466:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105468:	89 14 24             	mov    %edx,(%esp)
8010546b:	e8 d0 e3 ff ff       	call   80103840 <growproc>
80105470:	85 c0                	test   %eax,%eax
80105472:	78 0c                	js     80105480 <sys_sbrk+0x40>
    return -1;
  return addr;
80105474:	89 d8                	mov    %ebx,%eax
}
80105476:	83 c4 24             	add    $0x24,%esp
80105479:	5b                   	pop    %ebx
8010547a:	5d                   	pop    %ebp
8010547b:	c3                   	ret    
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105485:	eb ef                	jmp    80105476 <sys_sbrk+0x36>
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	53                   	push   %ebx
80105494:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105497:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010549e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054a5:	e8 96 f2 ff ff       	call   80104740 <argint>
801054aa:	85 c0                	test   %eax,%eax
801054ac:	78 7e                	js     8010552c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801054ae:	c7 04 24 80 b2 11 80 	movl   $0x8011b280,(%esp)
801054b5:	e8 d6 ee ff ff       	call   80104390 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801054bd:	8b 1d c0 ba 11 80    	mov    0x8011bac0,%ebx
  while(ticks - ticks0 < n){
801054c3:	85 d2                	test   %edx,%edx
801054c5:	75 29                	jne    801054f0 <sys_sleep+0x60>
801054c7:	eb 4f                	jmp    80105518 <sys_sleep+0x88>
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801054d0:	c7 44 24 04 80 b2 11 	movl   $0x8011b280,0x4(%esp)
801054d7:	80 
801054d8:	c7 04 24 c0 ba 11 80 	movl   $0x8011bac0,(%esp)
801054df:	e8 cc e7 ff ff       	call   80103cb0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054e4:	a1 c0 ba 11 80       	mov    0x8011bac0,%eax
801054e9:	29 d8                	sub    %ebx,%eax
801054eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801054ee:	73 28                	jae    80105518 <sys_sleep+0x88>
    if(myproc()->killed){
801054f0:	e8 0b e2 ff ff       	call   80103700 <myproc>
801054f5:	8b 40 24             	mov    0x24(%eax),%eax
801054f8:	85 c0                	test   %eax,%eax
801054fa:	74 d4                	je     801054d0 <sys_sleep+0x40>
      release(&tickslock);
801054fc:	c7 04 24 80 b2 11 80 	movl   $0x8011b280,(%esp)
80105503:	e8 f8 ee ff ff       	call   80104400 <release>
      return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010550d:	83 c4 24             	add    $0x24,%esp
80105510:	5b                   	pop    %ebx
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret    
80105513:	90                   	nop
80105514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105518:	c7 04 24 80 b2 11 80 	movl   $0x8011b280,(%esp)
8010551f:	e8 dc ee ff ff       	call   80104400 <release>
  return 0;
}
80105524:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105527:	31 c0                	xor    %eax,%eax
}
80105529:	5b                   	pop    %ebx
8010552a:	5d                   	pop    %ebp
8010552b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010552c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105531:	eb da                	jmp    8010550d <sys_sleep+0x7d>
80105533:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	53                   	push   %ebx
80105544:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105547:	c7 04 24 80 b2 11 80 	movl   $0x8011b280,(%esp)
8010554e:	e8 3d ee ff ff       	call   80104390 <acquire>
  xticks = ticks;
80105553:	8b 1d c0 ba 11 80    	mov    0x8011bac0,%ebx
  release(&tickslock);
80105559:	c7 04 24 80 b2 11 80 	movl   $0x8011b280,(%esp)
80105560:	e8 9b ee ff ff       	call   80104400 <release>
  return xticks;
}
80105565:	83 c4 14             	add    $0x14,%esp
80105568:	89 d8                	mov    %ebx,%eax
8010556a:	5b                   	pop    %ebx
8010556b:	5d                   	pop    %ebp
8010556c:	c3                   	ret    
8010556d:	8d 76 00             	lea    0x0(%esi),%esi

80105570 <sys_getppid>:
int
sys_getppid(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 18             	sub    $0x18,%esp
    cprintf("Run sys_getppid.\n");
80105576:	c7 04 24 0d 76 10 80 	movl   $0x8010760d,(%esp)
8010557d:	e8 ce b0 ff ff       	call   80100650 <cprintf>
    struct proc *curproc = myproc();
80105582:	e8 79 e1 ff ff       	call   80103700 <myproc>
    return curproc->parent->pid;
80105587:	8b 40 14             	mov    0x14(%eax),%eax
8010558a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010558d:	c9                   	leave  
8010558e:	c3                   	ret    
8010558f:	90                   	nop

80105590 <sys_getChildren>:
int
sys_getChildren(int procId)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
  return getChildren(procId);
}
80105593:	5d                   	pop    %ebp
    return curproc->parent->pid;
}
int
sys_getChildren(int procId)
{
  return getChildren(procId);
80105594:	e9 97 ea ff ff       	jmp    80104030 <getChildren>
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_getCount>:
}
int
sys_getCount(int sysNum){
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 18             	sub    $0x18,%esp
    argint(0,&sysNum);
801055a6:	8d 45 08             	lea    0x8(%ebp),%eax
801055a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055b4:	e8 87 f1 ff ff       	call   80104740 <argint>

  return getCount(sysNum);
801055b9:	8b 45 08             	mov    0x8(%ebp),%eax
801055bc:	89 04 24             	mov    %eax,(%esp)
801055bf:	e8 dc ea ff ff       	call   801040a0 <getCount>
}
801055c4:	c9                   	leave  
801055c5:	c3                   	ret    
801055c6:	8d 76 00             	lea    0x0(%esi),%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <sys_getPolicy>:
int
sys_getPolicy(void){
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
  return getPolicy();
}
801055d3:	5d                   	pop    %ebp

  return getCount(sysNum);
}
int
sys_getPolicy(void){
  return getPolicy();
801055d4:	e9 07 eb ff ff       	jmp    801040e0 <getPolicy>
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_setPolicy>:
}
int sys_setPolicy(int policyNum){
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 18             	sub    $0x18,%esp
  argint(0,&policyNum);
801055e6:	8d 45 08             	lea    0x8(%ebp),%eax
801055e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055f4:	e8 47 f1 ff ff       	call   80104740 <argint>
  setPolicy(policyNum);
801055f9:	8b 45 08             	mov    0x8(%ebp),%eax
801055fc:	89 04 24             	mov    %eax,(%esp)
801055ff:	e8 bc ea ff ff       	call   801040c0 <setPolicy>
  return 1;
80105604:	b8 01 00 00 00       	mov    $0x1,%eax
80105609:	c9                   	leave  
8010560a:	c3                   	ret    

8010560b <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010560b:	1e                   	push   %ds
  pushl %es
8010560c:	06                   	push   %es
  pushl %fs
8010560d:	0f a0                	push   %fs
  pushl %gs
8010560f:	0f a8                	push   %gs
  pushal
80105611:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105612:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105616:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105618:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010561a:	54                   	push   %esp
  call trap
8010561b:	e8 e0 00 00 00       	call   80105700 <trap>
  addl $4, %esp
80105620:	83 c4 04             	add    $0x4,%esp

80105623 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105623:	61                   	popa   
  popl %gs
80105624:	0f a9                	pop    %gs
  popl %fs
80105626:	0f a1                	pop    %fs
  popl %es
80105628:	07                   	pop    %es
  popl %ds
80105629:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010562a:	83 c4 08             	add    $0x8,%esp
  iret
8010562d:	cf                   	iret   
8010562e:	66 90                	xchg   %ax,%ax

80105630 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105630:	31 c0                	xor    %eax,%eax
80105632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105638:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010563f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105644:	66 89 0c c5 c2 b2 11 	mov    %cx,-0x7fee4d3e(,%eax,8)
8010564b:	80 
8010564c:	c6 04 c5 c4 b2 11 80 	movb   $0x0,-0x7fee4d3c(,%eax,8)
80105653:	00 
80105654:	c6 04 c5 c5 b2 11 80 	movb   $0x8e,-0x7fee4d3b(,%eax,8)
8010565b:	8e 
8010565c:	66 89 14 c5 c0 b2 11 	mov    %dx,-0x7fee4d40(,%eax,8)
80105663:	80 
80105664:	c1 ea 10             	shr    $0x10,%edx
80105667:	66 89 14 c5 c6 b2 11 	mov    %dx,-0x7fee4d3a(,%eax,8)
8010566e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010566f:	83 c0 01             	add    $0x1,%eax
80105672:	3d 00 01 00 00       	cmp    $0x100,%eax
80105677:	75 bf                	jne    80105638 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105679:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010567a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010567f:	89 e5                	mov    %esp,%ebp
80105681:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105684:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105689:	c7 44 24 04 1f 76 10 	movl   $0x8010761f,0x4(%esp)
80105690:	80 
80105691:	c7 04 24 80 b2 11 80 	movl   $0x8011b280,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105698:	66 89 15 c2 b4 11 80 	mov    %dx,0x8011b4c2
8010569f:	66 a3 c0 b4 11 80    	mov    %ax,0x8011b4c0
801056a5:	c1 e8 10             	shr    $0x10,%eax
801056a8:	c6 05 c4 b4 11 80 00 	movb   $0x0,0x8011b4c4
801056af:	c6 05 c5 b4 11 80 ef 	movb   $0xef,0x8011b4c5
801056b6:	66 a3 c6 b4 11 80    	mov    %ax,0x8011b4c6

  initlock(&tickslock, "time");
801056bc:	e8 5f eb ff ff       	call   80104220 <initlock>
}
801056c1:	c9                   	leave  
801056c2:	c3                   	ret    
801056c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <idtinit>:

void
idtinit(void)
{
801056d0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801056d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801056d6:	89 e5                	mov    %esp,%ebp
801056d8:	83 ec 10             	sub    $0x10,%esp
801056db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801056df:	b8 c0 b2 11 80       	mov    $0x8011b2c0,%eax
801056e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801056e8:	c1 e8 10             	shr    $0x10,%eax
801056eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801056ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801056f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
80105705:	53                   	push   %ebx
80105706:	83 ec 3c             	sub    $0x3c,%esp
80105709:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010570c:	8b 43 30             	mov    0x30(%ebx),%eax
8010570f:	83 f8 40             	cmp    $0x40,%eax
80105712:	0f 84 d0 01 00 00    	je     801058e8 <trap+0x1e8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105718:	83 e8 20             	sub    $0x20,%eax
8010571b:	83 f8 1f             	cmp    $0x1f,%eax
8010571e:	77 08                	ja     80105728 <trap+0x28>
80105720:	ff 24 85 c8 76 10 80 	jmp    *-0x7fef8938(,%eax,4)
80105727:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105728:	e8 d3 df ff ff       	call   80103700 <myproc>
8010572d:	85 c0                	test   %eax,%eax
8010572f:	90                   	nop
80105730:	0f 84 2a 02 00 00    	je     80105960 <trap+0x260>
80105736:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010573a:	0f 84 20 02 00 00    	je     80105960 <trap+0x260>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105740:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105743:	8b 53 38             	mov    0x38(%ebx),%edx
80105746:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105749:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010574c:	e8 8f df ff ff       	call   801036e0 <cpuid>
80105751:	8b 73 30             	mov    0x30(%ebx),%esi
80105754:	89 c7                	mov    %eax,%edi
80105756:	8b 43 34             	mov    0x34(%ebx),%eax
80105759:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010575c:	e8 9f df ff ff       	call   80103700 <myproc>
80105761:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105764:	e8 97 df ff ff       	call   80103700 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105769:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010576c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105770:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105773:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105776:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010577a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010577d:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105781:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105784:	89 54 24 18          	mov    %edx,0x18(%esp)
80105788:	89 7c 24 10          	mov    %edi,0x10(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010578c:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105790:	8b 40 10             	mov    0x10(%eax),%eax
80105793:	c7 04 24 84 76 10 80 	movl   $0x80107684,(%esp)
8010579a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010579e:	e8 ad ae ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801057a3:	e8 58 df ff ff       	call   80103700 <myproc>
801057a8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801057af:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057b0:	e8 4b df ff ff       	call   80103700 <myproc>
801057b5:	85 c0                	test   %eax,%eax
801057b7:	74 0c                	je     801057c5 <trap+0xc5>
801057b9:	e8 42 df ff ff       	call   80103700 <myproc>
801057be:	8b 50 24             	mov    0x24(%eax),%edx
801057c1:	85 d2                	test   %edx,%edx
801057c3:	75 4b                	jne    80105810 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801057c5:	e8 36 df ff ff       	call   80103700 <myproc>
801057ca:	85 c0                	test   %eax,%eax
801057cc:	74 0d                	je     801057db <trap+0xdb>
801057ce:	66 90                	xchg   %ax,%ax
801057d0:	e8 2b df ff ff       	call   80103700 <myproc>
801057d5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801057d9:	74 4d                	je     80105828 <trap+0x128>
      



  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057db:	e8 20 df ff ff       	call   80103700 <myproc>
801057e0:	85 c0                	test   %eax,%eax
801057e2:	74 1d                	je     80105801 <trap+0x101>
801057e4:	e8 17 df ff ff       	call   80103700 <myproc>
801057e9:	8b 40 24             	mov    0x24(%eax),%eax
801057ec:	85 c0                	test   %eax,%eax
801057ee:	74 11                	je     80105801 <trap+0x101>
801057f0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057f4:	83 e0 03             	and    $0x3,%eax
801057f7:	66 83 f8 03          	cmp    $0x3,%ax
801057fb:	0f 84 18 01 00 00    	je     80105919 <trap+0x219>
    exit();
}
80105801:	83 c4 3c             	add    $0x3c,%esp
80105804:	5b                   	pop    %ebx
80105805:	5e                   	pop    %esi
80105806:	5f                   	pop    %edi
80105807:	5d                   	pop    %ebp
80105808:	c3                   	ret    
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105810:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105814:	83 e0 03             	and    $0x3,%eax
80105817:	66 83 f8 03          	cmp    $0x3,%ax
8010581b:	75 a8                	jne    801057c5 <trap+0xc5>
    exit();
8010581d:	e8 1e e3 ff ff       	call   80103b40 <exit>
80105822:	eb a1                	jmp    801057c5 <trap+0xc5>
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105828:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105830:	75 a9                	jne    801057db <trap+0xdb>
     tf->trapno == T_IRQ0+IRQ_TIMER)
  {
    if (getPolicy()==2)
80105832:	e8 a9 e8 ff ff       	call   801040e0 <getPolicy>
80105837:	83 f8 02             	cmp    $0x2,%eax
8010583a:	75 1b                	jne    80105857 <trap+0x157>
    {
      if(ticks % QUANTUM ==0)
8010583c:	8b 0d c0 ba 11 80    	mov    0x8011bac0,%ecx
80105842:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105847:	89 c8                	mov    %ecx,%eax
80105849:	f7 e2                	mul    %edx
8010584b:	c1 ea 03             	shr    $0x3,%edx
8010584e:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105851:	01 c0                	add    %eax,%eax
80105853:	39 c1                	cmp    %eax,%ecx
80105855:	75 84                	jne    801057db <trap+0xdb>
        yield();
80105857:	e8 14 e4 ff ff       	call   80103c70 <yield>
8010585c:	e9 7a ff ff ff       	jmp    801057db <trap+0xdb>
80105861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105868:	90                   	nop
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105870:	e8 6b de ff ff       	call   801036e0 <cpuid>
80105875:	85 c0                	test   %eax,%eax
80105877:	0f 84 b3 00 00 00    	je     80105930 <trap+0x230>
8010587d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105880:	e8 fb ce ff ff       	call   80102780 <lapiceoi>
    break;
80105885:	e9 26 ff ff ff       	jmp    801057b0 <trap+0xb0>
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105890:	e8 3b cd ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
80105895:	e8 e6 ce ff ff       	call   80102780 <lapiceoi>
    break;
8010589a:	e9 11 ff ff ff       	jmp    801057b0 <trap+0xb0>
8010589f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801058a0:	e8 1b 02 00 00       	call   80105ac0 <uartintr>
    lapiceoi();
801058a5:	e8 d6 ce ff ff       	call   80102780 <lapiceoi>
    break;
801058aa:	e9 01 ff ff ff       	jmp    801057b0 <trap+0xb0>
801058af:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801058b0:	8b 7b 38             	mov    0x38(%ebx),%edi
801058b3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801058b7:	e8 24 de ff ff       	call   801036e0 <cpuid>
801058bc:	c7 04 24 2c 76 10 80 	movl   $0x8010762c,(%esp)
801058c3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801058c7:	89 74 24 08          	mov    %esi,0x8(%esp)
801058cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801058cf:	e8 7c ad ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801058d4:	e8 a7 ce ff ff       	call   80102780 <lapiceoi>
    break;
801058d9:	e9 d2 fe ff ff       	jmp    801057b0 <trap+0xb0>
801058de:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801058e0:	e8 9b c7 ff ff       	call   80102080 <ideintr>
801058e5:	eb 96                	jmp    8010587d <trap+0x17d>
801058e7:	90                   	nop
801058e8:	90                   	nop
801058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801058f0:	e8 0b de ff ff       	call   80103700 <myproc>
801058f5:	8b 70 24             	mov    0x24(%eax),%esi
801058f8:	85 f6                	test   %esi,%esi
801058fa:	75 2c                	jne    80105928 <trap+0x228>
      exit();
    myproc()->tf = tf;
801058fc:	e8 ff dd ff ff       	call   80103700 <myproc>
80105901:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105904:	e8 07 ef ff ff       	call   80104810 <syscall>
    if(myproc()->killed)
80105909:	e8 f2 dd ff ff       	call   80103700 <myproc>
8010590e:	8b 48 24             	mov    0x24(%eax),%ecx
80105911:	85 c9                	test   %ecx,%ecx
80105913:	0f 84 e8 fe ff ff    	je     80105801 <trap+0x101>


  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105919:	83 c4 3c             	add    $0x3c,%esp
8010591c:	5b                   	pop    %ebx
8010591d:	5e                   	pop    %esi
8010591e:	5f                   	pop    %edi
8010591f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105920:	e9 1b e2 ff ff       	jmp    80103b40 <exit>
80105925:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105928:	e8 13 e2 ff ff       	call   80103b40 <exit>
8010592d:	eb cd                	jmp    801058fc <trap+0x1fc>
8010592f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105930:	c7 04 24 80 b2 11 80 	movl   $0x8011b280,(%esp)
80105937:	e8 54 ea ff ff       	call   80104390 <acquire>
      ticks++;
      wakeup(&ticks);
8010593c:	c7 04 24 c0 ba 11 80 	movl   $0x8011bac0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105943:	83 05 c0 ba 11 80 01 	addl   $0x1,0x8011bac0
      wakeup(&ticks);
8010594a:	e8 01 e5 ff ff       	call   80103e50 <wakeup>
      release(&tickslock);
8010594f:	c7 04 24 80 b2 11 80 	movl   $0x8011b280,(%esp)
80105956:	e8 a5 ea ff ff       	call   80104400 <release>
8010595b:	e9 1d ff ff ff       	jmp    8010587d <trap+0x17d>
80105960:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105963:	8b 73 38             	mov    0x38(%ebx),%esi
80105966:	e8 75 dd ff ff       	call   801036e0 <cpuid>
8010596b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010596f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105973:	89 44 24 08          	mov    %eax,0x8(%esp)
80105977:	8b 43 30             	mov    0x30(%ebx),%eax
8010597a:	c7 04 24 50 76 10 80 	movl   $0x80107650,(%esp)
80105981:	89 44 24 04          	mov    %eax,0x4(%esp)
80105985:	e8 c6 ac ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010598a:	c7 04 24 24 76 10 80 	movl   $0x80107624,(%esp)
80105991:	e8 ca a9 ff ff       	call   80100360 <panic>
80105996:	66 90                	xchg   %ax,%ax
80105998:	66 90                	xchg   %ax,%ax
8010599a:	66 90                	xchg   %ax,%ax
8010599c:	66 90                	xchg   %ax,%ax
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059a0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801059a5:	55                   	push   %ebp
801059a6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059a8:	85 c0                	test   %eax,%eax
801059aa:	74 14                	je     801059c0 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059ac:	ba fd 03 00 00       	mov    $0x3fd,%edx
801059b1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801059b2:	a8 01                	test   $0x1,%al
801059b4:	74 0a                	je     801059c0 <uartgetc+0x20>
801059b6:	b2 f8                	mov    $0xf8,%dl
801059b8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801059b9:	0f b6 c0             	movzbl %al,%eax
}
801059bc:	5d                   	pop    %ebp
801059bd:	c3                   	ret    
801059be:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801059c5:	5d                   	pop    %ebp
801059c6:	c3                   	ret    
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801059d0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
801059d5:	85 c0                	test   %eax,%eax
801059d7:	74 3f                	je     80105a18 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
801059d9:	55                   	push   %ebp
801059da:	89 e5                	mov    %esp,%ebp
801059dc:	56                   	push   %esi
801059dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801059e2:	53                   	push   %ebx
  int i;

  if(!uart)
801059e3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
801059e8:	83 ec 10             	sub    $0x10,%esp
801059eb:	eb 14                	jmp    80105a01 <uartputc+0x31>
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
801059f0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801059f7:	e8 a4 cd ff ff       	call   801027a0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801059fc:	83 eb 01             	sub    $0x1,%ebx
801059ff:	74 07                	je     80105a08 <uartputc+0x38>
80105a01:	89 f2                	mov    %esi,%edx
80105a03:	ec                   	in     (%dx),%al
80105a04:	a8 20                	test   $0x20,%al
80105a06:	74 e8                	je     801059f0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105a08:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a0c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a11:	ee                   	out    %al,(%dx)
}
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	5b                   	pop    %ebx
80105a16:	5e                   	pop    %esi
80105a17:	5d                   	pop    %ebp
80105a18:	f3 c3                	repz ret 
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a20 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105a20:	55                   	push   %ebp
80105a21:	31 c9                	xor    %ecx,%ecx
80105a23:	89 e5                	mov    %esp,%ebp
80105a25:	89 c8                	mov    %ecx,%eax
80105a27:	57                   	push   %edi
80105a28:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105a2d:	56                   	push   %esi
80105a2e:	89 fa                	mov    %edi,%edx
80105a30:	53                   	push   %ebx
80105a31:	83 ec 1c             	sub    $0x1c,%esp
80105a34:	ee                   	out    %al,(%dx)
80105a35:	be fb 03 00 00       	mov    $0x3fb,%esi
80105a3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a3f:	89 f2                	mov    %esi,%edx
80105a41:	ee                   	out    %al,(%dx)
80105a42:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a47:	b2 f8                	mov    $0xf8,%dl
80105a49:	ee                   	out    %al,(%dx)
80105a4a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105a4f:	89 c8                	mov    %ecx,%eax
80105a51:	89 da                	mov    %ebx,%edx
80105a53:	ee                   	out    %al,(%dx)
80105a54:	b8 03 00 00 00       	mov    $0x3,%eax
80105a59:	89 f2                	mov    %esi,%edx
80105a5b:	ee                   	out    %al,(%dx)
80105a5c:	b2 fc                	mov    $0xfc,%dl
80105a5e:	89 c8                	mov    %ecx,%eax
80105a60:	ee                   	out    %al,(%dx)
80105a61:	b8 01 00 00 00       	mov    $0x1,%eax
80105a66:	89 da                	mov    %ebx,%edx
80105a68:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a69:	b2 fd                	mov    $0xfd,%dl
80105a6b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105a6c:	3c ff                	cmp    $0xff,%al
80105a6e:	74 42                	je     80105ab2 <uartinit+0x92>
    return;
  uart = 1;
80105a70:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105a77:	00 00 00 
80105a7a:	89 fa                	mov    %edi,%edx
80105a7c:	ec                   	in     (%dx),%al
80105a7d:	b2 f8                	mov    $0xf8,%dl
80105a7f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105a80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a87:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a88:	bb 48 77 10 80       	mov    $0x80107748,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105a8d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105a94:	e8 17 c8 ff ff       	call   801022b0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a99:	b8 78 00 00 00       	mov    $0x78,%eax
80105a9e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105aa0:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105aa3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105aa6:	e8 25 ff ff ff       	call   801059d0 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105aab:	0f be 03             	movsbl (%ebx),%eax
80105aae:	84 c0                	test   %al,%al
80105ab0:	75 ee                	jne    80105aa0 <uartinit+0x80>
    uartputc(*p);
}
80105ab2:	83 c4 1c             	add    $0x1c,%esp
80105ab5:	5b                   	pop    %ebx
80105ab6:	5e                   	pop    %esi
80105ab7:	5f                   	pop    %edi
80105ab8:	5d                   	pop    %ebp
80105ab9:	c3                   	ret    
80105aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ac0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105ac6:	c7 04 24 a0 59 10 80 	movl   $0x801059a0,(%esp)
80105acd:	e8 de ac ff ff       	call   801007b0 <consoleintr>
}
80105ad2:	c9                   	leave  
80105ad3:	c3                   	ret    

80105ad4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ad4:	6a 00                	push   $0x0
  pushl $0
80105ad6:	6a 00                	push   $0x0
  jmp alltraps
80105ad8:	e9 2e fb ff ff       	jmp    8010560b <alltraps>

80105add <vector1>:
.globl vector1
vector1:
  pushl $0
80105add:	6a 00                	push   $0x0
  pushl $1
80105adf:	6a 01                	push   $0x1
  jmp alltraps
80105ae1:	e9 25 fb ff ff       	jmp    8010560b <alltraps>

80105ae6 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $2
80105ae8:	6a 02                	push   $0x2
  jmp alltraps
80105aea:	e9 1c fb ff ff       	jmp    8010560b <alltraps>

80105aef <vector3>:
.globl vector3
vector3:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $3
80105af1:	6a 03                	push   $0x3
  jmp alltraps
80105af3:	e9 13 fb ff ff       	jmp    8010560b <alltraps>

80105af8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $4
80105afa:	6a 04                	push   $0x4
  jmp alltraps
80105afc:	e9 0a fb ff ff       	jmp    8010560b <alltraps>

80105b01 <vector5>:
.globl vector5
vector5:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $5
80105b03:	6a 05                	push   $0x5
  jmp alltraps
80105b05:	e9 01 fb ff ff       	jmp    8010560b <alltraps>

80105b0a <vector6>:
.globl vector6
vector6:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $6
80105b0c:	6a 06                	push   $0x6
  jmp alltraps
80105b0e:	e9 f8 fa ff ff       	jmp    8010560b <alltraps>

80105b13 <vector7>:
.globl vector7
vector7:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $7
80105b15:	6a 07                	push   $0x7
  jmp alltraps
80105b17:	e9 ef fa ff ff       	jmp    8010560b <alltraps>

80105b1c <vector8>:
.globl vector8
vector8:
  pushl $8
80105b1c:	6a 08                	push   $0x8
  jmp alltraps
80105b1e:	e9 e8 fa ff ff       	jmp    8010560b <alltraps>

80105b23 <vector9>:
.globl vector9
vector9:
  pushl $0
80105b23:	6a 00                	push   $0x0
  pushl $9
80105b25:	6a 09                	push   $0x9
  jmp alltraps
80105b27:	e9 df fa ff ff       	jmp    8010560b <alltraps>

80105b2c <vector10>:
.globl vector10
vector10:
  pushl $10
80105b2c:	6a 0a                	push   $0xa
  jmp alltraps
80105b2e:	e9 d8 fa ff ff       	jmp    8010560b <alltraps>

80105b33 <vector11>:
.globl vector11
vector11:
  pushl $11
80105b33:	6a 0b                	push   $0xb
  jmp alltraps
80105b35:	e9 d1 fa ff ff       	jmp    8010560b <alltraps>

80105b3a <vector12>:
.globl vector12
vector12:
  pushl $12
80105b3a:	6a 0c                	push   $0xc
  jmp alltraps
80105b3c:	e9 ca fa ff ff       	jmp    8010560b <alltraps>

80105b41 <vector13>:
.globl vector13
vector13:
  pushl $13
80105b41:	6a 0d                	push   $0xd
  jmp alltraps
80105b43:	e9 c3 fa ff ff       	jmp    8010560b <alltraps>

80105b48 <vector14>:
.globl vector14
vector14:
  pushl $14
80105b48:	6a 0e                	push   $0xe
  jmp alltraps
80105b4a:	e9 bc fa ff ff       	jmp    8010560b <alltraps>

80105b4f <vector15>:
.globl vector15
vector15:
  pushl $0
80105b4f:	6a 00                	push   $0x0
  pushl $15
80105b51:	6a 0f                	push   $0xf
  jmp alltraps
80105b53:	e9 b3 fa ff ff       	jmp    8010560b <alltraps>

80105b58 <vector16>:
.globl vector16
vector16:
  pushl $0
80105b58:	6a 00                	push   $0x0
  pushl $16
80105b5a:	6a 10                	push   $0x10
  jmp alltraps
80105b5c:	e9 aa fa ff ff       	jmp    8010560b <alltraps>

80105b61 <vector17>:
.globl vector17
vector17:
  pushl $17
80105b61:	6a 11                	push   $0x11
  jmp alltraps
80105b63:	e9 a3 fa ff ff       	jmp    8010560b <alltraps>

80105b68 <vector18>:
.globl vector18
vector18:
  pushl $0
80105b68:	6a 00                	push   $0x0
  pushl $18
80105b6a:	6a 12                	push   $0x12
  jmp alltraps
80105b6c:	e9 9a fa ff ff       	jmp    8010560b <alltraps>

80105b71 <vector19>:
.globl vector19
vector19:
  pushl $0
80105b71:	6a 00                	push   $0x0
  pushl $19
80105b73:	6a 13                	push   $0x13
  jmp alltraps
80105b75:	e9 91 fa ff ff       	jmp    8010560b <alltraps>

80105b7a <vector20>:
.globl vector20
vector20:
  pushl $0
80105b7a:	6a 00                	push   $0x0
  pushl $20
80105b7c:	6a 14                	push   $0x14
  jmp alltraps
80105b7e:	e9 88 fa ff ff       	jmp    8010560b <alltraps>

80105b83 <vector21>:
.globl vector21
vector21:
  pushl $0
80105b83:	6a 00                	push   $0x0
  pushl $21
80105b85:	6a 15                	push   $0x15
  jmp alltraps
80105b87:	e9 7f fa ff ff       	jmp    8010560b <alltraps>

80105b8c <vector22>:
.globl vector22
vector22:
  pushl $0
80105b8c:	6a 00                	push   $0x0
  pushl $22
80105b8e:	6a 16                	push   $0x16
  jmp alltraps
80105b90:	e9 76 fa ff ff       	jmp    8010560b <alltraps>

80105b95 <vector23>:
.globl vector23
vector23:
  pushl $0
80105b95:	6a 00                	push   $0x0
  pushl $23
80105b97:	6a 17                	push   $0x17
  jmp alltraps
80105b99:	e9 6d fa ff ff       	jmp    8010560b <alltraps>

80105b9e <vector24>:
.globl vector24
vector24:
  pushl $0
80105b9e:	6a 00                	push   $0x0
  pushl $24
80105ba0:	6a 18                	push   $0x18
  jmp alltraps
80105ba2:	e9 64 fa ff ff       	jmp    8010560b <alltraps>

80105ba7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ba7:	6a 00                	push   $0x0
  pushl $25
80105ba9:	6a 19                	push   $0x19
  jmp alltraps
80105bab:	e9 5b fa ff ff       	jmp    8010560b <alltraps>

80105bb0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105bb0:	6a 00                	push   $0x0
  pushl $26
80105bb2:	6a 1a                	push   $0x1a
  jmp alltraps
80105bb4:	e9 52 fa ff ff       	jmp    8010560b <alltraps>

80105bb9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105bb9:	6a 00                	push   $0x0
  pushl $27
80105bbb:	6a 1b                	push   $0x1b
  jmp alltraps
80105bbd:	e9 49 fa ff ff       	jmp    8010560b <alltraps>

80105bc2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105bc2:	6a 00                	push   $0x0
  pushl $28
80105bc4:	6a 1c                	push   $0x1c
  jmp alltraps
80105bc6:	e9 40 fa ff ff       	jmp    8010560b <alltraps>

80105bcb <vector29>:
.globl vector29
vector29:
  pushl $0
80105bcb:	6a 00                	push   $0x0
  pushl $29
80105bcd:	6a 1d                	push   $0x1d
  jmp alltraps
80105bcf:	e9 37 fa ff ff       	jmp    8010560b <alltraps>

80105bd4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105bd4:	6a 00                	push   $0x0
  pushl $30
80105bd6:	6a 1e                	push   $0x1e
  jmp alltraps
80105bd8:	e9 2e fa ff ff       	jmp    8010560b <alltraps>

80105bdd <vector31>:
.globl vector31
vector31:
  pushl $0
80105bdd:	6a 00                	push   $0x0
  pushl $31
80105bdf:	6a 1f                	push   $0x1f
  jmp alltraps
80105be1:	e9 25 fa ff ff       	jmp    8010560b <alltraps>

80105be6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105be6:	6a 00                	push   $0x0
  pushl $32
80105be8:	6a 20                	push   $0x20
  jmp alltraps
80105bea:	e9 1c fa ff ff       	jmp    8010560b <alltraps>

80105bef <vector33>:
.globl vector33
vector33:
  pushl $0
80105bef:	6a 00                	push   $0x0
  pushl $33
80105bf1:	6a 21                	push   $0x21
  jmp alltraps
80105bf3:	e9 13 fa ff ff       	jmp    8010560b <alltraps>

80105bf8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105bf8:	6a 00                	push   $0x0
  pushl $34
80105bfa:	6a 22                	push   $0x22
  jmp alltraps
80105bfc:	e9 0a fa ff ff       	jmp    8010560b <alltraps>

80105c01 <vector35>:
.globl vector35
vector35:
  pushl $0
80105c01:	6a 00                	push   $0x0
  pushl $35
80105c03:	6a 23                	push   $0x23
  jmp alltraps
80105c05:	e9 01 fa ff ff       	jmp    8010560b <alltraps>

80105c0a <vector36>:
.globl vector36
vector36:
  pushl $0
80105c0a:	6a 00                	push   $0x0
  pushl $36
80105c0c:	6a 24                	push   $0x24
  jmp alltraps
80105c0e:	e9 f8 f9 ff ff       	jmp    8010560b <alltraps>

80105c13 <vector37>:
.globl vector37
vector37:
  pushl $0
80105c13:	6a 00                	push   $0x0
  pushl $37
80105c15:	6a 25                	push   $0x25
  jmp alltraps
80105c17:	e9 ef f9 ff ff       	jmp    8010560b <alltraps>

80105c1c <vector38>:
.globl vector38
vector38:
  pushl $0
80105c1c:	6a 00                	push   $0x0
  pushl $38
80105c1e:	6a 26                	push   $0x26
  jmp alltraps
80105c20:	e9 e6 f9 ff ff       	jmp    8010560b <alltraps>

80105c25 <vector39>:
.globl vector39
vector39:
  pushl $0
80105c25:	6a 00                	push   $0x0
  pushl $39
80105c27:	6a 27                	push   $0x27
  jmp alltraps
80105c29:	e9 dd f9 ff ff       	jmp    8010560b <alltraps>

80105c2e <vector40>:
.globl vector40
vector40:
  pushl $0
80105c2e:	6a 00                	push   $0x0
  pushl $40
80105c30:	6a 28                	push   $0x28
  jmp alltraps
80105c32:	e9 d4 f9 ff ff       	jmp    8010560b <alltraps>

80105c37 <vector41>:
.globl vector41
vector41:
  pushl $0
80105c37:	6a 00                	push   $0x0
  pushl $41
80105c39:	6a 29                	push   $0x29
  jmp alltraps
80105c3b:	e9 cb f9 ff ff       	jmp    8010560b <alltraps>

80105c40 <vector42>:
.globl vector42
vector42:
  pushl $0
80105c40:	6a 00                	push   $0x0
  pushl $42
80105c42:	6a 2a                	push   $0x2a
  jmp alltraps
80105c44:	e9 c2 f9 ff ff       	jmp    8010560b <alltraps>

80105c49 <vector43>:
.globl vector43
vector43:
  pushl $0
80105c49:	6a 00                	push   $0x0
  pushl $43
80105c4b:	6a 2b                	push   $0x2b
  jmp alltraps
80105c4d:	e9 b9 f9 ff ff       	jmp    8010560b <alltraps>

80105c52 <vector44>:
.globl vector44
vector44:
  pushl $0
80105c52:	6a 00                	push   $0x0
  pushl $44
80105c54:	6a 2c                	push   $0x2c
  jmp alltraps
80105c56:	e9 b0 f9 ff ff       	jmp    8010560b <alltraps>

80105c5b <vector45>:
.globl vector45
vector45:
  pushl $0
80105c5b:	6a 00                	push   $0x0
  pushl $45
80105c5d:	6a 2d                	push   $0x2d
  jmp alltraps
80105c5f:	e9 a7 f9 ff ff       	jmp    8010560b <alltraps>

80105c64 <vector46>:
.globl vector46
vector46:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $46
80105c66:	6a 2e                	push   $0x2e
  jmp alltraps
80105c68:	e9 9e f9 ff ff       	jmp    8010560b <alltraps>

80105c6d <vector47>:
.globl vector47
vector47:
  pushl $0
80105c6d:	6a 00                	push   $0x0
  pushl $47
80105c6f:	6a 2f                	push   $0x2f
  jmp alltraps
80105c71:	e9 95 f9 ff ff       	jmp    8010560b <alltraps>

80105c76 <vector48>:
.globl vector48
vector48:
  pushl $0
80105c76:	6a 00                	push   $0x0
  pushl $48
80105c78:	6a 30                	push   $0x30
  jmp alltraps
80105c7a:	e9 8c f9 ff ff       	jmp    8010560b <alltraps>

80105c7f <vector49>:
.globl vector49
vector49:
  pushl $0
80105c7f:	6a 00                	push   $0x0
  pushl $49
80105c81:	6a 31                	push   $0x31
  jmp alltraps
80105c83:	e9 83 f9 ff ff       	jmp    8010560b <alltraps>

80105c88 <vector50>:
.globl vector50
vector50:
  pushl $0
80105c88:	6a 00                	push   $0x0
  pushl $50
80105c8a:	6a 32                	push   $0x32
  jmp alltraps
80105c8c:	e9 7a f9 ff ff       	jmp    8010560b <alltraps>

80105c91 <vector51>:
.globl vector51
vector51:
  pushl $0
80105c91:	6a 00                	push   $0x0
  pushl $51
80105c93:	6a 33                	push   $0x33
  jmp alltraps
80105c95:	e9 71 f9 ff ff       	jmp    8010560b <alltraps>

80105c9a <vector52>:
.globl vector52
vector52:
  pushl $0
80105c9a:	6a 00                	push   $0x0
  pushl $52
80105c9c:	6a 34                	push   $0x34
  jmp alltraps
80105c9e:	e9 68 f9 ff ff       	jmp    8010560b <alltraps>

80105ca3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ca3:	6a 00                	push   $0x0
  pushl $53
80105ca5:	6a 35                	push   $0x35
  jmp alltraps
80105ca7:	e9 5f f9 ff ff       	jmp    8010560b <alltraps>

80105cac <vector54>:
.globl vector54
vector54:
  pushl $0
80105cac:	6a 00                	push   $0x0
  pushl $54
80105cae:	6a 36                	push   $0x36
  jmp alltraps
80105cb0:	e9 56 f9 ff ff       	jmp    8010560b <alltraps>

80105cb5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $55
80105cb7:	6a 37                	push   $0x37
  jmp alltraps
80105cb9:	e9 4d f9 ff ff       	jmp    8010560b <alltraps>

80105cbe <vector56>:
.globl vector56
vector56:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $56
80105cc0:	6a 38                	push   $0x38
  jmp alltraps
80105cc2:	e9 44 f9 ff ff       	jmp    8010560b <alltraps>

80105cc7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $57
80105cc9:	6a 39                	push   $0x39
  jmp alltraps
80105ccb:	e9 3b f9 ff ff       	jmp    8010560b <alltraps>

80105cd0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $58
80105cd2:	6a 3a                	push   $0x3a
  jmp alltraps
80105cd4:	e9 32 f9 ff ff       	jmp    8010560b <alltraps>

80105cd9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $59
80105cdb:	6a 3b                	push   $0x3b
  jmp alltraps
80105cdd:	e9 29 f9 ff ff       	jmp    8010560b <alltraps>

80105ce2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $60
80105ce4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ce6:	e9 20 f9 ff ff       	jmp    8010560b <alltraps>

80105ceb <vector61>:
.globl vector61
vector61:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $61
80105ced:	6a 3d                	push   $0x3d
  jmp alltraps
80105cef:	e9 17 f9 ff ff       	jmp    8010560b <alltraps>

80105cf4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $62
80105cf6:	6a 3e                	push   $0x3e
  jmp alltraps
80105cf8:	e9 0e f9 ff ff       	jmp    8010560b <alltraps>

80105cfd <vector63>:
.globl vector63
vector63:
  pushl $0
80105cfd:	6a 00                	push   $0x0
  pushl $63
80105cff:	6a 3f                	push   $0x3f
  jmp alltraps
80105d01:	e9 05 f9 ff ff       	jmp    8010560b <alltraps>

80105d06 <vector64>:
.globl vector64
vector64:
  pushl $0
80105d06:	6a 00                	push   $0x0
  pushl $64
80105d08:	6a 40                	push   $0x40
  jmp alltraps
80105d0a:	e9 fc f8 ff ff       	jmp    8010560b <alltraps>

80105d0f <vector65>:
.globl vector65
vector65:
  pushl $0
80105d0f:	6a 00                	push   $0x0
  pushl $65
80105d11:	6a 41                	push   $0x41
  jmp alltraps
80105d13:	e9 f3 f8 ff ff       	jmp    8010560b <alltraps>

80105d18 <vector66>:
.globl vector66
vector66:
  pushl $0
80105d18:	6a 00                	push   $0x0
  pushl $66
80105d1a:	6a 42                	push   $0x42
  jmp alltraps
80105d1c:	e9 ea f8 ff ff       	jmp    8010560b <alltraps>

80105d21 <vector67>:
.globl vector67
vector67:
  pushl $0
80105d21:	6a 00                	push   $0x0
  pushl $67
80105d23:	6a 43                	push   $0x43
  jmp alltraps
80105d25:	e9 e1 f8 ff ff       	jmp    8010560b <alltraps>

80105d2a <vector68>:
.globl vector68
vector68:
  pushl $0
80105d2a:	6a 00                	push   $0x0
  pushl $68
80105d2c:	6a 44                	push   $0x44
  jmp alltraps
80105d2e:	e9 d8 f8 ff ff       	jmp    8010560b <alltraps>

80105d33 <vector69>:
.globl vector69
vector69:
  pushl $0
80105d33:	6a 00                	push   $0x0
  pushl $69
80105d35:	6a 45                	push   $0x45
  jmp alltraps
80105d37:	e9 cf f8 ff ff       	jmp    8010560b <alltraps>

80105d3c <vector70>:
.globl vector70
vector70:
  pushl $0
80105d3c:	6a 00                	push   $0x0
  pushl $70
80105d3e:	6a 46                	push   $0x46
  jmp alltraps
80105d40:	e9 c6 f8 ff ff       	jmp    8010560b <alltraps>

80105d45 <vector71>:
.globl vector71
vector71:
  pushl $0
80105d45:	6a 00                	push   $0x0
  pushl $71
80105d47:	6a 47                	push   $0x47
  jmp alltraps
80105d49:	e9 bd f8 ff ff       	jmp    8010560b <alltraps>

80105d4e <vector72>:
.globl vector72
vector72:
  pushl $0
80105d4e:	6a 00                	push   $0x0
  pushl $72
80105d50:	6a 48                	push   $0x48
  jmp alltraps
80105d52:	e9 b4 f8 ff ff       	jmp    8010560b <alltraps>

80105d57 <vector73>:
.globl vector73
vector73:
  pushl $0
80105d57:	6a 00                	push   $0x0
  pushl $73
80105d59:	6a 49                	push   $0x49
  jmp alltraps
80105d5b:	e9 ab f8 ff ff       	jmp    8010560b <alltraps>

80105d60 <vector74>:
.globl vector74
vector74:
  pushl $0
80105d60:	6a 00                	push   $0x0
  pushl $74
80105d62:	6a 4a                	push   $0x4a
  jmp alltraps
80105d64:	e9 a2 f8 ff ff       	jmp    8010560b <alltraps>

80105d69 <vector75>:
.globl vector75
vector75:
  pushl $0
80105d69:	6a 00                	push   $0x0
  pushl $75
80105d6b:	6a 4b                	push   $0x4b
  jmp alltraps
80105d6d:	e9 99 f8 ff ff       	jmp    8010560b <alltraps>

80105d72 <vector76>:
.globl vector76
vector76:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $76
80105d74:	6a 4c                	push   $0x4c
  jmp alltraps
80105d76:	e9 90 f8 ff ff       	jmp    8010560b <alltraps>

80105d7b <vector77>:
.globl vector77
vector77:
  pushl $0
80105d7b:	6a 00                	push   $0x0
  pushl $77
80105d7d:	6a 4d                	push   $0x4d
  jmp alltraps
80105d7f:	e9 87 f8 ff ff       	jmp    8010560b <alltraps>

80105d84 <vector78>:
.globl vector78
vector78:
  pushl $0
80105d84:	6a 00                	push   $0x0
  pushl $78
80105d86:	6a 4e                	push   $0x4e
  jmp alltraps
80105d88:	e9 7e f8 ff ff       	jmp    8010560b <alltraps>

80105d8d <vector79>:
.globl vector79
vector79:
  pushl $0
80105d8d:	6a 00                	push   $0x0
  pushl $79
80105d8f:	6a 4f                	push   $0x4f
  jmp alltraps
80105d91:	e9 75 f8 ff ff       	jmp    8010560b <alltraps>

80105d96 <vector80>:
.globl vector80
vector80:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $80
80105d98:	6a 50                	push   $0x50
  jmp alltraps
80105d9a:	e9 6c f8 ff ff       	jmp    8010560b <alltraps>

80105d9f <vector81>:
.globl vector81
vector81:
  pushl $0
80105d9f:	6a 00                	push   $0x0
  pushl $81
80105da1:	6a 51                	push   $0x51
  jmp alltraps
80105da3:	e9 63 f8 ff ff       	jmp    8010560b <alltraps>

80105da8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105da8:	6a 00                	push   $0x0
  pushl $82
80105daa:	6a 52                	push   $0x52
  jmp alltraps
80105dac:	e9 5a f8 ff ff       	jmp    8010560b <alltraps>

80105db1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105db1:	6a 00                	push   $0x0
  pushl $83
80105db3:	6a 53                	push   $0x53
  jmp alltraps
80105db5:	e9 51 f8 ff ff       	jmp    8010560b <alltraps>

80105dba <vector84>:
.globl vector84
vector84:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $84
80105dbc:	6a 54                	push   $0x54
  jmp alltraps
80105dbe:	e9 48 f8 ff ff       	jmp    8010560b <alltraps>

80105dc3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105dc3:	6a 00                	push   $0x0
  pushl $85
80105dc5:	6a 55                	push   $0x55
  jmp alltraps
80105dc7:	e9 3f f8 ff ff       	jmp    8010560b <alltraps>

80105dcc <vector86>:
.globl vector86
vector86:
  pushl $0
80105dcc:	6a 00                	push   $0x0
  pushl $86
80105dce:	6a 56                	push   $0x56
  jmp alltraps
80105dd0:	e9 36 f8 ff ff       	jmp    8010560b <alltraps>

80105dd5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105dd5:	6a 00                	push   $0x0
  pushl $87
80105dd7:	6a 57                	push   $0x57
  jmp alltraps
80105dd9:	e9 2d f8 ff ff       	jmp    8010560b <alltraps>

80105dde <vector88>:
.globl vector88
vector88:
  pushl $0
80105dde:	6a 00                	push   $0x0
  pushl $88
80105de0:	6a 58                	push   $0x58
  jmp alltraps
80105de2:	e9 24 f8 ff ff       	jmp    8010560b <alltraps>

80105de7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105de7:	6a 00                	push   $0x0
  pushl $89
80105de9:	6a 59                	push   $0x59
  jmp alltraps
80105deb:	e9 1b f8 ff ff       	jmp    8010560b <alltraps>

80105df0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105df0:	6a 00                	push   $0x0
  pushl $90
80105df2:	6a 5a                	push   $0x5a
  jmp alltraps
80105df4:	e9 12 f8 ff ff       	jmp    8010560b <alltraps>

80105df9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105df9:	6a 00                	push   $0x0
  pushl $91
80105dfb:	6a 5b                	push   $0x5b
  jmp alltraps
80105dfd:	e9 09 f8 ff ff       	jmp    8010560b <alltraps>

80105e02 <vector92>:
.globl vector92
vector92:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $92
80105e04:	6a 5c                	push   $0x5c
  jmp alltraps
80105e06:	e9 00 f8 ff ff       	jmp    8010560b <alltraps>

80105e0b <vector93>:
.globl vector93
vector93:
  pushl $0
80105e0b:	6a 00                	push   $0x0
  pushl $93
80105e0d:	6a 5d                	push   $0x5d
  jmp alltraps
80105e0f:	e9 f7 f7 ff ff       	jmp    8010560b <alltraps>

80105e14 <vector94>:
.globl vector94
vector94:
  pushl $0
80105e14:	6a 00                	push   $0x0
  pushl $94
80105e16:	6a 5e                	push   $0x5e
  jmp alltraps
80105e18:	e9 ee f7 ff ff       	jmp    8010560b <alltraps>

80105e1d <vector95>:
.globl vector95
vector95:
  pushl $0
80105e1d:	6a 00                	push   $0x0
  pushl $95
80105e1f:	6a 5f                	push   $0x5f
  jmp alltraps
80105e21:	e9 e5 f7 ff ff       	jmp    8010560b <alltraps>

80105e26 <vector96>:
.globl vector96
vector96:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $96
80105e28:	6a 60                	push   $0x60
  jmp alltraps
80105e2a:	e9 dc f7 ff ff       	jmp    8010560b <alltraps>

80105e2f <vector97>:
.globl vector97
vector97:
  pushl $0
80105e2f:	6a 00                	push   $0x0
  pushl $97
80105e31:	6a 61                	push   $0x61
  jmp alltraps
80105e33:	e9 d3 f7 ff ff       	jmp    8010560b <alltraps>

80105e38 <vector98>:
.globl vector98
vector98:
  pushl $0
80105e38:	6a 00                	push   $0x0
  pushl $98
80105e3a:	6a 62                	push   $0x62
  jmp alltraps
80105e3c:	e9 ca f7 ff ff       	jmp    8010560b <alltraps>

80105e41 <vector99>:
.globl vector99
vector99:
  pushl $0
80105e41:	6a 00                	push   $0x0
  pushl $99
80105e43:	6a 63                	push   $0x63
  jmp alltraps
80105e45:	e9 c1 f7 ff ff       	jmp    8010560b <alltraps>

80105e4a <vector100>:
.globl vector100
vector100:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $100
80105e4c:	6a 64                	push   $0x64
  jmp alltraps
80105e4e:	e9 b8 f7 ff ff       	jmp    8010560b <alltraps>

80105e53 <vector101>:
.globl vector101
vector101:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $101
80105e55:	6a 65                	push   $0x65
  jmp alltraps
80105e57:	e9 af f7 ff ff       	jmp    8010560b <alltraps>

80105e5c <vector102>:
.globl vector102
vector102:
  pushl $0
80105e5c:	6a 00                	push   $0x0
  pushl $102
80105e5e:	6a 66                	push   $0x66
  jmp alltraps
80105e60:	e9 a6 f7 ff ff       	jmp    8010560b <alltraps>

80105e65 <vector103>:
.globl vector103
vector103:
  pushl $0
80105e65:	6a 00                	push   $0x0
  pushl $103
80105e67:	6a 67                	push   $0x67
  jmp alltraps
80105e69:	e9 9d f7 ff ff       	jmp    8010560b <alltraps>

80105e6e <vector104>:
.globl vector104
vector104:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $104
80105e70:	6a 68                	push   $0x68
  jmp alltraps
80105e72:	e9 94 f7 ff ff       	jmp    8010560b <alltraps>

80105e77 <vector105>:
.globl vector105
vector105:
  pushl $0
80105e77:	6a 00                	push   $0x0
  pushl $105
80105e79:	6a 69                	push   $0x69
  jmp alltraps
80105e7b:	e9 8b f7 ff ff       	jmp    8010560b <alltraps>

80105e80 <vector106>:
.globl vector106
vector106:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $106
80105e82:	6a 6a                	push   $0x6a
  jmp alltraps
80105e84:	e9 82 f7 ff ff       	jmp    8010560b <alltraps>

80105e89 <vector107>:
.globl vector107
vector107:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $107
80105e8b:	6a 6b                	push   $0x6b
  jmp alltraps
80105e8d:	e9 79 f7 ff ff       	jmp    8010560b <alltraps>

80105e92 <vector108>:
.globl vector108
vector108:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $108
80105e94:	6a 6c                	push   $0x6c
  jmp alltraps
80105e96:	e9 70 f7 ff ff       	jmp    8010560b <alltraps>

80105e9b <vector109>:
.globl vector109
vector109:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $109
80105e9d:	6a 6d                	push   $0x6d
  jmp alltraps
80105e9f:	e9 67 f7 ff ff       	jmp    8010560b <alltraps>

80105ea4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $110
80105ea6:	6a 6e                	push   $0x6e
  jmp alltraps
80105ea8:	e9 5e f7 ff ff       	jmp    8010560b <alltraps>

80105ead <vector111>:
.globl vector111
vector111:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $111
80105eaf:	6a 6f                	push   $0x6f
  jmp alltraps
80105eb1:	e9 55 f7 ff ff       	jmp    8010560b <alltraps>

80105eb6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $112
80105eb8:	6a 70                	push   $0x70
  jmp alltraps
80105eba:	e9 4c f7 ff ff       	jmp    8010560b <alltraps>

80105ebf <vector113>:
.globl vector113
vector113:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $113
80105ec1:	6a 71                	push   $0x71
  jmp alltraps
80105ec3:	e9 43 f7 ff ff       	jmp    8010560b <alltraps>

80105ec8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $114
80105eca:	6a 72                	push   $0x72
  jmp alltraps
80105ecc:	e9 3a f7 ff ff       	jmp    8010560b <alltraps>

80105ed1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $115
80105ed3:	6a 73                	push   $0x73
  jmp alltraps
80105ed5:	e9 31 f7 ff ff       	jmp    8010560b <alltraps>

80105eda <vector116>:
.globl vector116
vector116:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $116
80105edc:	6a 74                	push   $0x74
  jmp alltraps
80105ede:	e9 28 f7 ff ff       	jmp    8010560b <alltraps>

80105ee3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $117
80105ee5:	6a 75                	push   $0x75
  jmp alltraps
80105ee7:	e9 1f f7 ff ff       	jmp    8010560b <alltraps>

80105eec <vector118>:
.globl vector118
vector118:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $118
80105eee:	6a 76                	push   $0x76
  jmp alltraps
80105ef0:	e9 16 f7 ff ff       	jmp    8010560b <alltraps>

80105ef5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $119
80105ef7:	6a 77                	push   $0x77
  jmp alltraps
80105ef9:	e9 0d f7 ff ff       	jmp    8010560b <alltraps>

80105efe <vector120>:
.globl vector120
vector120:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $120
80105f00:	6a 78                	push   $0x78
  jmp alltraps
80105f02:	e9 04 f7 ff ff       	jmp    8010560b <alltraps>

80105f07 <vector121>:
.globl vector121
vector121:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $121
80105f09:	6a 79                	push   $0x79
  jmp alltraps
80105f0b:	e9 fb f6 ff ff       	jmp    8010560b <alltraps>

80105f10 <vector122>:
.globl vector122
vector122:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $122
80105f12:	6a 7a                	push   $0x7a
  jmp alltraps
80105f14:	e9 f2 f6 ff ff       	jmp    8010560b <alltraps>

80105f19 <vector123>:
.globl vector123
vector123:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $123
80105f1b:	6a 7b                	push   $0x7b
  jmp alltraps
80105f1d:	e9 e9 f6 ff ff       	jmp    8010560b <alltraps>

80105f22 <vector124>:
.globl vector124
vector124:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $124
80105f24:	6a 7c                	push   $0x7c
  jmp alltraps
80105f26:	e9 e0 f6 ff ff       	jmp    8010560b <alltraps>

80105f2b <vector125>:
.globl vector125
vector125:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $125
80105f2d:	6a 7d                	push   $0x7d
  jmp alltraps
80105f2f:	e9 d7 f6 ff ff       	jmp    8010560b <alltraps>

80105f34 <vector126>:
.globl vector126
vector126:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $126
80105f36:	6a 7e                	push   $0x7e
  jmp alltraps
80105f38:	e9 ce f6 ff ff       	jmp    8010560b <alltraps>

80105f3d <vector127>:
.globl vector127
vector127:
  pushl $0
80105f3d:	6a 00                	push   $0x0
  pushl $127
80105f3f:	6a 7f                	push   $0x7f
  jmp alltraps
80105f41:	e9 c5 f6 ff ff       	jmp    8010560b <alltraps>

80105f46 <vector128>:
.globl vector128
vector128:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $128
80105f48:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105f4d:	e9 b9 f6 ff ff       	jmp    8010560b <alltraps>

80105f52 <vector129>:
.globl vector129
vector129:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $129
80105f54:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105f59:	e9 ad f6 ff ff       	jmp    8010560b <alltraps>

80105f5e <vector130>:
.globl vector130
vector130:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $130
80105f60:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105f65:	e9 a1 f6 ff ff       	jmp    8010560b <alltraps>

80105f6a <vector131>:
.globl vector131
vector131:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $131
80105f6c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105f71:	e9 95 f6 ff ff       	jmp    8010560b <alltraps>

80105f76 <vector132>:
.globl vector132
vector132:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $132
80105f78:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105f7d:	e9 89 f6 ff ff       	jmp    8010560b <alltraps>

80105f82 <vector133>:
.globl vector133
vector133:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $133
80105f84:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105f89:	e9 7d f6 ff ff       	jmp    8010560b <alltraps>

80105f8e <vector134>:
.globl vector134
vector134:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $134
80105f90:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105f95:	e9 71 f6 ff ff       	jmp    8010560b <alltraps>

80105f9a <vector135>:
.globl vector135
vector135:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $135
80105f9c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105fa1:	e9 65 f6 ff ff       	jmp    8010560b <alltraps>

80105fa6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $136
80105fa8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105fad:	e9 59 f6 ff ff       	jmp    8010560b <alltraps>

80105fb2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $137
80105fb4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105fb9:	e9 4d f6 ff ff       	jmp    8010560b <alltraps>

80105fbe <vector138>:
.globl vector138
vector138:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $138
80105fc0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105fc5:	e9 41 f6 ff ff       	jmp    8010560b <alltraps>

80105fca <vector139>:
.globl vector139
vector139:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $139
80105fcc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105fd1:	e9 35 f6 ff ff       	jmp    8010560b <alltraps>

80105fd6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $140
80105fd8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105fdd:	e9 29 f6 ff ff       	jmp    8010560b <alltraps>

80105fe2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $141
80105fe4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105fe9:	e9 1d f6 ff ff       	jmp    8010560b <alltraps>

80105fee <vector142>:
.globl vector142
vector142:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $142
80105ff0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105ff5:	e9 11 f6 ff ff       	jmp    8010560b <alltraps>

80105ffa <vector143>:
.globl vector143
vector143:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $143
80105ffc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106001:	e9 05 f6 ff ff       	jmp    8010560b <alltraps>

80106006 <vector144>:
.globl vector144
vector144:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $144
80106008:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010600d:	e9 f9 f5 ff ff       	jmp    8010560b <alltraps>

80106012 <vector145>:
.globl vector145
vector145:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $145
80106014:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106019:	e9 ed f5 ff ff       	jmp    8010560b <alltraps>

8010601e <vector146>:
.globl vector146
vector146:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $146
80106020:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106025:	e9 e1 f5 ff ff       	jmp    8010560b <alltraps>

8010602a <vector147>:
.globl vector147
vector147:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $147
8010602c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106031:	e9 d5 f5 ff ff       	jmp    8010560b <alltraps>

80106036 <vector148>:
.globl vector148
vector148:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $148
80106038:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010603d:	e9 c9 f5 ff ff       	jmp    8010560b <alltraps>

80106042 <vector149>:
.globl vector149
vector149:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $149
80106044:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106049:	e9 bd f5 ff ff       	jmp    8010560b <alltraps>

8010604e <vector150>:
.globl vector150
vector150:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $150
80106050:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106055:	e9 b1 f5 ff ff       	jmp    8010560b <alltraps>

8010605a <vector151>:
.globl vector151
vector151:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $151
8010605c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106061:	e9 a5 f5 ff ff       	jmp    8010560b <alltraps>

80106066 <vector152>:
.globl vector152
vector152:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $152
80106068:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010606d:	e9 99 f5 ff ff       	jmp    8010560b <alltraps>

80106072 <vector153>:
.globl vector153
vector153:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $153
80106074:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106079:	e9 8d f5 ff ff       	jmp    8010560b <alltraps>

8010607e <vector154>:
.globl vector154
vector154:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $154
80106080:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106085:	e9 81 f5 ff ff       	jmp    8010560b <alltraps>

8010608a <vector155>:
.globl vector155
vector155:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $155
8010608c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106091:	e9 75 f5 ff ff       	jmp    8010560b <alltraps>

80106096 <vector156>:
.globl vector156
vector156:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $156
80106098:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010609d:	e9 69 f5 ff ff       	jmp    8010560b <alltraps>

801060a2 <vector157>:
.globl vector157
vector157:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $157
801060a4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801060a9:	e9 5d f5 ff ff       	jmp    8010560b <alltraps>

801060ae <vector158>:
.globl vector158
vector158:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $158
801060b0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801060b5:	e9 51 f5 ff ff       	jmp    8010560b <alltraps>

801060ba <vector159>:
.globl vector159
vector159:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $159
801060bc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801060c1:	e9 45 f5 ff ff       	jmp    8010560b <alltraps>

801060c6 <vector160>:
.globl vector160
vector160:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $160
801060c8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801060cd:	e9 39 f5 ff ff       	jmp    8010560b <alltraps>

801060d2 <vector161>:
.globl vector161
vector161:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $161
801060d4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801060d9:	e9 2d f5 ff ff       	jmp    8010560b <alltraps>

801060de <vector162>:
.globl vector162
vector162:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $162
801060e0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801060e5:	e9 21 f5 ff ff       	jmp    8010560b <alltraps>

801060ea <vector163>:
.globl vector163
vector163:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $163
801060ec:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801060f1:	e9 15 f5 ff ff       	jmp    8010560b <alltraps>

801060f6 <vector164>:
.globl vector164
vector164:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $164
801060f8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801060fd:	e9 09 f5 ff ff       	jmp    8010560b <alltraps>

80106102 <vector165>:
.globl vector165
vector165:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $165
80106104:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106109:	e9 fd f4 ff ff       	jmp    8010560b <alltraps>

8010610e <vector166>:
.globl vector166
vector166:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $166
80106110:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106115:	e9 f1 f4 ff ff       	jmp    8010560b <alltraps>

8010611a <vector167>:
.globl vector167
vector167:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $167
8010611c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106121:	e9 e5 f4 ff ff       	jmp    8010560b <alltraps>

80106126 <vector168>:
.globl vector168
vector168:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $168
80106128:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010612d:	e9 d9 f4 ff ff       	jmp    8010560b <alltraps>

80106132 <vector169>:
.globl vector169
vector169:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $169
80106134:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106139:	e9 cd f4 ff ff       	jmp    8010560b <alltraps>

8010613e <vector170>:
.globl vector170
vector170:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $170
80106140:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106145:	e9 c1 f4 ff ff       	jmp    8010560b <alltraps>

8010614a <vector171>:
.globl vector171
vector171:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $171
8010614c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106151:	e9 b5 f4 ff ff       	jmp    8010560b <alltraps>

80106156 <vector172>:
.globl vector172
vector172:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $172
80106158:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010615d:	e9 a9 f4 ff ff       	jmp    8010560b <alltraps>

80106162 <vector173>:
.globl vector173
vector173:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $173
80106164:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106169:	e9 9d f4 ff ff       	jmp    8010560b <alltraps>

8010616e <vector174>:
.globl vector174
vector174:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $174
80106170:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106175:	e9 91 f4 ff ff       	jmp    8010560b <alltraps>

8010617a <vector175>:
.globl vector175
vector175:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $175
8010617c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106181:	e9 85 f4 ff ff       	jmp    8010560b <alltraps>

80106186 <vector176>:
.globl vector176
vector176:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $176
80106188:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010618d:	e9 79 f4 ff ff       	jmp    8010560b <alltraps>

80106192 <vector177>:
.globl vector177
vector177:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $177
80106194:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106199:	e9 6d f4 ff ff       	jmp    8010560b <alltraps>

8010619e <vector178>:
.globl vector178
vector178:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $178
801061a0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801061a5:	e9 61 f4 ff ff       	jmp    8010560b <alltraps>

801061aa <vector179>:
.globl vector179
vector179:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $179
801061ac:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801061b1:	e9 55 f4 ff ff       	jmp    8010560b <alltraps>

801061b6 <vector180>:
.globl vector180
vector180:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $180
801061b8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801061bd:	e9 49 f4 ff ff       	jmp    8010560b <alltraps>

801061c2 <vector181>:
.globl vector181
vector181:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $181
801061c4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801061c9:	e9 3d f4 ff ff       	jmp    8010560b <alltraps>

801061ce <vector182>:
.globl vector182
vector182:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $182
801061d0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801061d5:	e9 31 f4 ff ff       	jmp    8010560b <alltraps>

801061da <vector183>:
.globl vector183
vector183:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $183
801061dc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801061e1:	e9 25 f4 ff ff       	jmp    8010560b <alltraps>

801061e6 <vector184>:
.globl vector184
vector184:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $184
801061e8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801061ed:	e9 19 f4 ff ff       	jmp    8010560b <alltraps>

801061f2 <vector185>:
.globl vector185
vector185:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $185
801061f4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801061f9:	e9 0d f4 ff ff       	jmp    8010560b <alltraps>

801061fe <vector186>:
.globl vector186
vector186:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $186
80106200:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106205:	e9 01 f4 ff ff       	jmp    8010560b <alltraps>

8010620a <vector187>:
.globl vector187
vector187:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $187
8010620c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106211:	e9 f5 f3 ff ff       	jmp    8010560b <alltraps>

80106216 <vector188>:
.globl vector188
vector188:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $188
80106218:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010621d:	e9 e9 f3 ff ff       	jmp    8010560b <alltraps>

80106222 <vector189>:
.globl vector189
vector189:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $189
80106224:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106229:	e9 dd f3 ff ff       	jmp    8010560b <alltraps>

8010622e <vector190>:
.globl vector190
vector190:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $190
80106230:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106235:	e9 d1 f3 ff ff       	jmp    8010560b <alltraps>

8010623a <vector191>:
.globl vector191
vector191:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $191
8010623c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106241:	e9 c5 f3 ff ff       	jmp    8010560b <alltraps>

80106246 <vector192>:
.globl vector192
vector192:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $192
80106248:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010624d:	e9 b9 f3 ff ff       	jmp    8010560b <alltraps>

80106252 <vector193>:
.globl vector193
vector193:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $193
80106254:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106259:	e9 ad f3 ff ff       	jmp    8010560b <alltraps>

8010625e <vector194>:
.globl vector194
vector194:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $194
80106260:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106265:	e9 a1 f3 ff ff       	jmp    8010560b <alltraps>

8010626a <vector195>:
.globl vector195
vector195:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $195
8010626c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106271:	e9 95 f3 ff ff       	jmp    8010560b <alltraps>

80106276 <vector196>:
.globl vector196
vector196:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $196
80106278:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010627d:	e9 89 f3 ff ff       	jmp    8010560b <alltraps>

80106282 <vector197>:
.globl vector197
vector197:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $197
80106284:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106289:	e9 7d f3 ff ff       	jmp    8010560b <alltraps>

8010628e <vector198>:
.globl vector198
vector198:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $198
80106290:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106295:	e9 71 f3 ff ff       	jmp    8010560b <alltraps>

8010629a <vector199>:
.globl vector199
vector199:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $199
8010629c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801062a1:	e9 65 f3 ff ff       	jmp    8010560b <alltraps>

801062a6 <vector200>:
.globl vector200
vector200:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $200
801062a8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801062ad:	e9 59 f3 ff ff       	jmp    8010560b <alltraps>

801062b2 <vector201>:
.globl vector201
vector201:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $201
801062b4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801062b9:	e9 4d f3 ff ff       	jmp    8010560b <alltraps>

801062be <vector202>:
.globl vector202
vector202:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $202
801062c0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801062c5:	e9 41 f3 ff ff       	jmp    8010560b <alltraps>

801062ca <vector203>:
.globl vector203
vector203:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $203
801062cc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801062d1:	e9 35 f3 ff ff       	jmp    8010560b <alltraps>

801062d6 <vector204>:
.globl vector204
vector204:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $204
801062d8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801062dd:	e9 29 f3 ff ff       	jmp    8010560b <alltraps>

801062e2 <vector205>:
.globl vector205
vector205:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $205
801062e4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801062e9:	e9 1d f3 ff ff       	jmp    8010560b <alltraps>

801062ee <vector206>:
.globl vector206
vector206:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $206
801062f0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801062f5:	e9 11 f3 ff ff       	jmp    8010560b <alltraps>

801062fa <vector207>:
.globl vector207
vector207:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $207
801062fc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106301:	e9 05 f3 ff ff       	jmp    8010560b <alltraps>

80106306 <vector208>:
.globl vector208
vector208:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $208
80106308:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010630d:	e9 f9 f2 ff ff       	jmp    8010560b <alltraps>

80106312 <vector209>:
.globl vector209
vector209:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $209
80106314:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106319:	e9 ed f2 ff ff       	jmp    8010560b <alltraps>

8010631e <vector210>:
.globl vector210
vector210:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $210
80106320:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106325:	e9 e1 f2 ff ff       	jmp    8010560b <alltraps>

8010632a <vector211>:
.globl vector211
vector211:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $211
8010632c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106331:	e9 d5 f2 ff ff       	jmp    8010560b <alltraps>

80106336 <vector212>:
.globl vector212
vector212:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $212
80106338:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010633d:	e9 c9 f2 ff ff       	jmp    8010560b <alltraps>

80106342 <vector213>:
.globl vector213
vector213:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $213
80106344:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106349:	e9 bd f2 ff ff       	jmp    8010560b <alltraps>

8010634e <vector214>:
.globl vector214
vector214:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $214
80106350:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106355:	e9 b1 f2 ff ff       	jmp    8010560b <alltraps>

8010635a <vector215>:
.globl vector215
vector215:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $215
8010635c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106361:	e9 a5 f2 ff ff       	jmp    8010560b <alltraps>

80106366 <vector216>:
.globl vector216
vector216:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $216
80106368:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010636d:	e9 99 f2 ff ff       	jmp    8010560b <alltraps>

80106372 <vector217>:
.globl vector217
vector217:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $217
80106374:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106379:	e9 8d f2 ff ff       	jmp    8010560b <alltraps>

8010637e <vector218>:
.globl vector218
vector218:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $218
80106380:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106385:	e9 81 f2 ff ff       	jmp    8010560b <alltraps>

8010638a <vector219>:
.globl vector219
vector219:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $219
8010638c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106391:	e9 75 f2 ff ff       	jmp    8010560b <alltraps>

80106396 <vector220>:
.globl vector220
vector220:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $220
80106398:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010639d:	e9 69 f2 ff ff       	jmp    8010560b <alltraps>

801063a2 <vector221>:
.globl vector221
vector221:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $221
801063a4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801063a9:	e9 5d f2 ff ff       	jmp    8010560b <alltraps>

801063ae <vector222>:
.globl vector222
vector222:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $222
801063b0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801063b5:	e9 51 f2 ff ff       	jmp    8010560b <alltraps>

801063ba <vector223>:
.globl vector223
vector223:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $223
801063bc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801063c1:	e9 45 f2 ff ff       	jmp    8010560b <alltraps>

801063c6 <vector224>:
.globl vector224
vector224:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $224
801063c8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801063cd:	e9 39 f2 ff ff       	jmp    8010560b <alltraps>

801063d2 <vector225>:
.globl vector225
vector225:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $225
801063d4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801063d9:	e9 2d f2 ff ff       	jmp    8010560b <alltraps>

801063de <vector226>:
.globl vector226
vector226:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $226
801063e0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801063e5:	e9 21 f2 ff ff       	jmp    8010560b <alltraps>

801063ea <vector227>:
.globl vector227
vector227:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $227
801063ec:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801063f1:	e9 15 f2 ff ff       	jmp    8010560b <alltraps>

801063f6 <vector228>:
.globl vector228
vector228:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $228
801063f8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801063fd:	e9 09 f2 ff ff       	jmp    8010560b <alltraps>

80106402 <vector229>:
.globl vector229
vector229:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $229
80106404:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106409:	e9 fd f1 ff ff       	jmp    8010560b <alltraps>

8010640e <vector230>:
.globl vector230
vector230:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $230
80106410:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106415:	e9 f1 f1 ff ff       	jmp    8010560b <alltraps>

8010641a <vector231>:
.globl vector231
vector231:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $231
8010641c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106421:	e9 e5 f1 ff ff       	jmp    8010560b <alltraps>

80106426 <vector232>:
.globl vector232
vector232:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $232
80106428:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010642d:	e9 d9 f1 ff ff       	jmp    8010560b <alltraps>

80106432 <vector233>:
.globl vector233
vector233:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $233
80106434:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106439:	e9 cd f1 ff ff       	jmp    8010560b <alltraps>

8010643e <vector234>:
.globl vector234
vector234:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $234
80106440:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106445:	e9 c1 f1 ff ff       	jmp    8010560b <alltraps>

8010644a <vector235>:
.globl vector235
vector235:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $235
8010644c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106451:	e9 b5 f1 ff ff       	jmp    8010560b <alltraps>

80106456 <vector236>:
.globl vector236
vector236:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $236
80106458:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010645d:	e9 a9 f1 ff ff       	jmp    8010560b <alltraps>

80106462 <vector237>:
.globl vector237
vector237:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $237
80106464:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106469:	e9 9d f1 ff ff       	jmp    8010560b <alltraps>

8010646e <vector238>:
.globl vector238
vector238:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $238
80106470:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106475:	e9 91 f1 ff ff       	jmp    8010560b <alltraps>

8010647a <vector239>:
.globl vector239
vector239:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $239
8010647c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106481:	e9 85 f1 ff ff       	jmp    8010560b <alltraps>

80106486 <vector240>:
.globl vector240
vector240:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $240
80106488:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010648d:	e9 79 f1 ff ff       	jmp    8010560b <alltraps>

80106492 <vector241>:
.globl vector241
vector241:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $241
80106494:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106499:	e9 6d f1 ff ff       	jmp    8010560b <alltraps>

8010649e <vector242>:
.globl vector242
vector242:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $242
801064a0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801064a5:	e9 61 f1 ff ff       	jmp    8010560b <alltraps>

801064aa <vector243>:
.globl vector243
vector243:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $243
801064ac:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801064b1:	e9 55 f1 ff ff       	jmp    8010560b <alltraps>

801064b6 <vector244>:
.globl vector244
vector244:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $244
801064b8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801064bd:	e9 49 f1 ff ff       	jmp    8010560b <alltraps>

801064c2 <vector245>:
.globl vector245
vector245:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $245
801064c4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801064c9:	e9 3d f1 ff ff       	jmp    8010560b <alltraps>

801064ce <vector246>:
.globl vector246
vector246:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $246
801064d0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801064d5:	e9 31 f1 ff ff       	jmp    8010560b <alltraps>

801064da <vector247>:
.globl vector247
vector247:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $247
801064dc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801064e1:	e9 25 f1 ff ff       	jmp    8010560b <alltraps>

801064e6 <vector248>:
.globl vector248
vector248:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $248
801064e8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801064ed:	e9 19 f1 ff ff       	jmp    8010560b <alltraps>

801064f2 <vector249>:
.globl vector249
vector249:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $249
801064f4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801064f9:	e9 0d f1 ff ff       	jmp    8010560b <alltraps>

801064fe <vector250>:
.globl vector250
vector250:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $250
80106500:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106505:	e9 01 f1 ff ff       	jmp    8010560b <alltraps>

8010650a <vector251>:
.globl vector251
vector251:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $251
8010650c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106511:	e9 f5 f0 ff ff       	jmp    8010560b <alltraps>

80106516 <vector252>:
.globl vector252
vector252:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $252
80106518:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010651d:	e9 e9 f0 ff ff       	jmp    8010560b <alltraps>

80106522 <vector253>:
.globl vector253
vector253:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $253
80106524:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106529:	e9 dd f0 ff ff       	jmp    8010560b <alltraps>

8010652e <vector254>:
.globl vector254
vector254:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $254
80106530:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106535:	e9 d1 f0 ff ff       	jmp    8010560b <alltraps>

8010653a <vector255>:
.globl vector255
vector255:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $255
8010653c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106541:	e9 c5 f0 ff ff       	jmp    8010560b <alltraps>
80106546:	66 90                	xchg   %ax,%ax
80106548:	66 90                	xchg   %ax,%ax
8010654a:	66 90                	xchg   %ax,%ax
8010654c:	66 90                	xchg   %ax,%ax
8010654e:	66 90                	xchg   %ax,%ax

80106550 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	57                   	push   %edi
80106554:	56                   	push   %esi
80106555:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106557:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010655a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010655b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010655e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106561:	8b 1f                	mov    (%edi),%ebx
80106563:	f6 c3 01             	test   $0x1,%bl
80106566:	74 28                	je     80106590 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106568:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010656e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106574:	c1 ee 0a             	shr    $0xa,%esi
}
80106577:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010657a:	89 f2                	mov    %esi,%edx
8010657c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106582:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106585:	5b                   	pop    %ebx
80106586:	5e                   	pop    %esi
80106587:	5f                   	pop    %edi
80106588:	5d                   	pop    %ebp
80106589:	c3                   	ret    
8010658a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106590:	85 c9                	test   %ecx,%ecx
80106592:	74 34                	je     801065c8 <walkpgdir+0x78>
80106594:	e8 07 bf ff ff       	call   801024a0 <kalloc>
80106599:	85 c0                	test   %eax,%eax
8010659b:	89 c3                	mov    %eax,%ebx
8010659d:	74 29                	je     801065c8 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010659f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801065a6:	00 
801065a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065ae:	00 
801065af:	89 04 24             	mov    %eax,(%esp)
801065b2:	e8 99 de ff ff       	call   80104450 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801065b7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801065bd:	83 c8 07             	or     $0x7,%eax
801065c0:	89 07                	mov    %eax,(%edi)
801065c2:	eb b0                	jmp    80106574 <walkpgdir+0x24>
801065c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
801065c8:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801065cb:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801065cd:	5b                   	pop    %ebx
801065ce:	5e                   	pop    %esi
801065cf:	5f                   	pop    %edi
801065d0:	5d                   	pop    %ebp
801065d1:	c3                   	ret    
801065d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	56                   	push   %esi
801065e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801065e6:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801065e8:	83 ec 1c             	sub    $0x1c,%esp
801065eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801065ee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801065f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801065f7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801065fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801065fe:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106602:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106609:	29 df                	sub    %ebx,%edi
8010660b:	eb 18                	jmp    80106625 <mappages+0x45>
8010660d:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106610:	f6 00 01             	testb  $0x1,(%eax)
80106613:	75 3d                	jne    80106652 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106615:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106618:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010661b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010661d:	74 29                	je     80106648 <mappages+0x68>
      break;
    a += PGSIZE;
8010661f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106625:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106628:	b9 01 00 00 00       	mov    $0x1,%ecx
8010662d:	89 da                	mov    %ebx,%edx
8010662f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106632:	e8 19 ff ff ff       	call   80106550 <walkpgdir>
80106637:	85 c0                	test   %eax,%eax
80106639:	75 d5                	jne    80106610 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010663b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010663e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106643:	5b                   	pop    %ebx
80106644:	5e                   	pop    %esi
80106645:	5f                   	pop    %edi
80106646:	5d                   	pop    %ebp
80106647:	c3                   	ret    
80106648:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010664b:	31 c0                	xor    %eax,%eax
}
8010664d:	5b                   	pop    %ebx
8010664e:	5e                   	pop    %esi
8010664f:	5f                   	pop    %edi
80106650:	5d                   	pop    %ebp
80106651:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106652:	c7 04 24 50 77 10 80 	movl   $0x80107750,(%esp)
80106659:	e8 02 9d ff ff       	call   80100360 <panic>
8010665e:	66 90                	xchg   %ax,%ax

80106660 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	57                   	push   %edi
80106664:	89 c7                	mov    %eax,%edi
80106666:	56                   	push   %esi
80106667:	89 d6                	mov    %edx,%esi
80106669:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010666a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106670:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106673:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106679:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010667b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010667e:	72 3b                	jb     801066bb <deallocuvm.part.0+0x5b>
80106680:	eb 5e                	jmp    801066e0 <deallocuvm.part.0+0x80>
80106682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106688:	8b 10                	mov    (%eax),%edx
8010668a:	f6 c2 01             	test   $0x1,%dl
8010668d:	74 22                	je     801066b1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010668f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106695:	74 54                	je     801066eb <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106697:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010669d:	89 14 24             	mov    %edx,(%esp)
801066a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066a3:	e8 48 bc ff ff       	call   801022f0 <kfree>
      *pte = 0;
801066a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066b7:	39 f3                	cmp    %esi,%ebx
801066b9:	73 25                	jae    801066e0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
801066bb:	31 c9                	xor    %ecx,%ecx
801066bd:	89 da                	mov    %ebx,%edx
801066bf:	89 f8                	mov    %edi,%eax
801066c1:	e8 8a fe ff ff       	call   80106550 <walkpgdir>
    if(!pte)
801066c6:	85 c0                	test   %eax,%eax
801066c8:	75 be                	jne    80106688 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801066ca:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801066d0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066dc:	39 f3                	cmp    %esi,%ebx
801066de:	72 db                	jb     801066bb <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801066e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801066e3:	83 c4 1c             	add    $0x1c,%esp
801066e6:	5b                   	pop    %ebx
801066e7:	5e                   	pop    %esi
801066e8:	5f                   	pop    %edi
801066e9:	5d                   	pop    %ebp
801066ea:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801066eb:	c7 04 24 c6 70 10 80 	movl   $0x801070c6,(%esp)
801066f2:	e8 69 9c ff ff       	call   80100360 <panic>
801066f7:	89 f6                	mov    %esi,%esi
801066f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106700 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106706:	e8 d5 cf ff ff       	call   801036e0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010670b:	31 c9                	xor    %ecx,%ecx
8010670d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106712:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106718:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010671d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106721:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106726:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106729:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010672d:	31 c9                	xor    %ecx,%ecx
8010672f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106733:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106738:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010673c:	31 c9                	xor    %ecx,%ecx
8010673e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106742:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106747:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010674b:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010674d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106751:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106755:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106759:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010675d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106761:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106765:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106769:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010676d:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106771:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106776:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010677a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010677e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106782:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106786:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010678a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010678e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106792:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106796:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010679a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010679e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801067a2:	c1 e8 10             	shr    $0x10,%eax
801067a5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801067a9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801067ac:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
801067af:	c9                   	leave  
801067b0:	c3                   	ret    
801067b1:	eb 0d                	jmp    801067c0 <switchkvm>
801067b3:	90                   	nop
801067b4:	90                   	nop
801067b5:	90                   	nop
801067b6:	90                   	nop
801067b7:	90                   	nop
801067b8:	90                   	nop
801067b9:	90                   	nop
801067ba:	90                   	nop
801067bb:	90                   	nop
801067bc:	90                   	nop
801067bd:	90                   	nop
801067be:	90                   	nop
801067bf:	90                   	nop

801067c0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801067c0:	a1 c4 ba 11 80       	mov    0x8011bac4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801067c5:	55                   	push   %ebp
801067c6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801067c8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801067cd:	0f 22 d8             	mov    %eax,%cr3
}
801067d0:	5d                   	pop    %ebp
801067d1:	c3                   	ret    
801067d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067e0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	57                   	push   %edi
801067e4:	56                   	push   %esi
801067e5:	53                   	push   %ebx
801067e6:	83 ec 1c             	sub    $0x1c,%esp
801067e9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801067ec:	85 f6                	test   %esi,%esi
801067ee:	0f 84 cd 00 00 00    	je     801068c1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801067f4:	8b 46 08             	mov    0x8(%esi),%eax
801067f7:	85 c0                	test   %eax,%eax
801067f9:	0f 84 da 00 00 00    	je     801068d9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801067ff:	8b 7e 04             	mov    0x4(%esi),%edi
80106802:	85 ff                	test   %edi,%edi
80106804:	0f 84 c3 00 00 00    	je     801068cd <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
8010680a:	e8 91 da ff ff       	call   801042a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010680f:	e8 4c ce ff ff       	call   80103660 <mycpu>
80106814:	89 c3                	mov    %eax,%ebx
80106816:	e8 45 ce ff ff       	call   80103660 <mycpu>
8010681b:	89 c7                	mov    %eax,%edi
8010681d:	e8 3e ce ff ff       	call   80103660 <mycpu>
80106822:	83 c7 08             	add    $0x8,%edi
80106825:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106828:	e8 33 ce ff ff       	call   80103660 <mycpu>
8010682d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106830:	ba 67 00 00 00       	mov    $0x67,%edx
80106835:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010683c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106843:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010684a:	83 c1 08             	add    $0x8,%ecx
8010684d:	c1 e9 10             	shr    $0x10,%ecx
80106850:	83 c0 08             	add    $0x8,%eax
80106853:	c1 e8 18             	shr    $0x18,%eax
80106856:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010685c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106863:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106869:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010686e:	e8 ed cd ff ff       	call   80103660 <mycpu>
80106873:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010687a:	e8 e1 cd ff ff       	call   80103660 <mycpu>
8010687f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106884:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106888:	e8 d3 cd ff ff       	call   80103660 <mycpu>
8010688d:	8b 56 08             	mov    0x8(%esi),%edx
80106890:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106896:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106899:	e8 c2 cd ff ff       	call   80103660 <mycpu>
8010689e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801068a2:	b8 28 00 00 00       	mov    $0x28,%eax
801068a7:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801068aa:	8b 46 04             	mov    0x4(%esi),%eax
801068ad:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068b2:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801068b5:	83 c4 1c             	add    $0x1c,%esp
801068b8:	5b                   	pop    %ebx
801068b9:	5e                   	pop    %esi
801068ba:	5f                   	pop    %edi
801068bb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801068bc:	e9 1f da ff ff       	jmp    801042e0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801068c1:	c7 04 24 56 77 10 80 	movl   $0x80107756,(%esp)
801068c8:	e8 93 9a ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801068cd:	c7 04 24 81 77 10 80 	movl   $0x80107781,(%esp)
801068d4:	e8 87 9a ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801068d9:	c7 04 24 6c 77 10 80 	movl   $0x8010776c,(%esp)
801068e0:	e8 7b 9a ff ff       	call   80100360 <panic>
801068e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068f0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
801068f5:	53                   	push   %ebx
801068f6:	83 ec 1c             	sub    $0x1c,%esp
801068f9:	8b 75 10             	mov    0x10(%ebp),%esi
801068fc:	8b 45 08             	mov    0x8(%ebp),%eax
801068ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106902:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106908:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010690b:	77 54                	ja     80106961 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
8010690d:	e8 8e bb ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106912:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106919:	00 
8010691a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106921:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106922:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106924:	89 04 24             	mov    %eax,(%esp)
80106927:	e8 24 db ff ff       	call   80104450 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010692c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106932:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106937:	89 04 24             	mov    %eax,(%esp)
8010693a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010693d:	31 d2                	xor    %edx,%edx
8010693f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106946:	00 
80106947:	e8 94 fc ff ff       	call   801065e0 <mappages>
  memmove(mem, init, sz);
8010694c:	89 75 10             	mov    %esi,0x10(%ebp)
8010694f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106952:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106955:	83 c4 1c             	add    $0x1c,%esp
80106958:	5b                   	pop    %ebx
80106959:	5e                   	pop    %esi
8010695a:	5f                   	pop    %edi
8010695b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
8010695c:	e9 8f db ff ff       	jmp    801044f0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106961:	c7 04 24 95 77 10 80 	movl   $0x80107795,(%esp)
80106968:	e8 f3 99 ff ff       	call   80100360 <panic>
8010696d:	8d 76 00             	lea    0x0(%esi),%esi

80106970 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	57                   	push   %edi
80106974:	56                   	push   %esi
80106975:	53                   	push   %ebx
80106976:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106979:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106980:	0f 85 98 00 00 00    	jne    80106a1e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106986:	8b 75 18             	mov    0x18(%ebp),%esi
80106989:	31 db                	xor    %ebx,%ebx
8010698b:	85 f6                	test   %esi,%esi
8010698d:	75 1a                	jne    801069a9 <loaduvm+0x39>
8010698f:	eb 77                	jmp    80106a08 <loaduvm+0x98>
80106991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106998:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010699e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801069a4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801069a7:	76 5f                	jbe    80106a08 <loaduvm+0x98>
801069a9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801069ac:	31 c9                	xor    %ecx,%ecx
801069ae:	8b 45 08             	mov    0x8(%ebp),%eax
801069b1:	01 da                	add    %ebx,%edx
801069b3:	e8 98 fb ff ff       	call   80106550 <walkpgdir>
801069b8:	85 c0                	test   %eax,%eax
801069ba:	74 56                	je     80106a12 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801069bc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801069be:	bf 00 10 00 00       	mov    $0x1000,%edi
801069c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801069c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801069cb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801069d1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801069d4:	05 00 00 00 80       	add    $0x80000000,%eax
801069d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801069dd:	8b 45 10             	mov    0x10(%ebp),%eax
801069e0:	01 d9                	add    %ebx,%ecx
801069e2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801069e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801069ea:	89 04 24             	mov    %eax,(%esp)
801069ed:	e8 6e af ff ff       	call   80101960 <readi>
801069f2:	39 f8                	cmp    %edi,%eax
801069f4:	74 a2                	je     80106998 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801069f6:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801069f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801069fe:	5b                   	pop    %ebx
801069ff:	5e                   	pop    %esi
80106a00:	5f                   	pop    %edi
80106a01:	5d                   	pop    %ebp
80106a02:	c3                   	ret    
80106a03:	90                   	nop
80106a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a08:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106a0b:	31 c0                	xor    %eax,%eax
}
80106a0d:	5b                   	pop    %ebx
80106a0e:	5e                   	pop    %esi
80106a0f:	5f                   	pop    %edi
80106a10:	5d                   	pop    %ebp
80106a11:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106a12:	c7 04 24 af 77 10 80 	movl   $0x801077af,(%esp)
80106a19:	e8 42 99 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106a1e:	c7 04 24 50 78 10 80 	movl   $0x80107850,(%esp)
80106a25:	e8 36 99 ff ff       	call   80100360 <panic>
80106a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a30 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	57                   	push   %edi
80106a34:	56                   	push   %esi
80106a35:	53                   	push   %ebx
80106a36:	83 ec 1c             	sub    $0x1c,%esp
80106a39:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106a3c:	85 ff                	test   %edi,%edi
80106a3e:	0f 88 7e 00 00 00    	js     80106ac2 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106a44:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106a4a:	72 78                	jb     80106ac4 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106a4c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106a52:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106a58:	39 df                	cmp    %ebx,%edi
80106a5a:	77 4a                	ja     80106aa6 <allocuvm+0x76>
80106a5c:	eb 72                	jmp    80106ad0 <allocuvm+0xa0>
80106a5e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106a60:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a67:	00 
80106a68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a6f:	00 
80106a70:	89 04 24             	mov    %eax,(%esp)
80106a73:	e8 d8 d9 ff ff       	call   80104450 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106a78:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a83:	89 04 24             	mov    %eax,(%esp)
80106a86:	8b 45 08             	mov    0x8(%ebp),%eax
80106a89:	89 da                	mov    %ebx,%edx
80106a8b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106a92:	00 
80106a93:	e8 48 fb ff ff       	call   801065e0 <mappages>
80106a98:	85 c0                	test   %eax,%eax
80106a9a:	78 44                	js     80106ae0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106a9c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106aa2:	39 df                	cmp    %ebx,%edi
80106aa4:	76 2a                	jbe    80106ad0 <allocuvm+0xa0>
    mem = kalloc();
80106aa6:	e8 f5 b9 ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
80106aab:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106aad:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106aaf:	75 af                	jne    80106a60 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106ab1:	c7 04 24 cd 77 10 80 	movl   $0x801077cd,(%esp)
80106ab8:	e8 93 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106abd:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ac0:	77 48                	ja     80106b0a <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106ac2:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106ac4:	83 c4 1c             	add    $0x1c,%esp
80106ac7:	5b                   	pop    %ebx
80106ac8:	5e                   	pop    %esi
80106ac9:	5f                   	pop    %edi
80106aca:	5d                   	pop    %ebp
80106acb:	c3                   	ret    
80106acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ad0:	83 c4 1c             	add    $0x1c,%esp
80106ad3:	89 f8                	mov    %edi,%eax
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106ae0:	c7 04 24 e5 77 10 80 	movl   $0x801077e5,(%esp)
80106ae7:	e8 64 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106aec:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106aef:	76 0d                	jbe    80106afe <allocuvm+0xce>
80106af1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106af4:	89 fa                	mov    %edi,%edx
80106af6:	8b 45 08             	mov    0x8(%ebp),%eax
80106af9:	e8 62 fb ff ff       	call   80106660 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106afe:	89 34 24             	mov    %esi,(%esp)
80106b01:	e8 ea b7 ff ff       	call   801022f0 <kfree>
      return 0;
80106b06:	31 c0                	xor    %eax,%eax
80106b08:	eb ba                	jmp    80106ac4 <allocuvm+0x94>
80106b0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b0d:	89 fa                	mov    %edi,%edx
80106b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b12:	e8 49 fb ff ff       	call   80106660 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106b17:	31 c0                	xor    %eax,%eax
80106b19:	eb a9                	jmp    80106ac4 <allocuvm+0x94>
80106b1b:	90                   	nop
80106b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b20 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b26:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106b29:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b2c:	39 d1                	cmp    %edx,%ecx
80106b2e:	73 08                	jae    80106b38 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b30:	5d                   	pop    %ebp
80106b31:	e9 2a fb ff ff       	jmp    80106660 <deallocuvm.part.0>
80106b36:	66 90                	xchg   %ax,%ax
80106b38:	89 d0                	mov    %edx,%eax
80106b3a:	5d                   	pop    %ebp
80106b3b:	c3                   	ret    
80106b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	56                   	push   %esi
80106b44:	53                   	push   %ebx
80106b45:	83 ec 10             	sub    $0x10,%esp
80106b48:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106b4b:	85 f6                	test   %esi,%esi
80106b4d:	74 59                	je     80106ba8 <freevm+0x68>
80106b4f:	31 c9                	xor    %ecx,%ecx
80106b51:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106b56:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b58:	31 db                	xor    %ebx,%ebx
80106b5a:	e8 01 fb ff ff       	call   80106660 <deallocuvm.part.0>
80106b5f:	eb 12                	jmp    80106b73 <freevm+0x33>
80106b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b68:	83 c3 01             	add    $0x1,%ebx
80106b6b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b71:	74 27                	je     80106b9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106b73:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106b76:	f6 c2 01             	test   $0x1,%dl
80106b79:	74 ed                	je     80106b68 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b7b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b81:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b84:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106b8a:	89 14 24             	mov    %edx,(%esp)
80106b8d:	e8 5e b7 ff ff       	call   801022f0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b92:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b98:	75 d9                	jne    80106b73 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106b9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106b9d:	83 c4 10             	add    $0x10,%esp
80106ba0:	5b                   	pop    %ebx
80106ba1:	5e                   	pop    %esi
80106ba2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106ba3:	e9 48 b7 ff ff       	jmp    801022f0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106ba8:	c7 04 24 01 78 10 80 	movl   $0x80107801,(%esp)
80106baf:	e8 ac 97 ff ff       	call   80100360 <panic>
80106bb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106bc0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	56                   	push   %esi
80106bc4:	53                   	push   %ebx
80106bc5:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106bc8:	e8 d3 b8 ff ff       	call   801024a0 <kalloc>
80106bcd:	85 c0                	test   %eax,%eax
80106bcf:	89 c6                	mov    %eax,%esi
80106bd1:	74 6d                	je     80106c40 <setupkvm+0x80>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106bd3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bda:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106bdb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106be0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106be7:	00 
80106be8:	89 04 24             	mov    %eax,(%esp)
80106beb:	e8 60 d8 ff ff       	call   80104450 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106bf0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106bf3:	8b 43 04             	mov    0x4(%ebx),%eax
80106bf6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106bf9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bfd:	8b 13                	mov    (%ebx),%edx
80106bff:	89 04 24             	mov    %eax,(%esp)
80106c02:	29 c1                	sub    %eax,%ecx
80106c04:	89 f0                	mov    %esi,%eax
80106c06:	e8 d5 f9 ff ff       	call   801065e0 <mappages>
80106c0b:	85 c0                	test   %eax,%eax
80106c0d:	78 19                	js     80106c28 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c0f:	83 c3 10             	add    $0x10,%ebx
80106c12:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106c18:	72 d6                	jb     80106bf0 <setupkvm+0x30>
80106c1a:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106c1c:	83 c4 10             	add    $0x10,%esp
80106c1f:	5b                   	pop    %ebx
80106c20:	5e                   	pop    %esi
80106c21:	5d                   	pop    %ebp
80106c22:	c3                   	ret    
80106c23:	90                   	nop
80106c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106c28:	89 34 24             	mov    %esi,(%esp)
80106c2b:	e8 10 ff ff ff       	call   80106b40 <freevm>
      return 0;
    }
  return pgdir;
}
80106c30:	83 c4 10             	add    $0x10,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106c33:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106c35:	5b                   	pop    %ebx
80106c36:	5e                   	pop    %esi
80106c37:	5d                   	pop    %ebp
80106c38:	c3                   	ret    
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106c40:	31 c0                	xor    %eax,%eax
80106c42:	eb d8                	jmp    80106c1c <setupkvm+0x5c>
80106c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c50 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106c56:	e8 65 ff ff ff       	call   80106bc0 <setupkvm>
80106c5b:	a3 c4 ba 11 80       	mov    %eax,0x8011bac4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c60:	05 00 00 00 80       	add    $0x80000000,%eax
80106c65:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106c68:	c9                   	leave  
80106c69:	c3                   	ret    
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c70 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c71:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c73:	89 e5                	mov    %esp,%ebp
80106c75:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c7e:	e8 cd f8 ff ff       	call   80106550 <walkpgdir>
  if(pte == 0)
80106c83:	85 c0                	test   %eax,%eax
80106c85:	74 05                	je     80106c8c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106c87:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106c8a:	c9                   	leave  
80106c8b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106c8c:	c7 04 24 12 78 10 80 	movl   $0x80107812,(%esp)
80106c93:	e8 c8 96 ff ff       	call   80100360 <panic>
80106c98:	90                   	nop
80106c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ca0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ca9:	e8 12 ff ff ff       	call   80106bc0 <setupkvm>
80106cae:	85 c0                	test   %eax,%eax
80106cb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cb3:	0f 84 b9 00 00 00    	je     80106d72 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cbc:	85 c0                	test   %eax,%eax
80106cbe:	0f 84 94 00 00 00    	je     80106d58 <copyuvm+0xb8>
80106cc4:	31 ff                	xor    %edi,%edi
80106cc6:	eb 48                	jmp    80106d10 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106cc8:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106cce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106cd5:	00 
80106cd6:	89 74 24 04          	mov    %esi,0x4(%esp)
80106cda:	89 04 24             	mov    %eax,(%esp)
80106cdd:	e8 0e d8 ff ff       	call   801044f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ce5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cea:	89 fa                	mov    %edi,%edx
80106cec:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cf0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cf6:	89 04 24             	mov    %eax,(%esp)
80106cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cfc:	e8 df f8 ff ff       	call   801065e0 <mappages>
80106d01:	85 c0                	test   %eax,%eax
80106d03:	78 63                	js     80106d68 <copyuvm+0xc8>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106d05:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106d0b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106d0e:	76 48                	jbe    80106d58 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106d10:	8b 45 08             	mov    0x8(%ebp),%eax
80106d13:	31 c9                	xor    %ecx,%ecx
80106d15:	89 fa                	mov    %edi,%edx
80106d17:	e8 34 f8 ff ff       	call   80106550 <walkpgdir>
80106d1c:	85 c0                	test   %eax,%eax
80106d1e:	74 62                	je     80106d82 <copyuvm+0xe2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106d20:	8b 00                	mov    (%eax),%eax
80106d22:	a8 01                	test   $0x1,%al
80106d24:	74 50                	je     80106d76 <copyuvm+0xd6>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106d26:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106d28:	25 ff 0f 00 00       	and    $0xfff,%eax
80106d2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106d30:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106d36:	e8 65 b7 ff ff       	call   801024a0 <kalloc>
80106d3b:	85 c0                	test   %eax,%eax
80106d3d:	89 c3                	mov    %eax,%ebx
80106d3f:	75 87                	jne    80106cc8 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106d41:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d44:	89 04 24             	mov    %eax,(%esp)
80106d47:	e8 f4 fd ff ff       	call   80106b40 <freevm>
  return 0;
80106d4c:	31 c0                	xor    %eax,%eax
}
80106d4e:	83 c4 2c             	add    $0x2c,%esp
80106d51:	5b                   	pop    %ebx
80106d52:	5e                   	pop    %esi
80106d53:	5f                   	pop    %edi
80106d54:	5d                   	pop    %ebp
80106d55:	c3                   	ret    
80106d56:	66 90                	xchg   %ax,%ax
80106d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d5b:	83 c4 2c             	add    $0x2c,%esp
80106d5e:	5b                   	pop    %ebx
80106d5f:	5e                   	pop    %esi
80106d60:	5f                   	pop    %edi
80106d61:	5d                   	pop    %ebp
80106d62:	c3                   	ret    
80106d63:	90                   	nop
80106d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80106d68:	89 1c 24             	mov    %ebx,(%esp)
80106d6b:	e8 80 b5 ff ff       	call   801022f0 <kfree>
      goto bad;
80106d70:	eb cf                	jmp    80106d41 <copyuvm+0xa1>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106d72:	31 c0                	xor    %eax,%eax
80106d74:	eb d8                	jmp    80106d4e <copyuvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106d76:	c7 04 24 36 78 10 80 	movl   $0x80107836,(%esp)
80106d7d:	e8 de 95 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106d82:	c7 04 24 1c 78 10 80 	movl   $0x8010781c,(%esp)
80106d89:	e8 d2 95 ff ff       	call   80100360 <panic>
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d91:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d93:	89 e5                	mov    %esp,%ebp
80106d95:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9e:	e8 ad f7 ff ff       	call   80106550 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106da3:	8b 00                	mov    (%eax),%eax
80106da5:	89 c2                	mov    %eax,%edx
80106da7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106daa:	83 fa 05             	cmp    $0x5,%edx
80106dad:	75 11                	jne    80106dc0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106daf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106db4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106db9:	c9                   	leave  
80106dba:	c3                   	ret    
80106dbb:	90                   	nop
80106dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106dc0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106dc2:	c9                   	leave  
80106dc3:	c3                   	ret    
80106dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106dd0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ddf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106de2:	85 db                	test   %ebx,%ebx
80106de4:	75 3a                	jne    80106e20 <copyout+0x50>
80106de6:	eb 68                	jmp    80106e50 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106de8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106deb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ded:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106df1:	29 ca                	sub    %ecx,%edx
80106df3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106df9:	39 da                	cmp    %ebx,%edx
80106dfb:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106dfe:	29 f1                	sub    %esi,%ecx
80106e00:	01 c8                	add    %ecx,%eax
80106e02:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e06:	89 04 24             	mov    %eax,(%esp)
80106e09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106e0c:	e8 df d6 ff ff       	call   801044f0 <memmove>
    len -= n;
    buf += n;
80106e11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106e14:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106e1a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e1c:	29 d3                	sub    %edx,%ebx
80106e1e:	74 30                	je     80106e50 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106e20:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106e23:	89 ce                	mov    %ecx,%esi
80106e25:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106e2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106e2f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106e32:	89 04 24             	mov    %eax,(%esp)
80106e35:	e8 56 ff ff ff       	call   80106d90 <uva2ka>
    if(pa0 == 0)
80106e3a:	85 c0                	test   %eax,%eax
80106e3c:	75 aa                	jne    80106de8 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106e3e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106e46:	5b                   	pop    %ebx
80106e47:	5e                   	pop    %esi
80106e48:	5f                   	pop    %edi
80106e49:	5d                   	pop    %ebp
80106e4a:	c3                   	ret    
80106e4b:	90                   	nop
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e50:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106e53:	31 c0                	xor    %eax,%eax
}
80106e55:	5b                   	pop    %ebx
80106e56:	5e                   	pop    %esi
80106e57:	5f                   	pop    %edi
80106e58:	5d                   	pop    %ebp
80106e59:	c3                   	ret    
