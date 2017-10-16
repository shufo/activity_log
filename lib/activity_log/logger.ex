defmodule ActivityLog.Logger do

  @type payload :: Map

  @callback add(payload) :: {:ok, term}
end
