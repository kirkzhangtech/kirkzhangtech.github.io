---
title: go标准库解析
categories:
- golang
tag: golang
---
# 1. tar

## Constants

  ```golang
  const (
    // Type '0' indicates a regular file.
    TypeReg  = '0'
    TypeRegA = '\x00' // Deprecated: Use TypeReg instead.

    // Type '1' to '6' are header-only flags and may not have a data body.
    TypeLink    = '1' // Hard link
    TypeSymlink = '2' // Symbolic link
    TypeChar    = '3' // Character device node
    TypeBlock   = '4' // Block device node
    TypeDir     = '5' // Directory
    TypeFifo    = '6' // FIFO node

    // Type '7' is reserved.
    TypeCont = '7'

    // Type 'x' is used by the PAX format to store key-value records that
    // are only relevant to the next file.
    // This package transparently handles these types.
    TypeXHeader = 'x'

    // Type 'g' is used by the PAX format to store key-value records that
    // are relevant to all subsequent files.
    // This package only supports parsing and composing such headers,
    // but does not currently support persisting the global state across files.
    TypeXGlobalHeader = 'g'

    // Type 'S' indicates a sparse file in the GNU format.
    TypeGNUSparse = 'S'

    // Types 'L' and 'K' are used by the GNU format for a meta file
    // used to store the path or link name for the next file.
    // This package transparently handles these types.
    TypeGNULongName = 'L'
    TypeGNULongLink = 'K'
  )
  ```

## Variables

  ```golang
  var (
    ErrHeader          = errors.New("archive/tar: invalid tar header")
    ErrWriteTooLong    = errors.New("archive/tar: write too long")
    ErrFieldTooLong    = errors.New("archive/tar: header field too long")
    ErrWriteAfterClose = errors.New("archive/tar: write after close")
  )
  ```

## type Format

### func (f Format) String() string

## type Header
### func FileInfoHeader(fi fs.FileInfo, link string) (*Header, error)
### func (h *Header) FileInfo() fs.FileInfo
## type Reader
### func NewReader(r io.Reader) *Reader
### func (tr *Reader) Next() (*Header, error)
### func (tr *Reader) Read(b []byte) (int, error)
## type Writer
### func NewWriter(w io.Writer) *Writer
### func (tw *Writer) Close() error
### func (tw *Writer) Flush() error
### func (tw *Writer) Write(b []byte) (int, error)
### func (tw *Writer) WriteHeader(hdr *Header) error

# 2. zip

## Constants

  ```golang
  const (
    Store   uint16 = 0 // no compression
    Deflate uint16 = 8 // DEFLATE compressed
  )
  ```

## Variables

  ```golang
  var (
    ErrFormat    = errors.New("zip: not a valid zip file")
    ErrAlgorithm = errors.New("zip: unsupported compression algorithm")
    ErrChecksum  = errors.New("zip: checksum error")
  )

  ```

### func RegisterCompressor(method uint16, comp Compressor)
### func RegisterDecompressor(method uint16, dcomp Decompressor)
## type Compressor
## type Decompressor
## type File
### func (f *File) DataOffset() (offset int64, err error)
### func (f *File) Open() (io.ReadCloser, error)
### func (f *File) OpenRaw() (io.Reader, error)
## type FileHeader
### func FileInfoHeader(fi fs.FileInfo) (*FileHeader, error)
### func (h *FileHeader) FileInfo() fs.FileInfo
### func (h *FileHeader) ModTime() time.TimeDEPRECATED
### func (h *FileHeader) Mode() (mode fs.FileMode)
### func (h *FileHeader) SetModTime(t time.Time)DEPRECATED
### func (h *FileHeader) SetMode(mode fs.FileMode)
## type ReadCloser
### func OpenReader(name string) (*ReadCloser, error)
### func (rc *ReadCloser) Close() error
## type Reader
### func NewReader(r io.ReaderAt, size int64) (*Reader, error)
### func (r *Reader) Open(name string) (fs.File, error)
### func (z *Reader) RegisterDecompressor(method uint16, dcomp Decompressor)
## type Writer
### func NewWriter(w io.Writer) *Writer
### func (w *Writer) Close() error
### func (w *Writer) Copy(f *File) error
### func (w *Writer) Create(name string) (io.Writer, error)
### func (w *Writer) CreateHeader(fh *FileHeader) (io.Writer, error)
### func (w *Writer) CreateRaw(fh *FileHeader) (io.Writer, error)
### func (w *Writer) Flush() error
### func (w *Writer) RegisterCompressor(method uint16, comp Compressor)
### func (w *Writer) SetComment(comment string) error
### func (w *Writer) SetOffset(n int64)


# rand

## function not method of rand
### func ExpFloat64() float64
### func Float32() float32
### func Float64() float64
### func Int() int
### func Int31() int32
### func Int31n(n int32) int32
### func Int63() int64
### func Int63n(n int64) int64
### func Intn(n int) int
### func NormFloat64() float64
### func Perm(n int) []int
### func Read(p []byte) (n int, err error)
### func Seed(seed int64)
### func Shuffle(n int, swap func(i, j int))
### func Uint32() uint32
### func Uint64() uint64
## type Rand
### func New(src Source) *Rand
### func (r *Rand) ExpFloat64() float64
### func (r *Rand) Float32() float32
### func (r *Rand) Float64() float64
### func (r *Rand) Int() int
### func (r *Rand) Int31() int32
### func (r *Rand) Int31n(n int32) int32
### func (r *Rand) Int63() int64
### func (r *Rand) Int63n(n int64) int64
### func (r *Rand) Intn(n int) int
### func (r *Rand) NormFloat64() float64
### func (r *Rand) Perm(n int) []int
### func (r *Rand) Read(p []byte) (n int, err error)
### func (r *Rand) Seed(seed int64)
Seed使用提供的种子值将生成器初始化为一个确定的状态。Seed不应该与其他Rand方法并发调用。

### func (r *Rand) Shuffle(n int, swap func(i, j int))
### func (r *Rand) Uint32() uint32
### func (r *Rand) Uint64() uint64
## type Source

### func NewSource(seed int64) Source

NewSource返回一个新的伪随机源，其种子为给定值。与顶级函数使用的默认Source不同，这个Source对于多个goroutine的并发使用是不安全的。

```golang
randomSource := NewSource(time.Now().UnixNano())
randSeed := New(randomSource) //这时候就可以使用rand的method
randomInt := randSeed.Intn(300)//[0,300)的整数

```


## type Source64

Source64是一个也可以直接生成[0, 1<<64]范围内的均匀分布的伪随机uint64值的Source。如果一个Rand r的底层Source s实现了Source64，那么r.Uint64返回对s.Uint64的一次调用结果，而不是对s.Int63的两次调用。  
Source64的结构

```golang
type Source64 interface {
    Source
    Uint64() uint64
}
```

## type Zipf
### func NewZipf(r *Rand, s float64, v float64, imax uint64) *Zipf
### func (z *Zipf) Uint64() uint64


