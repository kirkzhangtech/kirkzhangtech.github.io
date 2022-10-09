---
title: go标准库阅读与解析
categories:
- golang
tag: golang
---
- [1. package tar](#1-package-tar)
  - [1.1. Constants](#11-constants)
  - [1.2. Variables](#12-variables)
  - [1.3. type Format](#13-type-format)
    - [1.3.1. func (f Format) String() string](#131-func-f-format-string-string)
  - [1.4. type Header](#14-type-header)
    - [1.4.1. func FileInfoHeader(fi fs.FileInfo, link string) (*Header, error)](#141-func-fileinfoheaderfi-fsfileinfo-link-string-header-error)
    - [1.4.2. func (h*Header) FileInfo() fs.FileInfo](#142-func-hheader-fileinfo-fsfileinfo)
  - [1.5. type Reader](#15-type-reader)
    - [1.5.1. func NewReader(r io.Reader) *Reader](#151-func-newreaderr-ioreader-reader)
    - [1.5.2. func (tr*Reader) Next() (*Header, error)](#152-func-trreader-next-header-error)
    - [1.5.3. func (tr*Reader) Read(b []byte) (int, error)](#153-func-trreader-readb-byte-int-error)
  - [1.6. type Writer](#16-type-writer)
    - [1.6.1. func NewWriter(w io.Writer) *Writer](#161-func-newwriterw-iowriter-writer)
    - [1.6.2. func (tw*Writer) Close() error](#162-func-twwriter-close-error)
    - [1.6.3. func (tw *Writer) Flush() error](#163-func-tw-writer-flush-error)
    - [1.6.4. func (tw*Writer) Write(b []byte) (int, error)](#164-func-twwriter-writeb-byte-int-error)
    - [1.6.5. func (tw *Writer) WriteHeader(hdr*Header) error](#165-func-tw-writer-writeheaderhdrheader-error)
- [2. zip package](#2-zip-package)
  - [2.1. Constants](#21-constants)
  - [2.2. Variables](#22-variables)
    - [2.2.1. func RegisterCompressor(method uint16, comp Compressor)](#221-func-registercompressormethod-uint16-comp-compressor)
    - [2.2.2. func RegisterDecompressor(method uint16, dcomp Decompressor)](#222-func-registerdecompressormethod-uint16-dcomp-decompressor)
  - [2.3. type Compressor](#23-type-compressor)
  - [2.4. type Decompressor](#24-type-decompressor)
  - [2.5. type File](#25-type-file)
    - [2.5.1. func (f *File) DataOffset() (offset int64, err error)](#251-func-f-file-dataoffset-offset-int64-err-error)
    - [2.5.2. func (f*File) Open() (io.ReadCloser, error)](#252-func-ffile-open-ioreadcloser-error)
    - [2.5.3. func (f *File) OpenRaw() (io.Reader, error)](#253-func-f-file-openraw-ioreader-error)
  - [2.6. type FileHeader](#26-type-fileheader)
    - [2.6.1. func FileInfoHeader(fi fs.FileInfo) (*FileHeader, error)](#261-func-fileinfoheaderfi-fsfileinfo-fileheader-error)
    - [2.6.2. func (h *FileHeader) FileInfo() fs.FileInfo](#262-func-h-fileheader-fileinfo-fsfileinfo)
    - [2.6.3. func (h*FileHeader) ModTime() time.TimeDEPRECATED](#263-func-hfileheader-modtime-timetimedeprecated)
    - [2.6.4. func (h *FileHeader) Mode() (mode fs.FileMode)](#264-func-h-fileheader-mode-mode-fsfilemode)
    - [2.6.5. func (h*FileHeader) SetModTime(t time.Time)DEPRECATED](#265-func-hfileheader-setmodtimet-timetimedeprecated)
    - [2.6.6. func (h *FileHeader) SetMode(mode fs.FileMode)](#266-func-h-fileheader-setmodemode-fsfilemode)
  - [2.7. type ReadCloser](#27-type-readcloser)
    - [2.7.1. func OpenReader(name string) (*ReadCloser, error)](#271-func-openreadername-string-readcloser-error)
    - [2.7.2. func (rc *ReadCloser) Close() error](#272-func-rc-readcloser-close-error)
  - [2.8. type Reader](#28-type-reader)
    - [2.8.1. func NewReader(r io.ReaderAt, size int64) (*Reader, error)](#281-func-newreaderr-ioreaderat-size-int64-reader-error)
    - [2.8.2. func (r *Reader) Open(name string) (fs.File, error)](#282-func-r-reader-openname-string-fsfile-error)
    - [2.8.3. func (z*Reader) RegisterDecompressor(method uint16, dcomp Decompressor)](#283-func-zreader-registerdecompressormethod-uint16-dcomp-decompressor)
  - [2.9. type Writer](#29-type-writer)
    - [2.9.1. func NewWriter(w io.Writer) *Writer](#291-func-newwriterw-iowriter-writer)
    - [2.9.2. func (w*Writer) Close() error](#292-func-wwriter-close-error)
    - [2.9.3. func (w \*Writer) Copy(f\*File) error](#293-func-w-writer-copyffile-error)
    - [2.9.4. func (w *Writer) Create(name string) (io.Writer, error)](#294-func-w-writer-createname-string-iowriter-error)
    - [2.9.5. func (w\*Writer) CreateHeader(fh\*FileHeader) (io.Writer, error)](#295-func-wwriter-createheaderfhfileheader-iowriter-error)
    - [2.9.6. func (w\*Writer) CreateRaw(fh\*FileHeader) (io.Writer, error)](#296-func-wwriter-createrawfhfileheader-iowriter-error)
    - [2.9.7. func (w*Writer) Flush() error](#297-func-wwriter-flush-error)
    - [2.9.8. func (w *Writer) RegisterCompressor(method uint16, comp Compressor)](#298-func-w-writer-registercompressormethod-uint16-comp-compressor)
    - [2.9.9. func (w*Writer) SetComment(comment string) error](#299-func-wwriter-setcommentcomment-string-error)
    - [2.9.10. func (w *Writer) SetOffset(n int64)](#2910-func-w-writer-setoffsetn-int64)
- [3. time package](#3-time-package)
  - [3.1. Constants](#31-constants)
    - [3.1.1. func After(d Duration) <-chan Time](#311-func-afterd-duration--chan-time)
    - [3.1.2. func Sleep(d Duration)](#312-func-sleepd-duration)
    - [3.1.3. func Tick(d Duration) <-chan Time](#313-func-tickd-duration--chan-time)
  - [3.2. type Duration](#32-type-duration)
    - [3.2.1. func ParseDuration(s string) (Duration, error)](#321-func-parsedurations-string-duration-error)
    - [3.2.2. func Since(t Time) Duration](#322-func-sincet-time-duration)
    - [3.2.3. func Until(t Time) Duration](#323-func-untilt-time-duration)
    - [3.2.4. func (d Duration) Abs() Duration](#324-func-d-duration-abs-duration)
    - [3.2.5. func (d Duration) Hours() float64](#325-func-d-duration-hours-float64)
    - [3.2.6. func (d Duration) Microseconds() int64](#326-func-d-duration-microseconds-int64)
    - [3.2.7. func (d Duration) Milliseconds() int64](#327-func-d-duration-milliseconds-int64)
    - [3.2.8. func (d Duration) Minutes() float64](#328-func-d-duration-minutes-float64)
    - [3.2.9. func (d Duration) Nanoseconds() int64](#329-func-d-duration-nanoseconds-int64)
    - [3.2.10. func (d Duration) Round(m Duration) Duration](#3210-func-d-duration-roundm-duration-duration)
    - [3.2.11. func (d Duration) Seconds() float64](#3211-func-d-duration-seconds-float64)
    - [3.2.12. func (d Duration) String() string](#3212-func-d-duration-string-string)
    - [3.2.13. func (d Duration) Truncate(m Duration) Duration](#3213-func-d-duration-truncatem-duration-duration)
  - [3.3. type Location](#33-type-location)
    - [3.3.1. func FixedZone(name string, offset int) *Location](#331-func-fixedzonename-string-offset-int-location)
    - [3.3.2. func LoadLocation(name string) (*Location, error)](#332-func-loadlocationname-string-location-error)
    - [3.3.3. func LoadLocationFromTZData(name string, data []byte) (*Location, error)](#333-func-loadlocationfromtzdataname-string-data-byte-location-error)
    - [3.3.4. func (l*Location) String() string](#334-func-llocation-string-string)
  - [3.4. type Month](#34-type-month)
    - [3.4.1. func (m Month) String() string](#341-func-m-month-string-string)
  - [3.5. type ParseError](#35-type-parseerror)
    - [3.5.1. func (e *ParseError) Error() string](#351-func-e-parseerror-error-string)
  - [3.6. type Ticker](#36-type-ticker)
    - [3.6.1. func NewTicker(d Duration) *Ticker](#361-func-newtickerd-duration-ticker)
    - [3.6.2. func (t *Ticker) Reset(d Duration)](#362-func-t-ticker-resetd-duration)
    - [3.6.3. func (t *Ticker) Stop()](#363-func-t-ticker-stop)
  - [3.7. type Time](#37-type-time)
    - [3.7.1. func Date(year int, month Month, day, hour, min, sec, nsec int, loc *Location) Time](#371-func-dateyear-int-month-month-day-hour-min-sec-nsec-int-loc-location-time)
    - [3.7.2. func Now() Time](#372-func-now-time)
    - [3.7.3. func Parse(layout, value string) (Time, error)](#373-func-parselayout-value-string-time-error)
    - [3.7.4. func ParseInLocation(layout, value string, loc *Location) (Time, error)](#374-func-parseinlocationlayout-value-string-loc-location-time-error)
    - [3.7.5. func Unix(sec int64, nsec int64) Time](#375-func-unixsec-int64-nsec-int64-time)
    - [3.7.6. func UnixMicro(usec int64) Time](#376-func-unixmicrousec-int64-time)
    - [3.7.7. func UnixMilli(msec int64) Time](#377-func-unixmillimsec-int64-time)
    - [3.7.8. func (t Time) Add(d Duration) Time](#378-func-t-time-addd-duration-time)
    - [3.7.9. func (t Time) AddDate(years int, months int, days int) Time](#379-func-t-time-adddateyears-int-months-int-days-int-time)
    - [3.7.10. func (t Time) After(u Time) bool](#3710-func-t-time-afteru-time-bool)
    - [3.7.11. func (t Time) AppendFormat(b []byte, layout string) []byte](#3711-func-t-time-appendformatb-byte-layout-string-byte)
    - [3.7.12. func (t Time) Before(u Time) bool](#3712-func-t-time-beforeu-time-bool)
    - [3.7.13. func (t Time) Clock() (hour, min, sec int)](#3713-func-t-time-clock-hour-min-sec-int)
    - [3.7.14. func (t Time) Date() (year int, month Month, day int)](#3714-func-t-time-date-year-int-month-month-day-int)
    - [3.7.15. func (t Time) Day() int](#3715-func-t-time-day-int)
    - [3.7.16. func (t Time) Equal(u Time) bool](#3716-func-t-time-equalu-time-bool)
    - [3.7.17. func (t Time) Format(layout string) string](#3717-func-t-time-formatlayout-string-string)
    - [3.7.18. func (t Time) GoString() string](#3718-func-t-time-gostring-string)
    - [3.7.19. func (t *Time) GobDecode(data []byte) error](#3719-func-t-time-gobdecodedata-byte-error)
    - [3.7.20. func (t Time) GobEncode() ([]byte, error)](#3720-func-t-time-gobencode-byte-error)
    - [3.7.21. func (t Time) Hour() int](#3721-func-t-time-hour-int)
    - [3.7.22. func (t Time) ISOWeek() (year, week int)](#3722-func-t-time-isoweek-year-week-int)
    - [3.7.23. func (t Time) In(loc*Location) Time](#3723-func-t-time-inloclocation-time)
    - [3.7.24. func (t Time) IsDST() bool](#3724-func-t-time-isdst-bool)
    - [3.7.25. func (t Time) IsZero() bool](#3725-func-t-time-iszero-bool)
    - [3.7.26. func (t Time) Local() Time](#3726-func-t-time-local-time)
    - [3.7.27. func (t Time) Location() *Location](#3727-func-t-time-location-location)
    - [3.7.28. func (t Time) MarshalBinary() ([]byte, error)](#3728-func-t-time-marshalbinary-byte-error)
    - [3.7.29. func (t Time) MarshalJSON() ([]byte, error)](#3729-func-t-time-marshaljson-byte-error)
    - [3.7.30. func (t Time) MarshalText() ([]byte, error)](#3730-func-t-time-marshaltext-byte-error)
    - [3.7.31. func (t Time) Minute() int](#3731-func-t-time-minute-int)
    - [3.7.32. func (t Time) Month() Month](#3732-func-t-time-month-month)
    - [3.7.33. func (t Time) Nanosecond() int](#3733-func-t-time-nanosecond-int)
    - [3.7.34. func (t Time) Round(d Duration) Time](#3734-func-t-time-roundd-duration-time)
    - [3.7.35. func (t Time) Second() int](#3735-func-t-time-second-int)
    - [3.7.36. func (t Time) String() string](#3736-func-t-time-string-string)
    - [3.7.37. func (t Time) Sub(u Time) Duration](#3737-func-t-time-subu-time-duration)
    - [3.7.38. func (t Time) Truncate(d Duration) Time](#3738-func-t-time-truncated-duration-time)
    - [3.7.39. func (t Time) UTC() Time](#3739-func-t-time-utc-time)
    - [3.7.40. func (t Time) Unix() int64](#3740-func-t-time-unix-int64)
    - [3.7.41. func (t Time) UnixMicro() int64](#3741-func-t-time-unixmicro-int64)
    - [3.7.42. func (t Time) UnixMilli() int64](#3742-func-t-time-unixmilli-int64)
    - [3.7.43. func (t Time) UnixNano() int64](#3743-func-t-time-unixnano-int64)
    - [3.7.44. func (t*Time) UnmarshalBinary(data []byte) error](#3744-func-ttime-unmarshalbinarydata-byte-error)
    - [3.7.45. func (t *Time) UnmarshalJSON(data []byte) error](#3745-func-t-time-unmarshaljsondata-byte-error)
    - [3.7.46. func (t*Time) UnmarshalText(data []byte) error](#3746-func-ttime-unmarshaltextdata-byte-error)
    - [3.7.47. func (t Time) Weekday() Weekday](#3747-func-t-time-weekday-weekday)
    - [3.7.48. func (t Time) Year() int](#3748-func-t-time-year-int)
    - [3.7.49. func (t Time) YearDay() int](#3749-func-t-time-yearday-int)
    - [3.7.50. func (t Time) Zone() (name string, offset int)](#3750-func-t-time-zone-name-string-offset-int)
    - [3.7.51. func (t Time) ZoneBounds() (start, end Time)](#3751-func-t-time-zonebounds-start-end-time)
    - [3.7.52. type Timer](#3752-type-timer)
    - [3.7.53. func AfterFunc(d Duration, f func()) *Timer](#3753-func-afterfuncd-duration-f-func-timer)
    - [3.7.54. func NewTimer(d Duration)*Timer](#3754-func-newtimerd-durationtimer)
    - [3.7.55. func (t *Timer) Reset(d Duration) bool](#3755-func-t-timer-resetd-duration-bool)
    - [3.7.56. func (t*Timer) Stop() bool](#3756-func-ttimer-stop-bool)
  - [3.8. type Weekday](#38-type-weekday)
    - [3.8.1. func (d Weekday) String() string](#381-func-d-weekday-string-string)
- [4. rand](#4-rand)
  - [4.1. function not method of rand](#41-function-not-method-of-rand)
    - [4.1.1. func ExpFloat64() float64](#411-func-expfloat64-float64)
    - [4.1.2. func Float32() float32](#412-func-float32-float32)
    - [4.1.3. func Float64() float64](#413-func-float64-float64)
    - [4.1.4. func Int() int](#414-func-int-int)
    - [4.1.5. func Int31() int32](#415-func-int31-int32)
    - [4.1.6. func Int31n(n int32) int32](#416-func-int31nn-int32-int32)
    - [4.1.7. func Int63() int64](#417-func-int63-int64)
    - [4.1.8. func Int63n(n int64) int64](#418-func-int63nn-int64-int64)
    - [4.1.9. func Intn(n int) int](#419-func-intnn-int-int)
    - [4.1.10. func NormFloat64() float64](#4110-func-normfloat64-float64)
    - [4.1.11. func Perm(n int) []int](#4111-func-permn-int-int)
    - [4.1.12. func Read(p []byte) (n int, err error)](#4112-func-readp-byte-n-int-err-error)
    - [4.1.13. func Seed(seed int64)](#4113-func-seedseed-int64)
    - [4.1.14. func Shuffle(n int, swap func(i, j int))](#4114-func-shufflen-int-swap-funci-j-int)
    - [4.1.15. func Uint32() uint32](#4115-func-uint32-uint32)
    - [4.1.16. func Uint64() uint64](#4116-func-uint64-uint64)
  - [4.2. type Rand](#42-type-rand)
    - [4.2.1. func New(src Source) *Rand](#421-func-newsrc-source-rand)
    - [4.2.2. func (r*Rand) ExpFloat64() float64](#422-func-rrand-expfloat64-float64)
    - [4.2.3. func (r *Rand) Float32() float32](#423-func-r-rand-float32-float32)
    - [4.2.4. func (r*Rand) Float64() float64](#424-func-rrand-float64-float64)
    - [4.2.5. func (r *Rand) Int() int](#425-func-r-rand-int-int)
    - [4.2.6. func (r*Rand) Int31() int32](#426-func-rrand-int31-int32)
    - [4.2.7. func (r *Rand) Int31n(n int32) int32](#427-func-r-rand-int31nn-int32-int32)
    - [4.2.8. func (r*Rand) Int63() int64](#428-func-rrand-int63-int64)
    - [4.2.9. func (r *Rand) Int63n(n int64) int64](#429-func-r-rand-int63nn-int64-int64)
    - [4.2.10. func (r*Rand) Intn(n int) int](#4210-func-rrand-intnn-int-int)
    - [4.2.11. func (r *Rand) NormFloat64() float64](#4211-func-r-rand-normfloat64-float64)
    - [4.2.12. func (r*Rand) Perm(n int) []int](#4212-func-rrand-permn-int-int)
    - [4.2.13. func (r *Rand) Read(p []byte) (n int, err error)](#4213-func-r-rand-readp-byte-n-int-err-error)
    - [4.2.14. func (r*Rand) Seed(seed int64)](#4214-func-rrand-seedseed-int64)
    - [4.2.15. func (r *Rand) Shuffle(n int, swap func(i, j int))](#4215-func-r-rand-shufflen-int-swap-funci-j-int)
    - [4.2.16. func (r*Rand) Uint32() uint32](#4216-func-rrand-uint32-uint32)
    - [4.2.17. func (r *Rand) Uint64() uint64](#4217-func-r-rand-uint64-uint64)
  - [4.3. type Source](#43-type-source)
    - [4.3.1. func NewSource(seed int64) Source](#431-func-newsourceseed-int64-source)
  - [4.4. type Source64](#44-type-source64)
  - [4.5. type Zipf](#45-type-zipf)
    - [4.5.1. func NewZipf(r \*Rand, s float64, v float64, imax uint64)\*Zipf](#451-func-newzipfr-rand-s-float64-v-float64-imax-uint64zipf)
    - [4.5.2. func (z *Zipf) Uint64() uint64](#452-func-z-zipf-uint64-uint64)

# 1. package tar

  Package tar implements access to tar archives.

  Tape(封装) archives (tar) are a file format for storing a sequence of files that can be read and written in a streaming manner. This package aims to cover most variations of the format, including those produced by GNU and BSD tar tools.

## 1.1. Constants

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

## 1.2. Variables

  ```golang
  var (
    ErrHeader          = errors.New("archive/tar: invalid tar header")
    ErrWriteTooLong    = errors.New("archive/tar: write too long")
    ErrFieldTooLong    = errors.New("archive/tar: header field too long")
    ErrWriteAfterClose = errors.New("archive/tar: write after close")
  )
  ```

## 1.3. type Format

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

### 1.3.1. func (f Format) String() string
  
  打印tar的格式

## 1.4. type Header
  
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

### 1.4.1. func FileInfoHeader(fi fs.FileInfo, link string) (*Header, error)

### 1.4.2. func (h*Header) FileInfo() fs.FileInfo

## 1.5. type Reader

### 1.5.1. func NewReader(r io.Reader) *Reader

### 1.5.2. func (tr*Reader) Next() (*Header, error)

### 1.5.3. func (tr*Reader) Read(b []byte) (int, error)

## 1.6. type Writer

### 1.6.1. func NewWriter(w io.Writer) *Writer

### 1.6.2. func (tw*Writer) Close() error

### 1.6.3. func (tw *Writer) Flush() error

### 1.6.4. func (tw*Writer) Write(b []byte) (int, error)

### 1.6.5. func (tw *Writer) WriteHeader(hdr*Header) error

# 2. zip package

## 2.1. Constants

  ```golang
  const (
    Store   uint16 = 0 // no compression
    Deflate uint16 = 8 // DEFLATE compressed
  )
  ```

## 2.2. Variables

  ```golang
  var (
    ErrFormat    = errors.New("zip: not a valid zip file")
    ErrAlgorithm = errors.New("zip: unsupported compression algorithm")
    ErrChecksum  = errors.New("zip: checksum error")
  )

  ```

### 2.2.1. func RegisterCompressor(method uint16, comp Compressor)

### 2.2.2. func RegisterDecompressor(method uint16, dcomp Decompressor)

## 2.3. type Compressor

## 2.4. type Decompressor

## 2.5. type File

### 2.5.1. func (f *File) DataOffset() (offset int64, err error)

### 2.5.2. func (f*File) Open() (io.ReadCloser, error)

### 2.5.3. func (f *File) OpenRaw() (io.Reader, error)

## 2.6. type FileHeader

### 2.6.1. func FileInfoHeader(fi fs.FileInfo) (*FileHeader, error)

### 2.6.2. func (h *FileHeader) FileInfo() fs.FileInfo

### 2.6.3. func (h*FileHeader) ModTime() time.TimeDEPRECATED

### 2.6.4. func (h *FileHeader) Mode() (mode fs.FileMode)

### 2.6.5. func (h*FileHeader) SetModTime(t time.Time)DEPRECATED

### 2.6.6. func (h *FileHeader) SetMode(mode fs.FileMode)

## 2.7. type ReadCloser

### 2.7.1. func OpenReader(name string) (*ReadCloser, error)

### 2.7.2. func (rc *ReadCloser) Close() error

## 2.8. type Reader

### 2.8.1. func NewReader(r io.ReaderAt, size int64) (*Reader, error)

### 2.8.2. func (r *Reader) Open(name string) (fs.File, error)

### 2.8.3. func (z*Reader) RegisterDecompressor(method uint16, dcomp Decompressor)

## 2.9. type Writer

### 2.9.1. func NewWriter(w io.Writer) *Writer

### 2.9.2. func (w*Writer) Close() error

### 2.9.3. func (w \*Writer) Copy(f\*File) error

### 2.9.4. func (w *Writer) Create(name string) (io.Writer, error)

### 2.9.5. func (w\*Writer) CreateHeader(fh\*FileHeader) (io.Writer, error)

### 2.9.6. func (w\*Writer) CreateRaw(fh\*FileHeader) (io.Writer, error)

### 2.9.7. func (w*Writer) Flush() error

### 2.9.8. func (w *Writer) RegisterCompressor(method uint16, comp Compressor)

### 2.9.9. func (w*Writer) SetComment(comment string) error

### 2.9.10. func (w *Writer) SetOffset(n int64)

# 3. time package

## 3.1. Constants

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

### 3.1.1. func After(d Duration) <-chan Time

  After waits for the duration to elapse and then sends the current time on the returned channel. It is equivalent to NewTimer(d).C. The underlying Timer is not recovered by the garbage collector until the timer fires. If efficiency is a concern, use NewTimer instead and call Timer.Stop if the timer is no longer needed.这里需要注意，这个After(d Duration)是指返回一次的时间戳，想要使用还要再次初始化

### 3.1.2. func Sleep(d Duration)

### 3.1.3. func Tick(d Duration) <-chan Time

## 3.2. type Duration

### 3.2.1. func ParseDuration(s string) (Duration, error)

### 3.2.2. func Since(t Time) Duration

### 3.2.3. func Until(t Time) Duration

### 3.2.4. func (d Duration) Abs() Duration

### 3.2.5. func (d Duration) Hours() float64

### 3.2.6. func (d Duration) Microseconds() int64

### 3.2.7. func (d Duration) Milliseconds() int64

### 3.2.8. func (d Duration) Minutes() float64

### 3.2.9. func (d Duration) Nanoseconds() int64

### 3.2.10. func (d Duration) Round(m Duration) Duration

### 3.2.11. func (d Duration) Seconds() float64

### 3.2.12. func (d Duration) String() string

### 3.2.13. func (d Duration) Truncate(m Duration) Duration

## 3.3. type Location

### 3.3.1. func FixedZone(name string, offset int) *Location

### 3.3.2. func LoadLocation(name string) (*Location, error)

### 3.3.3. func LoadLocationFromTZData(name string, data []byte) (*Location, error)

### 3.3.4. func (l*Location) String() string

## 3.4. type Month

### 3.4.1. func (m Month) String() string

## 3.5. type ParseError

### 3.5.1. func (e *ParseError) Error() string

## 3.6. type Ticker

  A Ticker holds a channel that delivers “ticks” of a clock at **intervals**.

### 3.6.1. func NewTicker(d Duration) *Ticker

  NewTicker returns a new Ticker containing a channel that will send the current time on the channel after each tick. The period of the ticks is specified by the duration argument. **The ticker will adjust the time interval or drop ticks to make up for slow receivers**. The duration d must be greater than zero; if not, NewTicker will panic. Stop the ticker to release associated resources.

### 3.6.2. func (t *Ticker) Reset(d Duration)

  Reset stops a ticker and resets its period to the specified duration. The next tick will arrive after the new period elapses. The duration d must be greater than zero; if not, Reset will panic.

### 3.6.3. func (t *Ticker) Stop()

  Stop turns off a ticker. After Stop, no more ticks will be sent. Stop does not close the channel, to prevent a concurrent goroutine reading from the channel from seeing an erroneous "tick".
  
## 3.7. type Time

### 3.7.1. func Date(year int, month Month, day, hour, min, sec, nsec int, loc *Location) Time

### 3.7.2. func Now() Time

### 3.7.3. func Parse(layout, value string) (Time, error)

### 3.7.4. func ParseInLocation(layout, value string, loc *Location) (Time, error)

### 3.7.5. func Unix(sec int64, nsec int64) Time

### 3.7.6. func UnixMicro(usec int64) Time

### 3.7.7. func UnixMilli(msec int64) Time

### 3.7.8. func (t Time) Add(d Duration) Time

### 3.7.9. func (t Time) AddDate(years int, months int, days int) Time

### 3.7.10. func (t Time) After(u Time) bool

### 3.7.11. func (t Time) AppendFormat(b []byte, layout string) []byte

### 3.7.12. func (t Time) Before(u Time) bool

### 3.7.13. func (t Time) Clock() (hour, min, sec int)

### 3.7.14. func (t Time) Date() (year int, month Month, day int)

### 3.7.15. func (t Time) Day() int

### 3.7.16. func (t Time) Equal(u Time) bool

### 3.7.17. func (t Time) Format(layout string) string

### 3.7.18. func (t Time) GoString() string

### 3.7.19. func (t *Time) GobDecode(data []byte) error

### 3.7.20. func (t Time) GobEncode() ([]byte, error)

### 3.7.21. func (t Time) Hour() int

### 3.7.22. func (t Time) ISOWeek() (year, week int)

### 3.7.23. func (t Time) In(loc*Location) Time

### 3.7.24. func (t Time) IsDST() bool

### 3.7.25. func (t Time) IsZero() bool

### 3.7.26. func (t Time) Local() Time

### 3.7.27. func (t Time) Location() *Location

### 3.7.28. func (t Time) MarshalBinary() ([]byte, error)

### 3.7.29. func (t Time) MarshalJSON() ([]byte, error)

### 3.7.30. func (t Time) MarshalText() ([]byte, error)

### 3.7.31. func (t Time) Minute() int

### 3.7.32. func (t Time) Month() Month

### 3.7.33. func (t Time) Nanosecond() int

### 3.7.34. func (t Time) Round(d Duration) Time

### 3.7.35. func (t Time) Second() int

### 3.7.36. func (t Time) String() string

### 3.7.37. func (t Time) Sub(u Time) Duration

### 3.7.38. func (t Time) Truncate(d Duration) Time

### 3.7.39. func (t Time) UTC() Time

### 3.7.40. func (t Time) Unix() int64

### 3.7.41. func (t Time) UnixMicro() int64

### 3.7.42. func (t Time) UnixMilli() int64

### 3.7.43. func (t Time) UnixNano() int64

### 3.7.44. func (t*Time) UnmarshalBinary(data []byte) error

### 3.7.45. func (t *Time) UnmarshalJSON(data []byte) error

### 3.7.46. func (t*Time) UnmarshalText(data []byte) error

### 3.7.47. func (t Time) Weekday() Weekday

### 3.7.48. func (t Time) Year() int

### 3.7.49. func (t Time) YearDay() int

### 3.7.50. func (t Time) Zone() (name string, offset int)

### 3.7.51. func (t Time) ZoneBounds() (start, end Time)

### 3.7.52. type Timer

  ```golang
  type Timer struct {
    C <-chan Time
    // contains filtered or unexported fields
  }
  ```

  这里的C用于接收

### 3.7.53. func AfterFunc(d Duration, f func()) *Timer

### 3.7.54. func NewTimer(d Duration)*Timer

### 3.7.55. func (t *Timer) Reset(d Duration) bool

### 3.7.56. func (t*Timer) Stop() bool

## 3.8. type Weekday

### 3.8.1. func (d Weekday) String() string

# 4. rand

## 4.1. function not method of rand

### 4.1.1. func ExpFloat64() float64

### 4.1.2. func Float32() float32

### 4.1.3. func Float64() float64

### 4.1.4. func Int() int

### 4.1.5. func Int31() int32

### 4.1.6. func Int31n(n int32) int32

### 4.1.7. func Int63() int64

### 4.1.8. func Int63n(n int64) int64

### 4.1.9. func Intn(n int) int

### 4.1.10. func NormFloat64() float64

### 4.1.11. func Perm(n int) []int

### 4.1.12. func Read(p []byte) (n int, err error)

### 4.1.13. func Seed(seed int64)

### 4.1.14. func Shuffle(n int, swap func(i, j int))

### 4.1.15. func Uint32() uint32

### 4.1.16. func Uint64() uint64

## 4.2. type Rand

### 4.2.1. func New(src Source) *Rand

### 4.2.2. func (r*Rand) ExpFloat64() float64

### 4.2.3. func (r *Rand) Float32() float32

### 4.2.4. func (r*Rand) Float64() float64

### 4.2.5. func (r *Rand) Int() int

### 4.2.6. func (r*Rand) Int31() int32

### 4.2.7. func (r *Rand) Int31n(n int32) int32

### 4.2.8. func (r*Rand) Int63() int64

### 4.2.9. func (r *Rand) Int63n(n int64) int64

### 4.2.10. func (r*Rand) Intn(n int) int

### 4.2.11. func (r *Rand) NormFloat64() float64

### 4.2.12. func (r*Rand) Perm(n int) []int

### 4.2.13. func (r *Rand) Read(p []byte) (n int, err error)

### 4.2.14. func (r*Rand) Seed(seed int64)

  Seed使用提供的种子值将生成器初始化为一个确定的状态。Seed不应该与其他Rand方法并发调用。

### 4.2.15. func (r *Rand) Shuffle(n int, swap func(i, j int))

### 4.2.16. func (r*Rand) Uint32() uint32

### 4.2.17. func (r *Rand) Uint64() uint64

## 4.3. type Source

### 4.3.1. func NewSource(seed int64) Source

  NewSource返回一个新的伪随机源，其种子为给定值。与顶级函数使用的默认Source不同，这个Source对于多个goroutine的并发使用是不安全的。

  ```golang
  randomSource := NewSource(time.Now().UnixNano())
  randSeed := New(randomSource) //这时候就可以使用rand的method
  randomInt := randSeed.Intn(300)//[0,300)的整数

  ```

## 4.4. type Source64

  Source64是一个也可以直接生成[0, 1<<64]范围内的均匀分布的伪随机uint64值的Source。如果一个Rand r的底层Source s实现了Source64，那么r.Uint64返回对s.Uint64的一次调用结果，而不是对s.Int63的两次调用。  
  Source64的结构

  ```golang
  type Source64 interface {
      Source
      Uint64() uint64
  }
  ```

## 4.5. type Zipf

### 4.5.1. func NewZipf(r \*Rand, s float64, v float64, imax uint64)\*Zipf

### 4.5.2. func (z *Zipf) Uint64() uint64
