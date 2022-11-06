---
title: go标准库阅读与解析
categories:
- golang
tag: golang
---

> source link: <https://pkg.go.dev/std>
abstarct: Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
<!-- more -->
<!-- toc -->

# package tar

  Package tar implements access to tar archives.

  Tape(封装,胶带) archives (tar) are a file format for storing a sequence of files that can be read and written in a streaming manner. This package aims to cover most variations of the format, including those produced by GNU and BSD tar tools.

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

  ```golang
  type Format int
  ```

  Format represents the tar archive format.The original tar format was introduced in Unix V7. Since then, there have been multiple competing(相互竞争) formats attempting to standardize or extend the V7 format to overcome its limitations. The most common formats are the **USTAR**, **PAX**, and **GNU** formats, each with their own advantages and limitations.

  The following table captures the capabilities of each format:

  ```bash
                    |  USTAR |       PAX |       GNU
  ------------------+--------+-----------+----------
  Name              |   256B | unlimited | unlimited
  Linkname          |   100B | unlimited | unlimited
  Size              | uint33 | unlimited |    uint89
  Mode              | uint21 |    uint21 |    uint57
  Uid/Gid           | uint21 | unlimited |    uint57
  Uname/Gname       |    32B | unlimited |       32B
  ModTime           | uint33 | unlimited |     int89
  AccessTime        |    n/a | unlimited |     int89
  ChangeTime        |    n/a | unlimited |     int89
  Devmajor/Devminor | uint21 |    uint21 |    uint57
  ------------------+--------+-----------+----------
  string encoding   |  ASCII |     UTF-8 |    binary
  sub-second times  |     no |       yes |        no
  sparse files      |     no |       yes |       yes
  ```

  The table's upper portion shows the Header fields, where each format reports the maximum number of bytes allowed for each string field and the integer type used to store each numeric field (where timestamps are stored as the number of seconds since the Unix epoch).

  The table's lower portion shows specialized features of each format, such as supported string encodings, support for sub-second timestamps, or support for sparse files.

  The Writer currently provides no support for sparse files.

  ```golang
  const (

  // FormatUnknown indicates that the format is unknown.
  FormatUnknown Format
  // FormatUSTAR represents the USTAR header format defined in POSIX.1-1988.
  //
  // While this format is compatible with most tar readers,
  // the format has several limitations making it unsuitable for some usages.
  // Most notably, it cannot support sparse files, files larger than 8GiB,
  // filenames larger than 256 characters, and non-ASCII filenames.
  //
  // Reference:
  // http://pubs.opengroup.org/onlinepubs/9699919799/utilities/pax.html#tag_20_92_13_06
  FormatUSTAR
  // FormatPAX represents the PAX header format defined in POSIX.1-2001.
  //
  // PAX extends USTAR by writing a special file with Typeflag TypeXHeader
  // preceding the original header. This file contains a set of key-value
  // records, which are used to overcome USTAR\'s shortcomings, in addition to
  // providing the ability to have sub-second resolution for timestamps.
  //
  // Some newer formats add their own extensions to PAX by defining their
  // own keys and assigning certain semantic meaning to the associated values.
  // For example, sparse file support in PAX is implemented using keys
  // defined by the GNU manual (e.g., "GNU.sparse.map").
  //
  // Reference:
  // http://pubs.opengroup.org/onlinepubs/009695399/utilities/pax.html
  FormatPAX
  // FormatGNU represents the GNU header format.
  //
  // The GNU header format is older than the USTAR and PAX standards and
  // is not compatible with them. The GNU format supports
  // arbitrary file sizes, filenames of arbitrary encoding and length,
  // sparse files, and other features.
  //
  // It is recommended that PAX be chosen over GNU unless the target
  // application can only parse GNU formatted archives.
  //
  // Reference:
  // https://www.gnu.org/software/tar/manual/html_node/Standard.html
  FormatGNU
  )

  ```

### func (f Format) String() string
  
  打印tar的格式

## type Header
  
  ```golang
    type Header struct {
    // Typeflag is the type of header entry.
    // The zero value is automatically promoted to either TypeReg or TypeDir
    // depending on the presence of a trailing slash in Name.
    Typeflag byte

    Name     string // Name of file entry
    Linkname string // Target name of link (valid for TypeLink or TypeSymlink)

    Size  int64  // Logical file size in bytes
    Mode  int64  // Permission and mode bits
    Uid   int    // User ID of owner
    Gid   int    // Group ID of owner
    Uname string // User name of owner
    Gname string // Group name of owner

    // If the Format is unspecified, then Writer.WriteHeader rounds ModTime
    // to the nearest second and ignores the AccessTime and ChangeTime fields.
    //
    // To use AccessTime or ChangeTime, specify the Format as PAX or GNU.
    // To use sub-second resolution, specify the Format as PAX.
    ModTime    time.Time // Modification time
    AccessTime time.Time // Access time (requires either PAX or GNU support)
    ChangeTime time.Time // Change time (requires either PAX or GNU support)

    Devmajor int64 // Major device number (valid for TypeChar or TypeBlock)
    Devminor int64 // Minor device number (valid for TypeChar or TypeBlock)

    // Xattrs stores extended attributes as PAX records under the
    // "SCHILY.xattr." namespace.
    //
    // The following are semantically equivalent:
    //  h.Xattrs[key] = value
    //  h.PAXRecords["SCHILY.xattr."+key] = value
    //
    // When Writer.WriteHeader is called, the contents of Xattrs will take
    // precedence over those in PAXRecords.
    //
    // Deprecated: Use PAXRecords instead.
    Xattrs map[string]string

    // PAXRecords is a map of PAX extended header records.
    //
    // User-defined records should have keys of the following form:
    //	VENDOR.keyword
    // Where VENDOR is some namespace in all uppercase, and keyword may
    // not contain the '=' character (e.g., "GOLANG.pkg.version").
    // The key and value should be non-empty UTF-8 strings.
    //
    // When Writer.WriteHeader is called, PAX records derived from the
    // other fields in Header take precedence over PAXRecords.
    PAXRecords map[string]string

    // Format specifies the format of the tar header.
    //
    // This is set by Reader.Next as a best-effort guess at the format.
    // Since the Reader liberally reads some non-compliant files,
    // it is possible for this to be FormatUnknown.
    //
    // If the format is unspecified when Writer.WriteHeader is called,
    // then it uses the first format (in the order of USTAR, PAX, GNU)
    // capable of encoding this Header (see Format).
    Format Format
  }

  ```

