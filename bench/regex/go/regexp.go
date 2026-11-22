// bench-regex's Go baseline (decision 86): Go's regexp behind a C ABI built as a c-archive. A
// pattern is compiled once into a handle, and each call takes one whole haystack, or a batch of
// texts and the offset where each ends, so that the cost of a call into Go is small beside its
// work.
package main

import "C"

import (
	"bytes"
	"regexp"
	"unsafe"
)

// The patterns compiled so far. A handle is an index into it plus one, so that 0 is no handle.
var compiled []*regexp.Regexp

func octets(pointer *C.uchar, length C.size_t) []byte {
	if length == 0 {
		return nil
	}
	return unsafe.Slice((*byte)(unsafe.Pointer(pointer)), int(length))
}

// go_regex_new compiles a pattern. It returns a handle, or 0 when Go refuses the pattern.
//
//export go_regex_new
func go_regex_new(pattern *C.uchar, length C.size_t) C.size_t {
	expression, err := regexp.Compile(string(octets(pattern, length)))
	if err != nil {
		return 0
	}
	compiled = append(compiled, expression)
	return C.size_t(len(compiled))
}

// go_regex_compile compiles a pattern and keeps nothing: the cost of compiling alone. It returns
// 1, or 0 when Go refuses the pattern.
//
//export go_regex_compile
func go_regex_compile(pattern *C.uchar, length C.size_t) C.size_t {
	if _, err := regexp.Compile(string(octets(pattern, length))); err != nil {
		return 0
	}
	return 1
}

// go_regex_find_all finds the matches of a pattern in a haystack, none inside another. It returns
// their count, and writes the sum of each match's start and end to offsets.
//
//export go_regex_find_all
func go_regex_find_all(handle C.size_t, haystack *C.uchar, length C.size_t, offsets *C.ulonglong) C.size_t {
	found := compiled[handle-1].FindAllIndex(octets(haystack, length), -1)
	sum := uint64(0)
	for _, span := range found {
		sum += uint64(span[0] + span[1])
	}
	*offsets = C.ulonglong(sum)
	return C.size_t(len(found))
}

// batch gives the octets of count texts, one after another, and the offset where each ends.
func batch(texts *C.uchar, ends *C.uint, count C.size_t) ([]byte, []C.uint) {
	if count == 0 {
		return nil, nil
	}
	offsets := unsafe.Slice(ends, int(count))
	return octets(texts, C.size_t(offsets[count-1])), offsets
}

// go_regex_matching counts the texts of a batch that a pattern matches.
//
//export go_regex_matching
func go_regex_matching(handle C.size_t, texts *C.uchar, ends *C.uint, count C.size_t) C.size_t {
	expression := compiled[handle-1]
	all, offsets := batch(texts, ends, count)
	matching := 0
	start := C.uint(0)
	for _, end := range offsets {
		if expression.Match(all[start:end]) {
			matching++
		}
		start = end
	}
	return C.size_t(matching)
}

// go_regex_groups sums the start and the end of each group of the first match in each text of a
// batch. A group that took no part adds nothing.
//
//export go_regex_groups
func go_regex_groups(handle C.size_t, texts *C.uchar, ends *C.uint, count C.size_t) C.size_t {
	expression := compiled[handle-1]
	all, offsets := batch(texts, ends, count)
	sum := 0
	start := C.uint(0)
	for _, end := range offsets {
		for _, offset := range expression.FindSubmatchIndex(all[start:end]) {
			if offset >= 0 {
				sum += offset
			}
		}
		start = end
	}
	return C.size_t(sum)
}

// lines gives a haystack's lines, as rebar's models split them: at each line feed, with a
// carriage return before it left out, and no empty line after the last line feed.
func lines(haystack []byte) [][]byte {
	if len(haystack) == 0 {
		return nil
	}
	all := bytes.Split(bytes.TrimSuffix(haystack, []byte{'\n'}), []byte{'\n'})
	for index, line := range all {
		all[index] = bytes.TrimSuffix(line, []byte{'\r'})
	}
	return all
}

// countCaptures counts the groups that take part in each match of a haystack, the whole match
// counted.
func countCaptures(expression *regexp.Regexp, haystack []byte) uint64 {
	count := uint64(0)
	for _, match := range expression.FindAllSubmatchIndex(haystack, -1) {
		for group := 0; group < len(match); group += 2 {
			if match[group] >= 0 {
				count++
			}
		}
	}
	return count
}

// go_rebar_run runs one of rebar's models on a whole haystack, in the order of regex_rebar.zig's
// Model: count, count-spans, count-captures, grep, grep-captures, and compile's count.
//
//export go_rebar_run
func go_rebar_run(handle C.size_t, model C.uint, haystack *C.uchar, length C.size_t) C.ulonglong {
	expression := compiled[handle-1]
	text := octets(haystack, length)
	sum := uint64(0)
	switch model {
	case 0, 5:
		sum = uint64(len(expression.FindAllIndex(text, -1)))
	case 1:
		for _, match := range expression.FindAllIndex(text, -1) {
			sum += uint64(match[1] - match[0])
		}
	case 2:
		sum = countCaptures(expression, text)
	case 3:
		for _, line := range lines(text) {
			if expression.Match(line) {
				sum++
			}
		}
	case 4:
		for _, line := range lines(text) {
			sum += countCaptures(expression, line)
		}
	default:
		panic("go_rebar_run: no such model")
	}
	return C.ulonglong(sum)
}

func main() {}
