//! bench-json's Rust baseline (decision 69): serde_json through its documented API, doing the
//! work stdx's decoder and encoder do (bench/json/baselines/baselines.zig).
//!
//! Decoding walks a text with a visitor and builds no document: it counts every container,
//! takes every name and string unescaped, and takes every number as serde_json parses it, into
//! a u64, an i64 or an f64. Encoding drives serde_json's serializer from the tokens: a map or a
//! sequence for each container, a `&str` checked as UTF-8 for each name and string, and a
//! number from its value, as serde_json has no text of a number to write.

use serde::de::{DeserializeSeed, Deserializer, MapAccess, SeqAccess, Visitor};
use serde::ser::{Error as _, Serialize, SerializeMap, SerializeSeq, Serializer};
use std::cell::Cell;
use std::fmt;

/// `stdx_bench_tally` of baselines.h.
#[repr(C)]
pub struct Tally {
    containers: u64,
    strings: u64,
    string_len: u64,
    numbers: u64,
    literals: u64,
}

/// `stdx_bench_token` of baselines.h.
#[repr(C)]
pub struct Token {
    kind: u8,
    fraction_digits: u8,
    negative: u8,
    integral: u8,
    octets: *const u8,
    len: usize,
    integer: u64,
    fraction: u64,
    real: f64,
}

// The kinds of a token, as baselines.h numbers them.
const BEGIN_OBJECT: u8 = 0;
const END_OBJECT: u8 = 1;
const BEGIN_ARRAY: u8 = 2;
const END_ARRAY: u8 = 3;
const STRING: u8 = 5;
const HEX: u8 = 6;
const NUMBER: u8 = 7;
const UNSIGNED: u8 = 8;
const SIGNED: u8 = 9;
const DECIMAL: u8 = 10;
const FALSE: u8 = 11;
const TRUE: u8 = 12;

extern "C" {
    /// baselines_yyjson.c: two lowercase hex digits for each octet of the token.
    fn stdx_bench_format_hex(token: *const Token, out: *mut u8) -> usize;
}

/// 1: this baseline is built.
#[no_mangle]
pub extern "C" fn stdx_bench_serde_built() -> i32 {
    1
}

/// A visitor that counts what it walks into the tally.
struct Walk<'t>(&'t mut Tally);

impl<'de, 't> DeserializeSeed<'de> for Walk<'t> {
    type Value = ();

    fn deserialize<D: Deserializer<'de>>(self, deserializer: D) -> Result<(), D::Error> {
        deserializer.deserialize_any(self)
    }
}

impl<'de, 't> Visitor<'de> for Walk<'t> {
    type Value = ();

    fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        formatter.write_str("a JSON value")
    }

    fn visit_bool<E>(self, _: bool) -> Result<(), E> {
        self.0.literals += 1;
        Ok(())
    }

    fn visit_unit<E>(self) -> Result<(), E> {
        self.0.literals += 1;
        Ok(())
    }

    fn visit_u64<E>(self, _: u64) -> Result<(), E> {
        self.0.numbers += 1;
        Ok(())
    }

    fn visit_i64<E>(self, _: i64) -> Result<(), E> {
        self.0.numbers += 1;
        Ok(())
    }

    fn visit_f64<E>(self, _: f64) -> Result<(), E> {
        self.0.numbers += 1;
        Ok(())
    }

    fn visit_str<E>(self, text: &str) -> Result<(), E> {
        self.0.strings += 1;
        self.0.string_len += text.len() as u64;
        Ok(())
    }

    fn visit_seq<A: SeqAccess<'de>>(self, mut sequence: A) -> Result<(), A::Error> {
        self.0.containers += 1;
        while sequence.next_element_seed(Walk(&mut *self.0))?.is_some() {}
        Ok(())
    }

    fn visit_map<A: MapAccess<'de>>(self, mut map: A) -> Result<(), A::Error> {
        self.0.containers += 1;
        while map.next_key_seed(Walk(&mut *self.0))?.is_some() {
            map.next_value_seed(Walk(&mut *self.0))?;
        }
        Ok(())
    }
}

