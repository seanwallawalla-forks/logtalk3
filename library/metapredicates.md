________________________________________________________________________

This file is part of Logtalk <https://logtalk.org/>  
Copyright 1998-2018 Paulo Moura <pmoura@logtalk.org>

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


About
-----

This library provides implementations of common meta-predicates.

The `meta` object implements common Prolog meta-predicates like `map/3` and
`fold_left/4`.

The `loop` object implements several kinds of loops typical of imperative 
languages.


API documentation
-----------------

Open the [../docs/index.html](../docs/index.html) file in a web browser
and choose the library index.


Loading
-------

To load all entities in this group load the `metapredicates_loader.lgt`
utility file:

	| ?- logtalk_load(library(metapredicates_loader)).


Usage
-----

See the `metapredicates` example and unit tests.