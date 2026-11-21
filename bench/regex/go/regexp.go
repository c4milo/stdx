// bench-regex's Go baseline (decision 86): Go's regexp behind a C ABI built as a c-archive. A
// pattern is compiled once into a handle, and each call takes one whole haystack, or a batch of
// texts with a line feed after each, so that the cost of a call into Go is small beside its work.
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

// go_regex_count counts the matches of a pattern in a haystack, none inside another.
//
//export go_regex_count
func go_regex_count(handle C.size_t, haystack *C.uchar, length C.size_t) C.size_t {
	return C.size_t(len(compiled[handle-1].FindAllIndex(octets(haystack, length), -1)))
}

// go_regex_matching counts the texts a pattern matches, of texts with a line feed after each.
//
//export go_regex_matching
func go_regex_matching(handle C.size_t, texts *C.uchar, length C.size_t) C.size_t {
	expression := compiled[handle-1]
	rest := octets(texts, length)
	count := 0
	for len(rest) > 0 {
		end := bytes.IndexByte(rest, '\n')
		if expression.Match(rest[:end]) {
			count++
		}
		rest = rest[end+1:]
	}
	return C.size_t(count)
}

// go_regex_groups sums the start and the end of each group of the first match in each text, of
// texts with a line feed after each. A group that took no part adds nothing.
//
//export go_regex_groups
func go_regex_groups(handle C.size_t, texts *C.uchar, length C.size_t) C.size_t {
	expression := compiled[handle-1]
	rest := octets(texts, length)
	sum := 0
	for len(rest) > 0 {
		end := bytes.IndexByte(rest, '\n')
		for _, offset := range expression.FindSubmatchIndex(rest[:end]) {
			if offset >= 0 {
				sum += offset
			}
		}
		rest = rest[end+1:]
	}
	return C.size_t(sum)
}

func main() {}