/// Walks the one text of `len` octets at `text` and adds what it found to `tally`. Returns 0, or
/// 1 when serde_json refuses the text.
///
/// # Safety
/// `text` holds `len` octets, and `tally` points at a tally.
#[no_mangle]
pub unsafe extern "C" fn stdx_bench_serde_decode(text: *const u8, len: usize, tally: *mut Tally) -> i32 {
    let text = std::slice::from_raw_parts(text, len);
    let mut deserializer = serde_json::Deserializer::from_slice(text);
    deserializer.disable_recursion_limit();
    if Walk(&mut *tally).deserialize(&mut deserializer).is_err() {
        return 1;
    }
    if deserializer.end().is_err() {
        return 1;
    }
    0
}

/// The value that starts at the next token: serializing it takes the value's tokens.
struct Text<'a> {
    tokens: &'a [Token],
    next: &'a Cell<usize>,
    scratch: *mut u8,
}

impl<'a> Text<'a> {
    fn take(&self) -> &'a Token {
        let index = self.next.get();
        self.next.set(index + 1);
        &self.tokens[index]
    }

    /// A name's or a string's octets as a `&str`, checked as UTF-8, as a caller that holds octets
    /// checks them.
    fn text_of<E: serde::ser::Error>(token: &Token) -> Result<&str, E> {
        let octets = unsafe { std::slice::from_raw_parts(token.octets, token.len) };
        std::str::from_utf8(octets).map_err(E::custom)
    }
}

impl<'a> Serialize for Text<'a> {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let token = self.take();
        match token.kind {
            BEGIN_OBJECT => {
                let mut map = serializer.serialize_map(None)?;
                loop {
                    let name = self.take();
                    if name.kind == END_OBJECT {
                        break;
                    }
                    map.serialize_key(Self::text_of::<S::Error>(name)?)?;
                    map.serialize_value(self)?;
                }
                map.end()
            }
            BEGIN_ARRAY => {
                let mut sequence = serializer.serialize_seq(None)?;
                while self.tokens[self.next.get()].kind != END_ARRAY {
                    sequence.serialize_element(self)?;
                }
                self.take();
                sequence.end()
            }
            STRING => serializer.serialize_str(Self::text_of::<S::Error>(token)?),
            HEX => {
                let digits = unsafe {
                    let len = stdx_bench_format_hex(token, self.scratch);
                    std::str::from_utf8_unchecked(std::slice::from_raw_parts(self.scratch, len))
                };
                serializer.serialize_str(digits)
            }
            NUMBER if token.integral == 0 => serializer.serialize_f64(token.real),
            NUMBER if token.negative != 0 => serializer.serialize_i64((token.integer as i64).wrapping_neg()),
            NUMBER | UNSIGNED => serializer.serialize_u64(token.integer),
            SIGNED => serializer.serialize_i64(token.integer as i64),
            DECIMAL => serializer.serialize_f64(token.real),
            FALSE => serializer.serialize_bool(false),
            TRUE => serializer.serialize_bool(true),
            END_ARRAY => Err(S::Error::custom("an array's end where a value starts")),
            _ => serializer.serialize_unit(),
        }
    }
}

/// Writes the one text of `len` tokens at `tokens` into `out`, with `scratch` for a hex string's
/// digits. Returns the octets written, or 0 when serde_json fails or `out` is too short.
///
/// # Safety
/// `tokens` holds `len` tokens of one text, `out` holds `out_len` octets, and `scratch` holds
/// twice the octets of the longest hex token.
#[no_mangle]
pub unsafe extern "C" fn stdx_bench_serde_encode(tokens: *const Token, len: usize, out: *mut u8, out_len: usize, scratch: *mut u8) -> usize {
    let tokens = std::slice::from_raw_parts(tokens, len);
    let mut room: &mut [u8] = std::slice::from_raw_parts_mut(out, out_len);
    let next = Cell::new(0);
    let text = Text { tokens, next: &next, scratch };
    if serde_json::to_writer(&mut room, &text).is_err() {
        return 0;
    }
    out_len - room.len()
}

// A dependent's message shapes as Buffa writes them: typed fields, serialized by code of the
// form serde's derive generates (`serialize_struct` and one `serialize_field` a field), not from
// tokens. bench-json times it beside `TextWriter`'s methods on the workloads named `messages:`
// (json_typed.zig; decision 81).

