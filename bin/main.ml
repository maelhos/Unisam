
open Unisam

(* Main logic *)
let display_stuff f =
  let header = Elf.parse_elf_header f in
  Printf.printf "Entry point: 0x%Lx\n" header.e_entry;
  Printf.printf "Section Header Offset: 0x%Lx\n" header.e_shoff;
  Printf.printf "Number of Sections: %d\n" header.e_shnum

(* Argument parsing *)
let speclist =
  [
    (*
    ("--parse-only", Arg.Set parse_only, "Only go as far as parsing");
    ("--type-only", Arg.Set type_only, "Only go as far as typing");
    ("--no-asm", Arg.Set no_asm, "Do not generated assembly");
    Was might speclist for Rust compiler
    *)
  ]

let usage_msg = "Usage: unisam <file>\nExample: unisam /bin/ls"
let input_files = ref []
let set_input_file filename = input_files := filename :: !input_files


let () =
  Arg.parse speclist set_input_file usage_msg;
  if List.is_empty !input_files then (
    Printf.eprintf "%s\n" usage_msg;
    exit 1);
  List.iter display_stuff !input_files