### func FileInfoHeader(fi fs.FileInfo, link string) (*Header, error)

### func (h*Header) FileInfo() fs.FileInfo

## type Reader

### func NewReader(r io.Reader) *Reader

### func (tr*Reader) Next() (*Header, error)

### func (tr*Reader) Read(b []byte) (int, error)

## type Writer

### func NewWriter(w io.Writer) *Writer

### func (tw*Writer) Close() error

### func (tw *Writer) Flush() error

### func (tw*Writer) Write(b []byte) (int, error)

### func (tw *Writer) WriteHeader(hdr*Header) error

# zip package

Package zip provides support for reading and writing ZIP archives.

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

### func (f*File) Open() (io.ReadCloser, error)

### func (f *File) OpenRaw() (io.Reader, error)

## type FileHeader

### func FileInfoHeader(fi fs.FileInfo) (*FileHeader, error)

### func (h *FileHeader) FileInfo() fs.FileInfo

### func (h*FileHeader) ModTime() time.TimeDEPRECATED

### func (h *FileHeader) Mode() (mode fs.FileMode)

### func (h*FileHeader) SetModTime(t time.Time)DEPRECATED

### func (h *FileHeader) SetMode(mode fs.FileMode)

## type ReadCloser

### func OpenReader(name string) (*ReadCloser, error)

### func (rc *ReadCloser) Close() error

## type Reader

### func NewReader(r io.ReaderAt, size int64) (*Reader, error)

### func (r *Reader) Open(name string) (fs.File, error)

### func (z*Reader) RegisterDecompressor(method uint16, dcomp Decompressor)

## type Writer

### func NewWriter(w io.Writer) *Writer

### func (w*Writer) Close() error

### func (w \*Writer) Copy(f\*File) error

### func (w *Writer) Create(name string) (io.Writer, error)

### func (w\*Writer) CreateHeader(fh\*FileHeader) (io.Writer, error)

### func (w\*Writer) CreateRaw(fh\*FileHeader) (io.Writer, error)

### func (w*Writer) Flush() error

### func (w *Writer) RegisterCompressor(method uint16, comp Compressor)

### func (w*Writer) SetComment(comment string) error

### func (w *Writer) SetOffset(n int64)


# bufio

Package bufio implements buffered I/O. It wraps an io.Reader or io.Writer object, creating another object (Reader or Writer) that also implements the interface but provides buffering and some help for textual(adj.本文的,按原文的) I/O.

**Constants**
```golang
const (
	// MaxScanTokenSize is the maximum size used to buffer a token
	// unless the user provides an explicit buffer with Scanner.Buffer.
	// The actual maximum token size may be smaller as the buffer
	// may need to include, for instance, a newline.
	MaxScanTokenSize = 64 * 1024
)
```
**Variables**
```golang
var (
	ErrInvalidUnreadByte = errors.New("bufio: invalid use of UnreadByte")
	ErrInvalidUnreadRune = errors.New("bufio: invalid use of UnreadRune")
	ErrBufferFull        = errors.New("bufio: buffer full")
	ErrNegativeCount     = errors.New("bufio: negative count")
)
var (
	ErrTooLong         = errors.New("bufio.Scanner: token too long")
	ErrNegativeAdvance = errors.New("bufio.Scanner: SplitFunc returns negative advance count")
	ErrAdvanceTooFar   = errors.New("bufio.Scanner: SplitFunc returns advance count beyond input")
	ErrBadReadCount    = errors.New("bufio.Scanner: Read returned impossible count")
)
Errors returned by Scanner.
var ErrFinalToken = errors.New("final token")

```
`ErrFinalToken` is a special sentinel error value. It is intended to be returned by a Split(vt.分离) function to indicate that the token being delivered with the error is the last token and scanning should stop after this one. After ErrFinalToken is received by Scan, scanning stops with no error. The value is useful to stop processing early or when it is necessary to deliver a final empty token. One could achieve the same behavior with a custom error value but providing one here is tidier. See the emptyFinalToken example for a use of this value.


## func ScanBytes(data []byte, atEOF bool) (advance int, token []byte, err error)
ScanBytes is a split function for a Scanner that returns each byte as a token.

## func ScanLines(data []byte, atEOF bool) (advance int, token []byte, err error)
## func ScanRunes(data []byte, atEOF bool) (advance int, token []byte, err error)
## func ScanWords(data []byte, atEOF bool) (advance int, token []byte, err error)

## type ReadWriter

```goalng
type ReadWriter struct {
	*Reader
	*Writer
}
```

### func NewReadWriter(r *Reader, w *Writer) *ReadWriter
## type Reader

```golang
type Reader struct {
	// contains filtered or unexported fields
}
```
## func NewReader(rd io.Reader) *Reader
## func NewReaderSize(rd io.Reader, size int) *Reader
### func (b *Reader) Buffered() int
### func (b *Reader) Discard(n int) (discarded int, err error)
### func (b *Reader) Peek(n int) ([]byte, error)
### func (b *Reader) Read(p []byte) (n int, err error)
### func (b *Reader) ReadByte() (byte, error)
### func (b *Reader) ReadBytes(delim byte) ([]byte, error)
### func (b *Reader) ReadLine() (line []byte, isPrefix bool, err error)
### func (b *Reader) ReadRune() (r rune, size int, err error)
### func (b *Reader) ReadSlice(delim byte) (line []byte, err error)
### func (b *Reader) ReadString(delim byte) (string, error)
### func (b *Reader) Reset(r io.Reader)
### func (b *Reader) Size() int
### func (b *Reader) UnreadByte() error
### func (b *Reader) UnreadRune() error
### func (b *Reader) WriteTo(w io.Writer) (n int64, err error)
## type Scanner
```golang
type Scanner struct {
	// contains filtered or unexported fields
}
```
## func NewScanner(r io.Reader) *Scanner
### func (s *Scanner) Buffer(buf []byte, max int)
### func (s *Scanner) Bytes() []byte
### func (s *Scanner) Err() error
### func (s *Scanner) Scan() bool
### func (s *Scanner) Split(split SplitFunc)
### func (s *Scanner) Text() string
## type SplitFunc
```golang
type SplitFunc func(data []byte, atEOF bool) (advance int, token []byte, err error)

```
## type Writer

