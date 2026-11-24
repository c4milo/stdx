import Stdx.Regex.Program

/-!
# Claim R4's two preconditions, from the two walks of the reverse program

`dfa_suffix.suffix_of` takes a literal for claim R4 after two walks of the reverse program
(decision 86). `Literal.walk` reads the literal from the program's entry, and `before_takes`
reads every instruction the program reaches after it. `suffix_rule` says what the two walks
give: every match ends with the literal, and no part of a match before the literal holds the
byte that `before_takes` judged. Those are `EndsWith` and `CleanBefore` of `Suffix.lean`.

The reverse program reads the text backward. So `literal` holds the literal's bytes from its
last to its first, as the walk reads them, and a match from `s` up to `e` is a path of the
reverse program from `text.length - e` up to `text.length - s` over the text read backward.
`hreverse` states that, and this file does not prove it: it is the builder's work.
-/
namespace Stdx.Regex.Program

/-- A byte of a text read backward. -/
theorem reverse_byte {text : List Nat} {i : Nat} (h : i < text.length) :
    text.reverse[i]? = text[text.length - 1 - i]? := by
  simp [List.getElem?_reverse h]

/-- Claim R4's preconditions. `Match` holds the spans a pattern matches in `text`. Where the
reverse program's instructions from `entry` take `literal` and lead to `before`, and no
instruction that the program reaches from `before` takes the byte `b`:

- every match ends with the literal, whose bytes stand before the match's end, read backward;
- no part of a match before its literal holds `b`. -/
theorem suffix_rule {prog : Array Inst} {text literal : List Nat} {entry before b : Nat}
    {Match : Nat → Nat → Prop}
    (hinside : ∀ s e, Match s e → s ≤ e ∧ e ≤ text.length)
    (hreverse : ∀ s e, Match s e →
      Matches prog entry text.reverse (text.length - e) (text.length - s))
    (hchain : Chain prog entry literal before)
    (hnone : ∀ x out, Reach prog before x → ¬ Takes prog x b out) :
    ∀ s e, Match s e →
      (s + literal.length ≤ e ∧ ∀ m, m < literal.length → text[e - 1 - m]? = literal[m]?) ∧
        ∀ q, s ≤ q → q < e - literal.length → text[q]? ≠ some b := by
  intro s e hm
  have hin := hinside s e hm
  have ⟨pc, hpath, hdone⟩ := hreverse s e hm
  have ⟨hbytes, hrest⟩ := chain_path hchain hpath hdone
  have hle := hrest.le
  have hlen : s + literal.length ≤ e := by omega
  refine ⟨⟨hlen, ?_⟩, ?_⟩
  · intro m hmlt
    have h := hbytes m hmlt
    rw [reverse_byte (by omega)] at h
    have hidx : text.length - 1 - (text.length - e + m) = e - 1 - m := by omega
    rw [hidx] at h
    exact h
  · intro q hsq hqe hq
    have hclean := path_clean hrest hnone (text.length - 1 - q) (by omega) (by omega)
    rw [reverse_byte (by omega)] at hclean
    have hidx : text.length - 1 - (text.length - 1 - q) = q := by omega
    rw [hidx] at hclean
    exact hclean hq

end Stdx.Regex.Program
