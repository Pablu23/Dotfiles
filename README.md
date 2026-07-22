# keymap drawer adv360 base keymap

```yaml
layout: 
  qmk_keyboard: adv360 
  layout_name: LAYOUT 
layers: 
  BASE: # Top rows 
    - ["=", "1", "2", "3", "4", "5", Fn, Fn, "6", "7", "8", "9", "0", "-"] 
    - [Tab, Q, W, E, R, T, Fn, Fn, Y, U, I, O, P, "\\"] # Third row left side 
    - [Esc, A, S, D, F, G, Fn] # Top row thumb keys 
    - [Ctrl, Alt, Super, Ctrl] # Third row right side 
    - [Fn, H, J, K, L, ";", "'"] # Fourth row left side 
    - [Shift, Z, X, C, V, B] # Second small key thumb row 
    - [Home, Page Up] # Fourth row right side 
    - [N, M, ",", ".", "/", Shift] # Last row left side 
    - [Fn, null, null, null, null] # Remaining Big thumb keys and small ones intertwined 
    - [Backspace, Delete, End, Page Down, Enter, {h: SYM, t: Space}] # Last row right side 
    - [Left, Up, Down, Right, Fn] 
  SYM: # Top rows 
    - [null, null, null, null, null, null, null, null, null, null, null, null, null, null] 
    - [null, "!", null, "*", "-", "<", ">", null, "[", "]", "", null, "\\", null] # Third row left side 
    - [null, "$", null, '~', "+", "=", "&"] # Top row thumb keys 
    - [Ctrl, Alt, Super, Ctrl] # Third row right side 
    - [null, "{", "}", "\"", null, ":", null] # Fourth row left side 
    - [null, "#", null, "^", "|", "_"] # Second small key thumb row 
    - [Home, Page Up] # Fourth row right side 
    - ["(", ")", "'", null, "?", null] # Last row left side 
    - [null, null, null, null, null] # Remaining Big thumb keys and small ones intertwined 
    - [Backspace, Delete, End, Page Down, Enter, Space] # Last row right side 
    - [null, null, null, null, null]
```