```golng
type Writer struct {
	// contains filtered or unexported fields
}
```

## func NewWriter(w io.Writer) *Writer
## func NewWriterSize(w io.Writer, size int) *Writer
### func (b *Writer) Available() int
### func (b *Writer) AvailableBuffer() []byte
### func (b *Writer) Buffered() int
### func (b *Writer) Flush() error
### func (b *Writer) ReadFrom(r io.Reader) (n int64, err error)
### func (b *Writer) Reset(w io.Writer)
### func (b *Writer) Size() int
### func (b *Writer) Write(p []byte) (nn int, err error)
### func (b *Writer) WriteByte(c byte) error
### func (b *Writer) WriteRune(r rune) (size int, err error)
### func (b *Writer) WriteString(s string) (int, error)


# builtin

Package builtin provides documentation for Go's predeclared identifiers. The items documented here are not actually in package builtin but their descriptions here allow godoc to present documentation for the language's special identifiers.

**Constants**
```golang
const (
	true  = 0 == 0 // Untyped bool.
	false = 0 != 0 // Untyped bool.
)
const iota = 0 // Untyped int.
```

**variables**
```golang
var nil Type // Type must be a pointer, channel, func, interface, map, or slice type
```

## func append(slice []Type, elems ...Type) []Type
## func cap(v Type) int
## func close(c chan<- Type)
## func complex(r, i FloatType) ComplexType
## func copy(dst, src []Type) int
## func delete(m map[Type]Type1, key Type)
## func imag(c ComplexType) FloatType
## func len(v Type) int
## func make(t Type, size ...IntegerType) Type
## func new(Type) *Type
## func panic(v any)
## func print(args ...Type)
## func println(args ...Type)
## func real(c ComplexType) FloatType
## func recover() any

## type ComplexType
## type FloatType
## type IntegerType
## type Type
## type Type1
## type any
## type bool
## type byte
## type comparable
## type complex128
## type complex64
## type error
## type float32
## type float64
## type int
## type int16
## type int32
## type int64
## type int8
## type rune
## type string
## type uint
## type uint16
## type uint32
## type uint64
## type uint8
## type uintptr



# bytes
Package bytes implements functions for the manipulation of byte slices. It is analogous to the facilities of the strings package.

**constants**
```golang
const MinRead = 512
```

**variables**
```golang
var ErrTooLarge = errors.New("bytes.Buffer: too large")

```
## func Compare(a, b []byte) int
## func Contains(b, subslice []byte) bool
## func ContainsAny(b []byte, chars string) bool
## func ContainsRune(b []byte, r rune) bool
## func Count(s, sep []byte) int
## func Cut(s, sep []byte) (before, after []byte, found bool)
## func Equal(a, b []byte) bool
## func EqualFold(s, t []byte) bool
## func Fields(s []byte) [][]byte
## func FieldsFunc(s []byte, f func(rune) bool) [][]byte
## func HasPrefix(s, prefix []byte) bool
## func HasSuffix(s, suffix []byte) bool
## func Index(s, sep []byte) int
## func IndexAny(s []byte, chars string) int
## func IndexByte(b []byte, c byte) int
## func IndexFunc(s []byte, f func(r rune) bool) int
## func IndexRune(s []byte, r rune) int
## func Join(s [][]byte, sep []byte) []byte
## func LastIndex(s, sep []byte) int
## func LastIndexAny(s []byte, chars string) int
## func LastIndexByte(s []byte, c byte) int
## func LastIndexFunc(s []byte, f func(r rune) bool) int
## func Map(mapping func(r rune) rune, s []byte) []byte
## func Repeat(b []byte, count int) []byte
## func Replace(s, old, new []byte, n int) []byte
## func ReplaceAll(s, old, new []byte) []byte
## func Runes(s []byte) []rune
## func Split(s, sep []byte) [][]byte
## func SplitAfter(s, sep []byte) [][]byte
## func SplitAfterN(s, sep []byte, n int) [][]byte
## func SplitN(s, sep []byte, n int) [][]byte
## func Title(s []byte) []byteDEPRECATED
## func ToLower(s []byte) []byte
## func ToLowerSpecial(c unicode.SpecialCase, s []byte) []byte
## func ToTitle(s []byte) []byte
## func ToTitleSpecial(c unicode.SpecialCase, s []byte) []byte
## func ToUpper(s []byte) []byte
## func ToUpperSpecial(c unicode.SpecialCase, s []byte) []byte
## func ToValidUTF8(s, replacement []byte) []byte
## func Trim(s []byte, cutset string) []byte
## func TrimFunc(s []byte, f func(r rune) bool) []byte
## func TrimLeft(s []byte, cutset string) []byte
## func TrimLeftFunc(s []byte, f func(r rune) bool) []byte
## func TrimPrefix(s, prefix []byte) []byte
## func TrimRight(s []byte, cutset string) []byte
## func TrimRightFunc(s []byte, f func(r rune) bool) []byte
## func TrimSpace(s []byte) []byte
## func TrimSuffix(s, suffix []byte) []byte

## type Buffer

