(**
 * Copyright (c) 2013-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "flow" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

(*****************************************************************************)
(* The "static" environment, initialized first and then doesn't change *)
(*****************************************************************************)

type genv = {
    options          : Options.t;
    workers          : Worker.t list option;
  }

(*****************************************************************************)
(* The environment constantly maintained by the server *)
(*****************************************************************************)

type errors = {
  (* errors are stored in a map from file path to error set, so that the errors
     from checking particular files can be cleared during recheck. *)
  local_errors: Errors.ErrorSet.t Utils_js.FilenameMap.t;
  (* errors encountered during merge have to be stored separately so
     dependencies can be cleared during merge. *)
  merge_errors: Errors.ErrorSet.t Utils_js.FilenameMap.t;
  (* error suppressions in the code *)
  suppressions: Error_suppressions.t Utils_js.FilenameMap.t;
  (* lint severity settings in the code *)
  severity_cover_set: ExactCover.lint_severity_cover Utils_js.FilenameMap.t;
}

type env = {
    (* All the files that we at least parse. *)
    files: Utils_js.FilenameSet.t;
    (* All the current files we typecheck. *)
    checked_files: CheckedSet.t;
    libs: SSet.t; (* a subset of `files` *)
    errors: errors;
    connections: Persistent_connection.t;
}

(*****************************************************************************)
(* Killing the server  *)
(*****************************************************************************)

let die() =
  exit(0)