use serde::ser::SerializeStruct;

const NAME: u8 = 4;
const NULL: u8 = 13;
/// The members of a strings message, and the levels of a deep one.
const STRINGS_MEMBERS: usize = 11;
const DEEP_LEVELS: usize = 50;
/// The tokens of each level of a deep message: a label's name and string, a value's name and
/// number, and a child's name and its object or null.
const DEEP_TOKENS_PER_LEVEL: usize = 6;

pub struct StringsMessage {
    id: String,
    name: String,
    email: String,
    phone: String,
    address: String,
    city: String,
    country: String,
    postal_code: String,
    company: String,
    title: String,
    note: String,
}

impl Serialize for StringsMessage {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let mut message = serializer.serialize_struct("StringsMessage", STRINGS_MEMBERS)?;
        message.serialize_field("id", &self.id)?;
        message.serialize_field("name", &self.name)?;
        message.serialize_field("email", &self.email)?;
        message.serialize_field("phone", &self.phone)?;
        message.serialize_field("address", &self.address)?;
        message.serialize_field("city", &self.city)?;
        message.serialize_field("country", &self.country)?;
        message.serialize_field("postal_code", &self.postal_code)?;
        message.serialize_field("company", &self.company)?;
        message.serialize_field("title", &self.title)?;
        message.serialize_field("note", &self.note)?;
        message.end()
    }
}

pub struct DeepMessage {
    label: String,
    value: i64,
    child: Option<Box<DeepMessage>>,
}

impl Serialize for DeepMessage {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let mut message = serializer.serialize_struct("DeepMessage", 3)?;
        message.serialize_field("label", &self.label)?;
        message.serialize_field("value", &self.value)?;
        message.serialize_field("child", &self.child)?;
        message.end()
    }
}

/// A tree message: its children, a repeated field left out when it is empty, as serde's derive
/// writes a field marked `skip_serializing_if = "Vec::is_empty"`.
pub struct TreeMessage {
    children: Vec<TreeMessage>,
}

impl Serialize for TreeMessage {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let len = usize::from(!self.children.is_empty());
        let mut message = serializer.serialize_struct("TreeMessage", len)?;
        if self.children.is_empty() {
            message.skip_field("children")?;
        } else {
            message.serialize_field("children", &self.children)?;
        }
        message.end()
    }
}

/// The messages of one workload, built from its tokens before anything is timed.
pub enum Typed {
    Empty,
    Strings(Vec<StringsMessage>),
    Deep(Vec<DeepMessage>),
    Tree(Vec<TreeMessage>),
}

/// The tree message whose object starts at `tokens[*next]`, with `*next` moved past it.
fn tree_message(tokens: &[Token], next: &mut usize) -> Option<TreeMessage> {
    if tokens.get(*next)?.kind != BEGIN_OBJECT {
        return None;
    }
    *next += 1;
    let mut children = Vec::new();
    if tokens.get(*next)?.kind == NAME {
        if owned(&tokens[*next])? != "children" || tokens.get(*next + 1)?.kind != BEGIN_ARRAY {
            return None;
        }
        *next += 2;
        while tokens.get(*next)?.kind != END_ARRAY {
            children.push(tree_message(tokens, next)?);
        }
        *next += 1;
    }
    if tokens.get(*next)?.kind != END_OBJECT {
        return None;
    }
    *next += 1;
    Some(TreeMessage { children })
}

fn owned(token: &Token) -> Option<String> {
    let octets = unsafe { std::slice::from_raw_parts(token.octets, token.len) };
    std::str::from_utf8(octets).ok().map(str::to_owned)
}

fn strings_message(tokens: &[Token]) -> Option<StringsMessage> {
    if tokens.len() != 2 * STRINGS_MEMBERS + 2 || tokens[0].kind != BEGIN_OBJECT {
        return None;
    }
    let value = |index: usize| -> Option<String> {
        let name = &tokens[1 + 2 * index];
        let string = &tokens[2 + 2 * index];
        if name.kind != NAME || string.kind != STRING {
            return None;
        }
        owned(string)
    };
    Some(StringsMessage {
        id: value(0)?,
        name: value(1)?,
        email: value(2)?,
        phone: value(3)?,
        address: value(4)?,
        city: value(5)?,
        country: value(6)?,
        postal_code: value(7)?,
        company: value(8)?,
        title: value(9)?,
        note: value(10)?,
    })
}

