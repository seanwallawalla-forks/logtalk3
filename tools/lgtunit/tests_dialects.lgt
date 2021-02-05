%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  Copyright 1998-2021 Paulo Moura <pmoura@logtalk.org>
%  SPDX-License-Identifier: Apache-2.0
%
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%
%      http://www.apache.org/licenses/LICENSE-2.0
%
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(tests_dialects,
	extends(lgtunit)).

	:- info([
		version is 1:5:0,
		author is 'Paulo Moura',
		date is 2020-06-03,
		comment is 'Unit tests for the "lgtunit" tool testing dialects.'
	]).

	% test/1 dialect

	test(test_1_01) :-
		true.

	test(test_1_02) :-
		\+ fail.

	test(test_1_03) :-
		catch(throw(error), _, true).

	% test/2 dialect

	test(test_2_01, true) :-
		true.

	test(test_2_02, true(integer(N))) :-
		N = 1.

	test(test_2_03, deterministic) :-
		true.

	test(test_2_04, deterministic(integer(N))) :-
		N = 1.

	test(test_2_05, fail) :-
		fail.

	test(test_2_06, error(my_error)) :-
		throw(error(my_error, my_error_context)).

	test(test_2_07, errors([my_error1,my_error2])) :-
		throw(error(my_error2, my_error_context)).

	test(test_2_08, ball(ball)) :-
		throw(ball).

	test(test_2_09, balls([ball1,ball2])) :-
		throw(ball1).

	test(test_2_10, subsumes(a(_), Result)) :-
		Result = a(1).

	% test/3 dialect

	test(test_3_01a, true, [condition(g(a01)), setup(g(b01)), cleanup(g(c01)), note(n01)]) :-
		check(a01), check(b01).
	test(test_3_01b, true, []) :-
		check(c01), check(n01).

	test(test_3_02a, true(integer(N)), [condition(g(a02)), setup(g(b02)), cleanup(g(c02)), note(n02)]) :-
		check(a02), check(b02),
		N = 1.
	test(test_3_02b, true, []) :-
		check(c02), check(n02).

	test(test_3_03a, deterministic, [condition(g(a03)), setup(g(b03)), cleanup(g(c03)), note(n03)]) :-
		check(a03), check(b03).
	test(test_3_03b, true, []) :-
		check(c03), check(n03).

	test(test_3_04a, deterministic(integer(N)), [condition(g(a04)), setup(g(b04)), cleanup(g(c04)), note(n04)]) :-
		check(a04), check(b04),
		N = 1.
	test(test_3_04b, true, []) :-
		check(c04), check(n04).

	test(test_3_05a, fail, [condition(g(a05)), setup(g(b05)), cleanup(g(c05)), note(n05)]) :-
		check(a05), check(b05),
		fail.
	test(test_3_05b, true, []) :-
		check(c05), check(n05).

	test(test_3_06a, error(my_error), [condition(g(a06)), setup(g(b06)), cleanup(g(c06)), note(n06)]) :-
		check(a06), check(b06),
		throw(error(my_error, my_error_context)).
	test(test_3_06b, true, []) :-
		check(c06), check(n06).

	test(test_3_07a, errors([my_error1,my_error2]), [condition(g(a07)), setup(g(b07)), cleanup(g(c07)), note(n07)]) :-
		check(a07), check(b07),
		throw(error(my_error2, my_error_context)).
	test(test_3_07b, true, []) :-
		check(c07), check(n07).

	test(test_3_08a, ball(ball), [condition(g(a08)), setup(g(b08)), cleanup(g(c08)), note(n08)]) :-
		check(a08), check(b08),
		throw(ball).
	test(test_3_08b, true, []) :-
		check(c08), check(n08).

	test(test_3_09a, balls([ball1,ball2]), [condition(g(a09)), setup(g(b09)), cleanup(g(c09)), note(n09)]) :-
		check(a09), check(b09),
		throw(ball1).
	test(test_3_09b, true, []) :-
		check(c09), check(n09).

	test(test_3_10a, subsumes(a(_), Result), [condition(g(a10)), setup(g(b10)), cleanup(g(c10)), note(n10)]) :-
		check(a10), check(b10),
		Result = a(1).

	test(test_3_10b, subsumes(a(_), Result), []) :-
		Result = a(1).

	% "explicit" dialects

	succeeds(succeeds_1_01) :-
		true.

	deterministic(deterministic_1_01) :-
		true.

	fails(fails_1_01) :-
		fail.

	throws(throws_2_01, ball) :-
		throw(ball).

	throws(throws_2_02, [ball1,ball2]) :-
		throw(ball1).

	throws(throws_2_03, [ball1,ball2]) :-
		throw(ball2).

	% quick_check/2-3 dialect

	quick_check(quick_check_3_01, integer(+integer), []).

	quick_check(quick_check_3_02, integer(+integer), [n(25)]).

	quick_check(quick_check_3_03, type::valid({integer}, +integer), []).

	quick_check(quick_check_3_04, type::valid({integer}, +integer), [n(50)]).

	quick_check(quick_check_2_01, integer(+integer)).

	quick_check(quick_check_2_02, type::valid({integer}, +integer)).

	% test identifiers

	- test(a(1)).

	- test(a(2)).

	- test(a(3)).

	% auxiliary predicates for checking that condition/1, setup/1, cleanup/1,
	% and note/1 options in the test/3 dialect are processed

	:- public(r/1).
	:- dynamic(r/1).

	g(Term) :-
		assertz(r(Term)).

	check(Term) :-
		once(retract(r(Term))).

	:- multifile(logtalk::message_hook/4).
	:- dynamic(logtalk::message_hook/4).

	logtalk::message_hook(passed_test(_, _, _, _, Note), _, lgtunit, _) :-
		g(Note),
		fail.

:- end_object.
