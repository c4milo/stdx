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

// The callers go_regexp_find serves at once: each thread of the check names a slot of its own.
const slotCount = 64

// The pattern of a slot's last call and what Go made of it. A check gives one pattern many texts,
// so one compiled pattern serves the calls that follow it. No two threads share a slot, so a slot
// needs no lock.
type slot struct {
	pattern  []byte
	regexp   *regexp.Regexp
	compiled bool
}

var slots [slotCount]slot

func compiled(last *slot, pattern []byte) *regexp.Regexp {
	if last.compiled && bytes.Equal(last.pattern, pattern) {
		return last.regexp
	}
	last.pattern = append(last.pattern[:0], pattern...)
	last.compiled = true
	last.regexp = nil
	if expression, err := regexp.Compile(string(pattern)); err == nil {
		last.regexp = expression
	}
	return last.regexp
}

func octets(pointer *C.uchar, length C.size_t) []byte {
	if length == 0 {
		return nil
	}
	return unsafe.Slice((*byte)(unsafe.Pointer(pointer)), int(length))
}

// go_regexp_find searches text for the leftmost-first match of pattern, for the caller that holds
// the slot index. It writes the start and the end of each group into offsets, the whole match
// first, with -1 twice for a group that took no part, and returns the groups written. It returns
// 0 when nothing matches, -1 when Go refuses the pattern, and -2 when the groups do not fit room,
// which counts groups.
//
//export go_regexp_find
func go_regexp_find(index C.size_t, pattern *C.uchar, patternLength C.size_t, text *C.uchar, textLength C.size_t, offsets *C.longlong, room C.size_t) C.longlong {
	expression := compiled(&slots[index%slotCount], octets(pattern, patternLength))
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
