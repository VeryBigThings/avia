defmodule Snitch.Application do
  @moduledoc """
  The Snitch Application Service.

  The Snitch system business domain lives in this application.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    config_elasticsearch()

    {:ok, pid} =
      Supervisor.start_link(
        [
          supervisor(Snitch.Repo, []),
          supervisor(Snitch.Tools.ElasticsearchCluster, []),
          worker(Cachex, [:avia_cache, [limit: 1000]]),
          supervisor(Task.Supervisor, [[name: MailManager.TaskSupervisor]]),
          worker(MailManager, [[name: MailManager]])
        ],
        strategy: :one_for_one,
        name: Snitch.Supervisor
      )

    {:ok, pid}
  end

  defp config_elasticsearch do
    old_config = Application.get_env(:snitch_core, Snitch.Tools.ElasticsearchCluster)
    new_config = Keyword.put(old_config, :url, System.fetch_env!("ELASTIC_HOST"))
    Application.put_env(:snitch_core, Snitch.Tools.ElasticsearchCluster, new_config)
  end
end
