:- encoding('UTF-16').
% the encoding/1 directive, when present, must be the
% first term, in the first line, of a source file


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


:- object(asian).

	:- info([
		version is 1:0:0,
		author is 'Paulo Moura',
		date is 2008-01-16,
		comment is 'Simple test of the encoding/1 directive.'
	]).

	:- public(country/3).
	:- mode(country(?atom, ?atom, ?atom), zero_or_more).
	:- info(country/3, [
		comment is 'Table of native names and capitals for some Asian countries.',
		argnames is ['Country', 'NativeName', 'Capital']
	]).

	country(china, '中国', '北京').
	country(japan, '日本', '東京').
	country(mongolia, 'Монгол Улс', 'Улаанбатаар').
	country(taiwan, '臺灣', '臺北').
	country(tajikistan, 'Тоҷикистон', 'Душанбе').

:- end_object.
