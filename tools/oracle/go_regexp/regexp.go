// The Go oracle of `zig build differential-regex` (decision 86): Go's regexp, which holds RE2's
// syntax and RE2's leftmost-first matches, and Go's bzip2 decoder, which reads RE2's exhaustive
// test log, behind a C ABI built as a c-archive. Each call takes its octets from the caller's
// buffers and writes into the caller's room.
package main

import "C"

import (
	"bytes"
	"compress/bzip2"
	"io"
	"regexp"
	"unsafe"
)

// The verdicts of go_regexp_find that are no count of groups.
const (
	noMatch       = 0
	refused       = -1
	groupsTooMany = -2
)

// The pattern of the last call and what Go made of it. RE2's logs give one pattern many texts, so
// one compiled pattern serves the calls that follow it.
var (
	lastPattern  []byte
	lastRegexp   *regexp.Regexp
	lastCompiled bool
)

func compiled(pattern []byte) *regexp.Regexp {
	if lastCompiled && bytes.Equal(lastPattern, pattern) {
		return lastRegexp
	}
	lastPattern = append(lastPattern[:0], pattern...)
	lastCompiled = true
	lastRegexp = nil
	if expression, err := regexp.Compile(string(pattern)); err == nil {
		lastRegexp = expression
	}
	return lastRegexp
}

func octets(pointer *C.uchar, length C.size_t) []byte {
	if length == 0 {
		return nil
	}
	return unsafe.Slice((*byte)(unsafe.Pointer(pointer)), int(length))
}

// go_regexp_find searches text for the leftmost-first match of pattern. It writes the start and
// the end of each group into offsets, the whole match first, with -1 twice for a group that took
// no part, and returns the groups written. It returns 0 when nothing matches, -1 when Go refuses
// the pattern, and -2 when the groups do not fit room, which counts groups.
//
//export go_regexp_find
func go_regexp_find(pattern *C.uchar, patternLength C.size_t, text *C.uchar, textLength C.size_t, offsets *C.longlong, room C.size_t) C.longlong {
	expression := compiled(octets(pattern, patternLength))
	if expression == nil {
		return refused
	}
	found := expression.FindSubmatchIndex(octets(text, textLength))
	if found == nil {
		return noMatch
	}
	groups := len(found) / 2
	if groups > int(room) {
		return groupsTooMany
	}
	out := unsafe.Slice(offsets, 2*groups)
	for index, offset := range found {
		out[index] = C.longlong(offset)
	}
	return C.longlong(groups)
}

// go_bzip2_decode decodes the bzip2 stream of length octets at input into output, which holds
// room octets. It returns the octets written, or -1 when the stream is refused or does not fit.
//
//export go_bzip2_decode
func go_bzip2_decode(input *C.uchar, length C.size_t, output *C.uchar, room C.size_t) C.longlong {
	destination := unsafe.Slice((*byte)(unsafe.Pointer(output)), int(room))
	reader := bzip2.NewReader(bytes.NewReader(octets(input, length)))
	written := 0
	for written < len(destination) {
		count, err := reader.Read(destination[written:])
		written += count
		if err == io.EOF {
			return C.longlong(written)
		}
		if err != nil {
			return -1
		}
	}
	// The room is full: the stream fits only when it ends here.
	var one [1]byte
	if count, err := reader.Read(one[:]); count == 0 && err == io.EOF {
		return C.longlong(written)
	}
	return -1
}

func main() {}