## func NewBuffer(buf []byte) *Buffer
## func NewBufferString(s string) *Buffer
### func (b *Buffer) Bytes() []byte
### func (b *Buffer) Cap() int
### func (b *Buffer) Grow(n int)
### func (b *Buffer) Len() int
### func (b *Buffer) Next(n int) []byte
### func (b *Buffer) Read(p []byte) (n int, err error)
### func (b *Buffer) ReadByte() (byte, error)
### func (b *Buffer) ReadBytes(delim byte) (line []byte, err error)
### func (b *Buffer) ReadFrom(r io.Reader) (n int64, err error)
### func (b *Buffer) ReadRune() (r rune, size int, err error)
### func (b *Buffer) ReadString(delim byte) (line string, err error)
### func (b *Buffer) Reset()
### func (b *Buffer) String() string
### func (b *Buffer) Truncate(n int)
### func (b *Buffer) UnreadByte() error
### func (b *Buffer) UnreadRune() error
### func (b *Buffer) Write(p []byte) (n int, err error)
### func (b *Buffer) WriteByte(c byte) error
### func (b *Buffer) WriteRune(r rune) (n int, err error)
### func (b *Buffer) WriteString(s string) (n int, err error)
### func (b *Buffer) WriteTo(w io.Writer) (n int64, err error)
## type Reader
## func NewReader(b []byte) *Reader
### func (r *Reader) Len() int
### func (r *Reader) Read(b []byte) (n int, err error)
### func (r *Reader) ReadAt(b []byte, off int64) (n int, err error)
### func (r *Reader) ReadByte() (byte, error)
### func (r *Reader) ReadRune() (ch rune, size int, err error)
### func (r *Reader) Reset(b []byte)
### func (r *Reader) Seek(offset int64, whence int) (int64, error)
### func (r *Reader) Size() int64
### func (r *Reader) UnreadByte() error
### func (r *Reader) UnreadRune() error
### func (r *Reader) WriteTo(w io.Writer) (n int64, err error)


# compress

## bzip2

Package bzip2 implements bzip2 decompression.

### func NewReader(r io.Reader) io.Reader
### type StructuralError
### func (s StructuralError) Error() string

## flate
Package flate implements the DEFLATE compressed data format, described in RFC 1951. The gzip and zlib packages implement access to DEFLATE-based file formats.

**Constants**

```golang
const (
	NoCompression      = 0
	BestSpeed          = 1
	BestCompression    = 9
	DefaultCompression = -1

	// HuffmanOnly disables Lempel-Ziv match searching and only performs Huffman
	// entropy encoding. This mode is useful in compressing data that has
	// already been compressed with an LZ style algorithm (e.g. Snappy or LZ4)
	// that lacks an entropy encoder. Compression gains are achieved when
	// certain bytes in the input stream occur more frequently than others.
	//
	// Note that HuffmanOnly produces a compressed output that is
	// RFC 1951 compliant. That is, any valid DEFLATE decompressor will
	// continue to be able to decompress this output.
	HuffmanOnly = -2
)
```
### func NewReader(r io.Reader) io.ReadCloser
### func NewReaderDict(r io.Reader, dict []byte) io.ReadCloser
### type CorruptInputError
#### func (e CorruptInputError) Error() string
### type InternalError
#### func (e InternalError) Error() string
### type ReadErrorDEPRECATED
#### func (e *ReadError) Error() string
### type Reader
### type Resetter
### type WriteErrorDEPRECATED
#### func (e *WriteError) Error() string
### type Writer
### func NewWriter(w io.Writer, level int) (*Writer, error)
### func NewWriterDict(w io.Writer, level int, dict []byte) (*Writer, error)
#### func (w *Writer) Close() error
#### func (w *Writer) Flush() error
#### func (w *Writer) Reset(dst io.Writer)
#### func (w *Writer) Write(data []byte) (n int, err error)


## gzip
Package gzip implements reading and writing of gzip format compressed files, as specified in RFC 1952.

**Constants**
```
const (
	NoCompression      = flate.NoCompression
	BestSpeed          = flate.BestSpeed
	BestCompression    = flate.BestCompression
	DefaultCompression = flate.DefaultCompression
	HuffmanOnly        = flate.HuffmanOnly
)
```
These constants are copied from the flate package, so that code that imports "compress/gzip" does not also have to import "compress/flate".

**Variables**
```
var (
	// ErrChecksum is returned when reading GZIP data that has an invalid checksum.
	ErrChecksum = errors.New("gzip: invalid checksum")
	// ErrHeader is returned when reading GZIP data that has an invalid header.
	ErrHeader = errors.New("gzip: invalid header")
)
```
### type Header
```golang
type Header struct {
	Comment string    // comment
	Extra   []byte    // "extra data"
	ModTime time.Time // modification time
	Name    string    // file name
	OS      byte      // operating system type
}
```
### type Reader
```golang
type Reader struct {
	Header // valid after NewReader or Reader.Reset
	// contains filtered or unexported fields
}
```
### func NewReader(r io.Reader) (*Reader, error)
#### func (z *Reader) Close() error
#### func (z *Reader) Multistream(ok bool)
#### func (z *Reader) Read(p []byte) (n int, err error)
#### func (z *Reader) Reset(r io.Reader) error
### type Writer

```golang
type Writer struct {
	Header // written at first call to Write, Flush, or Close
	// contains filtered or unexported fields
}

```
### func NewWriter(w io.Writer) *Writer
### func NewWriterLevel(w io.Writer, level int) (*Writer, error)
#### func (z *Writer) Close() error
#### func (z *Writer) Flush() error
#### func (z *Writer) Reset(w io.Writer)
#### func (z *Writer) Write(p []byte) (int, error)

## lzw
Package lzw implements the Lempel-Ziv-Welch compressed data format, described in T. A. Welch, “A Technique for High-Performance Data Compression”, Computer, 17(6) (June 1984), pp 8-19.

In particular, it implements LZW as used by the GIF and PDF file formats, which means variable-width codes up to 12 bits and the first two non-literal codes are a clear code and an EOF code.

The TIFF file format uses a similar but incompatible version of the LZW algorithm. See the golang.org/x/image/tiff/lzw package for an implementation.

### func NewReader(r io.Reader, order Order, litWidth int) io.ReadCloser
### func NewWriter(w io.Writer, order Order, litWidth int) io.WriteCloser
### type Order
```golang
type Order int
```
### type Reader
```golang
type Reader struct {
	// contains filtered or unexported fields
}
```
#### func (r *Reader) Close() error
#### func (r *Reader) Read(b []byte) (int, error)
#### func (r *Reader) Reset(src io.Reader, order Order, litWidth int)
### type Writer
```golang
type Writer struct {
	// contains filtered or unexported fields
}
```


#### func (w *Writer) Close() error
#### func (w *Writer) Reset(dst io.Writer, order Order, litWidth int)
#### func (w *Writer) Write(p []byte) (n int, err error)



## compress/zlib
**Overview**
Package zlib implements reading and writing of zlib format compressed data, as specified in RFC 1950.

The implementation provides filters that uncompress during reading and compress during writing. For example, to write compressed data to a buffer:

