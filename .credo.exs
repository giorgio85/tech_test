# This file contains the configuration for Credo
%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      strict: false,
      color: true,
      checks: [
        # You can disable specific checks for dependencies
        {Credo.Check.Warning.IoInspect, false}
      ]
    }
  ]
}
