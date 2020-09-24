%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "src/", "web/", "apps/", "test/"],
        excluded: [~r"/_build/", ~r"/deps/", ~r"/node_modules/"]
      },
      requires: [],
      strict: true,
      color: true,
      checks: [
        # extra enabled checks
        {VBT.Credo.Check.Consistency.ModuleLayout, []},
        {VBT.Credo.Check.Consistency.FileLocation,
         ignore_folder_namespace: %{
           "lib/banmed_web" => ~w/channels controllers views/,
           "test/banmed_web" => ~w/channels controllers views/
         }},
        {VBT.Credo.Check.Readability.MultilineSimpleDo, []},
        {Credo.Check.Readability.AliasAs, []},
        {Credo.Check.Readability.Specs, []},
        {Credo.Check.Readability.SinglePipe, []},
        {Credo.Check.Readability.WithCustomTaggedTuple, []},

        # disabled checks
        {Credo.Check.Design.TagTODO, false},
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Warning.LazyLogging, false}
      ]
    }
  ]
}