```golang
var b bytes.Buffer
w := zlib.NewWriter(&b)
w.Write([]byte("hello, world\n"))
w.Close()
```
and to read that data back:
```golang
r, err := zlib.NewReader(&b)
io.Copy(os.Stdout, r)
r.Close()
```
**Constants**
**Variables**
### func NewReader(r io.Reader) (io.ReadCloser, error)
### func NewReaderDict(r io.Reader, dict []byte) (io.ReadCloser, error)
### type Resetter
```golang
type Resetter interface {
	// Reset discards any buffered data and resets the Resetter as if it was
	// newly initialized with the given reader.
	Reset(r io.Reader, dict []byte) error
}
```
### type Writer
```golang
type Writer struct {
	// contains filtered or unexported fields
}
```
### func NewWriter(w io.Writer) *Writer
### func NewWriterLevel(w io.Writer, level int) (*Writer, error)
### func NewWriterLevelDict(w io.Writer, level int, dict []byte) (*Writer, error)
#### func (z *Writer) Close() error
#### func (z *Writer) Flush() error
#### func (z *Writer) Reset(w io.Writer)
#### func (z *Writer) Write(p []byte) (n int, err error)


# container
## container/heap
**Overview**
Package heap provides heap operations for any type that implements heap.Interface. A heap is a tree with the property that each node is the minimum-valued node in its subtree.

The minimum element in the tree is the root, at index 0.

A heap is a common way to implement a priority queue. To build a priority queue, implement the Heap interface with the (negative) priority as the ordering for the Less method, so Push adds items while Pop removes the highest-priority item from the queue. The Examples include such an implementation; the file example_pq_test.go has the complete source.

### func Fix(h Interface, i int)
### func Init(h Interface)
### func Pop(h Interface) any
### func Push(h Interface, x any)
### func Remove(h Interface, i int) any
### type Interface

## container/list

**Overview**
Package list implements a doubly linked list.

To iterate over a list (where l is a *List):
```golang
for e := l.Front(); e != nil; e = e.Next() {
	// do something with e.Value
}

```

### type Element
#### func (e *Element) Next() *Element
#### func (e *Element) Prev() *Element
### type List
### func New() *List
#### func (l *List) Back() *Element
#### func (l *List) Front() *Element
#### func (l *List) Init() *List
#### func (l *List) InsertAfter(v any, mark *Element) *Element
#### func (l *List) InsertBefore(v any, mark *Element) *Element
#### func (l *List) Len() int
#### func (l *List) MoveAfter(e, mark *Element)
#### func (l *List) MoveBefore(e, mark *Element)
#### func (l *List) MoveToBack(e *Element)
#### func (l *List) MoveToFront(e *Element)
#### func (l *List) PushBack(v any) *Element
#### func (l *List) PushBackList(other *List)
#### func (l *List) PushFront(v any) *Element
#### func (l *List) PushFrontList(other *List)
#### func (l *List) Remove(e *Element) any

# os

**overview**
Package os provides a platform-independent interface to operating system functionality. The design is Unix-like, although the error handling is Go-like; failing calls return values of type error rather than error numbers. Often, more information is available within the error. For example, if a call that takes a file name fails, such as Open or Stat, the error will include the failing file name when printed and will be of type *PathError, which may be unpacked for more information.

The os interface is intended to be uniform across all operating systems. Features not generally available appear in the system-specific package syscall.

Here is a simple example, opening a file and reading some of it.
```golang
file, err := os.Open("file.go") // For read access.
if err != nil {
	log.Fatal(err)
}
```
If the open fails, the error string will be self-explanatory, like
```golang
open file.go: no such file or directory
```
The file's data can then be read into a slice of bytes. Read and Write take their byte counts from the length of the argument slice.

```golang
data := make([]byte, 100)
count, err := file.Read(data)
if err != nil {
	log.Fatal(err)
}
fmt.Printf("read %d bytes: %q\n", count, data[:count])
```
Note: The maximum number of concurrent operations on a File may be limited by the OS or the system. The number should be high, but exceeding(adj.超越的) it may degrade(vt.贬低) performance or cause other issues.

summary:  
1. failing calls return values of type error rather than error numbers.like above open file failed. and emit "open file.go: no such file or directory"
2.  The maximum number of concurrent operations on a File may be limited by the OS or the system(not know the root cause and knowledge)

**Constants**
```golang
const (
	// Exactly one of O_RDONLY, O_WRONLY, or O_RDWR must be specified.
	O_RDONLY int = syscall.O_RDONLY // open the file read-only.
	O_WRONLY int = syscall.O_WRONLY // open the file write-only.
	O_RDWR   int = syscall.O_RDWR   // open the file read-write.
	// The remaining values may be or'ed in to control behavior.
	O_APPEND int = syscall.O_APPEND // append data to the file when writing.
	O_CREATE int = syscall.O_CREAT  // create a new file if none exists.
	O_EXCL   int = syscall.O_EXCL   // used with O_CREATE, file must not exist.
	O_SYNC   int = syscall.O_SYNC   // open for synchronous I/O.
	O_TRUNC  int = syscall.O_TRUNC  // truncate regular(adj. 定期的) writable file when opened.
)
```
Flags to OpenFile wrapping those of the underlying system. Not all flags may be implemented on a given system.
```golang
const (
	SEEK_SET int = 0 // seek relative to the origin of the file
	SEEK_CUR int = 1 // seek relative to the current offset
	SEEK_END int = 2 // seek relative to the end
)
```
Deprecated: Use io.SeekStart, io.SeekCurrent, and io.SeekEnd.
```golang
const (
	PathSeparator     = '/' // OS-specific path separator
	PathListSeparator = ':' // OS-specific path list separator
)
```
```golang
const (
	// The single letters are the abbreviations
	// used by the String method's formatting.
	ModeDir        = fs.ModeDir        // d: is a directory
	ModeAppend     = fs.ModeAppend     // a: append-only
	ModeExclusive  = fs.ModeExclusive  // l: exclusive use
	ModeTemporary  = fs.ModeTemporary  // T: temporary file; Plan 9 only
	ModeSymlink    = fs.ModeSymlink    // L: symbolic link
	ModeDevice     = fs.ModeDevice     // D: device file
	ModeNamedPipe  = fs.ModeNamedPipe  // p: named pipe (FIFO)
	ModeSocket     = fs.ModeSocket     // S: Unix domain socket
	ModeSetuid     = fs.ModeSetuid     // u: setuid
	ModeSetgid     = fs.ModeSetgid     // g: setgid
	ModeCharDevice = fs.ModeCharDevice // c: Unix character device, when ModeDevice is set
	ModeSticky     = fs.ModeSticky     // t: sticky
	ModeIrregular  = fs.ModeIrregular  // ?: non-regular file; nothing else is known about this file

	// Mask for the type bits. For regular files, none will be set.
	ModeType = fs.ModeType

	ModePerm = fs.ModePerm // Unix permission bits, 0o777
)
```
The defined file mode bits are the most significant bits of the FileMode. The nine least-significant bits are the standard Unix `rwxrwxrwx` permissions. The values of these bits should be considered part of the public API and may be used in wire protocols or disk representations: they must not be changed, although new bits might be added.
```golang
const DevNull = "/dev/null"
```
DevNull is the name of the operating system's “null device.” On Unix-like systems, it is "/dev/null"; on Windows, "NUL".