fn deep_message(tokens: &[Token]) -> Option<DeepMessage> {
    if tokens.len() != 1 + DEEP_TOKENS_PER_LEVEL * DEEP_LEVELS + DEEP_LEVELS || tokens[0].kind != BEGIN_OBJECT {
        return None;
    }
    let mut child: Option<Box<DeepMessage>> = None;
    for level in (0..DEEP_LEVELS).rev() {
        let at = &tokens[1 + DEEP_TOKENS_PER_LEVEL * level..][..DEEP_TOKENS_PER_LEVEL];
        if at[3].kind != SIGNED || (level + 1 == DEEP_LEVELS) != (at[5].kind == NULL) {
            return None;
        }
        child = Some(Box::new(DeepMessage { label: owned(&at[1])?, value: at[3].integer as i64, child }));
    }
    child.map(|message| *message)
}

/// A new, empty set of messages.
#[no_mangle]
pub extern "C" fn stdx_bench_serde_typed_new() -> *mut Typed {
    Box::into_raw(Box::new(Typed::Empty))
}

/// Adds the message of one text of `len` tokens at `tokens`; 0 when it took it, 1 when the text
/// is of neither shape or of the other shape than the messages before it.
///
/// # Safety
/// `typed` comes from `stdx_bench_serde_typed_new`, and `tokens` holds `len` tokens.
#[no_mangle]
pub unsafe extern "C" fn stdx_bench_serde_typed_add(typed: *mut Typed, tokens: *const Token, len: usize) -> i32 {
    let tokens = std::slice::from_raw_parts(tokens, len);
    let typed = &mut *typed;
    if let Typed::Empty = typed {
        *typed = if tokens.len() == 2 * STRINGS_MEMBERS + 2 {
            Typed::Strings(Vec::new())
        } else if tokens.len() == 1 + DEEP_TOKENS_PER_LEVEL * DEEP_LEVELS + DEEP_LEVELS {
            Typed::Deep(Vec::new())
        } else {
            Typed::Tree(Vec::new())
        };
    }
    match typed {
        Typed::Strings(messages) => match strings_message(tokens) {
            Some(message) => messages.push(message),
            None => return 1,
        },
        Typed::Deep(messages) => match deep_message(tokens) {
            Some(message) => messages.push(message),
            None => return 1,
        },
        Typed::Tree(messages) => {
            let mut next = 0;
            match tree_message(tokens, &mut next) {
                Some(message) if next == tokens.len() => messages.push(message),
                _ => return 1,
            }
        }
        Typed::Empty => return 1,
    }
    0
}

/// Writes every message, one text after another, into `out`. Returns the octets written, or 0
/// when serde_json fails or `out` is too short.
///
/// # Safety
/// `typed` comes from `stdx_bench_serde_typed_new`, and `out` holds `out_len` octets.
#[no_mangle]
pub unsafe extern "C" fn stdx_bench_serde_typed_encode(typed: *const Typed, out: *mut u8, out_len: usize) -> usize {
    let mut room: &mut [u8] = std::slice::from_raw_parts_mut(out, out_len);
    let written = match &*typed {
        Typed::Strings(messages) => messages.iter().all(|message| serde_json::to_writer(&mut room, message).is_ok()),
        Typed::Deep(messages) => messages.iter().all(|message| serde_json::to_writer(&mut room, message).is_ok()),
        Typed::Tree(messages) => messages.iter().all(|message| serde_json::to_writer(&mut room, message).is_ok()),
        Typed::Empty => false,
    };
    if written {
        out_len - room.len()
    } else {
        0
    }
}

/// Frees the messages.
///
/// # Safety
/// `typed` comes from `stdx_bench_serde_typed_new` and is not used after.
#[no_mangle]
pub unsafe extern "C" fn stdx_bench_serde_typed_free(typed: *mut Typed) {
    drop(Box::from_raw(typed));
}
