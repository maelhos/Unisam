
type elf_header = {
  e_type : int;
  e_machine : int;
  e_version : int32;
  e_entry : int64;
  e_phoff : int64;
  e_shoff : int64;
  e_flags : int32;
  e_ehsize : int;
  e_phentsize : int;
  e_phnum : int;
  e_shentsize : int;
  e_shnum : int;
  e_shstrndx : int;
}

(* There is probably a more OCamly way to do this... *)
let read_u16 b off =
  let b0 = Char.code (Bytes.get b (off + 0)) in
  let b1 = Char.code (Bytes.get b (off + 1)) in
  (b1 lsl 8) lor b0

let read_u32 b off =
  let b0 = Int32.of_int (Char.code (Bytes.get b (off + 0))) in
  let b1 = Int32.of_int (Char.code (Bytes.get b (off + 1))) in
  let b2 = Int32.of_int (Char.code (Bytes.get b (off + 2))) in
  let b3 = Int32.of_int (Char.code (Bytes.get b (off + 3))) in
  Int32.logor (Int32.logor b0 (Int32.shift_left b1 8))
              (Int32.logor (Int32.shift_left b2 16) (Int32.shift_left b3 24))
              
let read_u64 b off =
  let low  = read_u32 b (off + 0) in
  let high = read_u32 b (off + 4) in
  Int64.logor (Int64.of_int32 low) (Int64.shift_left (Int64.of_int32 high) 32)


let parse_elf_header filename =
  let ic = open_in_bin filename in (* This can also fail, TODO: another try *)
  let buf = Bytes.create 64 in
  try
    really_input ic buf 0 64;
    close_in ic;

    if Bytes.get buf 0 <> '\x7f' || Bytes.sub_string buf 1 3 <> "ELF" then
      failwith "Invalid Magic Bytes";

    if Bytes.get buf 4 <> '\x02' then
      failwith "Not 64-bit ELF"; (* do we want to support 32 bit ? *)

    {
      e_type = read_u16 buf 16;
      e_machine = read_u16 buf 18;
      e_version = read_u32 buf 20;
      e_entry = read_u64 buf 24;
      e_phoff = read_u64 buf 32;
      e_shoff = read_u64 buf 40;
      e_flags = read_u32 buf 48;
      e_ehsize = read_u16 buf 52;
      e_phentsize = read_u16 buf 54;
      e_phnum = read_u16 buf 56;
      e_shentsize = read_u16 buf 58;
      e_shnum = read_u16 buf 60;
      e_shstrndx = read_u16 buf 62;
    }
  with e ->
    close_in_noerr ic;
    raise e

