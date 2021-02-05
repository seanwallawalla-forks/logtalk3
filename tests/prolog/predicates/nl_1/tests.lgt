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


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1:1:0,
		author is 'Paulo Moura',
		date is 2017-02-13,
		comment is 'Unit tests for the ISO Prolog standard nl/0-1 built-in predicates.'
	]).

	% tests from the ISO/IEC 13211-1:1995(E) standard, section 8.12.3.4

	test(iso_nl_1_01, error(instantiation_error)) :-
		{nl(_)}.

	test(iso_nl_1_02, error(permission_error(output,stream,user_input))) :-
		{nl(user_input)}.

	% tests from the Logtalk portability work

	:- if((
		os::operating_system_type(windows),
		\+ current_logtalk_flag(prolog_dialect, ji),
		\+ current_logtalk_flag(prolog_dialect, sicstus),
		\+ current_logtalk_flag(prolog_dialect, swi)
	)).

	test(lgt_nl_1_03, true(Assertion)) :-
		^^set_text_output(''),
		current_output(S),
		{nl(S)},
		^^text_output_assertion('\r\n', Assertion).

	:- else.

	test(lgt_nl_1_03, true(Assertion)) :-
		^^set_text_output(''),
		current_output(S),
		{nl(S)},
		^^text_output_assertion('\n', Assertion).

	:- endif.

:- end_object.