**variables**
```golang
var (
	// ErrInvalid indicates an invalid argument.
	// Methods on File will return this error when the receiver is nil.
	ErrInvalid = fs.ErrInvalid // "invalid argument"

	ErrPermission = fs.ErrPermission // "permission denied"
	ErrExist      = fs.ErrExist      // "file already exists"
	ErrNotExist   = fs.ErrNotExist   // "file does not exist"
	ErrClosed     = fs.ErrClosed     // "file already closed"

	ErrNoDeadline       = errNoDeadline()       // "file type does not support deadline"
	ErrDeadlineExceeded = errDeadlineExceeded() // "i/o timeout"
)
```
Portable analogs of some common system call errors.

Errors returned from this package may be tested against these errors with errors.Is.

`Stdin`, `Stdout`, and `Stderr` are open Files pointing to the standard input, standard output, and standard error file descriptors.

Note that the Go runtime writes to standard error for panics and crashes; closing Stderr may cause those messages to go elsewhere, perhaps to a file opened later.
```golang
var Args []string
```

Args hold the command-line arguments, starting with the program name.

```golang
var ErrProcessDone = errors.New("os: process already finished")
```
ErrProcessDone indicates a Process has finished.

## fucntion
### func Chdir(dir string) error
Chdir changes the current working directory to the named directory. If there is an error, it will be of type *PathError.
```golang
package main

import (
	"fmt"
	"log"
	"os"
)

func main() {
	if err := os.Chdir("/home/kirkzhang/go-workspace"); err != nil {
		log.Fatal(err)
	}
	CurDir, err := os.Getwd()
	if err != nil {
		panic(err)
	} else {
		fmt.Println("Current working directory: ", CurDir)
	}
}

$ Current working directory:  /home/kirkzhang/go-workspace

```
summary:  
more like `cd` command in linux

### func Chmod(name string, mode FileMode) error
Chmod changes the mode of the named file to mode. If the file is a symbolic link, it changes the mode of the link's target. If there is an error, it will be of type *PathError.

A different subset of the mode bits are used, depending on the operating system.

On Unix, the mode's permission bits, ModeSetuid, ModeSetgid, and ModeSticky are used.

On Windows, only the 0200 bit (owner writable) of mode is used; it controls whether the file's read-only attribute is set or cleared. The other bits are currently unused. For compatibility with Go 1.12 and earlier, use a non-zero mode. Use mode 0400 for a read-only file and 0600 for a readable+writable file.

On Plan 9, the mode's permission bits, ModeAppend, ModeExclusive, and ModeTemporary are used.
```golang
func main() {
	if err := os.Chmod("./hello_world.go", os.ModePerm); err != nil {
  // if err := os.Chmod("./hello_world.go", os.FileMode.Perm(777));
		log.Fatal(err)
	}
	CurDir, err := os.Getwd()
	if err != nil {
		panic(err)
	} else {
		fmt.Println("Current working directory: ", CurDir)
	}

}


```

### func Chown(name string, uid, gid int) error
Chown changes the numeric uid and gid of the named file. If the file is a symbolic link, it changes the uid and gid of the link's target. A uid or gid of -1 means to not change that value. If there is an error, it will be of type *PathError.

On Windows or Plan 9, Chown always returns the syscall.EWINDOWS or EPLAN9 error, wrapped in *PathError.

### func Chtimes(name string, atime time.Time, mtime time.Time) error
Chtimes changes the access and modification times of the named file, similar to the Unix utime() or utimes() functions.

The underlying filesystem may truncate or round the values to a less precise time unit. If there is an error, it will be of type *PathError.

### func Clearenv()
Clearenv deletes all environment variables.
### func DirFS(dir string) fs.FS
DirFS returns a file system (an fs.FS) for the tree of files rooted at the directory dir.

Note that DirFS("/prefix") only guarantees that the Open calls it makes to the operating system will begin with "/prefix": DirFS("/prefix").Open("file") is the same as os.Open("/prefix/file"). So if /prefix/file is a symbolic link pointing outside the /prefix tree, then using DirFS does not stop the access any more than using os.Open does. Additionally, the root of the fs.FS returned for a relative path, DirFS("prefix"), will be affected by later calls to Chdir. DirFS is therefore not a general substitute for a chroot-style security mechanism when the directory tree contains arbitrary content.

### func Environ() []string
Environ returns a copy of strings representing the environment, in the form "key=value".

### func Executable() (string, error)
Executable returns the path name for the executable that started the current process. There is no guarantee that the path is still pointing to the correct executable. If a symlink was used to start the process, depending on the operating system, the result might be the symlink or the path it pointed to. If a stable result is needed, path/filepath.EvalSymlinks might help.

Executable returns an absolute path unless an error occurred.

The main use case is finding resources located relative to an executable.

### func Exit(code int)
Exit causes the current program to exit with the given status code. Conventionally, code zero indicates success, non-zero an error. The program terminates immediately; deferred functions are not run.

For portability, the status code should be in the range [0, 125].
### func Expand(s string, mapping func(string) string) string
Expand replaces ${var} or $var in the string based on the mapping function. For example, os.ExpandEnv(s) is equivalent to os.Expand(s, os.Getenv).
### func ExpandEnv(s string) string
ExpandEnv replaces ${var} or $var in the string according to the values of the current environment variables. References to undefined variables are replaced by the empty string.
### func Getegid() int
Getegid returns the numeric effective group id of the caller.

