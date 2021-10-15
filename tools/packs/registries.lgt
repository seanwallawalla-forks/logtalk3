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


:- object(registries,
	imports((packs_common, options))).

	:- info([
		version is 0:9:0,
		author is 'Paulo Moura',
		date is 2021-10-15,
		comment is 'Registry handling predicates.'
	]).

	:- public(list/0).
	:- mode(list, one).
	:- info(list/0, [
		comment is 'Prints a list of all installed registries.'
	]).

	:- public(directory/0).
	:- mode(directory, one).
	:- info(location/0, [
		comment is 'Prints the directory where the registries are installed.'
	]).

	:- public(directory/1).
	:- mode(directory(+atom), zero_or_one).
	:- info(directory/1, [
		comment is 'Prints the directory where a registry is installed.',
		argnames is ['Registry']
	]).

	:- public(directory/2).
	:- mode(directory(?atom, ?atom), zero_or_more).
	:- info(directory/2, [
		comment is 'Enumerates by backtracking all installed registries and respective directories.',
		argnames is ['Registry', 'Directory']
	]).

	:- public(describe/1).
	:- mode(describe(+atom), one).
	:- info(describe/1, [
		comment is 'Prints all registry entries.',
		argnames is ['Registry']
	]).

	:- public(add/3).
	:- mode(add(+atom, +atom, ++list(compound)), zero_or_one).
	:- info(add/3, [
		comment is 'Adds a new registry using the given options. Fails if the registry is already defined.',
		argnames is ['Registry', 'URL', 'Options'],
		remarks is [
			'``force(Boolean)`` option' - 'Force re-installation if the registry is already installed. Default is ``false``.',
			'``clean(Boolean)`` option' - 'Clean registry archive after updating. Default is ``false``.',
			'``verbose(Boolean)`` option' - 'Verbose installation steps. Default is ``false``.'
		]
	]).

	:- public(add/2).
	:- mode(add(+atom, +atom), zero_or_one).
	:- info(add/2, [
		comment is 'Adds a new registry using default options. Fails if the registry is already defined.',
		argnames is ['Registry', 'URL']
	]).

	:- public(update/2).
	:- mode(update(+atom, ++list(compound)), zero_or_one).
	:- info(update/2, [
		comment is 'Updates an installed registry using the specified options. Fails if the registry is not installed.',
		argnames is ['Registry', 'Options'],
		remarks is [
			'``force(Boolean)`` option' - 'Force update if the registry is pinned. Default is ``false``.',
			'``clean(Boolean)`` option' - 'Clean registry archive after updating. Default is ``false``.',
			'``verbose(Boolean)`` option' - 'Verbose installation steps. Default is ``false``.'
		]
	]).

	:- public(update/1).
	:- mode(update(+atom), zero_or_one).
	:- info(update/1, [
		comment is 'Updates an installed registry using default options. Fails if the registry is not installed.',
		argnames is ['Registry']
	]).

	:- public(update/0).
	:- mode(update, zero_or_one).
	:- info(update/0, [
		comment is 'Updates all installed registries using default options.'
	]).

	:- public(delete/2).
	:- mode(delete(+atom, ++list(compound)), zero_or_one).
	:- info(delete/2, [
		comment is 'Deletes a registry using the specified options (if not pinned).',
		argnames is ['Registry', 'Options'],
		remarks is [
			'``force(Boolean)`` option' - 'Force deletion if the registry is pinned or there are installed registry packs. Default is ``false``.',
			'``clean(Boolean)`` option' - 'Clean registry archive after deleting. Default is ``false``.',
			'``verbose(Boolean)`` option' - 'Verbose installation steps. Default is ``false``.'
		]
	]).

	:- public(delete/1).
	:- mode(delete(+atom), zero_or_one).
	:- info(delete/1, [
		comment is 'Deletes a registry using default options.',
		argnames is ['Registry']
	]).

	:- public(clean/1).
	:- mode(clean(+atom), zero_or_one).
	:- info(clean/1, [
		comment is 'Cleans all registry archives. Fails if the registry is not defined.',
		argnames is ['Registry']
	]).

	:- public(clean/0).
	:- mode(clean, one).
	:- info(clean/0, [
		comment is 'Cleans all archives for all registries.'
	]).

	:- private(deleted_registry_/1).
	:- dynamic(deleted_registry_/1).
	:- mode(deleted_registry_(?atom), zero_or_one).
	:- info(deleted_registry_/1, [
		comment is 'Table of deleted registries.',
		argnames is ['Registry']
	]).
	:- uses(list, [
		member/2
	]).

	:- uses(logtalk, [
		expand_library_path/2, loaded_file_property/2, print_message/3
	]).

	:- uses(os, [
		decompose_file_name/3, decompose_file_name/4, delete_file/1,
		directory_exists/1, directory_files/3, ensure_file/1, file_exists/1,
		internal_os_path/2, make_directory_path/1, operating_system_type/1,
		path_concat/3
	]).

	:- uses(type, [
		check/2, valid/2
	]).

	% registry info predicates

	list :-
		print_message(information, packs, @'Defined registries:'),
		expand_library_path(logtalk_packs(registries), Directory),
		directory_files(Directory, Registries, [type(directory), dot_files(false)]),
		(	Registries == [] ->
			print_message(information, packs, @'  (none)')
		;	findall(
				Registry-Pinned,
				(	member(Registry, Registries),
					(	pinned(Registry) ->
						Pinned = true
					;	Pinned = false
					)
				),
				RegistryPairs
			),
			print_message(information, packs, registries_list(RegistryPairs))
		).

	describe(Registry) :-
		check(atom, Registry),
		(	registry_object(Registry, RegistryObject) ->
			RegistryObject::description(Description),
			RegistryObject::home(Home),
			RegistryObject::clone(Clone),
			RegistryObject::archive(Archive),
			(	pinned(Registry) ->
				Pinned = true
			;	Pinned = false
			),
			print_message(information, packs, registry_info(Registry,Description,Home,Clone,Archive,Pinned))
		;	print_message(error, packs, unknown_registry(Registry)),
			fail
		).

	% registry directory predicates

	directory(Registry, Directory) :-
		(	var(Registry) ->
			implements_protocol(RegistryObject, registry_protocol),
			RegistryObject::name(Registry)
		;	check(atom, Registry),
			implements_protocol(RegistryObject, registry_protocol),
			RegistryObject::name(Registry),
			!
		),
		\+ deleted_registry_(Registry),
		expand_library_path(logtalk_packs(registries), Registries),
		path_concat(Registries, Registry, Directory),
		directory_exists(Directory).

	directory(Registry) :-
		directory(Registry, Directory),
		print_message(information, packs, 'Registry directory'-Directory).

	directory :-
		expand_library_path(logtalk_packs(registries), Directory),
		print_message(information, packs, 'Registries directory'-Directory).

	% add registry predicates

	add(Registry, URL, UserOptions) :-
		check(atom, Registry),
		check(atom, URL),
		^^check_options(UserOptions),
		^^merge_options(UserOptions, Options),
		(	registry_object(Registry, _),
			member(force(false), Options) ->
			print_message(error, packs, registry_already_defined(Registry)),
			fail
		;	true
		),
		decompose_file_name(URL, _, Name, Extension),
		(	Extension == '.git' ->
			clone(Registry, URL, Path, Options)
		;	^^supported_archive(Extension) ->
			download(Registry, URL, Archive, Options),
			uncompress(Registry, Archive, Path, Options)
		;	atom_concat(Name, Extension, Archive),
			print_message(error, packs, unsupported_archive_format(Archive)),
			fail
		),
		^^load_registry(Path),
		retractall(deleted_registry_(Registry)),
		(	member(clean(true), Options) ->
			delete_archives(Registry)
		;	true
		),
		^^print_readme_file_path(Path).

	add(Registry, URL) :-
		add(Registry, URL, []).

	% delete registry predicates

	delete(Registry, UserOptions) :-
		check(atom, Registry),
		^^check_options(UserOptions),
		^^merge_options(UserOptions, Options),
		(	directory(Registry, Directory0) ->
			(	pinned(Registry),
				member(force(false), Options) ->
				print_message(error, packs, cannot_delete_pinned_registry(Registry)),
				fail
			;	true
			),
			(	packs::installed(Registry, _, _, _),
				member(force(false), Options) ->
				print_message(error, packs, cannot_delete_registry_with_installed_packs(Registry)),
				fail
			;	true
			),
			internal_os_path(Directory0, Directory),
			(	operating_system_type(windows) ->
				(	member(verbose(true), Options) ->
					atom_concat('del /s /q "', Directory, Command0),
					atom_concat(Command0, '" && rmdir /s /q "', Command1),
					atom_concat(Command1, Directory, Command2),
					atom_concat(Command2, '"', Command)
				;	atom_concat('del /s /q "', Directory, Command0),
					atom_concat(Command0, '" > nul 2>&1 && rmdir /s /q "', Command1),
					atom_concat(Command1, Directory, Command2),
					atom_concat(Command2, '" > nul 2>&1', Command)
				)
			;	% assume unix
				(	member(verbose(true), Options) ->
					atom_concat('rm -rvf "', Directory, Command0)
				;	atom_concat('rm -rf "', Directory, Command0)
				),
				atom_concat(Command0, '"', Command)
			),
			^^command(Command, registry_deletion_failed(Registry, Directory)),
			assertz(deleted_registry_(Registry)),
			(	member(clean(true), Options) ->
				delete_archives(Registry)
			;	true
			)
		;	print_message(error, packs, unknown_registry(Registry)),
			fail
		).

	delete(Registry) :-
		delete(Registry, []).

	% update registry predicates

	update(Registry, UserOptions) :-
		check(atom, Registry),
		^^check_options(UserOptions),
		^^merge_options(UserOptions, Options),
		(	deleted_registry_(Registry) ->
			print_message(error, packs, unknown_registry(Registry)),
			fail
		;	registry_object(Registry, RegistryObject) ->
			(	pinned(Registry),
				member(force(false), Options) ->
				print_message(error, packs, cannot_update_pinned_registry(Registry)),
				fail
			;	true
			),
			expand_library_path(logtalk_packs(registries), Registries),
			path_concat(Registries, Registry, Path),
			path_concat(Path, '.git', Git),
			(	directory_exists(Git) ->
				RegistryObject::clone(URL),
				print_message(comment, packs, updating_registry(Registry, URL)),
				update_clone(Registry, Path, Options)
			;	RegistryObject::archive(URL),
				print_message(comment, packs, updating_registry(Registry, URL)),
				update_archive(Registry, URL, Options)
			),
			object_property(RegistryObject, file(File)),
			loaded_file_property(File, parent(Parent)),
			logtalk_load(Parent, [reload(always)]),
			(	member(clean(true), Options) ->
				delete_archives(Registry)
			;	true
			),
			print_message(comment, packs, registry_updated(Registry, URL))
		;	print_message(error, packs, unknown_registry(Registry)),
			fail
		).

	update(Registry) :-
		update(Registry, []).

	update :-
		forall(
			registry_object(Registry, _),
			update(Registry, [])
		).

	update_clone(Registry, Path, Options) :-
		internal_os_path(Path, OSPath),
		atom_concat('git -C "', OSPath, Command0),
		atom_concat(Command0, '" pull ', Command1),
		(	member(verbose(true), Options) ->
			atom_concat(Command1, '-v',  Command)
		;	atom_concat(Command1, '-q',  Command)
		),
		^^command(Command, registry_clone_pull_failed(Registry, OSPath)).

	update_archive(Registry, URL, Options) :-
		download(Registry, URL, Archive, Options),
		uncompress(Registry, Archive, _, Options).

	% clean predicates

	clean(Registry) :-
		check(atom, Registry),
		(	registry_object(Registry, _) ->
			delete_archives(Registry)
		;	print_message(error, packs, unknown_registry(Registry)),
			fail
		).

	clean :-
		expand_library_path(logtalk_packs(registries), Directory),
		directory_files(Directory, Registries, [type(directory), dot_files(false)]),
		member(Registry, Registries),
		delete_archives(Registry),
		fail.
	clean.

	delete_archives(Registry) :-
		expand_library_path(logtalk_packs(archives), Archives),
		path_concat(Archives, registries, ArchivesRegistries),
		path_concat(ArchivesRegistries, Registry, ArchivesRegistriesRegistry),
		(	directory_exists(ArchivesRegistriesRegistry) ->
			directory_files(ArchivesRegistriesRegistry, Files, [type(regular), dot_files(false), paths(absolute)]),
			forall(member(File, Files), delete_file(File))
		;	true
		).

	% options handling

	default_option(verbose(false)).
	default_option(clean(false)).
	default_option(force(false)).

	valid_option(verbose(Boolean)) :-
		valid(boolean, Boolean).
	valid_option(clean(Boolean)) :-
		valid(boolean, Boolean).
	valid_option(force(Boolean)) :-
		valid(boolean, Boolean).

	% pinned registry handling

	pin(Registry) :-
		(	pin_file(Registry, File) ->
			ensure_file(File)
		;	print_message(error, packs, unknown_registry(Registry)),
			fail
		).

	unpin(Registry) :-
		(	pin_file(Registry, File) ->
			(	file_exists(File) ->
				delete_file(File)
			;	true
			)
		;	print_message(error, packs, unknown_registry(Registry)),
			fail
		).

	pinned(Registry) :-
		(	pin_file(Registry, File) ->
			file_exists(File)
		;	print_message(error, packs, unknown_registry(Registry)),
			fail
		).

	pin_file(Registry, File) :-
		check(atom, Registry),
		directory(Registry, Directory),
		path_concat(Directory, 'PINNED.packs', File).

	% auxiliary predicates

	registry_directory(Registry, Directory) :-
		registry_object(Registry, _),
		expand_library_path(logtalk_packs(registries), RegistriesDirectory),
		directory_files(RegistriesDirectory, Registries, [type(directory), dot_files(false), paths(relative)]),
		member(Registry, Registries),
		path_concat(RegistriesDirectory, Registry, Directory).

	registry_object(Registry, RegistryObject) :-
		(	var(Registry) ->
			implements_protocol(RegistryObject, registry_protocol),
			RegistryObject::name(Registry)
		;	implements_protocol(RegistryObject, registry_protocol),
			RegistryObject::name(Registry),
			!
		),
		\+ deleted_registry_(Registry).

	clone(Registry, URL, Path, Options) :-
		expand_library_path(logtalk_packs(registries), Registries),
		path_concat(Registries, Registry, Path),
		internal_os_path(Path, OSPath),
		(	member(verbose(true), Options) ->
			atom_concat('git clone -v ', URL, Command1)
		;	atom_concat('git clone -q ', URL, Command1)
		),
		atom_concat(Command1, ' "', Command2),
		atom_concat(Command2, OSPath, Command3),
		atom_concat(Command3, '"', Command),
		^^command(Command, registry_cloning_failed(Registry, URL)).

	download(Registry, URL, Archive, Options) :-
		expand_library_path(logtalk_packs(archives), Archives),
		path_concat(Archives, registries, ArchivesRegistries),
		path_concat(ArchivesRegistries, Registry, ArchivesRegistriesRegistry),
		decompose_file_name(URL, _, Basename),
		path_concat(ArchivesRegistriesRegistry, Basename, Archive0),
		internal_os_path(Archive0, Archive),
		make_directory_path(ArchivesRegistriesRegistry),
		(	member(verbose(true), Options) ->
			atom_concat('curl -v -L -o "', Archive, Command0)
		;	atom_concat('curl -s -S -L -o "', Archive, Command0)
		),
		atom_concat(Command0, '" ', Command1),
		atom_concat(Command1, URL, Command),
		^^command(Command, registry_download_failed(Registry, URL)).

	uncompress(Registry, Archive, Path, Options) :-
		expand_library_path(logtalk_packs(registries), Registries),
		path_concat(Registries, Registry, Path),
		internal_os_path(Path, OSPath),
		make_directory_path(Path),
		^^tar_command(Tar),
		(	member(verbose(true), Options) ->
			atom_concat(Tar, ' -xvf "', Command0)
		;	atom_concat(Tar, ' -xf "', Command0)
		),
		atom_concat(Command0, Archive, Command1),
		atom_concat(Command1, '" --strip 1 --directory "', Command2),
		atom_concat(Command2, OSPath, Command3),
		atom_concat(Command3, '"', Command),
		^^command(Command, registry_archive_uncompress_failed(Registry, OSPath)).

:- end_object.