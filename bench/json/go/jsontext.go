// bench-json's Go baseline (decision 69): encoding/json/jsontext, Go's reader and writer of JSON
// tokens, behind the C ABI of bench/json/baselines/baselines.h, built as a c-archive. It does the
// work stdx's decoder and encoder do (bench/json/baselines/baselines.zig).
//
// Decoding reads a text a token at a time and takes every name and string unescaped. Encoding
// writes a text a token at a time: a string for each name and string, a hex string's digits and a
// decimal's text formatted as a Go caller formats them, and a number's text as a value.
//
// Each decoder and encoder is kept across calls and reset for each text, as a caller keeps them.
// Both allow a name that repeats in an object, which no other candidate checks for.
package main

import "C"

import (
	"bytes"
	"encoding/hex"
	"encoding/json/jsontext"
	"io"
	"strconv"
	"unsafe"
)

// tally is stdx_bench_tally of baselines.h.
type tally struct {
	containers, strings, stringLen, numbers, literals uint64
}

// token is stdx_bench_token of baselines.h.
type token struct {
	kind, fractionDigits, negative, integral uint8
	octets                                   *byte
	len                                      uintptr
	integer, fraction                        uint64
	real                                     float64
}

// tokenSize is the size baselines.h gives a token on a 64-bit target.
const tokenSize = 48

// A compile error when the Go layout of a token differs from the C one.
var _ [tokenSize - unsafe.Sizeof(token{})]struct{}
var _ [unsafe.Sizeof(token{}) - tokenSize]struct{}

// The kinds of a token, as baselines.h numbers them.
const (
	beginObject = iota
	endObject
	beginArray
	endArray
	name
	str
	hexString
	number
	unsigned
	signed
	decimal
	falseLiteral
	trueLiteral
	nullLiteral
)

var (
	input   bytes.Reader
	decoder = jsontext.NewDecoder(&input, jsontext.AllowDuplicateNames(true))
	output  sliceWriter
	encoder = jsontext.NewEncoder(&output, jsontext.AllowDuplicateNames(true))
	scratch []byte
)

// sliceWriter writes into the caller's memory and fails when it is full.
type sliceWriter struct {
	out     []byte
	written int
}

func (w *sliceWriter) Write(p []byte) (int, error) {
	if len(p) > len(w.out)-w.written {
		return 0, io.ErrShortWrite
	}
	copy(w.out[w.written:], p)
	w.written += len(p)
	return len(p), nil
}

// stdx_bench_go_built returns 1: this baseline is built.
//
//export stdx_bench_go_built
func stdx_bench_go_built() C.int {
	return 1
}

// stdx_bench_go_decode reads the one text of length octets at text and adds what it found to the
// tally at counts. It returns 0, or 1 when jsontext refuses the text.
//
//export stdx_bench_go_decode
func stdx_bench_go_decode(text unsafe.Pointer, length C.size_t, counts unsafe.Pointer) C.int {
	found := (*tally)(counts)
	input.Reset(unsafe.Slice((*byte)(text), int(length)))
	decoder.Reset(&input, jsontext.AllowDuplicateNames(true))
	for {
		next, err := decoder.ReadToken()
		if err == io.EOF {
			return 0
		}
		if err != nil {
			return 1
		}
		switch next.Kind() {
		case '{', '[':
			found.containers++
		case '}', ']':
		case '"':
			found.strings++
			found.stringLen += uint64(len(next.String()))
		case '0':
			found.numbers++
		default:
			found.literals++
		}
	}
}

// stdx_bench_go_encode writes the one text of count tokens at tokens into the outLen octets at
// out. It returns the octets written, or 0 when jsontext fails or out is too short.
//
//export stdx_bench_go_encode
func stdx_bench_go_encode(tokens unsafe.Pointer, count C.size_t, out unsafe.Pointer, outLen C.size_t) C.size_t {
	output = sliceWriter{out: unsafe.Slice((*byte)(out), int(outLen))}
	encoder.Reset(&output, jsontext.AllowDuplicateNames(true))
	list := unsafe.Slice((*token)(tokens), int(count))
	for index := range list {
		if write(&list[index]) != nil {
			return 0
		}
	}
	return C.size_t(output.written)
}

// write writes one token.
func write(t *token) error {
	switch t.kind {
	case beginObject:
		return encoder.WriteToken(jsontext.BeginObject)
	case endObject:
		return encoder.WriteToken(jsontext.EndObject)
	case beginArray:
		return encoder.WriteToken(jsontext.BeginArray)
	case endArray:
		return encoder.WriteToken(jsontext.EndArray)
	case name, str:
		return encoder.WriteToken(jsontext.String(unsafe.String(t.octets, int(t.len))))
	case hexString:
		scratch = hex.AppendEncode(scratch[:0], unsafe.Slice(t.octets, int(t.len)))
		return encoder.WriteToken(jsontext.String(unsafe.String(unsafe.SliceData(scratch), len(scratch))))
	case number:
		return encoder.WriteValue(jsontext.Value(unsafe.Slice(t.octets, int(t.len))))
	case unsigned:
		return encoder.WriteToken(jsontext.Uint(t.integer))
	case signed:
		return encoder.WriteToken(jsontext.Int(int64(t.integer)))
	case decimal:
		scratch = strconv.AppendFloat(scratch[:0], t.real, 'f', int(t.fractionDigits), 64)
		return encoder.WriteValue(jsontext.Value(scratch))
	case falseLiteral:
		return encoder.WriteToken(jsontext.False)
	case trueLiteral:
		return encoder.WriteToken(jsontext.True)
	default:
		return encoder.WriteToken(jsontext.Null)
	}
}

func main() {}