On Windows, it returns -1.
### func Getenv(key string) string
Getenv retrieves the value of the environment variable named by the key. It returns the value, which will be empty if the variable is not present. To distinguish between an empty value and an unset value, use LookupEnv.
### func Geteuid() int

### func Getgid() int
Geteuid returns the numeric effective user id of the caller.

On Windows, it returns -1.
### func Getgroups() ([]int, error)
Getgid returns the numeric group id of the caller.

On Windows, it returns -1.
### func Getpagesize() int
Getgroups returns a list of the numeric ids of groups that the caller belongs to.

On Windows, it returns syscall.EWINDOWS. See the os/user package for a possible alternative.
### func Getpid() int
Getpagesize returns the underlying system's memory page size.
### func Getppid() int
Getpid returns the process id of the caller.
### func Getuid() int
Geteuid returns the numeric effective user id of the caller.

On Windows, it returns -1.
### func Getwd() (dir string, err error)
Getgid returns the numeric group id of the caller.

On Windows, it returns -1.
### func Hostname() (name string, err error)
### func IsExist(err error) bool
### func IsNotExist(err error) bool
### func IsPathSeparator(c uint8) bool
### func IsPermission(err error) bool
### func IsTimeout(err error) bool
### func Lchown(name string, uid, gid int) error
### func Link(oldname, newname string) error
### func LookupEnv(key string) (string, bool)
### func Mkdir(name string, perm FileMode) error
### func MkdirAll(path string, perm FileMode) error
### func MkdirTemp(dir, pattern string) (string, error)
### func NewSyscallError(syscall string, err error) error
### func Pipe() (r *File, w *File, err error)
### func ReadFile(name string) ([]byte, error)
### func Readlink(name string) (string, error)
### func Remove(name string) error
### func RemoveAll(path string) error
### func Rename(oldpath, newpath string) error
### func SameFile(fi1, fi2 FileInfo) bool
### func Setenv(key, value string) error
### func Symlink(oldname, newname string) error
### func TempDir() string
### func Truncate(name string, size int64) error
### func Unsetenv(key string) error
### func UserCacheDir() (string, error)
### func UserConfigDir() (string, error)
### func UserHomeDir() (string, error)
### func WriteFile(name string, data []byte, perm FileMode) error
## type DirEntry
### func ReadDir(name string) ([]DirEntry, error)
## type File
### func Create(name string) (*File, error)
### func CreateTemp(dir, pattern string) (*File, error)
### func NewFile(fd uintptr, name string) *File
### func Open(name string) (*File, error)
### func OpenFile(name string, flag int, perm FileMode) (*File, error)
### func (f *File) Chdir() error
### func (f *File) Chmod(mode FileMode) error
### func (f *File) Chown(uid, gid int) error
### func (f *File) Close() error
### func (f *File) Fd() uintptr
### func (f *File) Name() string
### func (f *File) Read(b []byte) (n int, err error)
### func (f *File) ReadAt(b []byte, off int64) (n int, err error)
### func (f *File) ReadDir(n int) ([]DirEntry, error)
### func (f *File) ReadFrom(r io.Reader) (n int64, err error)
### func (f *File) Readdir(n int) ([]FileInfo, error)
### func (f *File) Readdirnames(n int) (names []string, err error)
### func (f *File) Seek(offset int64, whence int) (ret int64, err error)
### func (f *File) SetDeadline(t time.Time) error
### func (f *File) SetReadDeadline(t time.Time) error
### func (f *File) SetWriteDeadline(t time.Time) error
### func (f *File) Stat() (FileInfo, error)
### func (f *File) Sync() error
### func (f *File) SyscallConn() (syscall.RawConn, error)
### func (f *File) Truncate(size int64) error
### func (f *File) Write(b []byte) (n int, err error)
### func (f *File) WriteAt(b []byte, off int64) (n int, err error)
### func (f *File) WriteString(s string) (n int, err error)
## type FileInfo
### func Lstat(name string) (FileInfo, error)
### func Stat(name string) (FileInfo, error)
## type FileMode
## type LinkError
### func (e *LinkError) Error() string
### func (e *LinkError) Unwrap() error
## type PathError
## type ProcAttr
## type Process
### func FindProcess(pid int) (*Process, error)
### func StartProcess(name string, argv []string, attr \*ProcAttr) (\*Process, error)
### func (p *Process) Kill() error
### func (p *Process) Release() error
### func (p *Process) Signal(sig Signal) error
### func (p \*Process) Wait() (\*ProcessState, error)
## type ProcessState
### func (p *ProcessState) ExitCode() int
### func (p *ProcessState) Exited() bool
### func (p *ProcessState) Pid() int
### func (p *ProcessState) String() string
### func (p *ProcessState) Success() bool
### func (p *ProcessState) Sys() any
### func (p *ProcessState) SysUsage() any
### func (p *ProcessState) SystemTime() time.Duration
### func (p *ProcessState) UserTime() time.Duration
## type Signal
## type SyscallError
### func (e *SyscallError) Error() string
### func (e *SyscallError) Timeout() bool
### func (e *SyscallError) Unwrap() error












# time package

**Constants**
  ```golang
  const (
    Layout      = "01/02 03:04:05PM '06 -0700" // The reference time, in numerical order.
    ANSIC       = "Mon Jan _2 15:04:05 2006"
    UnixDate    = "Mon Jan _2 15:04:05 MST 2006"
    RubyDate    = "Mon Jan 02 15:04:05 -0700 2006"
    RFC822      = "02 Jan 06 15:04 MST"
    RFC822Z     = "02 Jan 06 15:04 -0700" // RFC822 with numeric zone
    RFC850      = "Monday, 02-Jan-06 15:04:05 MST"
    RFC1123     = "Mon, 02 Jan 2006 15:04:05 MST"
    RFC1123Z    = "Mon, 02 Jan 2006 15:04:05 -0700" // RFC1123 with numeric zone
    RFC3339     = "2006-01-02T15:04:05Z07:00"
    RFC3339Nano = "2006-01-02T15:04:05.999999999Z07:00"
    Kitchen     = "3:04PM"
    // Handy time stamps.
    Stamp      = "Jan _2 15:04:05"
    StampMilli = "Jan _2 15:04:05.000"
    StampMicro = "Jan _2 15:04:05.000000"
    StampNano  = "Jan _2 15:04:05.000000000"
  )
  ```

