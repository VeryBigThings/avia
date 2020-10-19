Bureaucrat.start(
  env_var: "DOC",
  writer: Bureaucrat.MarkdownWriter,
  default_path: "doc/api/index.html.md"
)

ExUnit.start(formatters: [ExUnit.CLIFormatter, Bureaucrat.Formatter])
