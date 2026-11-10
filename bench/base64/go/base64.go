// bench-base64's Go baseline (decision 68): Go's encoding/base64 standard encoding, with pad
// characters, which Go's protojson uses for a bytes field, behind a C ABI built as a c-archive.
// Each call encodes or decodes one whole text into the caller's buffer.
package main

import "C"

import (
	"encoding/base64"
	"unsafe"
)

// go_base64_encode encodes len octets at input into output, which holds room octets. It returns
// the letters written, or -1 when they do not fit.
//
//export go_base64_encode
func go_base64_encode(input *C.uchar, length C.size_t, output *C.uchar, room C.size_t) C.longlong {
	source := unsafe.Slice((*byte)(unsafe.Pointer(input)), int(length))
	destination := unsafe.Slice((*byte)(unsafe.Pointer(output)), int(room))
	need := base64.StdEncoding.EncodedLen(len(source))
	if need > len(destination) {
		return -1
	}
	base64.StdEncoding.Encode(destination, source)
	return C.longlong(need)
}

// go_base64_decode decodes len letters at text into output, which holds room octets. It returns
// the octets written, or -1 when the text is refused or does not fit.
//
//export go_base64_decode
func go_base64_decode(text *C.uchar, length C.size_t, output *C.uchar, room C.size_t) C.longlong {
	source := unsafe.Slice((*byte)(unsafe.Pointer(text)), int(length))
	destination := unsafe.Slice((*byte)(unsafe.Pointer(output)), int(room))
	if base64.StdEncoding.DecodedLen(len(source)) > len(destination) {
		return -1
	}
	written, err := base64.StdEncoding.Decode(destination, source)
	if err != nil {
		return -1
	}
	return C.longlong(written)
}

func main() {}
