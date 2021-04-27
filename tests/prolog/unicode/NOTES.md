________________________________________________________________________

This file is part of Logtalk <https://logtalk.org/>  
Copyright 1998-2021 Paulo Moura <pmoura@logtalk.org>  
SPDX-License-Identifier: Apache-2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
________________________________________________________________________


This directory contains *work-in-progress* test sets for Prolog Unicode
support. Currently, two test sets are provided: `builtins` (for flags,
built-in predicates, and stream properties) and `encodings` (for UTF-8,
UTF-16, and UTF-32 encodings, with and without a BOM). The `encodings`
test set is only enabled for backends supporting all the above encodings
(currently, CxProlog and SICStus Prolog).

The tests are based on the October 5, 2009 WG17 ISO Prolog Core revision
standardization proposal, which specifies the following minimal language
features:

1. An `encoding` Prolog flag, allowing applications to query the default
encoding for opening streams. When the Prolog systems supports multiple
encodings, the default encoding can be changed by setting this directive
to a supported encoding.

2. Encodings are represented by atoms after the names specified by the
Internet Assigned Numbers Authority (IANA) and marked as the "(preferred
MIME name)":

	http://www.iana.org/assignments/character-sets

3. Two new `open/4` predicate options, `encoding(Atom)` and `bom(Boolean)`.

4. Two new stream properties, `encoding(Atom)` and `bom(Boolean)`.

5. The standard built-in predicates that must be Unicode aware include:

- `atom_chars/2`
- `atom_codes/2`
- `atom_concat/3`
- `atom_length/2`
- `char_code/2`
- `current_prolog_flag/2`
- `get_char/1-2`
- `get_code/1-2`
- `open/3-4`
- `peek_char/1-2`
- `peek_code/1-2`
- `put_char/1-2`
- `put_code/1-2`
- `read_term/3`
- `set_prolog_flag/2`
- `stream_property/2`
- `sub_atom/5`
- `write_term/3`