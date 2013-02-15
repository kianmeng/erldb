-module(model_plugin).

-export([post_model/2]).

-define(PATH, "examples/").

post_model(_,_) ->
    {ok, Filenames} = file:list_dir("examples"),
    code:add_path("ebin"),
    rebar_log:log(info, "Files: ~p~n", [Filenames]),
    compile_models(Filenames, []).

compile_models([], Acc) ->
    rebar_log:log(info, "Done...~n", []);
compile_models([H|T], Acc) ->
    {ok, Module} = test:create(?PATH ++ H),
    rebar_log:log(info, "Created ~p...~n", [Module]),
    file:copy(Module, "ebin/" ++ Module),
    file:delete(Module),
    compile_models(T, [Module|Acc]).

