defmodule ActivityLogTest do
  use ExUnit.Case
  use ActivityLog

  activity "comment" do
    actor  :user
    object :comment
    target :article
  end

  test "activity/2 macro" do
    assert %__MODULE__{}
    assert %__MODULE__{} |> Map.get(:type) == :comment
  end

  test "actor/1 macro" do
    assert %__MODULE__{actor: %__MODULE__.Actor{}} |> Map.get(:actor) |> Map.get(:type) == :user
  end

  test "object/1 macro" do
    assert %__MODULE__{object: %__MODULE__.Object{}} |> Map.get(:object) |> Map.get(:type) == :comment
  end

  test "target/1 macro" do
    assert %__MODULE__{target: %__MODULE__.Target{}} |> Map.get(:target) |> Map.get(:type) == :article
  end
end
