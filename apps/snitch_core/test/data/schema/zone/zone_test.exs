defmodule Snitch.Data.Schema.ZoneTest do
  use ExUnit.Case, async: true
  use Snitch.DataCase

  alias Snitch.Data.Schema.Zone

  test "Zone invalidates bad type" do
    params = %{name: "foobar", description: "non-existent", zone_type: "x"}
    zone = Zone.create_changeset(%Zone{}, params)

    assert %Ecto.Changeset{errors: errors} = zone
    assert [zone_type: {"is invalid", _}] = errors
  end
end
