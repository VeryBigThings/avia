defmodule Snitch.Repo.Migrations.AlterUserTimestamps do
  use Ecto.Migration

  def change do
    alter table(:snitch_users) do
      modify(:inserted_at, :naive_datetime_usec, type: :utc_datetime)
      modify(:updated_at, :naive_datetime_usec, type: :utc_datetime)
    end
  end

  def down do
    alter table(:snitch_users) do
      modify(:inserted_at, :utc_datetime, type: :naive_datetime_usec)
      modify(:updated_at, :utc_datetime, type: :naive_datetime_usec)
    end
  end
end
