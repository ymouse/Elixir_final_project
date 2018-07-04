defmodule MAIN do
@moduledoc false
  use Application
  def start(_type, _args) do
    Task.start(Interactor.run())
  end
end