### func After(d Duration) <-chan Time

  After waits for the duration to elapse and then sends the current time on the returned channel. It is equivalent to NewTimer(d).C. The underlying Timer is not recovered by the garbage collector until the timer fires. If efficiency is a concern, use NewTimer instead and call Timer.Stop if the timer is no longer needed.这里需要注意，这个After(d Duration)是指返回一次的时间戳，想要使用还要再次初始化

### func Sleep(d Duration)

### func Tick(d Duration) <-chan Time

## type Duration

### func ParseDuration(s string) (Duration, error)

### func Since(t Time) Duration

### func Until(t Time) Duration

### func (d Duration) Abs() Duration

### func (d Duration) Hours() float64

### func (d Duration) Microseconds() int64

### func (d Duration) Milliseconds() int64

### func (d Duration) Minutes() float64

### func (d Duration) Nanoseconds() int64

### func (d Duration) Round(m Duration) Duration

### func (d Duration) Seconds() float64

### func (d Duration) String() string

### func (d Duration) Truncate(m Duration) Duration

## type Location

### func FixedZone(name string, offset int) *Location

### func LoadLocation(name string) (*Location, error)

### func LoadLocationFromTZData(name string, data []byte) (*Location, error)

### func (l*Location) String() string

## type Month

### func (m Month) String() string

## type ParseError

### func (e *ParseError) Error() string

## type Ticker

  A Ticker holds a channel that delivers “ticks” of a clock at **intervals**.

### func NewTicker(d Duration) *Ticker

  NewTicker returns a new Ticker containing a channel that will send the current time on the channel after each tick. The period of the ticks is specified by the duration argument. **The ticker will adjust the time interval or drop ticks to make up for slow receivers**. The duration d must be greater than zero; if not, NewTicker will panic. Stop the ticker to release associated resources.

### func (t *Ticker) Reset(d Duration)

  Reset stops a ticker and resets its period to the specified duration. The next tick will arrive after the new period elapses. The duration d must be greater than zero; if not, Reset will panic.

### func (t *Ticker) Stop()

  Stop turns off a ticker. After Stop, no more ticks will be sent. Stop does not close the channel, to prevent a concurrent goroutine reading from the channel from seeing an erroneous "tick".


## type Time

### func Date(year int, month Month, day, hour, min, sec, nsec int, loc *Location) Time

### func Now() Time

### func Parse(layout, value string) (Time, error)

### func ParseInLocation(layout, value string, loc *Location) (Time, error)

### func Unix(sec int64, nsec int64) Time

### func UnixMicro(usec int64) Time

### func UnixMilli(msec int64) Time

### func (t Time) Add(d Duration) Time

### func (t Time) AddDate(years int, months int, days int) Time

### func (t Time) After(u Time) bool

### func (t Time) AppendFormat(b []byte, layout string) []byte

### func (t Time) Before(u Time) bool

### func (t Time) Clock() (hour, min, sec int)

### func (t Time) Date() (year int, month Month, day int)

### func (t Time) Day() int

### func (t Time) Equal(u Time) bool

### func (t Time) Format(layout string) string

### func (t Time) GoString() string

### func (t *Time) GobDecode(data []byte) error

### func (t Time) GobEncode() ([]byte, error)

### func (t Time) Hour() int

### func (t Time) ISOWeek() (year, week int)

### func (t Time) In(loc*Location) Time

### func (t Time) IsDST() bool

### func (t Time) IsZero() bool

### func (t Time) Local() Time

### func (t Time) Location() *Location

### func (t Time) MarshalBinary() ([]byte, error)

### func (t Time) MarshalJSON() ([]byte, error)

### func (t Time) MarshalText() ([]byte, error)

### func (t Time) Minute() int

### func (t Time) Month() Month

### func (t Time) Nanosecond() int

### func (t Time) Round(d Duration) Time

### func (t Time) Second() int

### func (t Time) String() string

### func (t Time) Sub(u Time) Duration

### func (t Time) Truncate(d Duration) Time

### func (t Time) UTC() Time

### func (t Time) Unix() int64

### func (t Time) UnixMicro() int64

### func (t Time) UnixMilli() int64

### func (t Time) UnixNano() int64

### func (t*Time) UnmarshalBinary(data []byte) error

### func (t *Time) UnmarshalJSON(data []byte) error

### func (t*Time) UnmarshalText(data []byte) error

### func (t Time) Weekday() Weekday

### func (t Time) Year() int

### func (t Time) YearDay() int

### func (t Time) Zone() (name string, offset int)

### func (t Time) ZoneBounds() (start, end Time)

### type Timer

  ```golang
  type Timer struct {
    C <-chan Time
    // contains filtered or unexported fields
  }
  ```

  这里的C用于接收

### func AfterFunc(d Duration, f func()) *Timer

### func NewTimer(d Duration)*Timer

### func (t *Timer) Reset(d Duration) bool

### func (t*Timer) Stop() bool

## type Weekday

### func (d Weekday) String() string

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

### func (r*Rand) ExpFloat64() float64

### func (r *Rand) Float32() float32

### func (r*Rand) Float64() float64

### func (r *Rand) Int() int

### func (r*Rand) Int31() int32

### func (r *Rand) Int31n(n int32) int32

### func (r*Rand) Int63() int64

### func (r *Rand) Int63n(n int64) int64

### func (r*Rand) Intn(n int) int

### func (r *Rand) NormFloat64() float64

### func (r*Rand) Perm(n int) []int

### func (r *Rand) Read(p []byte) (n int, err error)

### func (r*Rand) Seed(seed int64)

  Seed使用提供的种子值将生成器初始化为一个确定的状态。Seed不应该与其他Rand方法并发调用。

### func (r *Rand) Shuffle(n int, swap func(i, j int))

### func (r*Rand) Uint32() uint32

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

### func NewZipf(r \*Rand, s float64, v float64, imax uint64)\*Zipf

### func (z *Zipf) Uint64() uint64
